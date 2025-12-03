/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

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

  static ScraperCategory fromJson(int index) {
    switch (index) {
      case 0:
        return ScraperCategory.general;
      case 1:
        return ScraperCategory.fitness;
      case 2:
        return ScraperCategory.sports;
      case 3:
        return ScraperCategory.esports;
      case 4:
        return ScraperCategory.health;
      case 5:
        return ScraperCategory.movies;
      case 6:
        return ScraperCategory.jobs;
      case 7:
        return ScraperCategory.finance;
      case 8:
        return ScraperCategory.location;
      case 9:
        return ScraperCategory.science;
      case 10:
        return ScraperCategory.gaming;
      case 11:
        return ScraperCategory.travel;
      case 12:
        return ScraperCategory.social_media;
      case 13:
        return ScraperCategory.ecommerce;
      case 14:
        return ScraperCategory.news;
      case 15:
        return ScraperCategory.weather;
      case 16:
        return ScraperCategory.education;
      case 17:
        return ScraperCategory.music;
      case 18:
        return ScraperCategory.books;
      case 19:
        return ScraperCategory.comics;
      case 20:
        return ScraperCategory.anime;
      case 21:
        return ScraperCategory.real_estate;
      case 22:
        return ScraperCategory.food;
      case 23:
        return ScraperCategory.fashion;
      case 24:
        return ScraperCategory.security;
      case 25:
        return ScraperCategory.ai;
      case 26:
        return ScraperCategory.seo;
      case 27:
        return ScraperCategory.lead_generation;
      case 28:
        return ScraperCategory.developer_tools;
      case 29:
        return ScraperCategory.automotive;
      case 30:
        return ScraperCategory.government;
      case 31:
        return ScraperCategory.cryptocurrency;
      case 32:
        return ScraperCategory.images;
      case 33:
        return ScraperCategory.videos;
      case 34:
        return ScraperCategory.other;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "ScraperCategory"');
    }
  }

  @override
  int toJson() => index;

  @override
  String toString() => name;
}
