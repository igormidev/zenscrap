import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class CreateScrappableEndpoint extends Endpoint {
  Future<Scrappable> call(
    Session session, {
    required String referenceLink,
  }) async {
    final userId = (await session.authenticated)?.userId;

    final GenerativeModel geminiModel = GenerativeModel(
      model: 'gemini-2.5-pro',
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
    if (text == null) {
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
    late final Map<String, String> queryParams;
    late final List<String> pathParams;
    late final Map<String, String> referenceLinkPathParameters;
    late final ScraperCategory category;

    final scrapingResult =
        await scrapingBee.fetchHtmlAndScreenshot(referenceLink);

    if (scrapingResult == null) {
      // Handle the error case - throw an exception
      throw ZenScrapException(
        title: 'Failed to fetch webpage',
        description:
            'Could not retrieve webpage content from ScrapingBee API. The service may be temporarily unavailable.',
      );
    }

    var (String html, Uint8List pageFullscreenScreenshot) = scrapingResult;

    // Convert HTML to bytes for file-like upload
    final Uint8List htmlBytes = utf8.encode(html);
    final ByteData htmlByteData = ByteData.view(htmlBytes.buffer);
    final ByteData screenshotByteData =
        ByteData.view(pageFullscreenScreenshot.buffer);

    try {
      final Map<String, dynamic> convertedData =
          jsonDecode(text) as Map<String, dynamic>;
      name = convertedData['name'] as String;
      description = convertedData['description'] as String;
      url = convertedData['url'] as String;

      // Remove the __example__ key if present (it's just for schema validation)
      final Map<String, dynamic> rawQueryParams =
          Map<String, dynamic>.from(convertedData['queryParams'] as Map? ?? {});
      rawQueryParams.remove('__example__');
      queryParams = Map<String, String>.from(rawQueryParams);

      pathParams =
          List<String>.from(convertedData['pathParams'] as List? ?? []);

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
      session.log('Error decoding JSON from Gemini AI response:\n$error',
          level: LogLevel.error, stackTrace: stackTrace);
      throw ZenScrapException(
          title: 'Gemini AI could not generate the scrappable data.',
          description:
              'The returned text was not a valid JSON. Try again later.');
    }

    return session.db.transaction((transaction) async {
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
          pathParams: pathParams,
        ),
        transaction: transaction,
      );

      final ByteTestData testData = await ByteTestData.db.insertRow(
          session,
          ByteTestData(
            referenceHtmlPage: htmlByteData,
            referenceSiteScreenshot: screenshotByteData,
          ),
          transaction: transaction);
      final ReferenceTestData referenceTestData =
          await ReferenceTestData.db.insertRow(
              session,
              ReferenceTestData(
                referenceLinkUsed: referenceLink,
                byteDataId: testData.id!,
                byteData: testData,
                referenceQueryParametersJson:
                    jsonEncode(referenceLinkPathParameters),
              ),
              transaction: transaction);

      await ReferenceTestData.db.attachRow.byteData(
          session, referenceTestData, testData,
          transaction: transaction);

      final Scrappable scrappable = await Scrappable.db.insertRow(
        session,
        Scrappable(
          name: name,
          description: description,
          createdAt: DateTime.now(),
          isDeleted: false,
          willHideFromMarketplace: false,
          accountId: accountApiUsage?.accountInfo?.id,
          apiUsageOwnerNanoId: accountApiUsage?.nanoId,
          targetRequestId: targetRequest.id!,
          referenceTestDataId: referenceTestData.id!,
          referenceTestData: referenceTestData,
          targetRequest: targetRequest,
          category: category,
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

String getPromptToGenerateScrappableTargetRequest(String url) =>
    '''I need you to analyze a URL and return a SINGLE flat JSON object with specific fields.

The reference URL to analyze is: "$url"

You must return a JSON object with EXACTLY these fields at the root level:
- name: A short descriptive name for this URL pattern (max 50 chars)
- description: A 1-3 sentence description of what this URL represents
- url: The URL with dynamic parts replaced by {paramName} placeholders
- queryParams: An object with query parameters and their values from the URL
- pathParams: An array of parameter names that were replaced in the URL
- referenceLinkPathParameters: An object mapping parameter names to their actual values from the reference URL

EXAMPLE:
If the input URL is: www.mySocialMedia.com/posts/123/comments/3854?sort=asc&filter=all

You should return EXACTLY this structure:
{
  "name": "Social Media Post Comments",
  "description": "Retrieves comments for a specific post on the social media platform, with sorting and filtering options.",
  "url": "www.mySocialMedia.com/posts/{postId}/comments/{commentId}",
  "queryParams": {
    "sort": "asc",
    "filter": "all"
  },
  "pathParams": ["postId", "commentId"],
  "referenceLinkPathParameters": {
    "postId": "123",
    "commentId": "3854"
  }
}

IMPORTANT RULES:
1. Return ONLY a single flat JSON object - no nesting under "scrappable" or "scrappableTargetRequest"
2. ALL six fields must be at the root level of the JSON
3. Intelligently identify dynamic URL segments (numbers, IDs, slugs) and replace them with descriptive {paramName} placeholders
4. The pathParams array must contain the exact same parameter names used in the url placeholders
5. The referenceLinkPathParameters must map these parameter names to their actual values from the reference URL
6. Return raw JSON only - no markdown, no code blocks, no extra text

Return JSON that exactly matches this schema. Do not add or remove fields.

Analyze the URL pattern, identify what appears to be dynamic content (IDs, slugs, usernames, etc.), and create a reusable template.

Return only raw json, without anything more (not even md notations like "```" in the begining... just the raw json).
''';

final createScrappableSchema = Schema(
  SchemaType.object,
  description:
      'Schema for Gemini AI to generate structured scrappable configuration from a user-provided URL. '
      'This schema enforces the AI to analyze a reference URL and extract: '
      '1) A normalized URL template with path parameters as placeholders (e.g., /posts/{postId}), '
      '2) Query parameters with their default values from the reference URL, '
      '3) A list of path parameter names that will be dynamically replaced, '
      '4) The actual values of path parameters from the reference URL for testing purposes, '
      '5) A human-readable name and description for the scrappable configuration. '
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
          'The query parameters that will be requested by the user in his payload. This is a dynamic map where keys are parameter names and values are their default values.',
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
          'The path parameters that will be requested by the user in his payload.',
      items: Schema(
        SchemaType.string,
        nullable: false,
      ),
    ),
    'referenceLinkPathParameters': Schema(
      SchemaType.object,
      nullable: false,
      description:
          'A JSON representation of the path parameters extracted of the reference link. This is a dynamic map where keys are parameter names and values are their extracted values from the reference URL.',
      properties: {
        '__example__': Schema(
          SchemaType.string,
          nullable: true,
          description:
              'This is just an example property to satisfy the schema requirement. The actual properties will be dynamic based on the URL path parameters.',
        ),
      },
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
  },
);
