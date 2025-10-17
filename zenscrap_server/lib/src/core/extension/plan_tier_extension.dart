import 'package:zenscrap_server/src/generated/protocol.dart';

extension PlanTierExt on PlanTier {
  /// The user has a subscription to a plan tier.
  /// Each month, the user receives a certain number of api credits based on their plan tier.
  int get apiCreditsToBeAddedPerMonth {
    return switch (this) {
      PlanTier.none => 100,
      PlanTier.basic => 50000,
      PlanTier.pro => 200000,
      PlanTier.ultra => 1000000,
    };
  }

  /// The number of api-calls/concurrent requests allowed by the user's current plan.
  int get numberOfConcurrentRequestsAllowedByPlan {
    return switch (this) {
      PlanTier.none => 0,
      PlanTier.basic => 10,
      PlanTier.pro => 30,
      PlanTier.ultra => 100,
    };
  }
}

extension ScraperCategoryExt on ScraperCategory {
  String get displayName {
    switch (this) {
      case ScraperCategory.general:
        return 'General';
      case ScraperCategory.fitness:
        return 'Fitness';
      case ScraperCategory.sports:
        return 'Sports';
      case ScraperCategory.esports:
        return 'E-sports';
      case ScraperCategory.health:
        return 'Health';
      case ScraperCategory.movies:
        return 'Movies';
      case ScraperCategory.jobs:
        return 'Jobs';
      case ScraperCategory.finance:
        return 'Finance';
      case ScraperCategory.location:
        return 'Location';
      case ScraperCategory.science:
        return 'Science';
      case ScraperCategory.gaming:
        return 'Gaming';
      case ScraperCategory.travel:
        return 'Travel';
      case ScraperCategory.social_media:
        return 'Social Media';
      case ScraperCategory.ecommerce:
        return 'E-commerce';
      case ScraperCategory.news:
        return 'News';
      case ScraperCategory.weather:
        return 'Weather';
      case ScraperCategory.education:
        return 'Education';
      case ScraperCategory.music:
        return 'Music';
      case ScraperCategory.books:
        return 'Books';
      case ScraperCategory.comics:
        return 'Comics';
      case ScraperCategory.anime:
        return 'Anime';
      case ScraperCategory.real_estate:
        return 'Real Estate';
      case ScraperCategory.food:
        return 'Food';
      case ScraperCategory.fashion:
        return 'Fashion';
      case ScraperCategory.security:
        return 'Security';
      case ScraperCategory.ai:
        return 'AI';
      case ScraperCategory.seo:
        return 'SEO';
      case ScraperCategory.lead_generation:
        return 'Lead Generation';
      case ScraperCategory.developer_tools:
        return 'Developer Tools';
      case ScraperCategory.automotive:
        return 'Automotive';
      case ScraperCategory.government:
        return 'Government';
      case ScraperCategory.cryptocurrency:
        return 'Cryptocurrency';
      case ScraperCategory.images:
        return 'Images';
      case ScraperCategory.videos:
        return 'Videos';
      case ScraperCategory.other:
        return 'Other';
    }
  }

  String get description {
    switch (this) {
      case ScraperCategory.general:
        return 'General-purpose or uncategorized scrapers';
      case ScraperCategory.fitness:
        return 'Health and fitness related';
      case ScraperCategory.sports:
        return 'Traditional sports data';
      case ScraperCategory.esports:
        return 'E-sports (competitive gaming)';
      case ScraperCategory.health:
        return 'Healthcare and medicine';
      case ScraperCategory.movies:
        return 'Movies and TV information';
      case ScraperCategory.jobs:
        return 'Job listings and employment';
      case ScraperCategory.finance:
        return 'Finance, banking, stock market';
      case ScraperCategory.location:
        return 'Location-based data, maps, geocoding';
      case ScraperCategory.science:
        return 'Science, research, academic data';
      case ScraperCategory.gaming:
        return 'Video games (general gaming info)';
      case ScraperCategory.travel:
        return 'Travel, tourism, hospitality';
      case ScraperCategory.social_media:
        return 'Social networks and social media platforms';
      case ScraperCategory.ecommerce:
        return 'E-commerce and online shopping';
      case ScraperCategory.news:
        return 'News and journalism sites';
      case ScraperCategory.weather:
        return 'Weather and climate data';
      case ScraperCategory.education:
        return 'Educational content and e-learning';
      case ScraperCategory.music:
        return 'Music, audio streaming, artist info';
      case ScraperCategory.books:
        return 'Books, literature, libraries';
      case ScraperCategory.comics:
        return 'Comics, manga';
      case ScraperCategory.anime:
        return 'Anime and animation';
      case ScraperCategory.real_estate:
        return 'Real estate, housing, property listings';
      case ScraperCategory.food:
        return 'Food, recipes, restaurants';
      case ScraperCategory.fashion:
        return 'Fashion, style, beauty';
      case ScraperCategory.security:
        return 'Cybersecurity, threat intelligence';
      case ScraperCategory.ai:
        return 'Artificial intelligence, ML tools';
      case ScraperCategory.seo:
        return 'SEO tools, search engine data';
      case ScraperCategory.lead_generation:
        return 'Lead generation, marketing data';
      case ScraperCategory.developer_tools:
        return 'Developer tools, general web scraping utilities';
      case ScraperCategory.automotive:
        return 'Automotive, vehicles, car listings';
      case ScraperCategory.government:
        return 'Government data, public records';
      case ScraperCategory.cryptocurrency:
        return 'Cryptocurrency and blockchain data';
      case ScraperCategory.images:
        return 'Image platforms or photography';
      case ScraperCategory.videos:
        return 'Video platforms (e.g. streaming, video sharing)';
      case ScraperCategory.other:
        return 'Other or uncategorized';
    }
  }
}
