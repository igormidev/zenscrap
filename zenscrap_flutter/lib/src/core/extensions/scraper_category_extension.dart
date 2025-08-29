import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

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

  IconData get icon {
    switch (this) {
      case ScraperCategory.general:
        return Icons.category_outlined;
      case ScraperCategory.fitness:
        return Icons.fitness_center_rounded;
      case ScraperCategory.sports:
        return Icons.sports_soccer_rounded;
      case ScraperCategory.esports:
        return Icons.sports_esports_rounded;
      case ScraperCategory.health:
        return Icons.health_and_safety_rounded;
      case ScraperCategory.movies:
        return Icons.movie_rounded;
      case ScraperCategory.jobs:
        return Icons.work_rounded;
      case ScraperCategory.finance:
        return Icons.account_balance_rounded;
      case ScraperCategory.location:
        return Icons.location_on_rounded;
      case ScraperCategory.science:
        return Icons.science_rounded;
      case ScraperCategory.gaming:
        return Icons.games_rounded;
      case ScraperCategory.travel:
        return Icons.flight_rounded;
      case ScraperCategory.social_media:
        return Icons.share_rounded;
      case ScraperCategory.ecommerce:
        return Icons.shopping_cart_rounded;
      case ScraperCategory.news:
        return Icons.newspaper_rounded;
      case ScraperCategory.weather:
        return Icons.cloud_rounded;
      case ScraperCategory.education:
        return Icons.school_rounded;
      case ScraperCategory.music:
        return Icons.music_note_rounded;
      case ScraperCategory.books:
        return Icons.menu_book_rounded;
      case ScraperCategory.comics:
        return Icons.auto_stories_rounded;
      case ScraperCategory.anime:
        return Icons.animation_rounded;
      case ScraperCategory.real_estate:
        return Icons.home_rounded;
      case ScraperCategory.food:
        return Icons.restaurant_rounded;
      case ScraperCategory.fashion:
        return Icons.checkroom_rounded;
      case ScraperCategory.security:
        return Icons.security_rounded;
      case ScraperCategory.ai:
        return Icons.psychology_rounded;
      case ScraperCategory.seo:
        return Icons.search_rounded;
      case ScraperCategory.lead_generation:
        return Icons.contacts_rounded;
      case ScraperCategory.developer_tools:
        return Icons.code_rounded;
      case ScraperCategory.automotive:
        return Icons.directions_car_rounded;
      case ScraperCategory.government:
        return Icons.account_balance_rounded;
      case ScraperCategory.cryptocurrency:
        return Icons.currency_bitcoin_rounded;
      case ScraperCategory.images:
        return Icons.image_rounded;
      case ScraperCategory.videos:
        return Icons.videocam_rounded;
      case ScraperCategory.other:
        return Icons.more_horiz_rounded;
    }
  }
}