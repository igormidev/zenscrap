import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/docs/scrappable_request_structure_guide.dart';
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class CreateScrappableEndpoint extends Endpoint {
  Stream<Scrappable> call(
    Session session, {
    required String referenceLink,
  }) async* {
    final userId = (await session.authenticated)?.userId;

    // Validate scrappable limit for authenticated users
    if (userId != null) {
      final accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.userInfoId.equals(userId),
      );

      if (accountInfo != null) {
        final currentScrappablesCount = await Scrappable.db.count(
          session,
          where: (t) =>
              t.accountId.equals(accountInfo.id) & t.isDeleted.equals(false),
        );

        final maxAllowed = accountInfo.planTier.maxScrappables;

        if (currentScrappablesCount >= maxAllowed) {
          throw ZenScrapException(
            title: 'Endpoint Limit Reached',
            description:
                'You have reached the maximum number of endpoints ($maxAllowed) for your ${accountInfo.planTier.name} plan. '
                'Please upgrade your plan to create more endpoints.',
          );
        }
      }
    }

    final GenerativeModel geminiModel = GenerativeModel(
      model: 'gemini-3-pro',
      apiKey: session.passwords['geminiApiKey']!,
      systemInstruction: Content.system(
          'You are a helpful assistant that analyzes URLs and converts them into structured data for API request handling. '
          'Always return valid JSON with exactly the fields requested, nothing more, nothing less.'),
      generationConfig:
          GenerationConfig(responseSchema: createScrappableSchema),
    );
    final ChatSession chat = geminiModel.startChat();
    final GenerateContentResponse result = await chat.sendMessage(
      Content.text(getPromptToGenerateScrappableTargetRequest(referenceLink)),
    );
    var text = result.text;
    if (text == null || text.isEmpty) {
      throw ZenScrapException(
          title: 'Gemini AI could not generate the scrappable data.',
          description: 'No text was returned from the AI. Try again later.');
    }

    // Clean up the response in case the AI wrapped it in markdown code blocks
    text = text.trim();
    if (text.startsWith('```json')) {
      text = text.substring(7); // Remove ```json
    } else if (text.startsWith('```')) {
      text = text.substring(3); // Remove ```
    }
    if (text.endsWith('```')) {
      text = text.substring(0, text.length - 3); // Remove trailing ```
    }
    text = text.trim();

    late final String name;
    late final String description;
    late final String url;
    late final Map<String, String?> queryParams;
    late final Map<String, String?> queryParamsNotRelatedToUrl;
    late final List<String> pathParams;
    late final Map<String, String> referenceLinkPathParameters;
    late final ScraperCategory category;

    try {
      final Map<String, dynamic> convertedData =
          jsonDecode(text) as Map<String, dynamic>;
      name = convertedData['name'] as String;
      description = convertedData['description'] as String;

      // Extract scrappableRequest nested object
      final Map<String, dynamic> scrappableRequestData =
          convertedData['scrappableRequest'] as Map<String, dynamic>;

      url = scrappableRequestData['url'] as String;

      // Remove the __example__ key if present (it's just for schema validation)
      final Map<String, dynamic> rawQueryParams = Map<String, dynamic>.from(
          scrappableRequestData['queryParams'] as Map? ?? {});
      rawQueryParams.remove('__example__');
      queryParams = Map<String, String?>.from(rawQueryParams);

      // Remove the __example__ key if present (it's just for schema validation)
      final Map<String, dynamic> rawQueryParamsNotRelatedToUrl =
          Map<String, dynamic>.from(
              scrappableRequestData['queryParamsNotRelatedToUrl'] as Map? ??
                  {});
      rawQueryParamsNotRelatedToUrl.remove('__example__');
      queryParamsNotRelatedToUrl =
          Map<String, String?>.from(rawQueryParamsNotRelatedToUrl);

      pathParams =
          List<String>.from(scrappableRequestData['pathParams'] as List? ?? []);

      // Remove the __example__ key if present (it's just for schema validation)
      final Map<String, dynamic> rawRefLinkParams = Map<String, dynamic>.from(
          convertedData['referenceLinkPathParameters'] as Map? ?? {});
      rawRefLinkParams.remove('__example__');
      referenceLinkPathParameters = Map<String, String>.from(rawRefLinkParams);

      // Parse the category from the AI response
      final String categoryStr =
          convertedData['category'] as String? ?? 'general';
      try {
        category = ScraperCategory.values.byName(categoryStr);
      } catch (e) {
        // If the category doesn't match any enum value, default to general
        category = ScraperCategory.general;
      }
    } catch (error, stackTrace) {
      session.log(
          'Error decoding JSON from Gemini AI response:\n$error\n\nResponse Text:\n$text',
          level: LogLevel.error,
          stackTrace: stackTrace);
      throw ZenScrapException(
          title: 'Gemini AI could not generate the scrappable data.',
          description:
              'The returned text was not a valid JSON. Try again later.');
    }

    yield await session.db.transaction((transaction) async {
      final accountApiUsage = userId == null
          ? null
          : await AccountApiUsage.db.findFirstRow(session,
              where: (p0) => p0.accountInfo.userInfoId.equals(userId),
              include: AccountApiUsage.include(
                accountInfo: AccountInfo.include(),
              ),
              transaction: transaction);
      final ScrappableRequest targetRequest =
          await ScrappableRequest.db.insertRow(
        session,
        ScrappableRequest(
          url: url,
          queryParams: queryParams,
          queryParamsNotRelatedToUrl: queryParamsNotRelatedToUrl,
          pathParams: pathParams,
        ),
        transaction: transaction,
      );

      final ReferenceTestData referenceTestData =
          await ReferenceTestData.db.insertRow(
              session,
              ReferenceTestData(
                referenceLinkUsed: referenceLink,
                referenceQueryParametersJson:
                    jsonEncode(referenceLinkPathParameters),
              ),
              transaction: transaction);

      final now = DateTime.now();
      final Scrappable scrappable = await Scrappable.db.insertRow(
        session,
        Scrappable(
          name: name,
          description: description,
          createdAt: now,
          generalInfosUpdatedAt: now,
          extractRulesUpdatedAt: now,
          isDeleted: false,
          willHideFromMarketplace: false,
          accountId: accountApiUsage?.accountInfo?.id,
          apiUsageOwnerNanoId: accountApiUsage?.nanoId,
          targetRequestId: targetRequest.id!,
          referenceTestDataId: referenceTestData.id!,
          referenceTestData: referenceTestData,
          targetRequest: targetRequest,
          category: category,
          // Auto-fix configuration (default values)
          autoFixEnabled: true,
          consecutiveErrorThreshold: 100,
          currentConsecutiveErrors: 0,
          autoFixInProgress: false,
          autoFixAttemptCount: 0,
        ),
        transaction: transaction,
      );

      await Scrappable.db.attachRow.targetRequest(
          session, scrappable, targetRequest,
          transaction: transaction);
      await Scrappable.db.attachRow.referenceTestData(
          session, scrappable, referenceTestData,
          transaction: transaction);

      return scrappable;
    });
  }
}

String getPromptToGenerateScrappableTargetRequest(String url,
        {String? userContext}) =>
    '''I need you to analyze a URL and return a structured JSON object representing a scrappable request configuration.

The reference URL to analyze is: "$url"

You must return a JSON object with this EXACT structure:

```json
{
  "name": "Short descriptive name (max 50 chars)",
  "description": "1-3 sentence description of what this URL represents",
  "category": "appropriate_category",
  "scrappableRequest": {
    "url": "URL with {paramName} placeholders",
    "queryParams": {},
    "queryParamsNotRelatedToUrl": {},
    "pathParams": []
  },
  "referenceLinkPathParameters": {}
}
```

## Understanding the Structure

$scrappableRequestStructureGuide

## CRITICAL: Identifying Dynamic vs Static Parameters

**Path Parameters** - Replace with {paramName} if they are:
- Numeric IDs (user IDs, post IDs, product IDs, etc.)
- Unique identifiers (UUIDs, slugs, hashes)
- Variable names (usernames, product names that change)

**Query Parameters** - Mark as dynamic (value: null) if they represent:
- **Search queries**: ?q=..., ?search=..., ?query=..., ?term=...
  * Example: ?query=neymar+junior → {"query": null}
- **Filters**: ?filter=..., ?category=..., ?type=..., ?brand=...
  * Example: ?category=laptops → {"category": null}
- **Variable IDs**: ?id=..., ?user=..., ?product=...
  * Example: ?productId=12345 → {"productId": null}
- **Pagination**: ?page=..., ?offset=..., ?start=...
  * Example: ?page=1 → {"page": null}

**Query Parameters** - Keep as static (actual value) if they are:
- Configuration options that rarely change
- Default sorting/ordering preferences
- API version numbers
- Fixed limits or counts

EXAMPLE 1 - Social Media with Static Params:
Input URL: www.mySocialMedia.com/posts/123/comments/3854?sort=asc&filter=all

Output:
{
  "name": "Social Media Post Comments",
  "description": "Retrieves comments for a specific post on the social media platform, with sorting and filtering options.",
  "category": "social_media",
  "scrappableRequest": {
    "url": "www.mySocialMedia.com/posts/{postId}/comments/{commentId}",
    "queryParams": {
      "sort": "asc",
      "filter": "all"
    },
    "queryParamsNotRelatedToUrl": {},
    "pathParams": ["postId", "commentId"]
  },
  "referenceLinkPathParameters": {
    "postId": "123",
    "commentId": "3854"
  }
}

EXAMPLE 2 - Search with Dynamic Query (URL-based search):
Input URL: https://www.transfermarkt.pt?query=neymar+junior

Analysis: The search term "neymar+junior" appears in the URL and varies - users will search for different players
Output:
{
  "name": "Transfermarkt Player Search",
  "description": "Searches for football players on Transfermarkt with variable search terms.",
  "category": "sports",
  "scrappableRequest": {
    "url": "https://www.transfermarkt.pt",
    "queryParams": {
      "query": null
    },
    "queryParamsNotRelatedToUrl": {},
    "pathParams": []
  },
  "referenceLinkPathParameters": {}
}

EXAMPLE 3 - E-commerce with Mixed Dynamic/Static:
Input URL: https://shop.com/products/12345?category=laptops&sort=price&limit=20

Analysis:
- Product ID (12345) varies per product
- Category (laptops) appears in URL and varies as users browse different categories
- Sort (price) appears in URL and is a common preference, but might vary
- Limit (20) appears in URL and is probably fixed

Output:
{
  "name": "Shop Product Listing",
  "description": "Product listings for an e-commerce site with category filtering and configurable sorting.",
  "category": "ecommerce",
  "scrappableRequest": {
    "url": "https://shop.com/products/{categoryId}",
    "queryParams": {
      "category": null,
      "sort": null,
      "limit": "20"
    },
    "queryParamsNotRelatedToUrl": {},
    "pathParams": ["categoryId"]
  },
  "referenceLinkPathParameters": {
    "categoryId": "12345"
  }
}

EXAMPLE 4 - News Article with Slug:
Input URL: https://news.com/articles/2024-01-15/breaking-news-headline-here

Analysis: The date and headline slug will vary for different articles
Output:
{
  "name": "News Article",
  "description": "Individual news articles identified by date and headline slug.",
  "category": "news",
  "scrappableRequest": {
    "url": "https://news.com/articles/{articleSlug}",
    "queryParams": {},
    "queryParamsNotRelatedToUrl": {},
    "pathParams": ["articleSlug"]
  },
  "referenceLinkPathParameters": {
    "articleSlug": "2024-01-15/breaking-news-headline-here"
  }
}

EXAMPLE 5 - E-commerce with Client-Side Search (queryParamsNotRelatedToUrl):
Input URL: https://shop.example.com/products
User Context: "I want to search for products and navigate through pages"

Analysis:
- The URL doesn't have search or pagination params
- But the site has a search box and page navigation buttons (client-side only)
- Create parameters in queryParamsNotRelatedToUrl for search and pagination
- These will be used as {searchQuery} and {currentPage} placeholders in js_scenario
- They will NOT be added to the URL

Output:
{
  "name": "E-commerce Product Search",
  "description": "Search for products on the e-commerce site with pagination support. Uses client-side search and page navigation.",
  "category": "ecommerce",
  "scrappableRequest": {
    "url": "https://shop.example.com/products",
    "queryParams": {},
    "queryParamsNotRelatedToUrl": {
      "searchQuery": null,
      "currentPage": null
    },
    "pathParams": []
  },
  "referenceLinkPathParameters": {}
}

Note: The searchQuery and currentPage parameters will be used as {searchQuery} and {currentPage} placeholders in the extraction rules that the AI will create later. They will be replaced at runtime with values from the user's API payload.

EXAMPLE 6 - Site with Filters (queryParamsNotRelatedToUrl):
Input URL: https://realestate.com/listings
User Context: "I want to filter by location, price range, and number of bedrooms"

Analysis:
- Site has dropdown filters but they don't update the URL (client-side only)
- Create parameters in queryParamsNotRelatedToUrl for each filter option
- Users can control these in their API payloads
- These will be used as {location}, {minPrice}, etc. in js_scenario

Output:
{
  "name": "Real Estate Listings",
  "description": "Search real estate listings with dynamic filters for location, price range, and bedrooms.",
  "category": "real_estate",
  "scrappableRequest": {
    "url": "https://realestate.com/listings",
    "queryParams": {},
    "queryParamsNotRelatedToUrl": {
      "location": null,
      "minPrice": null,
      "maxPrice": null,
      "bedrooms": null
    },
    "pathParams": []
  },
  "referenceLinkPathParameters": {}
}

IMPORTANT RULES:
1. Return a structured JSON object with the nested structure shown above
2. The top level must have: name, description, category, scrappableRequest, and referenceLinkPathParameters
3. The scrappableRequest object must contain: url, queryParams, queryParamsNotRelatedToUrl, and pathParams
4. Intelligently identify dynamic URL segments (numbers, IDs, slugs) and replace them with descriptive {paramName} placeholders
5. **CRITICAL**: Think carefully about queryParams vs queryParamsNotRelatedToUrl:
   - Does this parameter appear in the URL? → Put in scrappableRequest.queryParams
   - Is this for client-side interaction only (URL never changes)? → Put in scrappableRequest.queryParamsNotRelatedToUrl
   - See the detailed guide above for examples and decision trees
6. For dynamic parameters, set their value to null (not the actual value)
7. The pathParams array must contain the exact same parameter names used in the url placeholders
8. The referenceLinkPathParameters must map these parameter names to their actual values from the reference URL
9. Return raw JSON only - no markdown, no code blocks, no extra text

CATEGORY SELECTION RULES - EXTREMELY IMPORTANT:
You MUST carefully analyze the URL content and domain to select the MOST SPECIFIC category. 
DO NOT default to "general" unless you are 100% certain the URL doesn't fit ANY other category.

Think step by step:
1. First, analyze the domain name and URL path for obvious category indicators
2. Look for keywords in the URL that match specific categories
3. Consider the primary purpose of what's being scraped
4. Only select "general" as an absolute LAST RESORT after ruling out ALL other categories

CATEGORY DESCRIPTIONS (select the MOST APPROPRIATE one):
- fitness: Health and fitness related (gyms, workouts, exercise tracking, fitness apps)
- sports: Traditional sports data (scores, teams, players, leagues, sports news)
- esports: E-sports/competitive gaming (tournaments, teams, game stats, esports leagues)
- health: Healthcare and medicine (medical info, hospitals, symptoms, treatments)
- movies: Movies and TV information (IMDB, streaming platforms, reviews, showtimes)
- jobs: Job listings and employment (Indeed, LinkedIn jobs, career sites)
- finance: Finance, banking, stock market (trading, investments, banking, crypto prices)
- location: Location-based data, maps, geocoding (Google Maps, GPS, addresses)
- science: Science, research, academic data (journals, research papers, scientific data)
- gaming: Video games general info (game stores, reviews, gaming news, Steam)
- travel: Travel, tourism, hospitality (hotels, flights, Airbnb, travel guides)
- social_media: Social networks and platforms (Twitter, Facebook, Instagram, TikTok)
- ecommerce: E-commerce and online shopping (Amazon, eBay, product listings, prices)
- news: News and journalism sites (CNN, BBC, newspapers, news aggregators)
- weather: Weather and climate data (weather.com, forecasts, climate info)
- education: Educational content and e-learning (courses, tutorials, universities)
- music: Music, audio streaming, artist info (Spotify, SoundCloud, music charts)
- books: Books, literature, libraries (Goodreads, book stores, ISBN lookups)
- comics: Comics, manga (comic sites, manga readers, webtoons)
- anime: Anime and animation (MyAnimeList, Crunchyroll, anime databases)
- real_estate: Real estate, housing, property (Zillow, property listings, rentals)
- food: Food, recipes, restaurants (Yelp, recipe sites, food delivery, menus)
- fashion: Fashion, style, beauty (clothing stores, fashion blogs, beauty products)
- security: Cybersecurity, threat intelligence (CVE databases, security advisories)
- ai: Artificial intelligence, ML tools (AI platforms, model repos, AI services)
- seo: SEO tools, search engine data (keyword tools, rankings, search analytics)
- lead_generation: Lead generation, marketing data (business contacts, B2B data)
- developer_tools: Developer tools, APIs, code repos (GitHub, npm, developer docs)
- automotive: Automotive, vehicles, car listings (car dealers, auto parts, vehicles)
- government: Government data, public records (gov sites, public data, regulations)
- cryptocurrency: Cryptocurrency and blockchain (crypto exchanges, DeFi, wallets)
- images: Image platforms or photography (Instagram, Flickr, stock photos)
- videos: Video platforms (YouTube, Vimeo, TikTok, streaming services)
- other: Use ONLY if absolutely nothing else fits
- general: LAST RESORT - use ONLY after carefully considering ALL categories above

CATEGORY SELECTION EXAMPLES:
- github.com/user/repo → "developer_tools"
- twitter.com/user/status → "social_media"  
- amazon.com/product/123 → "ecommerce"
- imdb.com/movie/tt123 → "movies"
- weather.com/forecast → "weather"
- linkedin.com/jobs/view → "jobs"
- espn.com/nba/scores → "sports"
- twitch.tv/esports → "esports"
- zillow.com/homedetails → "real_estate"

Return JSON that exactly matches this schema. Do not add or remove fields.

Analyze the URL pattern, identify what appears to be dynamic content (IDs, slugs, usernames, etc.), and create a reusable template.

${userContext != null ? '''
IMPORTANT - USER CONTEXT:
The user provided additional context about what they want to scrape:
"""
$userContext
"""

This context may give you clues about:
- What data they want to extract
- Which parts of the URL are dynamic vs static
- What search terms or filters might vary
- The purpose of the scraper

Use this information to better identify dynamic parameters!
''' : ''}

Return only raw json, without anything more (not even md notations like "```" in the begining... just the raw json).
''';

final createScrappableSchema = Schema(
  SchemaType.object,
  description:
      'Schema for Gemini AI to generate structured scrappable configuration from a user-provided URL. '
      'This schema enforces the AI to analyze a reference URL and extract: '
      '1) A normalized URL template with path parameters as placeholders (e.g., /posts/{postId}), '
      '2) Query parameters with their default values from the reference URL, '
      '3) Query parameters NOT related to the URL (for client-side interactions), '
      '4) A list of path parameter names that will be dynamically replaced, '
      '5) The actual values of path parameters from the reference URL for testing purposes, '
      '6) A human-readable name, description, and category for the scrappable configuration. '
      'The AI uses intelligent pattern recognition to identify dynamic segments in URLs (like IDs, slugs, usernames) '
      'and converts them into reusable templates that can accept different values while maintaining the same URL structure.',
  nullable: false,
  properties: {
    'name': Schema(
      SchemaType.string,
      nullable: false,
      description:
          'A short name for the scrappable, like "MySocialMedia Posts Comments".',
    ),
    'description': Schema(
      SchemaType.string,
      nullable: false,
      description: 'A brief description of what this scrappable is for.',
    ),
    'category': Schema(
      SchemaType.string,
      nullable: false,
      description:
          'The category that best describes the purpose of this scrappable. Must be one of the predefined category values.',
      enumValues: [
        'general',
        'fitness',
        'sports',
        'esports',
        'health',
        'movies',
        'jobs',
        'finance',
        'location',
        'science',
        'gaming',
        'travel',
        'social_media',
        'ecommerce',
        'news',
        'weather',
        'education',
        'music',
        'books',
        'comics',
        'anime',
        'real_estate',
        'food',
        'fashion',
        'security',
        'ai',
        'seo',
        'lead_generation',
        'developer_tools',
        'automotive',
        'government',
        'cryptocurrency',
        'images',
        'videos',
        'other',
      ],
    ),
    'scrappableRequest': Schema(
      SchemaType.object,
      nullable: false,
      description:
          'The scrappable request configuration defining how URLs are constructed and which parameters are available.',
      properties: {
        'url': Schema(
          SchemaType.string,
          nullable: false,
          description:
              'The URL with path parameters replaced by placeholders in {param} format.',
        ),
        'queryParams': Schema(
          SchemaType.object,
          nullable: false,
          description:
              'Query parameters that will be added to the URL via Uri(queryParameters:). Use this for parameters that actually modify the URL. This is a dynamic map where keys are parameter names and values are their default values (or null for dynamic values).',
          properties: {
            '__example__': Schema(
              SchemaType.string,
              nullable: true,
              description:
                  'This is just an example property to satisfy the schema requirement. The actual properties will be dynamic.',
            ),
          },
        ),
        'queryParamsNotRelatedToUrl': Schema(
          SchemaType.object,
          nullable: false,
          description:
              'Dynamic parameters used ONLY in extract_rules/js_scenario placeholders as {paramName}, NOT added to the URL. '
              'Use this for client-side interactions like search boxes, pagination buttons, filters, form inputs that do NOT modify the URL. '
              'These parameters will be replaced at runtime when users provide values in their API payload. '
              'Example: {"searchQuery": null, "currentPage": null} - these will become {searchQuery} and {currentPage} placeholders in js_scenario.',
          properties: {
            '__example__': Schema(
              SchemaType.string,
              nullable: true,
              description:
                  'This is just an example property to satisfy the schema requirement. The actual properties will be dynamic.',
            ),
          },
        ),
        'pathParams': Schema(
          SchemaType.array,
          nullable: false,
          description:
              'The path parameters that will be requested by the user in their payload.',
          items: Schema(
            SchemaType.string,
            nullable: false,
          ),
        ),
      },
    ),
    'referenceLinkPathParameters': Schema(
      SchemaType.object,
      nullable: false,
      description:
          'A JSON representation of the path parameters extracted from the reference link. This is a dynamic map where keys are parameter names and values are their extracted values from the reference URL.',
      properties: {
        '__example__': Schema(
          SchemaType.string,
          nullable: true,
          description:
              'This is just an example property to satisfy the schema requirement. The actual properties will be dynamic based on the URL path parameters.',
        ),
      },
    ),
  },
);
