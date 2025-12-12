import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// Navigation item for creating a new scrappable
  ///
  /// In en, this message translates to:
  /// **'Create Scrappable'**
  String get landing_nav_create_scrappable;

  /// Navigation item for how it works section
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get landing_nav_how_it_works;

  /// Navigation item for auto-fix section
  ///
  /// In en, this message translates to:
  /// **'Auto-Fix'**
  String get landing_nav_auto_fix;

  /// Navigation item for features section
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get landing_nav_features;

  /// Navigation item for marketplace section
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get landing_nav_marketplace;

  /// Navigation item for pricing section
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get landing_nav_pricing;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get landing_sign_in;

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'ZenScrap'**
  String get landing_app_name;

  /// Learn more scroll indicator text
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get landing_learn_more;

  /// Main hero section headline
  ///
  /// In en, this message translates to:
  /// **'Web Scrapers That\nFix Themselves'**
  String get landing_hero_title;

  /// Hero section subheadline
  ///
  /// In en, this message translates to:
  /// **'Describe what you want to extract. Our AI builds, tests, and maintains your scraper automatically. No code. No CSS selectors. No broken endpoints.'**
  String get landing_hero_subtitle;

  /// Label for target URL input field
  ///
  /// In en, this message translates to:
  /// **'Target URL'**
  String get landing_hero_target_url_label;

  /// Hint text for target URL input field
  ///
  /// In en, this message translates to:
  /// **'https://example.com/product/12345'**
  String get landing_hero_target_url_hint;

  /// Validation error for invalid URL
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get landing_hero_url_validation_invalid;

  /// Validation error for URL minimum length
  ///
  /// In en, this message translates to:
  /// **'URL must be at least 10 characters'**
  String get landing_hero_url_validation_min_length;

  /// Validation error for URL maximum length
  ///
  /// In en, this message translates to:
  /// **'URL must be less than 500 characters'**
  String get landing_hero_url_validation_max_length;

  /// Label for prompt input field
  ///
  /// In en, this message translates to:
  /// **'What do you want to extract?'**
  String get landing_hero_prompt_label;

  /// Hint text for prompt input field
  ///
  /// In en, this message translates to:
  /// **'E.g. Extract product name, price, and images'**
  String get landing_hero_prompt_hint;

  /// Validation error for prompt minimum length
  ///
  /// In en, this message translates to:
  /// **'Prompt must be at least 10 characters'**
  String get landing_hero_prompt_validation_min_length;

  /// Validation error for prompt maximum length
  ///
  /// In en, this message translates to:
  /// **'Prompt must be less than 2200 characters'**
  String get landing_hero_prompt_validation_max_length;

  /// Call-to-action button text in hero section
  ///
  /// In en, this message translates to:
  /// **'Create Your First Scraper'**
  String get landing_hero_cta_button;

  /// Free label next to CTA button
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get landing_hero_free_label;

  /// Trust badge - no credit card needed
  ///
  /// In en, this message translates to:
  /// **'No credit card required'**
  String get landing_trust_no_credit_card;

  /// Trust badge - no signup required
  ///
  /// In en, this message translates to:
  /// **'No signup to test'**
  String get landing_trust_no_signup;

  /// Trust badge - quick setup time
  ///
  /// In en, this message translates to:
  /// **'Ready in under 2 minutes'**
  String get landing_trust_ready_in_minutes;

  /// Problem section main title
  ///
  /// In en, this message translates to:
  /// **'Traditional Web Scraping is Broken'**
  String get landing_problem_title;

  /// Problem section subtitle
  ///
  /// In en, this message translates to:
  /// **'Hours lost to CSS selectors. Scrapers that break every week. Anti-bot systems that block your requests. Sound familiar?'**
  String get landing_problem_subtitle;

  /// Problem card title - CSS selectors
  ///
  /// In en, this message translates to:
  /// **'CSS Selector Hell'**
  String get landing_problem_css_title;

  /// Problem card description - CSS selectors
  ///
  /// In en, this message translates to:
  /// **'Hunting through HTML to find the right selectors, only to have them break when the site updates.'**
  String get landing_problem_css_description;

  /// Problem card title - maintenance
  ///
  /// In en, this message translates to:
  /// **'Constant Maintenance'**
  String get landing_problem_maintenance_title;

  /// Problem card description - maintenance
  ///
  /// In en, this message translates to:
  /// **'Websites change their structure constantly. Your scraper worked yesterday—today it returns empty data.'**
  String get landing_problem_maintenance_description;

  /// Problem card title - anti-bot
  ///
  /// In en, this message translates to:
  /// **'Anti-Bot Nightmares'**
  String get landing_problem_antibot_title;

  /// Problem card description - anti-bot
  ///
  /// In en, this message translates to:
  /// **'CAPTCHAs, rate limits, IP bans. Fighting anti-bot systems is a full-time job.'**
  String get landing_problem_antibot_description;

  /// Problem card title - productivity
  ///
  /// In en, this message translates to:
  /// **'Lost Productivity'**
  String get landing_problem_productivity_title;

  /// Problem card description - productivity
  ///
  /// In en, this message translates to:
  /// **'Every hour debugging scrapers is an hour not spent on your actual business.'**
  String get landing_problem_productivity_description;

  /// How it works section main title
  ///
  /// In en, this message translates to:
  /// **'Three Steps to Automated Data'**
  String get landing_how_title;

  /// How it works section subtitle
  ///
  /// In en, this message translates to:
  /// **'No code. No configuration. Just describe what you need.'**
  String get landing_how_subtitle;

  /// Step 1 title
  ///
  /// In en, this message translates to:
  /// **'Paste Your URL'**
  String get landing_how_step1_title;

  /// Step 1 description
  ///
  /// In en, this message translates to:
  /// **'Drop the link to the page you want to extract data from. Any website, any complexity.'**
  String get landing_how_step1_description;

  /// Step 2 title
  ///
  /// In en, this message translates to:
  /// **'Describe What You Want'**
  String get landing_how_step2_title;

  /// Step 2 description
  ///
  /// In en, this message translates to:
  /// **'Tell our AI in plain language what data you need. Product prices, article content, user profiles—anything.'**
  String get landing_how_step2_description;

  /// Step 3 title
  ///
  /// In en, this message translates to:
  /// **'Get Your Self-Healing API'**
  String get landing_how_step3_title;

  /// Step 3 description
  ///
  /// In en, this message translates to:
  /// **'Receive a ready-to-use API endpoint that automatically adapts when the target site changes.'**
  String get landing_how_step3_description;

  /// Note about AI capabilities
  ///
  /// In en, this message translates to:
  /// **'AI automatically generates name, description, category, and URL patterns'**
  String get landing_how_ai_note;

  /// Auto-fix section badge text
  ///
  /// In en, this message translates to:
  /// **'INDUSTRY FIRST'**
  String get landing_autofix_badge;

  /// Auto-fix section main title
  ///
  /// In en, this message translates to:
  /// **'The Self-Healing Web Scraper'**
  String get landing_autofix_title;

  /// Auto-fix section subtitle
  ///
  /// In en, this message translates to:
  /// **'Websites change. Your scrapers don\'t have to break. Our AI automatically detects when a target site updates and fixes your extraction rules—before you even notice.'**
  String get landing_autofix_subtitle;

  /// Auto-fix step 1 title
  ///
  /// In en, this message translates to:
  /// **'Site Changes Detected'**
  String get landing_autofix_step1_title;

  /// Auto-fix step 1 description
  ///
  /// In en, this message translates to:
  /// **'Our system monitors your scrapers and detects when extraction rules start failing.'**
  String get landing_autofix_step1_description;

  /// Auto-fix step 2 title
  ///
  /// In en, this message translates to:
  /// **'AI Analyzes & Adapts'**
  String get landing_autofix_step2_title;

  /// Auto-fix step 2 description
  ///
  /// In en, this message translates to:
  /// **'The AI examines the new page structure and generates updated extraction rules.'**
  String get landing_autofix_step2_description;

  /// Auto-fix step 3 title
  ///
  /// In en, this message translates to:
  /// **'Scraper Fixed'**
  String get landing_autofix_step3_title;

  /// Auto-fix step 3 description
  ///
  /// In en, this message translates to:
  /// **'Your endpoint continues working seamlessly. You receive an email notification.'**
  String get landing_autofix_step3_description;

  /// Notifications feature title
  ///
  /// In en, this message translates to:
  /// **'Proactive Notifications'**
  String get landing_autofix_notifications_title;

  /// Notifications feature description
  ///
  /// In en, this message translates to:
  /// **'Get notified when a site changes and your scraper is being auto-fixed.'**
  String get landing_autofix_notifications_description;

  /// Comparison column title - without
  ///
  /// In en, this message translates to:
  /// **'Without ZenScrap'**
  String get landing_autofix_without_title;

  /// Without ZenScrap item 1
  ///
  /// In en, this message translates to:
  /// **'Scraper breaks unexpectedly'**
  String get landing_autofix_without_item1;

  /// Without ZenScrap item 2
  ///
  /// In en, this message translates to:
  /// **'Hours spent debugging'**
  String get landing_autofix_without_item2;

  /// Without ZenScrap item 3
  ///
  /// In en, this message translates to:
  /// **'Lost data and revenue'**
  String get landing_autofix_without_item3;

  /// Without ZenScrap item 4
  ///
  /// In en, this message translates to:
  /// **'Constant maintenance burden'**
  String get landing_autofix_without_item4;

  /// Comparison column title - with
  ///
  /// In en, this message translates to:
  /// **'With ZenScrap'**
  String get landing_autofix_with_title;

  /// With ZenScrap item 1
  ///
  /// In en, this message translates to:
  /// **'AI detects issues instantly'**
  String get landing_autofix_with_item1;

  /// With ZenScrap item 2
  ///
  /// In en, this message translates to:
  /// **'Automatic fixes in minutes'**
  String get landing_autofix_with_item2;

  /// With ZenScrap item 3
  ///
  /// In en, this message translates to:
  /// **'Zero data loss'**
  String get landing_autofix_with_item3;

  /// With ZenScrap item 4
  ///
  /// In en, this message translates to:
  /// **'Set it and forget it'**
  String get landing_autofix_with_item4;

  /// Features section main title
  ///
  /// In en, this message translates to:
  /// **'Built for the Modern Web'**
  String get landing_features_title;

  /// Features section subtitle
  ///
  /// In en, this message translates to:
  /// **'Enterprise-grade infrastructure wrapped in a simple interface.'**
  String get landing_features_subtitle;

  /// Feature card title - cost optimization
  ///
  /// In en, this message translates to:
  /// **'Smart Cost Optimization'**
  String get landing_features_cost_title;

  /// Feature card description - cost optimization
  ///
  /// In en, this message translates to:
  /// **'AI automatically tests configurations and finds the cheapest option that works. No wasted credits.'**
  String get landing_features_cost_description;

  /// Feature card title - anti-bot
  ///
  /// In en, this message translates to:
  /// **'Anti-Bot Handled'**
  String get landing_features_antibot_title;

  /// Feature card description - anti-bot
  ///
  /// In en, this message translates to:
  /// **'CAPTCHAs, rate limits, fingerprinting—we handle all of it so you don\'t have to.'**
  String get landing_features_antibot_description;

  /// Feature card title - geo-targeting
  ///
  /// In en, this message translates to:
  /// **'Global Geo-Targeting'**
  String get landing_features_geo_title;

  /// Feature card description - geo-targeting
  ///
  /// In en, this message translates to:
  /// **'Access region-locked content with automatic proxy selection based on target location.'**
  String get landing_features_geo_description;

  /// Feature card title - testing
  ///
  /// In en, this message translates to:
  /// **'In-Platform Testing'**
  String get landing_features_testing_title;

  /// Feature card description - testing
  ///
  /// In en, this message translates to:
  /// **'Test any scraper instantly without leaving the platform. No Postman needed.'**
  String get landing_features_testing_description;

  /// Feature card title - analytics
  ///
  /// In en, this message translates to:
  /// **'Deep Analytics'**
  String get landing_features_analytics_title;

  /// Feature card description - analytics
  ///
  /// In en, this message translates to:
  /// **'Track every request, identify issues instantly, and monitor usage across time ranges.'**
  String get landing_features_analytics_description;

  /// Feature card title - JavaScript rendering
  ///
  /// In en, this message translates to:
  /// **'JavaScript Rendering'**
  String get landing_features_js_title;

  /// Feature card description - JavaScript rendering
  ///
  /// In en, this message translates to:
  /// **'Full headless browser support for SPAs, dynamic content, and infinite scroll pages.'**
  String get landing_features_js_description;

  /// Marketplace section badge text
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY'**
  String get landing_marketplace_badge;

  /// Marketplace section main title
  ///
  /// In en, this message translates to:
  /// **'Don\'t Build What Already Exists'**
  String get landing_marketplace_title;

  /// Marketplace section subtitle
  ///
  /// In en, this message translates to:
  /// **'Browse our marketplace of pre-built scrapers for popular websites. Use them instantly or learn from how others solved similar challenges.'**
  String get landing_marketplace_subtitle;

  /// Marketplace feature title - pre-built scrapers
  ///
  /// In en, this message translates to:
  /// **'Pre-Built Scrapers'**
  String get landing_marketplace_prebuilt_title;

  /// Marketplace feature description - pre-built scrapers
  ///
  /// In en, this message translates to:
  /// **'Amazon, eBay, LinkedIn, news sites—popular websites already have working scrapers ready to use.'**
  String get landing_marketplace_prebuilt_description;

  /// Marketplace feature title - usage statistics
  ///
  /// In en, this message translates to:
  /// **'Usage Statistics'**
  String get landing_marketplace_stats_title;

  /// Marketplace feature description - usage statistics
  ///
  /// In en, this message translates to:
  /// **'See which scrapers are most popular and reliable based on real community usage data.'**
  String get landing_marketplace_stats_description;

  /// Marketplace feature title - instant testing
  ///
  /// In en, this message translates to:
  /// **'Instant Testing'**
  String get landing_marketplace_testing_title;

  /// Marketplace feature description - instant testing
  ///
  /// In en, this message translates to:
  /// **'Try any marketplace scraper before using it. Test with your own parameters to verify results.'**
  String get landing_marketplace_testing_description;

  /// Marketplace category - e-commerce
  ///
  /// In en, this message translates to:
  /// **'E-Commerce'**
  String get landing_marketplace_category_ecommerce;

  /// Marketplace category - news and media
  ///
  /// In en, this message translates to:
  /// **'News & Media'**
  String get landing_marketplace_category_news;

  /// Marketplace category - job listings
  ///
  /// In en, this message translates to:
  /// **'Job Listings'**
  String get landing_marketplace_category_jobs;

  /// Marketplace category - social media
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get landing_marketplace_category_social;

  /// Marketplace category - real estate
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get landing_marketplace_category_realestate;

  /// Marketplace category - finance
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get landing_marketplace_category_finance;

  /// Marketplace category - sports
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get landing_marketplace_category_sports;

  /// Marketplace category - more categories
  ///
  /// In en, this message translates to:
  /// **'+ 25 more'**
  String get landing_marketplace_category_more;

  /// Pricing section main title
  ///
  /// In en, this message translates to:
  /// **'Simple, Transparent Pricing'**
  String get landing_pricing_title;

  /// Pricing section subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that fits your needs. Scale as you grow.'**
  String get landing_pricing_subtitle;

  /// Final CTA section main title
  ///
  /// In en, this message translates to:
  /// **'Ready to Stop Babysitting\nYour Scrapers?'**
  String get landing_cta_title;

  /// Final CTA section subtitle
  ///
  /// In en, this message translates to:
  /// **'Join developers who\'ve reclaimed their time. Build once, let AI maintain forever.'**
  String get landing_cta_subtitle;

  /// Final CTA create scraper button
  ///
  /// In en, this message translates to:
  /// **'Create Your First Scraper'**
  String get landing_cta_create_button;

  /// Final CTA browse marketplace button
  ///
  /// In en, this message translates to:
  /// **'Browse Marketplace'**
  String get landing_cta_marketplace_button;

  /// Footer tagline text
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Web Scraping'**
  String get landing_footer_tagline;

  /// Main title for the account page
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_title;

  /// Section title for account information
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get account_information_title;

  /// Label for user name field
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get account_user_name_label;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get account_email_label;

  /// Label for subscription plan field
  ///
  /// In en, this message translates to:
  /// **'Your subscription plan'**
  String get account_subscription_plan_label;

  /// Title for appearance/theme customization section
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get account_appearance_title;

  /// Title for display mode (light/dark theme) card
  ///
  /// In en, this message translates to:
  /// **'Display Mode'**
  String get account_display_mode_title;

  /// Subtitle for display mode card
  ///
  /// In en, this message translates to:
  /// **'Choose between light and dark theme'**
  String get account_display_mode_subtitle;

  /// Title for accent color picker card
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get account_accent_color_title;

  /// Subtitle for accent color picker card
  ///
  /// In en, this message translates to:
  /// **'Personalize the app with your favorite color'**
  String get account_accent_color_subtitle;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get account_loading;

  /// Tooltip for change profile image button
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get account_change_image_tooltip;

  /// Label for light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get account_brightness_light;

  /// Label for dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get account_brightness_dark;

  /// Beta badge text
  ///
  /// In en, this message translates to:
  /// **'BETA'**
  String get account_beta_badge;

  /// Title in dark mode beta warning
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get account_dark_mode_title;

  /// Warning message about dark mode being in beta
  ///
  /// In en, this message translates to:
  /// **'Some UI elements may not display perfectly. We\'re actively improving it.'**
  String get account_dark_mode_beta_warning;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
