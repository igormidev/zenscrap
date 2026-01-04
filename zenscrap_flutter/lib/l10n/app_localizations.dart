import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart' deferred as app_localizations_de;
import 'app_localizations_en.dart' deferred as app_localizations_en;
import 'app_localizations_es.dart' deferred as app_localizations_es;
import 'app_localizations_fr.dart' deferred as app_localizations_fr;
import 'app_localizations_ja.dart' deferred as app_localizations_ja;
import 'app_localizations_pt.dart' deferred as app_localizations_pt;

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

  /// Label for language selector in mobile drawer
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get landing_drawer_language;

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

  /// Dialog title when user tries to browse marketplace without logging in
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get landing_marketplace_login_title;

  /// Dialog message when user tries to browse marketplace without logging in
  ///
  /// In en, this message translates to:
  /// **'You need to log in to see the marketplace endpoints.'**
  String get landing_marketplace_login_message;

  /// OK button text for marketplace login dialog
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get landing_marketplace_login_ok;

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

  /// Button text to sync subscription from Stripe
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get account_subscription_sync;

  /// Loading text while syncing subscription
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get account_subscription_syncing;

  /// Success message after syncing subscription
  ///
  /// In en, this message translates to:
  /// **'Subscription synced successfully'**
  String get account_subscription_sync_success;

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

  /// Title for AI usage page
  ///
  /// In en, this message translates to:
  /// **'AI Usage'**
  String get ai_usage_title;

  /// Refresh button label
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get ai_usage_refresh;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get ai_usage_retry;

  /// Credit history section title
  ///
  /// In en, this message translates to:
  /// **'Credit History'**
  String get ai_usage_credit_history;

  /// Empty state title for credit history
  ///
  /// In en, this message translates to:
  /// **'No credit history yet'**
  String get ai_usage_no_credit_history;

  /// Empty state description for credit history
  ///
  /// In en, this message translates to:
  /// **'Your AI credit transactions will appear here'**
  String get ai_usage_credit_history_empty_description;

  /// Title for monthly AI credits transaction
  ///
  /// In en, this message translates to:
  /// **'Monthly AI Credits'**
  String get ai_usage_monthly_ai_credits;

  /// Title for initial account AI credit
  ///
  /// In en, this message translates to:
  /// **'Initial Credit'**
  String get ai_usage_initial_credit;

  /// Subtitle for initial account AI credit
  ///
  /// In en, this message translates to:
  /// **'Welcome bonus'**
  String get ai_usage_welcome_bonus;

  /// Free plan name
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get ai_usage_plan_name_free;

  /// Plan subtitle with plan name
  ///
  /// In en, this message translates to:
  /// **'{planName} plan'**
  String ai_usage_plan_subtitle(String planName);

  /// Fallback title for unknown transaction types
  ///
  /// In en, this message translates to:
  /// **'Unknown Transaction'**
  String get ai_usage_unknown_transaction;

  /// AI credits overview section title
  ///
  /// In en, this message translates to:
  /// **'AI Credits Overview'**
  String get ai_usage_credits_overview;

  /// Label for remaining credits
  ///
  /// In en, this message translates to:
  /// **'Remaining Credits'**
  String get ai_usage_remaining_credits;

  /// Label for monthly limit
  ///
  /// In en, this message translates to:
  /// **'Monthly Limit'**
  String get ai_usage_monthly_limit;

  /// Usage percentage text
  ///
  /// In en, this message translates to:
  /// **'{percentage}% used this month'**
  String ai_usage_percentage_used(String percentage);

  /// Badge text when user has their own API key
  ///
  /// In en, this message translates to:
  /// **'Using your own OpenAI API key'**
  String get ai_usage_using_own_api_key;

  /// Auto-fix sessions section title
  ///
  /// In en, this message translates to:
  /// **'Auto-Fix Sessions'**
  String get ai_usage_autofix_sessions;

  /// Empty state title for auto-fix sessions
  ///
  /// In en, this message translates to:
  /// **'No auto-fix sessions yet'**
  String get ai_usage_no_autofix_sessions;

  /// Empty state description for auto-fix sessions
  ///
  /// In en, this message translates to:
  /// **'When your scrappables break, our AI will automatically attempt to fix them. Those sessions will appear here.'**
  String get ai_usage_autofix_empty_description;

  /// Label for powerful AI model
  ///
  /// In en, this message translates to:
  /// **'Powerful Model'**
  String get ai_usage_powerful_model;

  /// Label for normal AI model
  ///
  /// In en, this message translates to:
  /// **'Normal Model'**
  String get ai_usage_normal_model;

  /// Token count display
  ///
  /// In en, this message translates to:
  /// **'{count} tokens'**
  String ai_usage_tokens_count(String count);

  /// Scrappable identifier
  ///
  /// In en, this message translates to:
  /// **'Scrappable #{id}'**
  String ai_usage_scrappable_id(int id);

  /// Pending status label
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ai_usage_status_pending;

  /// In progress status label
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get ai_usage_status_in_progress;

  /// Success status label
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get ai_usage_status_success;

  /// Failed status label
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get ai_usage_status_failed;

  /// Exhausted status label
  ///
  /// In en, this message translates to:
  /// **'Exhausted'**
  String get ai_usage_status_exhausted;

  /// Cancelled status label
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get ai_usage_status_cancelled;

  /// Label for triggered at detail
  ///
  /// In en, this message translates to:
  /// **'Triggered at'**
  String get ai_usage_triggered_at;

  /// Consecutive errors detail value
  ///
  /// In en, this message translates to:
  /// **'{count} consecutive errors (threshold: {threshold})'**
  String ai_usage_consecutive_errors(int count, int threshold);

  /// Label for API key detail
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get ai_usage_api_key_label;

  /// Value when using user's own API key
  ///
  /// In en, this message translates to:
  /// **'Your own key'**
  String get ai_usage_your_own_key;

  /// Value when using platform API key
  ///
  /// In en, this message translates to:
  /// **'Platform key'**
  String get ai_usage_platform_key;

  /// Label for tokens used detail
  ///
  /// In en, this message translates to:
  /// **'Tokens used'**
  String get ai_usage_tokens_used;

  /// Label for cost detail
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get ai_usage_cost;

  /// Title for fix summary section
  ///
  /// In en, this message translates to:
  /// **'Fix Summary'**
  String get ai_usage_fix_summary;

  /// Title for failure reason section
  ///
  /// In en, this message translates to:
  /// **'Failure Reason'**
  String get ai_usage_failure_reason;

  /// Attempts section title with count
  ///
  /// In en, this message translates to:
  /// **'Attempts ({count})'**
  String ai_usage_attempts_count(int count);

  /// Attempt in progress status
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get ai_usage_attempt_status_in_progress;

  /// Attempt success status
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get ai_usage_attempt_status_success;

  /// Attempt AI error status
  ///
  /// In en, this message translates to:
  /// **'AI Error'**
  String get ai_usage_attempt_status_ai_error;

  /// Attempt API error status
  ///
  /// In en, this message translates to:
  /// **'API Error'**
  String get ai_usage_attempt_status_api_error;

  /// Attempt validation failed status
  ///
  /// In en, this message translates to:
  /// **'Validation Failed'**
  String get ai_usage_attempt_status_validation_failed;

  /// Short abbreviation for tokens
  ///
  /// In en, this message translates to:
  /// **'tok'**
  String get ai_usage_tokens_short;

  /// Load more button label
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get ai_usage_load_more;

  /// Title for the API key management section
  ///
  /// In en, this message translates to:
  /// **'OpenAI API Key'**
  String get ai_usage_api_key_section_title;

  /// Description explaining what the API key is for
  ///
  /// In en, this message translates to:
  /// **'Use your own OpenAI API key to bypass monthly credit limits. Your key is stored securely.'**
  String get ai_usage_api_key_description;

  /// Status text when API key is set
  ///
  /// In en, this message translates to:
  /// **'API key configured'**
  String get ai_usage_api_key_configured;

  /// Status text when no API key is set
  ///
  /// In en, this message translates to:
  /// **'No API key configured'**
  String get ai_usage_api_key_not_configured;

  /// Button to add API key
  ///
  /// In en, this message translates to:
  /// **'Add API Key'**
  String get ai_usage_api_key_add;

  /// Button to edit API key
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get ai_usage_api_key_edit;

  /// Button to remove API key
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get ai_usage_api_key_remove;

  /// Dialog title for API key input
  ///
  /// In en, this message translates to:
  /// **'OpenAI API Key'**
  String get ai_usage_api_key_dialog_title;

  /// Hint text for API key input field
  ///
  /// In en, this message translates to:
  /// **'sk-...'**
  String get ai_usage_api_key_dialog_hint;

  /// Description in the API key dialog
  ///
  /// In en, this message translates to:
  /// **'Enter your OpenAI API key. The key will be validated before saving.'**
  String get ai_usage_api_key_dialog_description;

  /// Tooltip for showing the API key
  ///
  /// In en, this message translates to:
  /// **'Show API key'**
  String get ai_usage_api_key_show;

  /// Tooltip for hiding the API key
  ///
  /// In en, this message translates to:
  /// **'Hide API key'**
  String get ai_usage_api_key_hide;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get ai_usage_api_key_save;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get ai_usage_api_key_cancel;

  /// Confirmation dialog title for removing API key
  ///
  /// In en, this message translates to:
  /// **'Remove API Key?'**
  String get ai_usage_api_key_remove_confirm_title;

  /// Confirmation dialog message for removing API key
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove your OpenAI API key? You will use the platform\'s monthly credits instead.'**
  String get ai_usage_api_key_remove_confirm_message;

  /// Success message when API key is updated
  ///
  /// In en, this message translates to:
  /// **'API key updated successfully'**
  String get ai_usage_api_key_updated;

  /// Success message when API key is removed
  ///
  /// In en, this message translates to:
  /// **'API key removed successfully'**
  String get ai_usage_api_key_removed;

  /// Error message when API key update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update API key'**
  String get ai_usage_api_key_error;

  /// Main title for API analytics page
  ///
  /// In en, this message translates to:
  /// **'API Analytics'**
  String get api_analytics_title;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get api_analytics_retry;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get api_analytics_refresh;

  /// Load more button text
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get api_analytics_load_more;

  /// Title when no scrappable is selected
  ///
  /// In en, this message translates to:
  /// **'No Scrappable Selected'**
  String get api_analytics_no_scrappable_selected;

  /// Hint text to select a scrappable
  ///
  /// In en, this message translates to:
  /// **'Select a scrappable from the list to view detailed analytics'**
  String get api_analytics_select_scrappable_hint;

  /// Message when there are no more analytics to load
  ///
  /// In en, this message translates to:
  /// **'No more analytics to load'**
  String get api_analytics_no_more_to_load;

  /// Error title when analytics fail to load
  ///
  /// In en, this message translates to:
  /// **'Error Loading Analytics'**
  String get api_analytics_error_loading;

  /// Shows count of items displayed
  ///
  /// In en, this message translates to:
  /// **'Showing {current} of {total}'**
  String api_analytics_showing_count(int current, int total);

  /// Items count display
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String api_analytics_items_count(int current, int total);

  /// Success status label
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get api_analytics_status_success;

  /// Client error status label
  ///
  /// In en, this message translates to:
  /// **'Client Error'**
  String get api_analytics_status_client_error;

  /// Server error status label
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get api_analytics_status_server_error;

  /// Insufficient credits status label
  ///
  /// In en, this message translates to:
  /// **'Insufficient Credits'**
  String get api_analytics_status_insufficient_credits;

  /// Max concurrency exceeded status label
  ///
  /// In en, this message translates to:
  /// **'Max Concurrency'**
  String get api_analytics_status_max_concurrency;

  /// Extract rules error status label
  ///
  /// In en, this message translates to:
  /// **'Extract Rules Error'**
  String get api_analytics_status_extract_rules_error;

  /// 4xx status code label
  ///
  /// In en, this message translates to:
  /// **'4xx'**
  String get api_analytics_status_4xx;

  /// 5xx status code label
  ///
  /// In en, this message translates to:
  /// **'5xx'**
  String get api_analytics_status_5xx;

  /// 2xx status code label
  ///
  /// In en, this message translates to:
  /// **'2xx'**
  String get api_analytics_status_2xx;

  /// No credits stat card label
  ///
  /// In en, this message translates to:
  /// **'No Credits'**
  String get api_analytics_stat_no_credits;

  /// Extract rules errors stat card label
  ///
  /// In en, this message translates to:
  /// **'Extract rules errors'**
  String get api_analytics_stat_extract_rules_errors;

  /// Tooltip for success status
  ///
  /// In en, this message translates to:
  /// **'Requests completed successfully'**
  String get api_analytics_tooltip_success;

  /// Tooltip for client error status
  ///
  /// In en, this message translates to:
  /// **'Client errors - invalid request parameters or missing data'**
  String get api_analytics_tooltip_client_error;

  /// Tooltip for server error status
  ///
  /// In en, this message translates to:
  /// **'Server errors - issues with the target website'**
  String get api_analytics_tooltip_server_error;

  /// Tooltip for extract rules error status
  ///
  /// In en, this message translates to:
  /// **'The AI-generated extract rules failed to parse the response'**
  String get api_analytics_tooltip_extract_rules_error;

  /// Tooltip for insufficient credits status
  ///
  /// In en, this message translates to:
  /// **'Requests failed due to insufficient credits'**
  String get api_analytics_tooltip_insufficient_credits;

  /// Tooltip for max concurrency status
  ///
  /// In en, this message translates to:
  /// **'Requests rejected due to concurrency limit'**
  String get api_analytics_tooltip_max_concurrency;

  /// Last hour time scope option
  ///
  /// In en, this message translates to:
  /// **'Last Hour'**
  String get api_analytics_scope_last_hour;

  /// Last 12 hours time scope option
  ///
  /// In en, this message translates to:
  /// **'Last 12 Hours'**
  String get api_analytics_scope_last_12_hours;

  /// Last 24 hours time scope option
  ///
  /// In en, this message translates to:
  /// **'Last 24 Hours'**
  String get api_analytics_scope_last_24_hours;

  /// Last 7 days time scope option
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get api_analytics_scope_last_7_days;

  /// Last 30 days time scope option
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get api_analytics_scope_last_30_days;

  /// Scope explanation for last hour
  ///
  /// In en, this message translates to:
  /// **'Each column represents 5 minutes'**
  String get api_analytics_column_5_minutes;

  /// Scope explanation for last 12 hours
  ///
  /// In en, this message translates to:
  /// **'Each column represents 1 hour'**
  String get api_analytics_column_1_hour;

  /// Scope explanation for last 24 hours
  ///
  /// In en, this message translates to:
  /// **'Each column represents 2 hours'**
  String get api_analytics_column_2_hours;

  /// Scope explanation for last 7 or 30 days
  ///
  /// In en, this message translates to:
  /// **'Each column represents 1 day'**
  String get api_analytics_column_1_day;

  /// Warning about request delay
  ///
  /// In en, this message translates to:
  /// **'A request can take up to 10 minutes to appear here'**
  String get api_analytics_request_delay_warning;

  /// Empty state for scrappable with no requests
  ///
  /// In en, this message translates to:
  /// **'No requests'**
  String get api_analytics_no_requests;

  /// Max concurrency exceeded chip label
  ///
  /// In en, this message translates to:
  /// **'Max concurrency exceeded'**
  String get api_analytics_max_concurrency_exceeded;

  /// Insufficient credits chip label
  ///
  /// In en, this message translates to:
  /// **'Insufficient credits'**
  String get api_analytics_insufficient_credits_chip;

  /// Last 12 hours badge label
  ///
  /// In en, this message translates to:
  /// **'Last 12 hours'**
  String get api_analytics_last_12_hours;

  /// Total requests count in tooltip
  ///
  /// In en, this message translates to:
  /// **'Total: {count} requests'**
  String api_analytics_total_requests(int count);

  /// Success count in tooltip
  ///
  /// In en, this message translates to:
  /// **'Success: {count} ({percentage}%)'**
  String api_analytics_tooltip_success_count(int count, String percentage);

  /// 4xx error count in tooltip
  ///
  /// In en, this message translates to:
  /// **'4xx: {count} ({percentage}%)'**
  String api_analytics_tooltip_4xx_count(int count, String percentage);

  /// 5xx error count in tooltip
  ///
  /// In en, this message translates to:
  /// **'5xx: {count} ({percentage}%)'**
  String api_analytics_tooltip_5xx_count(int count, String percentage);

  /// ScrapingBee error count in tooltip
  ///
  /// In en, this message translates to:
  /// **'ScrapingBee Error: {count} ({percentage}%)'**
  String api_analytics_tooltip_scraping_bee_error(int count, String percentage);

  /// No credits count in tooltip
  ///
  /// In en, this message translates to:
  /// **'No Credits: {count} ({percentage}%)'**
  String api_analytics_tooltip_no_credits_count(int count, String percentage);

  /// Max concurrency count in tooltip
  ///
  /// In en, this message translates to:
  /// **'Max Concurrency: {count} ({percentage}%)'**
  String api_analytics_tooltip_max_concurrency_count(
    int count,
    String percentage,
  );

  /// Show less tooltip
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get api_analytics_show_less;

  /// Show details tooltip
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get api_analytics_show_details;

  /// Title field label in details
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get api_analytics_detail_title;

  /// Description field label in details
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get api_analytics_detail_description;

  /// Error object field label in details
  ///
  /// In en, this message translates to:
  /// **'Error Object'**
  String get api_analytics_detail_error_object;

  /// Stack trace field label in details
  ///
  /// In en, this message translates to:
  /// **'Stack Trace'**
  String get api_analytics_detail_stack_trace;

  /// Request payload field label in details
  ///
  /// In en, this message translates to:
  /// **'Request Payload'**
  String get api_analytics_detail_request_payload;

  /// Response data field label in details
  ///
  /// In en, this message translates to:
  /// **'Response Data'**
  String get api_analytics_detail_response_data;

  /// Success badge text
  ///
  /// In en, this message translates to:
  /// **'SUCCESS'**
  String get api_analytics_success_badge;

  /// Collapse tooltip
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get api_analytics_collapse;

  /// Expand tooltip
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get api_analytics_expand;

  /// Snackbar message when content is copied
  ///
  /// In en, this message translates to:
  /// **'{label} copied to clipboard'**
  String api_analytics_copied_to_clipboard(String label);

  /// Copy button tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy {label}'**
  String api_analytics_copy_label(String label);

  /// Message to expand more lines
  ///
  /// In en, this message translates to:
  /// **'Click expand to see {count}+ more lines'**
  String api_analytics_expand_more_lines(int count);

  /// Subtitle explaining what endpoints are shown
  ///
  /// In en, this message translates to:
  /// **'Endpoints you\'ve called in the selected time period'**
  String get api_analytics_subtitle;

  /// Tooltip for time scope selector
  ///
  /// In en, this message translates to:
  /// **'Shows endpoints you\'ve interacted with during this time period'**
  String get api_analytics_scope_tooltip;

  /// Badge label for user's own endpoints
  ///
  /// In en, this message translates to:
  /// **'Yours'**
  String get api_analytics_badge_yours;

  /// Badge label for marketplace endpoints
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get api_analytics_badge_marketplace;

  /// Label for API key in analytics details
  ///
  /// In en, this message translates to:
  /// **'API Key:'**
  String get api_analytics_api_key_label;

  /// Placeholder shown when API key was deleted
  ///
  /// In en, this message translates to:
  /// **'API Key (deleted)'**
  String get api_analytics_api_key_deleted;

  /// Snackbar message when API key is copied
  ///
  /// In en, this message translates to:
  /// **'API key copied to clipboard'**
  String get api_analytics_api_key_copied;

  /// Copy button label
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get api_analytics_copy_button;

  /// Prefix for average duration badge
  ///
  /// In en, this message translates to:
  /// **'Avg: '**
  String get api_analytics_average_duration_prefix;

  /// Tooltip for average duration badge on scrappable cards
  ///
  /// In en, this message translates to:
  /// **'Average request duration'**
  String get scrappable_card_average_duration_tooltip;

  /// Label for request duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get api_analytics_duration_label;

  /// Error message shown when loading more analytics fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load more data. Tap to retry.'**
  String get api_analytics_load_more_failed;

  /// Main title for API usage page
  ///
  /// In en, this message translates to:
  /// **'Api Credits & Keys'**
  String get api_usage_page_title;

  /// Refresh button label
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get api_usage_refresh;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get api_usage_retry;

  /// Overview navigation tab label
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get api_usage_overview;

  /// API Keys navigation tab label
  ///
  /// In en, this message translates to:
  /// **'API Keys'**
  String get api_usage_api_keys;

  /// History navigation tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get api_usage_history;

  /// Title for API usage overview section
  ///
  /// In en, this message translates to:
  /// **'API Usage Overview'**
  String get api_usage_overview_title;

  /// Credit history section title
  ///
  /// In en, this message translates to:
  /// **'Credit History'**
  String get api_usage_credit_history;

  /// Dialog title when new API key is created
  ///
  /// In en, this message translates to:
  /// **'New API Key Created'**
  String get api_usage_new_api_key_created;

  /// Warning message to save API key
  ///
  /// In en, this message translates to:
  /// **'Please copy and save this API key. You won\'t be able to see it again!'**
  String get api_usage_copy_api_key_warning;

  /// Snackbar message when API key is copied
  ///
  /// In en, this message translates to:
  /// **'API key copied to clipboard'**
  String get api_usage_api_key_copied;

  /// Done button label
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get api_usage_done;

  /// Deactivate API key dialog title and tooltip
  ///
  /// In en, this message translates to:
  /// **'Deactivate API Key'**
  String get api_usage_deactivate_api_key;

  /// Confirmation message for deactivating API key
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate this API key? This action cannot be undone.'**
  String get api_usage_deactivate_confirmation;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get api_usage_cancel;

  /// Deactivate button label
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get api_usage_deactivate;

  /// Create key button label
  ///
  /// In en, this message translates to:
  /// **'Create Key'**
  String get api_usage_create_key;

  /// Empty state message when no API keys exist
  ///
  /// In en, this message translates to:
  /// **'No API keys yet'**
  String get api_usage_no_api_keys;

  /// Purchase credits section title
  ///
  /// In en, this message translates to:
  /// **'Purchase API Credits'**
  String get api_usage_purchase_credits;

  /// Best value badge label
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get api_usage_best_value;

  /// Bulk discount badge label
  ///
  /// In en, this message translates to:
  /// **'BULK DISCOUNT'**
  String get api_usage_bulk_discount;

  /// Info text about credits not expiring
  ///
  /// In en, this message translates to:
  /// **'Credits never expire • Instant activation'**
  String get api_usage_credits_never_expire;

  /// Unit price display
  ///
  /// In en, this message translates to:
  /// **'Unit price: {unitPrice}'**
  String api_usage_unit_price(String unitPrice);

  /// Dialog title when Ultra plan is required
  ///
  /// In en, this message translates to:
  /// **'Ultra Plan Required'**
  String get api_usage_ultra_plan_required;

  /// Message explaining Ultra plan requirement
  ///
  /// In en, this message translates to:
  /// **'Credit packages are an exclusive benefit for Ultra plan subscribers.'**
  String get api_usage_ultra_exclusive_benefit;

  /// Benefit item text
  ///
  /// In en, this message translates to:
  /// **'Credits that never expire'**
  String get api_usage_credits_never_expire_benefit;

  /// Benefit item text
  ///
  /// In en, this message translates to:
  /// **'Perfect for traffic spikes'**
  String get api_usage_perfect_for_traffic_spikes;

  /// Maybe later button label
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get api_usage_maybe_later;

  /// Upgrade to Ultra button label
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Ultra'**
  String get api_usage_upgrade_to_ultra;

  /// Message for upgrade dialog
  ///
  /// In en, this message translates to:
  /// **'Unlock the ability to purchase additional credits that never expire. Perfect for handling traffic spikes and seasonal demands.'**
  String get api_usage_unlock_credits_message;

  /// Dialog header title
  ///
  /// In en, this message translates to:
  /// **'Get Credits That Never Expire'**
  String get api_usage_get_credits_title;

  /// Dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'Perfect for traffic spikes & long-term planning'**
  String get api_usage_traffic_spikes_subtitle;

  /// Benefit title
  ///
  /// In en, this message translates to:
  /// **'Credits Never Expire'**
  String get api_usage_credits_never_expire_title;

  /// Benefit description
  ///
  /// In en, this message translates to:
  /// **'Unlike subscription credits that reset monthly, purchased credits stay in your account forever while your Ultra plan is active.'**
  String get api_usage_credits_never_expire_description;

  /// Benefit title
  ///
  /// In en, this message translates to:
  /// **'Instant Activation'**
  String get api_usage_instant_activation_title;

  /// Benefit description
  ///
  /// In en, this message translates to:
  /// **'Credits are added to your account immediately after payment - no waiting, no delays.'**
  String get api_usage_instant_activation_description;

  /// Benefit title
  ///
  /// In en, this message translates to:
  /// **'Scale Without Limits'**
  String get api_usage_scale_without_limits_title;

  /// Benefit description
  ///
  /// In en, this message translates to:
  /// **'Handle traffic spikes, seasonal demands, or special projects without upgrading your monthly plan.'**
  String get api_usage_scale_without_limits_description;

  /// Package selection section title
  ///
  /// In en, this message translates to:
  /// **'Choose Your Package'**
  String get api_usage_choose_package;

  /// 100K credits package
  ///
  /// In en, this message translates to:
  /// **'100,000 credits'**
  String get api_usage_100k_credits;

  /// 1M credits package
  ///
  /// In en, this message translates to:
  /// **'1,000,000 credits'**
  String get api_usage_1m_credits;

  /// 2.5M credits package
  ///
  /// In en, this message translates to:
  /// **'2,500,000 credits'**
  String get api_usage_2_5m_credits;

  /// Small package description
  ///
  /// In en, this message translates to:
  /// **'Great for testing and small projects'**
  String get api_usage_small_package_description;

  /// Medium package description
  ///
  /// In en, this message translates to:
  /// **'Best value for growing applications'**
  String get api_usage_medium_package_description;

  /// Large package description
  ///
  /// In en, this message translates to:
  /// **'Maximum savings for enterprise needs'**
  String get api_usage_large_package_description;

  /// Most popular badge
  ///
  /// In en, this message translates to:
  /// **'MOST POPULAR'**
  String get api_usage_most_popular;

  /// Best deal badge
  ///
  /// In en, this message translates to:
  /// **'BEST DEAL'**
  String get api_usage_best_deal;

  /// Secure payment trust signal
  ///
  /// In en, this message translates to:
  /// **'Secure payment via Stripe'**
  String get api_usage_secure_payment_stripe;

  /// Instant delivery trust signal
  ///
  /// In en, this message translates to:
  /// **'Instant delivery'**
  String get api_usage_instant_delivery;

  /// Not now button label
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get api_usage_not_now;

  /// Get 100K credits button
  ///
  /// In en, this message translates to:
  /// **'Get 100K Credits'**
  String get api_usage_get_100k_credits;

  /// Get 1M credits button
  ///
  /// In en, this message translates to:
  /// **'Get 1M Credits'**
  String get api_usage_get_1m_credits;

  /// Get 2.5M credits button
  ///
  /// In en, this message translates to:
  /// **'Get 2.5M Credits'**
  String get api_usage_get_2_5m_credits;

  /// Checkout loading message
  ///
  /// In en, this message translates to:
  /// **'Preparing checkout...'**
  String get api_usage_preparing_checkout;

  /// Redirect message
  ///
  /// In en, this message translates to:
  /// **'You\'ll be redirected to Stripe in a moment'**
  String get api_usage_redirect_to_stripe;

  /// Checkout failed error title
  ///
  /// In en, this message translates to:
  /// **'Checkout Failed'**
  String get api_usage_checkout_failed;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get api_usage_unexpected_error;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get api_usage_close;

  /// Complete purchase dialog title
  ///
  /// In en, this message translates to:
  /// **'Complete Your Purchase'**
  String get api_usage_complete_purchase;

  /// Checkout opened message
  ///
  /// In en, this message translates to:
  /// **'Checkout opened in a new tab'**
  String get api_usage_checkout_opened;

  /// Instructions to complete purchase
  ///
  /// In en, this message translates to:
  /// **'Complete your purchase in the Stripe checkout page, then refresh this page to see your new credits.'**
  String get api_usage_complete_in_stripe;

  /// Stripe security message
  ///
  /// In en, this message translates to:
  /// **'Secure payment powered by Stripe'**
  String get api_usage_secure_payment_powered_by_stripe;

  /// Refresh and close button
  ///
  /// In en, this message translates to:
  /// **'Refresh & Close'**
  String get api_usage_refresh_and_close;

  /// Account verification error
  ///
  /// In en, this message translates to:
  /// **'Unable to verify account status. Please try again.'**
  String get api_usage_unable_to_verify_account;

  /// Account refreshed snackbar
  ///
  /// In en, this message translates to:
  /// **'Account refreshed'**
  String get api_usage_account_refreshed;

  /// Credits overview section title
  ///
  /// In en, this message translates to:
  /// **'API Credits Overview'**
  String get api_usage_credits_overview;

  /// Total available credits label
  ///
  /// In en, this message translates to:
  /// **'Total Available'**
  String get api_usage_total_available;

  /// Description for total credits
  ///
  /// In en, this message translates to:
  /// **'Credits of purchase and subscription combined'**
  String get api_usage_credits_combined_description;

  /// Subscription credits label
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get api_usage_subscription;

  /// Message when user has no plan
  ///
  /// In en, this message translates to:
  /// **'Subscribe to unlock a plan'**
  String get api_usage_subscribe_to_unlock;

  /// Monthly renewal description
  ///
  /// In en, this message translates to:
  /// **'Will renew monthly {credits}'**
  String api_usage_will_renew_monthly(int credits);

  /// Purchased credits label
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get api_usage_purchased;

  /// Description for purchased credits
  ///
  /// In en, this message translates to:
  /// **'One-time purchase credits that never expire'**
  String get api_usage_purchased_description;

  /// Info text about credits
  ///
  /// In en, this message translates to:
  /// **'You can purchase additional credits • Subscription credits renew monthly'**
  String get api_usage_credits_info;

  /// Inactive API key badge
  ///
  /// In en, this message translates to:
  /// **'INACTIVE'**
  String get api_usage_inactive;

  /// API key created date
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String api_usage_created_date(String date);

  /// Number of requests
  ///
  /// In en, this message translates to:
  /// **'{count} requests'**
  String api_usage_requests_count(int count);

  /// Last 30 days label
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get api_usage_last_30_days;

  /// API Key field label
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get api_usage_api_key_label;

  /// Copy API key tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy API Key'**
  String get api_usage_copy_api_key;

  /// Account ID label
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get api_usage_account_id;

  /// Copy account ID tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy Account ID'**
  String get api_usage_copy_account_id;

  /// Account ID copied snackbar
  ///
  /// In en, this message translates to:
  /// **'Account ID copied to clipboard'**
  String get api_usage_account_id_copied;

  /// Create new API key dialog title
  ///
  /// In en, this message translates to:
  /// **'Create New API Key'**
  String get api_usage_create_new_api_key;

  /// API key name instruction
  ///
  /// In en, this message translates to:
  /// **'Give your API key a descriptive name to help you identify it later.'**
  String get api_usage_api_key_name_description;

  /// API key name field label
  ///
  /// In en, this message translates to:
  /// **'API Key Name'**
  String get api_usage_api_key_name;

  /// API key name hint text
  ///
  /// In en, this message translates to:
  /// **'e.g., Production Server, Mobile App, Testing'**
  String get api_usage_api_key_name_hint;

  /// Name required validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a name for the API key'**
  String get api_usage_name_required;

  /// Name min length validation error
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters long'**
  String get api_usage_name_min_length;

  /// Name max length validation error
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 50 characters'**
  String get api_usage_name_max_length;

  /// API key security warning
  ///
  /// In en, this message translates to:
  /// **'Whoever has access to this API key will have the same permissions as your account. Keep it secure and do not share it publicly.'**
  String get api_usage_api_key_security_warning;

  /// Creating button state
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get api_usage_creating;

  /// Create API key button
  ///
  /// In en, this message translates to:
  /// **'Create API Key'**
  String get api_usage_create_api_key;

  /// Empty state for credit history
  ///
  /// In en, this message translates to:
  /// **'No credit history yet'**
  String get api_usage_no_credit_history;

  /// Empty state description for credit history
  ///
  /// In en, this message translates to:
  /// **'Your credit transactions will appear here'**
  String get api_usage_credit_transactions_appear_here;

  /// Load more button
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get api_usage_load_more;

  /// Monthly subscription transaction title
  ///
  /// In en, this message translates to:
  /// **'Monthly Subscription'**
  String get api_usage_monthly_subscription;

  /// Title for initial account API credit
  ///
  /// In en, this message translates to:
  /// **'Initial Credit'**
  String get api_usage_initial_credit;

  /// Subtitle for initial account API credit
  ///
  /// In en, this message translates to:
  /// **'Welcome bonus'**
  String get api_usage_welcome_bonus;

  /// Plan and date subtitle
  ///
  /// In en, this message translates to:
  /// **'{planName} plan • {date}'**
  String api_usage_plan_date_subtitle(String planName, String date);

  /// Credit purchase transaction title
  ///
  /// In en, this message translates to:
  /// **'Credit Purchase'**
  String get api_usage_credit_purchase;

  /// Unknown transaction title
  ///
  /// In en, this message translates to:
  /// **'Unknown Transaction'**
  String get api_usage_unknown_transaction;

  /// Free plan name
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get api_usage_plan_free;

  /// Welcome title on auth page
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get auth_welcome;

  /// Login tab label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login_tab;

  /// Sign up tab label
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_sign_up_tab;

  /// Password reset tab label
  ///
  /// In en, this message translates to:
  /// **'Password Reset'**
  String get auth_password_reset_tab;

  /// Log in button label
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get auth_log_in_button;

  /// Sign up button label
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_sign_up_button;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email_label;

  /// Email field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get auth_email_hint;

  /// Email hint for password reset
  ///
  /// In en, this message translates to:
  /// **'The email you registered with'**
  String get auth_email_registered_hint;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password_label;

  /// Password field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get auth_password_hint;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get auth_confirm_password_label;

  /// Confirm password field hint text
  ///
  /// In en, this message translates to:
  /// **'Type your password again'**
  String get auth_confirm_password_hint;

  /// User name field label
  ///
  /// In en, this message translates to:
  /// **'User display name (Typically the company name)'**
  String get auth_user_name_label;

  /// User name field hint text
  ///
  /// In en, this message translates to:
  /// **'User name (or company name)'**
  String get auth_user_name_hint;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get auth_new_password_label;

  /// New password field hint text
  ///
  /// In en, this message translates to:
  /// **'Define your new password'**
  String get auth_new_password_hint;

  /// Confirm new password field hint text
  ///
  /// In en, this message translates to:
  /// **'Type again your new password'**
  String get auth_new_password_confirm_hint;

  /// Validation code field label
  ///
  /// In en, this message translates to:
  /// **'Validation code'**
  String get auth_validation_code_label;

  /// Validation code field hint text
  ///
  /// In en, this message translates to:
  /// **'Check your email for the validation code'**
  String get auth_validation_code_hint;

  /// Confirm email button label
  ///
  /// In en, this message translates to:
  /// **'Confirm your email'**
  String get auth_confirm_email_button;

  /// Check email message with email address
  ///
  /// In en, this message translates to:
  /// **'Check your \"{email}\"'**
  String auth_check_email(String email);

  /// Send verification code button label
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get auth_send_verification_code;

  /// Verification code info message
  ///
  /// In en, this message translates to:
  /// **'A verification code will be sent to your email'**
  String get auth_verification_code_info;

  /// Validate code button label
  ///
  /// In en, this message translates to:
  /// **'Validate the code sent to email'**
  String get auth_validate_code_button;

  /// Password reset success dialog title
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get auth_password_reset_success_title;

  /// Password reset success dialog message
  ///
  /// In en, this message translates to:
  /// **'Now you can log in with the new password'**
  String get auth_password_reset_success_message;

  /// Email confirmed dialog title
  ///
  /// In en, this message translates to:
  /// **'Email confirmed!'**
  String get auth_email_confirmed_title;

  /// Email confirmed dialog message
  ///
  /// In en, this message translates to:
  /// **'Now you can log in with your email and password.'**
  String get auth_email_confirmed_message;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get auth_ok_button;

  /// Or divider text for social login
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get auth_or_divider;

  /// Continue with Google button label
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get auth_continue_with_google;

  /// Signing in loading text
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get auth_signing_in;

  /// Google sign in description text
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account with Google'**
  String get auth_google_sign_in_description;

  /// Google sign in failed error message
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again or use email.'**
  String get auth_google_sign_in_failed;

  /// Header for email typo correction dialog
  ///
  /// In en, this message translates to:
  /// **'Did you mean?'**
  String get email_typo_dialog_header;

  /// Title explaining the typo detection
  ///
  /// In en, this message translates to:
  /// **'We noticed a possible typo in your email address'**
  String get email_typo_dialog_title;

  /// Label for the original email entered
  ///
  /// In en, this message translates to:
  /// **'You typed'**
  String get email_typo_you_typed;

  /// Label for the suggested correction
  ///
  /// In en, this message translates to:
  /// **'Did you mean'**
  String get email_typo_did_you_mean;

  /// Button to accept the suggested email
  ///
  /// In en, this message translates to:
  /// **'Yes, use corrected email'**
  String get email_typo_use_suggestion;

  /// Button to keep the original email
  ///
  /// In en, this message translates to:
  /// **'No, I typed it correctly'**
  String get email_typo_keep_original;

  /// Button to go back to the previous screen
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get auth_go_back;

  /// Button to change the email address
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get auth_change_email;

  /// Application title in dashboard appbar
  ///
  /// In en, this message translates to:
  /// **'Zen scrap'**
  String get dashboard_app_title;

  /// Navigation label for user endpoints
  ///
  /// In en, this message translates to:
  /// **'Your endpoints'**
  String get dashboard_nav_your_endpoints;

  /// Navigation label for marketplace
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get dashboard_nav_marketplace;

  /// Navigation label for credits and API keys
  ///
  /// In en, this message translates to:
  /// **'Credits & Keys'**
  String get dashboard_nav_credits_keys;

  /// Navigation label for API analytics
  ///
  /// In en, this message translates to:
  /// **'Api analytics'**
  String get dashboard_nav_api_analytics;

  /// Navigation label for account settings
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get dashboard_nav_account;

  /// Navigation label for logging out
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get dashboard_nav_log_out;

  /// Navigation label for subscription/pricing page
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get dashboard_nav_subscription;

  /// Navigation label for AI usage page
  ///
  /// In en, this message translates to:
  /// **'AI Usage'**
  String get dashboard_nav_ai_usage;

  /// Button text to collapse navigation sidebar
  ///
  /// In en, this message translates to:
  /// **'Collapse tab'**
  String get dashboard_collapse_tab;

  /// Application version display text
  ///
  /// In en, this message translates to:
  /// **'App version: {version}'**
  String dashboard_app_version(String version);

  /// Short version format for compact display
  ///
  /// In en, this message translates to:
  /// **'v{version}'**
  String dashboard_version_short(String version);

  /// Monthly billing label
  ///
  /// In en, this message translates to:
  /// **'Per month'**
  String get pricing_per_month;

  /// Yearly billing label
  ///
  /// In en, this message translates to:
  /// **'Per year'**
  String get pricing_per_year;

  /// Pricing page subtitle
  ///
  /// In en, this message translates to:
  /// **'We have you covered, whether you\'re an unique person running\na side-project, a startup or even an enterprise company.'**
  String get pricing_subtitle;

  /// Basic plan name
  ///
  /// In en, this message translates to:
  /// **'BASIC'**
  String get pricing_plan_basic;

  /// Basic plan subtitle
  ///
  /// In en, this message translates to:
  /// **'FOR SIDE-PROJECTS'**
  String get pricing_plan_basic_subtitle;

  /// Pro plan name
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get pricing_plan_pro;

  /// Pro plan subtitle
  ///
  /// In en, this message translates to:
  /// **'FOR STARTUP'**
  String get pricing_plan_pro_subtitle;

  /// Pro plan emphasis badge
  ///
  /// In en, this message translates to:
  /// **'MOST POPULAR'**
  String get pricing_plan_pro_emphasis;

  /// Ultra plan name
  ///
  /// In en, this message translates to:
  /// **'ULTRA'**
  String get pricing_plan_ultra;

  /// Ultra plan subtitle
  ///
  /// In en, this message translates to:
  /// **'ENTERPRISE USAGE'**
  String get pricing_plan_ultra_subtitle;

  /// API credits feature
  ///
  /// In en, this message translates to:
  /// **'{count} api credits'**
  String pricing_feature_api_credits(String count);

  /// Concurrent requests feature
  ///
  /// In en, this message translates to:
  /// **'{count} concurrent requests'**
  String pricing_feature_concurrent_requests(String count);

  /// Active endpoints feature
  ///
  /// In en, this message translates to:
  /// **'{count} active endpoints'**
  String pricing_feature_active_endpoints(String count);

  /// Best AI model access feature
  ///
  /// In en, this message translates to:
  /// **'Access a best AI model'**
  String get pricing_feature_best_ai_model;

  /// Priority support feature
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get pricing_feature_priority_support;

  /// Hide endpoints feature
  ///
  /// In en, this message translates to:
  /// **'Hide your endpoints from marketplace'**
  String get pricing_feature_hide_endpoints;

  /// Copy endpoints feature
  ///
  /// In en, this message translates to:
  /// **'Copy endpoints from marketplace'**
  String get pricing_feature_copy_endpoints;

  /// Add-on credits feature
  ///
  /// In en, this message translates to:
  /// **'Ability to purchase one time add-on api credits'**
  String get pricing_feature_addon_credits;

  /// Message when user needs to sign in before subscribing
  ///
  /// In en, this message translates to:
  /// **'Please sign in to subscribe'**
  String get pricing_sign_in_required;

  /// Error message when checkout page cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open checkout page'**
  String get pricing_checkout_error;

  /// Generic error message with error details
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String pricing_error_message(String error);

  /// Main title for marketplace page
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get marketplace_title;

  /// Subtitle showing public scrappables
  ///
  /// In en, this message translates to:
  /// **'Public Scrappables'**
  String get marketplace_public_scrappables;

  /// Tooltip for refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh page'**
  String get marketplace_refresh_page;

  /// Placeholder text for search input
  ///
  /// In en, this message translates to:
  /// **'Search for scrappables by name or description...'**
  String get marketplace_search_hint;

  /// Error message when marketplace fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading marketplace'**
  String get marketplace_error_loading;

  /// Empty state title when search has no results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get marketplace_no_results_found;

  /// Empty state title when marketplace is empty
  ///
  /// In en, this message translates to:
  /// **'No scrappables available'**
  String get marketplace_no_scrappables_available;

  /// Empty state message when search has no results
  ///
  /// In en, this message translates to:
  /// **'No scrappables match \"{searchQuery}\". Try adjusting your search.'**
  String marketplace_no_scrappables_match(String searchQuery);

  /// Empty state message when marketplace has no scrappables
  ///
  /// In en, this message translates to:
  /// **'The marketplace is currently empty. Check back later for new scrappables.'**
  String get marketplace_empty_message;

  /// Button to clear search query
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get marketplace_clear_search;

  /// Pagination range display
  ///
  /// In en, this message translates to:
  /// **'{startItem}-{endItem} of {totalCount}'**
  String marketplace_pagination_range(
    int startItem,
    int endItem,
    int totalCount,
  );

  /// Title for usage metrics section
  ///
  /// In en, this message translates to:
  /// **'Usage metrics (last 30 days)'**
  String get marketplace_usage_metrics_title;

  /// Error message when metrics fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load metrics'**
  String get marketplace_failed_to_load_metrics;

  /// Empty state for metrics
  ///
  /// In en, this message translates to:
  /// **'No requests in the last 30 days'**
  String get marketplace_no_requests_last_30_days;

  /// Success label in metrics
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get marketplace_metrics_success;

  /// Errors label in metrics
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get marketplace_metrics_errors;

  /// Total label in metrics
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get marketplace_metrics_total;

  /// Title for API key selector dialog
  ///
  /// In en, this message translates to:
  /// **'Select API Key'**
  String get marketplace_select_api_key;

  /// API key creation date
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String marketplace_api_key_created(String date);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get marketplace_cancel;

  /// Title for clone success dialog
  ///
  /// In en, this message translates to:
  /// **'Scrappable Cloned Successfully!'**
  String get marketplace_clone_success_title;

  /// Message showing cloned scrappable name
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" has been added to your endpoints'**
  String marketplace_clone_success_message(String name);

  /// Notice about cloned scrappable being private
  ///
  /// In en, this message translates to:
  /// **'The cloned scrappable is private by default. You can make it public from the edit screen.'**
  String get marketplace_clone_private_notice;

  /// Button to navigate to endpoints
  ///
  /// In en, this message translates to:
  /// **'Go to Endpoints'**
  String get marketplace_go_to_endpoints;

  /// Button to edit scrappable
  ///
  /// In en, this message translates to:
  /// **'Edit Scrappable'**
  String get marketplace_edit_scrappable;

  /// Close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get marketplace_close;

  /// Title for example response dialog
  ///
  /// In en, this message translates to:
  /// **'Example Response'**
  String get marketplace_example_response;

  /// Result tab label
  ///
  /// In en, this message translates to:
  /// **'RESULT'**
  String get marketplace_tab_result;

  /// HTML tab label
  ///
  /// In en, this message translates to:
  /// **'HTML'**
  String get marketplace_tab_html;

  /// Screenshot tab label
  ///
  /// In en, this message translates to:
  /// **'Screenshot'**
  String get marketplace_tab_screenshot;

  /// Label for reference URL
  ///
  /// In en, this message translates to:
  /// **'Reference url used for example:'**
  String get marketplace_reference_url;

  /// Tooltip for open URL button
  ///
  /// In en, this message translates to:
  /// **'Open URL'**
  String get marketplace_open_url;

  /// Tooltip for copy URL button
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get marketplace_copy_url;

  /// Empty state when no example response exists
  ///
  /// In en, this message translates to:
  /// **'No example response available'**
  String get marketplace_no_example_response;

  /// Copy button tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get marketplace_copy;

  /// Tooltip for increase font size button
  ///
  /// In en, this message translates to:
  /// **'Increase font size'**
  String get marketplace_increase_font_size;

  /// Tooltip for decrease font size button
  ///
  /// In en, this message translates to:
  /// **'Decrease font size'**
  String get marketplace_decrease_font_size;

  /// Empty state when no HTML content exists
  ///
  /// In en, this message translates to:
  /// **'No HTML content available'**
  String get marketplace_no_html_content;

  /// Empty state when no screenshot exists
  ///
  /// In en, this message translates to:
  /// **'No screenshot available'**
  String get marketplace_no_screenshot;

  /// Snackbar message when result is copied
  ///
  /// In en, this message translates to:
  /// **'Result copied to clipboard'**
  String get marketplace_result_copied;

  /// Snackbar message when HTML is copied
  ///
  /// In en, this message translates to:
  /// **'HTML copied to clipboard'**
  String get marketplace_html_copied;

  /// Snackbar message when screenshot info is copied
  ///
  /// In en, this message translates to:
  /// **'Screenshot info copied'**
  String get marketplace_screenshot_info_copied;

  /// Label for target URL field
  ///
  /// In en, this message translates to:
  /// **'Target URL:'**
  String get marketplace_target_url;

  /// Button to change target URL
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get marketplace_change;

  /// Label for curl command section
  ///
  /// In en, this message translates to:
  /// **'Curl Command'**
  String get marketplace_curl_command;

  /// Button to test endpoint
  ///
  /// In en, this message translates to:
  /// **'Test Endpoint'**
  String get marketplace_test_endpoint;

  /// Tooltip for copy curl command button
  ///
  /// In en, this message translates to:
  /// **'Copy the test cURL command'**
  String get marketplace_copy_curl_command;

  /// Section title for API configuration
  ///
  /// In en, this message translates to:
  /// **'API Configuration & Costs'**
  String get marketplace_api_configuration;

  /// Scrappable creation date
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String marketplace_created_date(String date);

  /// Last modification date for extraction rules
  ///
  /// In en, this message translates to:
  /// **'Last logic modification: {date}'**
  String marketplace_last_logic_modification(String date);

  /// Button to clone scrappable
  ///
  /// In en, this message translates to:
  /// **'Clone to My Endpoints'**
  String get marketplace_clone_to_my_endpoints;

  /// Message when user needs to log in
  ///
  /// In en, this message translates to:
  /// **'Please log in to use this scrappable.'**
  String get marketplace_login_required;

  /// Message when user has no API keys
  ///
  /// In en, this message translates to:
  /// **'No API keys found. Please create an API key first to use this scrappable.'**
  String get marketplace_no_api_keys;

  /// Title for upgrade required dialog
  ///
  /// In en, this message translates to:
  /// **'Upgrade Required'**
  String get marketplace_upgrade_required_title;

  /// Message explaining clone feature requires upgrade
  ///
  /// In en, this message translates to:
  /// **'Cloning scrappables from the marketplace is available on Pro and Ultra plans.'**
  String get marketplace_clone_feature_pro;

  /// Title for upgrade benefits list
  ///
  /// In en, this message translates to:
  /// **'Upgrade to unlock:'**
  String get marketplace_upgrade_benefits_title;

  /// Benefit item for cloning
  ///
  /// In en, this message translates to:
  /// **'Clone any marketplace scrappable'**
  String get marketplace_benefit_clone;

  /// Benefit item for credits
  ///
  /// In en, this message translates to:
  /// **'More API credits'**
  String get marketplace_benefit_more_credits;

  /// Benefit item for concurrent requests
  ///
  /// In en, this message translates to:
  /// **'Higher concurrent requests'**
  String get marketplace_benefit_concurrent;

  /// Benefit item for endpoints
  ///
  /// In en, this message translates to:
  /// **'More active endpoints'**
  String get marketplace_benefit_endpoints;

  /// Button to dismiss upgrade dialog
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get marketplace_maybe_later;

  /// Button to view pricing plans
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get marketplace_view_plans;

  /// Snackbar message when content is copied
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get scrap_session_copied_to_clipboard;

  /// Result tab label
  ///
  /// In en, this message translates to:
  /// **'RESULT'**
  String get scrap_session_tab_result;

  /// HTML tab label
  ///
  /// In en, this message translates to:
  /// **'HTML'**
  String get scrap_session_tab_html;

  /// Screenshot tab label
  ///
  /// In en, this message translates to:
  /// **'Screenshot'**
  String get scrap_session_tab_screenshot;

  /// Empty state message when no JSON response
  ///
  /// In en, this message translates to:
  /// **'No JSON response available'**
  String get scrap_session_no_json_response;

  /// Empty state message when no HTML content
  ///
  /// In en, this message translates to:
  /// **'No HTML content available'**
  String get scrap_session_no_html_content;

  /// Empty state message when no screenshot
  ///
  /// In en, this message translates to:
  /// **'No screenshot available'**
  String get scrap_session_no_screenshot;

  /// Copy button tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get scrap_session_copy;

  /// Tooltip for increase font size button
  ///
  /// In en, this message translates to:
  /// **'Increase font size'**
  String get scrap_session_increase_font_size;

  /// Tooltip for decrease font size button
  ///
  /// In en, this message translates to:
  /// **'Decrease font size'**
  String get scrap_session_decrease_font_size;

  /// Tab label for test suite
  ///
  /// In en, this message translates to:
  /// **'Test suite'**
  String get scrap_session_test_suite;

  /// Tab label for scrappable information
  ///
  /// In en, this message translates to:
  /// **'Scrappable info'**
  String get scrap_session_scrappable_info;

  /// Message shown when user tries to use powerful AI model without proper plan
  ///
  /// In en, this message translates to:
  /// **'Unlock access to the Powerful AI model for superior extraction accuracy and better understanding of complex web pages. Perfect for advanced scraping needs.'**
  String get scrap_session_powerful_model_upgrade;

  /// Dialog title for sign in requirement
  ///
  /// In en, this message translates to:
  /// **'Sign In Required'**
  String get scrap_session_sign_in_required;

  /// Sign in dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to unlock powerful features:'**
  String get scrap_session_sign_in_unlock_features;

  /// Sign in benefit title
  ///
  /// In en, this message translates to:
  /// **'Advanced AI Models'**
  String get scrap_session_advanced_ai_models;

  /// Sign in benefit description
  ///
  /// In en, this message translates to:
  /// **'Access Powerful AI models and other premium features'**
  String get scrap_session_advanced_ai_models_desc;

  /// Sign in benefit title
  ///
  /// In en, this message translates to:
  /// **'No Time Limits'**
  String get scrap_session_no_time_limits;

  /// Sign in benefit description
  ///
  /// In en, this message translates to:
  /// **'Endpoints never expire with a subscription'**
  String get scrap_session_no_time_limits_desc;

  /// Sign in benefit title
  ///
  /// In en, this message translates to:
  /// **'More API Credits'**
  String get scrap_session_more_api_credits;

  /// Sign in benefit description
  ///
  /// In en, this message translates to:
  /// **'Get thousands of API credits per month'**
  String get scrap_session_more_api_credits_desc;

  /// Sign in benefit title
  ///
  /// In en, this message translates to:
  /// **'Multiple Endpoints'**
  String get scrap_session_multiple_endpoints;

  /// Sign in benefit description
  ///
  /// In en, this message translates to:
  /// **'Create and manage multiple scraping endpoints'**
  String get scrap_session_multiple_endpoints_desc;

  /// Button to dismiss dialog
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get scrap_session_maybe_later;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get scrap_session_sign_in;

  /// Success message when AI model is changed
  ///
  /// In en, this message translates to:
  /// **'Scrap AI model changed to {modelName}'**
  String scrap_session_model_changed(String modelName);

  /// Label for currently selected AI model
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get scrap_session_current;

  /// Tooltip for deploy button
  ///
  /// In en, this message translates to:
  /// **'Continue to edit/use this scrappable\nendpoint by deploying it!'**
  String get scrap_session_deploy_tooltip;

  /// Deploy button label
  ///
  /// In en, this message translates to:
  /// **'DEPLOY ENDPOINT'**
  String get scrap_session_deploy_endpoint;

  /// Button to discard changes
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get scrap_session_discard_changes;

  /// Button to go back
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get scrap_session_go_back;

  /// Tooltip for edit scrappable request button
  ///
  /// In en, this message translates to:
  /// **'Edit scrappable request'**
  String get scrap_session_edit_request;

  /// Message when no test data is available
  ///
  /// In en, this message translates to:
  /// **'No test data available'**
  String get scrap_session_no_test_data;

  /// Message when chat is loading
  ///
  /// In en, this message translates to:
  /// **'Chat is loading...'**
  String get scrap_session_chat_loading;

  /// Tooltip for copy cURL button
  ///
  /// In en, this message translates to:
  /// **'Copy the test cURL command'**
  String get scrap_session_copy_curl;

  /// Header text when AI is analyzing URL
  ///
  /// In en, this message translates to:
  /// **'Analyzing URL'**
  String get scrap_session_analyzing_url;

  /// Status showing number of AI thoughts processed
  ///
  /// In en, this message translates to:
  /// **'{count} thoughts processed'**
  String scrap_session_thoughts_processed(int count);

  /// Status when AI is processing
  ///
  /// In en, this message translates to:
  /// **'AI is thinking...'**
  String get scrap_session_ai_thinking;

  /// Message when AI analysis is starting
  ///
  /// In en, this message translates to:
  /// **'Initializing AI analysis...'**
  String get scrap_session_initializing_ai;

  /// Title for web search grounding section
  ///
  /// In en, this message translates to:
  /// **'Web Search Grounding'**
  String get scrap_session_web_search_grounding;

  /// Status showing number of sources referenced
  ///
  /// In en, this message translates to:
  /// **'{count} sources referenced'**
  String scrap_session_sources_referenced(int count);

  /// Status message during AI analysis
  ///
  /// In en, this message translates to:
  /// **'Gemini 3 Pro is analyzing your URL pattern...'**
  String get scrap_session_ai_analyzing_pattern;

  /// Tooltip for test endpoint button
  ///
  /// In en, this message translates to:
  /// **'Test endpoint'**
  String get scrap_session_test_endpoint;

  /// Loading message when creating session
  ///
  /// In en, this message translates to:
  /// **'Creating session...'**
  String get scrap_session_creating_session;

  /// Placeholder when credits are exhausted
  ///
  /// In en, this message translates to:
  /// **'Add API key to continue...'**
  String get scrap_session_add_api_key;

  /// Placeholder for chat input
  ///
  /// In en, this message translates to:
  /// **'Ask for any modification...'**
  String get scrap_session_ask_modification;

  /// Validation message for minimum message length
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 3 characters'**
  String get scrap_session_message_min_length;

  /// Validation message for maximum message length
  ///
  /// In en, this message translates to:
  /// **'Message must be less than 1000 characters'**
  String get scrap_session_message_max_length;

  /// Dialog title for editing scrappable request
  ///
  /// In en, this message translates to:
  /// **'Edit Scrappable Request'**
  String get scrap_session_edit_request_title;

  /// Dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize the URL template, path parameters, and query parameters'**
  String get scrap_session_edit_request_subtitle;

  /// Info about path parameters
  ///
  /// In en, this message translates to:
  /// **'Path parameters should be wrapped in curly braces like {userId} or {postId}. They represent dynamic segments in the URL that will be replaced with actual values.'**
  String scrap_session_path_params_hint(Object postId, Object userId);

  /// Helper text for URL input
  ///
  /// In en, this message translates to:
  /// **'Use {paramName} for path parameters'**
  String scrap_session_use_param_name(Object paramName);

  /// Button to save changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get scrap_session_save_changes;

  /// Error dialog title for duplicate parameter
  ///
  /// In en, this message translates to:
  /// **'Duplicate Parameter'**
  String get scrap_session_duplicate_param;

  /// Error message for duplicate path parameter
  ///
  /// In en, this message translates to:
  /// **'This path parameter already exists.'**
  String get scrap_session_duplicate_path_param;

  /// Error message for duplicate query parameter
  ///
  /// In en, this message translates to:
  /// **'This query parameter already exists.'**
  String get scrap_session_duplicate_query_param;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Missing Path Parameters'**
  String get scrap_session_missing_path_params;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Unused Path Parameters'**
  String get scrap_session_unused_path_params;

  /// Success message when request is updated
  ///
  /// In en, this message translates to:
  /// **'Scrappable request updated successfully!'**
  String get scrap_session_request_updated;

  /// Close button tooltip
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get scrap_session_close;

  /// Tooltip shown on disabled buttons when chat is loading
  ///
  /// In en, this message translates to:
  /// **'Disabled while AI is processing'**
  String get scrap_session_chat_loading_disabled_tooltip;

  /// Notice shown in test dialog when chat is loading
  ///
  /// In en, this message translates to:
  /// **'AI is processing a request. Please wait before running tests.'**
  String get scrap_session_chat_loading_test_notice;

  /// Tooltip shown on disabled buttons when session has expired
  ///
  /// In en, this message translates to:
  /// **'Session expired - deploy to continue'**
  String get scrap_session_session_expired_tooltip;

  /// Notice shown in test dialog when session has expired
  ///
  /// In en, this message translates to:
  /// **'Your test session has expired. Deploy the endpoint to continue using it.'**
  String get scrap_session_session_expired_test_notice;

  /// Title shown when user has no scrappables
  ///
  /// In en, this message translates to:
  /// **'You did not create any scrappables yet.'**
  String get scrappables_empty_title;

  /// Button text to create first scrappable
  ///
  /// In en, this message translates to:
  /// **'Create your first scrappable'**
  String get scrappables_create_first;

  /// Hint text for search bar in user scrappables
  ///
  /// In en, this message translates to:
  /// **'Search your endpoints by name or description...'**
  String get scrappables_search_hint;

  /// Error title when loading endpoints fails
  ///
  /// In en, this message translates to:
  /// **'Error loading endpoints'**
  String get scrappables_error_loading;

  /// Title when no endpoints match search/filter
  ///
  /// In en, this message translates to:
  /// **'No endpoints found'**
  String get scrappables_no_results;

  /// Description when search returns no results
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords or adjust your filters.'**
  String get scrappables_try_different_keywords;

  /// Description when category filter returns no results
  ///
  /// In en, this message translates to:
  /// **'Try selecting different categories or clear your filters.'**
  String get scrappables_try_different_categories;

  /// Text for single selected category
  ///
  /// In en, this message translates to:
  /// **'the selected category'**
  String get scrappables_selected_category;

  /// Text for multiple selected categories
  ///
  /// In en, this message translates to:
  /// **'the selected categories'**
  String get scrappables_selected_categories;

  /// Header title for user's endpoints list
  ///
  /// In en, this message translates to:
  /// **'Your endpoints'**
  String get scrappables_your_endpoints;

  /// Button text to create a new endpoint
  ///
  /// In en, this message translates to:
  /// **'Create new endpoint'**
  String get scrappables_create_new;

  /// Title for the create scrappable dialog
  ///
  /// In en, this message translates to:
  /// **'Create New Scraper'**
  String get scrappables_create_dialog_title;

  /// Subtitle for the create scrappable dialog
  ///
  /// In en, this message translates to:
  /// **'AI-powered data extraction'**
  String get scrappables_create_dialog_subtitle;

  /// Description text explaining how the dialog works
  ///
  /// In en, this message translates to:
  /// **'Enter the URL you want to scrape and describe what data you want to extract. Our AI will analyze the page and create a custom scraper for you.'**
  String get scrappables_create_dialog_description;

  /// Hint text shown near the create button
  ///
  /// In en, this message translates to:
  /// **'Be specific about the data you need'**
  String get scrappables_create_dialog_hint;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get scrappables_create_dialog_cancel;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create Scraper'**
  String get scrappables_create_dialog_create;

  /// Creating button text when loading
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get scrappables_create_dialog_creating;

  /// Tooltip for showing original text (not translated)
  ///
  /// In en, this message translates to:
  /// **'Show original'**
  String get common_show_original;

  /// Tooltip for showing translated text
  ///
  /// In en, this message translates to:
  /// **'Show translated'**
  String get common_show_translated;

  /// Badge indicating text was auto-translated
  ///
  /// In en, this message translates to:
  /// **'Auto-translated from {language}'**
  String common_auto_translated(String language);

  /// Title for invalid credentials error dialog
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get authErrorInvalidCredentialsTitle;

  /// Description for invalid credentials error
  ///
  /// In en, this message translates to:
  /// **'The email or password you entered is incorrect. Please check your credentials and try again.'**
  String get authErrorInvalidCredentialsDescription;

  /// Description for account not found error
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find an account with this email address. Please check the email or create a new account.'**
  String get authErrorAccountNotFoundDescription;

  /// Title for locked/disabled account error
  ///
  /// In en, this message translates to:
  /// **'Account Locked'**
  String get authErrorAccountLockedTitle;

  /// Description for disabled account error
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Please contact support for assistance.'**
  String get authErrorAccountDisabledDescription;

  /// Description for locked account error
  ///
  /// In en, this message translates to:
  /// **'Your account has been temporarily locked due to security concerns. Please try again later or contact support.'**
  String get authErrorAccountLockedDescription;

  /// Title for email already exists error
  ///
  /// In en, this message translates to:
  /// **'Email Already Registered'**
  String get authErrorEmailExistsTitle;

  /// Description for email already exists error
  ///
  /// In en, this message translates to:
  /// **'An account with this email address already exists. Please try logging in instead, or use a different email.'**
  String get authErrorEmailExistsDescription;

  /// Title for invalid verification code error
  ///
  /// In en, this message translates to:
  /// **'Invalid Code'**
  String get authErrorInvalidCodeTitle;

  /// Description for invalid verification code error
  ///
  /// In en, this message translates to:
  /// **'The verification code you entered is incorrect. Please check the code in your email and try again.'**
  String get authErrorInvalidCodeDescription;

  /// Title for expired verification code error
  ///
  /// In en, this message translates to:
  /// **'Code Expired'**
  String get authErrorExpiredCodeTitle;

  /// Description for expired verification code error
  ///
  /// In en, this message translates to:
  /// **'This verification code has expired. Please request a new code and try again.'**
  String get authErrorExpiredCodeDescription;

  /// Title for weak password error
  ///
  /// In en, this message translates to:
  /// **'Password Too Weak'**
  String get authErrorWeakPasswordTitle;

  /// Description for weak password error
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password. Use at least 8 characters with a mix of letters, numbers, and symbols.'**
  String get authErrorWeakPasswordDescription;

  /// Title for invalid email format error
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get authErrorInvalidEmailTitle;

  /// Description for invalid email format error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authErrorInvalidEmailDescription;

  /// Title for rate limited error
  ///
  /// In en, this message translates to:
  /// **'Too Many Attempts'**
  String get authErrorRateLimitedTitle;

  /// Description for too many attempts error
  ///
  /// In en, this message translates to:
  /// **'You\'ve made too many attempts. Please wait a few minutes before trying again.'**
  String get authErrorTooManyAttemptsDescription;

  /// Description for login rate limited error
  ///
  /// In en, this message translates to:
  /// **'Too many login attempts. Please wait a few minutes before trying again.'**
  String get authErrorLoginRateLimitedDescription;

  /// Description for verification rate limited error
  ///
  /// In en, this message translates to:
  /// **'Too many verification attempts. Please wait a few minutes before trying again.'**
  String get authErrorVerificationRateLimitedDescription;

  /// Description for invalid password reset code error
  ///
  /// In en, this message translates to:
  /// **'The password reset code you entered is incorrect. Please check the code in your email and try again.'**
  String get authErrorPasswordResetCodeInvalidDescription;

  /// Description for expired password reset code error
  ///
  /// In en, this message translates to:
  /// **'This password reset code has expired. Please request a new password reset and try again.'**
  String get authErrorPasswordResetCodeExpiredDescription;

  /// Description for password reset rate limited error
  ///
  /// In en, this message translates to:
  /// **'Too many password reset attempts. Please wait a few minutes before trying again.'**
  String get authErrorPasswordResetRateLimitedDescription;

  /// Title for Google sign-in cancelled
  ///
  /// In en, this message translates to:
  /// **'Sign-In Cancelled'**
  String get authErrorGoogleCancelledTitle;

  /// Description for Google sign-in cancelled
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was cancelled. You can try again or use email sign-in instead.'**
  String get authErrorGoogleCancelledDescription;

  /// Title for Google sign-in failed
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In Failed'**
  String get authErrorGoogleFailedTitle;

  /// Description for Google sign-in failed
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete Google sign-in. Please try again or use email sign-in.'**
  String get authErrorGoogleFailedDescription;

  /// Title for Google account not verified
  ///
  /// In en, this message translates to:
  /// **'Account Not Verified'**
  String get authErrorGoogleNotVerifiedTitle;

  /// Description for Google account not verified
  ///
  /// In en, this message translates to:
  /// **'Your Google account email is not verified. Please verify your Google account and try again.'**
  String get authErrorGoogleNotVerifiedDescription;

  /// Title for Google account domain restricted
  ///
  /// In en, this message translates to:
  /// **'Domain Not Allowed'**
  String get authErrorGoogleDomainRestrictedTitle;

  /// Description for Google account domain restricted
  ///
  /// In en, this message translates to:
  /// **'Sign-in is restricted to specific email domains. Please use an allowed email address.'**
  String get authErrorGoogleDomainRestrictedDescription;

  /// Title for network error
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get authErrorNetworkTitle;

  /// Description for network error
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your internet connection and try again.'**
  String get authErrorNetworkDescription;

  /// Description for connection refused error
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Please check your internet connection and try again.'**
  String get authErrorConnectionRefusedDescription;

  /// Title for server error
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get authErrorServerTitle;

  /// Description for server error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later. If the problem persists, contact support.'**
  String get authErrorServerDescription;

  /// Title for timeout error
  ///
  /// In en, this message translates to:
  /// **'Request Timeout'**
  String get authErrorTimeoutTitle;

  /// Description for timeout error
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please check your connection and try again.'**
  String get authErrorTimeoutDescription;

  /// Title for unknown error
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get authErrorUnknownTitle;

  /// Description for unknown error
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again. If the problem continues, contact support.'**
  String get authErrorUnknownDescription;

  /// Button text for try again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get authErrorButtonTryAgain;

  /// Button text for try later
  ///
  /// In en, this message translates to:
  /// **'Try Later'**
  String get authErrorButtonTryLater;

  /// Button text for OK
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get authErrorButtonOk;

  /// IP block reason: Unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown reason'**
  String get ip_block_reason_unknown;

  /// IP block reason: Tor network detected
  ///
  /// In en, this message translates to:
  /// **'Tor exit node detected'**
  String get ip_block_reason_tor_detected;

  /// IP block reason: Datacenter IP flagged for abuse
  ///
  /// In en, this message translates to:
  /// **'Datacenter IP with abuse history'**
  String get ip_block_reason_datacenter_abuser;

  /// IP block reason: IP flagged for previous malicious activity
  ///
  /// In en, this message translates to:
  /// **'Known abusive IP address'**
  String get ip_block_reason_known_abuser;

  /// IP block reason: Bot or web crawler detected
  ///
  /// In en, this message translates to:
  /// **'Automated bot or crawler detected'**
  String get ip_block_reason_crawler_detected;

  /// IP block reason: Bogon (invalid/reserved) IP range
  ///
  /// In en, this message translates to:
  /// **'Invalid IP address range'**
  String get ip_block_reason_bogon_ip;

  /// Title for payment success page
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get payment_success_title;

  /// Message for payment success page
  ///
  /// In en, this message translates to:
  /// **'Thank you for upgrading your subscription. Your account is being updated.'**
  String get payment_success_message;

  /// Instructions section title on payment success page
  ///
  /// In en, this message translates to:
  /// **'What\'s Next?'**
  String get payment_success_instructions_title;

  /// Instructions message on payment success page
  ///
  /// In en, this message translates to:
  /// **'Your subscription will be active within a few minutes. Please refresh your account page to see your updated subscription status and new features.'**
  String get payment_success_instructions_message;

  /// Button text to navigate to account page from payment success
  ///
  /// In en, this message translates to:
  /// **'Go to Account'**
  String get payment_success_go_to_account;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return lookupAppLocalizations(locale);
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

Future<AppLocalizations> lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return app_localizations_pt.loadLibrary().then(
              (dynamic _) => app_localizations_pt.AppLocalizationsPtBr(),
            );
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return app_localizations_de.loadLibrary().then(
        (dynamic _) => app_localizations_de.AppLocalizationsDe(),
      );
    case 'en':
      return app_localizations_en.loadLibrary().then(
        (dynamic _) => app_localizations_en.AppLocalizationsEn(),
      );
    case 'es':
      return app_localizations_es.loadLibrary().then(
        (dynamic _) => app_localizations_es.AppLocalizationsEs(),
      );
    case 'fr':
      return app_localizations_fr.loadLibrary().then(
        (dynamic _) => app_localizations_fr.AppLocalizationsFr(),
      );
    case 'ja':
      return app_localizations_ja.loadLibrary().then(
        (dynamic _) => app_localizations_ja.AppLocalizationsJa(),
      );
    case 'pt':
      return app_localizations_pt.loadLibrary().then(
        (dynamic _) => app_localizations_pt.AppLocalizationsPt(),
      );
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
