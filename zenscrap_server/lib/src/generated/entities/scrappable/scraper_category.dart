/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

enum ScraperCategory implements _i1.SerializableModel {
  general,
  fitness,
  sports,
  esports,
  health,
  movies,
  jobs,
  finance,
  location,
  science,
  gaming,
  travel,
  social_media,
  ecommerce,
  news,
  weather,
  education,
  music,
  books,
  comics,
  anime,
  real_estate,
  food,
  fashion,
  security,
  ai,
  seo,
  lead_generation,
  developer_tools,
  automotive,
  government,
  cryptocurrency,
  images,
  videos,
  other;

  static ScraperCategory fromJson(String name) {
    switch (name) {
      case 'general':
        return ScraperCategory.general;
      case 'fitness':
        return ScraperCategory.fitness;
      case 'sports':
        return ScraperCategory.sports;
      case 'esports':
        return ScraperCategory.esports;
      case 'health':
        return ScraperCategory.health;
      case 'movies':
        return ScraperCategory.movies;
      case 'jobs':
        return ScraperCategory.jobs;
      case 'finance':
        return ScraperCategory.finance;
      case 'location':
        return ScraperCategory.location;
      case 'science':
        return ScraperCategory.science;
      case 'gaming':
        return ScraperCategory.gaming;
      case 'travel':
        return ScraperCategory.travel;
      case 'social_media':
        return ScraperCategory.social_media;
      case 'ecommerce':
        return ScraperCategory.ecommerce;
      case 'news':
        return ScraperCategory.news;
      case 'weather':
        return ScraperCategory.weather;
      case 'education':
        return ScraperCategory.education;
      case 'music':
        return ScraperCategory.music;
      case 'books':
        return ScraperCategory.books;
      case 'comics':
        return ScraperCategory.comics;
      case 'anime':
        return ScraperCategory.anime;
      case 'real_estate':
        return ScraperCategory.real_estate;
      case 'food':
        return ScraperCategory.food;
      case 'fashion':
        return ScraperCategory.fashion;
      case 'security':
        return ScraperCategory.security;
      case 'ai':
        return ScraperCategory.ai;
      case 'seo':
        return ScraperCategory.seo;
      case 'lead_generation':
        return ScraperCategory.lead_generation;
      case 'developer_tools':
        return ScraperCategory.developer_tools;
      case 'automotive':
        return ScraperCategory.automotive;
      case 'government':
        return ScraperCategory.government;
      case 'cryptocurrency':
        return ScraperCategory.cryptocurrency;
      case 'images':
        return ScraperCategory.images;
      case 'videos':
        return ScraperCategory.videos;
      case 'other':
        return ScraperCategory.other;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ScraperCategory"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
