// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get landing_nav_create_scrappable => 'Create Scrappable';

  @override
  String get landing_nav_how_it_works => 'How It Works';

  @override
  String get landing_nav_auto_fix => 'Auto-Fix';

  @override
  String get landing_nav_features => 'Features';

  @override
  String get landing_nav_marketplace => 'Marketplace';

  @override
  String get landing_nav_pricing => 'Pricing';

  @override
  String get landing_sign_in => 'Sign In';

  @override
  String get landing_app_name => 'ZenScrap';

  @override
  String get landing_learn_more => 'Learn more';

  @override
  String get landing_drawer_language => 'Language';

  @override
  String get landing_hero_title => 'Web Scrapers That\nFix Themselves';

  @override
  String get landing_hero_subtitle =>
      'Describe what you want to extract. Our AI builds, tests, and maintains your scraper automatically. No code. No CSS selectors. No broken endpoints.';

  @override
  String get landing_hero_target_url_label => 'Target URL';

  @override
  String get landing_hero_target_url_hint =>
      'https://example.com/product/12345';

  @override
  String get landing_hero_url_validation_invalid => 'Please enter a valid URL';

  @override
  String get landing_hero_url_validation_min_length =>
      'URL must be at least 10 characters';

  @override
  String get landing_hero_url_validation_max_length =>
      'URL must be less than 500 characters';

  @override
  String get landing_hero_prompt_label => 'What do you want to extract?';

  @override
  String get landing_hero_prompt_hint =>
      'E.g. Extract product name, price, and images';

  @override
  String get landing_hero_prompt_validation_min_length =>
      'Prompt must be at least 10 characters';

  @override
  String get landing_hero_prompt_validation_max_length =>
      'Prompt must be less than 2200 characters';

  @override
  String get landing_hero_cta_button => 'Create Your First Scraper';

  @override
  String get landing_hero_free_label => 'Free';

  @override
  String get landing_trust_no_credit_card => 'No credit card required';

  @override
  String get landing_trust_no_signup => 'No signup to test';

  @override
  String get landing_trust_ready_in_minutes => 'Ready in under 2 minutes';

  @override
  String get landing_problem_title => 'Traditional Web Scraping is Broken';

  @override
  String get landing_problem_subtitle =>
      'Hours lost to CSS selectors. Scrapers that break every week. Anti-bot systems that block your requests. Sound familiar?';

  @override
  String get landing_problem_css_title => 'CSS Selector Hell';

  @override
  String get landing_problem_css_description =>
      'Hunting through HTML to find the right selectors, only to have them break when the site updates.';

  @override
  String get landing_problem_maintenance_title => 'Constant Maintenance';

  @override
  String get landing_problem_maintenance_description =>
      'Websites change their structure constantly. Your scraper worked yesterday—today it returns empty data.';

  @override
  String get landing_problem_antibot_title => 'Anti-Bot Nightmares';

  @override
  String get landing_problem_antibot_description =>
      'CAPTCHAs, rate limits, IP bans. Fighting anti-bot systems is a full-time job.';

  @override
  String get landing_problem_productivity_title => 'Lost Productivity';

  @override
  String get landing_problem_productivity_description =>
      'Every hour debugging scrapers is an hour not spent on your actual business.';

  @override
  String get landing_how_title => 'Three Steps to Automated Data';

  @override
  String get landing_how_subtitle =>
      'No code. No configuration. Just describe what you need.';

  @override
  String get landing_how_step1_title => 'Paste Your URL';

  @override
  String get landing_how_step1_description =>
      'Drop the link to the page you want to extract data from. Any website, any complexity.';

  @override
  String get landing_how_step2_title => 'Describe What You Want';

  @override
  String get landing_how_step2_description =>
      'Tell our AI in plain language what data you need. Product prices, article content, user profiles—anything.';

  @override
  String get landing_how_step3_title => 'Get Your Self-Healing API';

  @override
  String get landing_how_step3_description =>
      'Receive a ready-to-use API endpoint that automatically adapts when the target site changes.';

  @override
  String get landing_how_ai_note =>
      'AI automatically generates name, description, category, and URL patterns';

  @override
  String get landing_autofix_badge => 'INDUSTRY FIRST';

  @override
  String get landing_autofix_title => 'The Self-Healing Web Scraper';

  @override
  String get landing_autofix_subtitle =>
      'Websites change. Your scrapers don\'t have to break. Our AI automatically detects when a target site updates and fixes your extraction rules—before you even notice.';

  @override
  String get landing_autofix_step1_title => 'Site Changes Detected';

  @override
  String get landing_autofix_step1_description =>
      'Our system monitors your scrapers and detects when extraction rules start failing.';

  @override
  String get landing_autofix_step2_title => 'AI Analyzes & Adapts';

  @override
  String get landing_autofix_step2_description =>
      'The AI examines the new page structure and generates updated extraction rules.';

  @override
  String get landing_autofix_step3_title => 'Scraper Fixed';

  @override
  String get landing_autofix_step3_description =>
      'Your endpoint continues working seamlessly. You receive an email notification.';

  @override
  String get landing_autofix_notifications_title => 'Proactive Notifications';

  @override
  String get landing_autofix_notifications_description =>
      'Get notified when a site changes and your scraper is being auto-fixed.';

  @override
  String get landing_autofix_without_title => 'Without ZenScrap';

  @override
  String get landing_autofix_without_item1 => 'Scraper breaks unexpectedly';

  @override
  String get landing_autofix_without_item2 => 'Hours spent debugging';

  @override
  String get landing_autofix_without_item3 => 'Lost data and revenue';

  @override
  String get landing_autofix_without_item4 => 'Constant maintenance burden';

  @override
  String get landing_autofix_with_title => 'With ZenScrap';

  @override
  String get landing_autofix_with_item1 => 'AI detects issues instantly';

  @override
  String get landing_autofix_with_item2 => 'Automatic fixes in minutes';

  @override
  String get landing_autofix_with_item3 => 'Zero data loss';

  @override
  String get landing_autofix_with_item4 => 'Set it and forget it';

  @override
  String get landing_features_title => 'Built for the Modern Web';

  @override
  String get landing_features_subtitle =>
      'Enterprise-grade infrastructure wrapped in a simple interface.';

  @override
  String get landing_features_cost_title => 'Smart Cost Optimization';

  @override
  String get landing_features_cost_description =>
      'AI automatically tests configurations and finds the cheapest option that works. No wasted credits.';

  @override
  String get landing_features_antibot_title => 'Anti-Bot Handled';

  @override
  String get landing_features_antibot_description =>
      'CAPTCHAs, rate limits, fingerprinting—we handle all of it so you don\'t have to.';

  @override
  String get landing_features_geo_title => 'Global Geo-Targeting';

  @override
  String get landing_features_geo_description =>
      'Access region-locked content with automatic proxy selection based on target location.';

  @override
  String get landing_features_testing_title => 'In-Platform Testing';

  @override
  String get landing_features_testing_description =>
      'Test any scraper instantly without leaving the platform. No Postman needed.';

  @override
  String get landing_features_analytics_title => 'Deep Analytics';

  @override
  String get landing_features_analytics_description =>
      'Track every request, identify issues instantly, and monitor usage across time ranges.';

  @override
  String get landing_features_js_title => 'JavaScript Rendering';

  @override
  String get landing_features_js_description =>
      'Full headless browser support for SPAs, dynamic content, and infinite scroll pages.';

  @override
  String get landing_marketplace_badge => 'COMMUNITY';

  @override
  String get landing_marketplace_title => 'Don\'t Build What Already Exists';

  @override
  String get landing_marketplace_subtitle =>
      'Browse our marketplace of pre-built scrapers for popular websites. Use them instantly or learn from how others solved similar challenges.';

  @override
  String get landing_marketplace_prebuilt_title => 'Pre-Built Scrapers';

  @override
  String get landing_marketplace_prebuilt_description =>
      'Amazon, eBay, LinkedIn, news sites—popular websites already have working scrapers ready to use.';

  @override
  String get landing_marketplace_stats_title => 'Usage Statistics';

  @override
  String get landing_marketplace_stats_description =>
      'See which scrapers are most popular and reliable based on real community usage data.';

  @override
  String get landing_marketplace_testing_title => 'Instant Testing';

  @override
  String get landing_marketplace_testing_description =>
      'Try any marketplace scraper before using it. Test with your own parameters to verify results.';

  @override
  String get landing_marketplace_category_ecommerce => 'E-Commerce';

  @override
  String get landing_marketplace_category_news => 'News & Media';

  @override
  String get landing_marketplace_category_jobs => 'Job Listings';

  @override
  String get landing_marketplace_category_social => 'Social Media';

  @override
  String get landing_marketplace_category_realestate => 'Real Estate';

  @override
  String get landing_marketplace_category_finance => 'Finance';

  @override
  String get landing_marketplace_category_sports => 'Sports';

  @override
  String get landing_marketplace_category_more => '+ 25 more';

  @override
  String get landing_pricing_title => 'Simple, Transparent Pricing';

  @override
  String get landing_pricing_subtitle =>
      'Choose the plan that fits your needs. Scale as you grow.';

  @override
  String get landing_cta_title => 'Ready to Stop Babysitting\nYour Scrapers?';

  @override
  String get landing_cta_subtitle =>
      'Join developers who\'ve reclaimed their time. Build once, let AI maintain forever.';

  @override
  String get landing_cta_create_button => 'Create Your First Scraper';

  @override
  String get landing_cta_marketplace_button => 'Browse Marketplace';

  @override
  String get landing_marketplace_login_title => 'Login Required';

  @override
  String get landing_marketplace_login_message =>
      'You need to log in to see the marketplace endpoints.';

  @override
  String get landing_marketplace_login_ok => 'OK';

  @override
  String get landing_footer_tagline => 'AI-Powered Web Scraping';

  @override
  String get account_title => 'Account';

  @override
  String get account_information_title => 'Account information';

  @override
  String get account_user_name_label => 'User name';

  @override
  String get account_email_label => 'Email';

  @override
  String get account_subscription_plan_label => 'Your subscription plan';

  @override
  String get account_appearance_title => 'Appearance';

  @override
  String get account_display_mode_title => 'Display Mode';

  @override
  String get account_display_mode_subtitle =>
      'Choose between light and dark theme';

  @override
  String get account_accent_color_title => 'Accent Color';

  @override
  String get account_accent_color_subtitle =>
      'Personalize the app with your favorite color';

  @override
  String get account_loading => 'Loading...';

  @override
  String get account_change_image_tooltip => 'Change image';

  @override
  String get account_brightness_light => 'Light';

  @override
  String get account_brightness_dark => 'Dark';

  @override
  String get account_beta_badge => 'BETA';

  @override
  String get account_dark_mode_title => 'Dark Mode';

  @override
  String get account_dark_mode_beta_warning =>
      'Some UI elements may not display perfectly. We\'re actively improving it.';

  @override
  String get ai_usage_title => 'AI Usage';

  @override
  String get ai_usage_refresh => 'Refresh';

  @override
  String get ai_usage_retry => 'Retry';

  @override
  String get ai_usage_credit_history => 'Credit History';

  @override
  String get ai_usage_no_credit_history => 'No credit history yet';

  @override
  String get ai_usage_credit_history_empty_description =>
      'Your AI credit transactions will appear here';

  @override
  String get ai_usage_monthly_ai_credits => 'Monthly AI Credits';

  @override
  String get ai_usage_initial_credit => 'Initial Credit';

  @override
  String get ai_usage_welcome_bonus => 'Welcome bonus';

  @override
  String get ai_usage_plan_name_free => 'Free';

  @override
  String ai_usage_plan_subtitle(String planName) {
    return '$planName plan';
  }

  @override
  String get ai_usage_unknown_transaction => 'Unknown Transaction';

  @override
  String get ai_usage_credits_overview => 'AI Credits Overview';

  @override
  String get ai_usage_remaining_credits => 'Remaining Credits';

  @override
  String get ai_usage_monthly_limit => 'Monthly Limit';

  @override
  String ai_usage_percentage_used(String percentage) {
    return '$percentage% used this month';
  }

  @override
  String get ai_usage_using_own_api_key => 'Using your own OpenAI API key';

  @override
  String get ai_usage_autofix_sessions => 'Auto-Fix Sessions';

  @override
  String get ai_usage_no_autofix_sessions => 'No auto-fix sessions yet';

  @override
  String get ai_usage_autofix_empty_description =>
      'When your scrappables break, our AI will automatically attempt to fix them. Those sessions will appear here.';

  @override
  String get ai_usage_powerful_model => 'Powerful Model';

  @override
  String get ai_usage_normal_model => 'Normal Model';

  @override
  String ai_usage_tokens_count(String count) {
    return '$count tokens';
  }

  @override
  String ai_usage_scrappable_id(int id) {
    return 'Scrappable #$id';
  }

  @override
  String get ai_usage_status_pending => 'Pending';

  @override
  String get ai_usage_status_in_progress => 'In Progress';

  @override
  String get ai_usage_status_success => 'Success';

  @override
  String get ai_usage_status_failed => 'Failed';

  @override
  String get ai_usage_status_exhausted => 'Exhausted';

  @override
  String get ai_usage_status_cancelled => 'Cancelled';

  @override
  String get ai_usage_triggered_at => 'Triggered at';

  @override
  String ai_usage_consecutive_errors(int count, int threshold) {
    return '$count consecutive errors (threshold: $threshold)';
  }

  @override
  String get ai_usage_api_key_label => 'API Key';

  @override
  String get ai_usage_your_own_key => 'Your own key';

  @override
  String get ai_usage_platform_key => 'Platform key';

  @override
  String get ai_usage_tokens_used => 'Tokens used';

  @override
  String get ai_usage_cost => 'Cost';

  @override
  String get ai_usage_fix_summary => 'Fix Summary';

  @override
  String get ai_usage_failure_reason => 'Failure Reason';

  @override
  String ai_usage_attempts_count(int count) {
    return 'Attempts ($count)';
  }

  @override
  String get ai_usage_attempt_status_in_progress => 'In Progress';

  @override
  String get ai_usage_attempt_status_success => 'Success';

  @override
  String get ai_usage_attempt_status_ai_error => 'AI Error';

  @override
  String get ai_usage_attempt_status_api_error => 'API Error';

  @override
  String get ai_usage_attempt_status_validation_failed => 'Validation Failed';

  @override
  String get ai_usage_tokens_short => 'tok';

  @override
  String get ai_usage_load_more => 'Load More';

  @override
  String get ai_usage_api_key_section_title => 'OpenAI API Key';

  @override
  String get ai_usage_api_key_description =>
      'Use your own OpenAI API key to bypass monthly credit limits. Your key is stored securely.';

  @override
  String get ai_usage_api_key_configured => 'API key configured';

  @override
  String get ai_usage_api_key_not_configured => 'No API key configured';

  @override
  String get ai_usage_api_key_add => 'Add API Key';

  @override
  String get ai_usage_api_key_edit => 'Edit';

  @override
  String get ai_usage_api_key_remove => 'Remove';

  @override
  String get ai_usage_api_key_dialog_title => 'OpenAI API Key';

  @override
  String get ai_usage_api_key_dialog_hint => 'sk-...';

  @override
  String get ai_usage_api_key_dialog_description =>
      'Enter your OpenAI API key. The key will be validated before saving.';

  @override
  String get ai_usage_api_key_show => 'Show API key';

  @override
  String get ai_usage_api_key_hide => 'Hide API key';

  @override
  String get ai_usage_api_key_save => 'Save';

  @override
  String get ai_usage_api_key_cancel => 'Cancel';

  @override
  String get ai_usage_api_key_remove_confirm_title => 'Remove API Key?';

  @override
  String get ai_usage_api_key_remove_confirm_message =>
      'Are you sure you want to remove your OpenAI API key? You will use the platform\'s monthly credits instead.';

  @override
  String get ai_usage_api_key_updated => 'API key updated successfully';

  @override
  String get ai_usage_api_key_removed => 'API key removed successfully';

  @override
  String get ai_usage_api_key_error => 'Failed to update API key';

  @override
  String get api_analytics_title => 'API Analytics';

  @override
  String get api_analytics_retry => 'Retry';

  @override
  String get api_analytics_refresh => 'Refresh';

  @override
  String get api_analytics_load_more => 'Load More';

  @override
  String get api_analytics_no_scrappable_selected => 'No Scrappable Selected';

  @override
  String get api_analytics_select_scrappable_hint =>
      'Select a scrappable from the list to view detailed analytics';

  @override
  String get api_analytics_no_more_to_load => 'No more analytics to load';

  @override
  String get api_analytics_error_loading => 'Error Loading Analytics';

  @override
  String api_analytics_showing_count(int current, int total) {
    return 'Showing $current of $total';
  }

  @override
  String api_analytics_items_count(int current, int total) {
    return '$current of $total';
  }

  @override
  String get api_analytics_status_success => 'Success';

  @override
  String get api_analytics_status_client_error => 'Client Error';

  @override
  String get api_analytics_status_server_error => 'Server Error';

  @override
  String get api_analytics_status_insufficient_credits =>
      'Insufficient Credits';

  @override
  String get api_analytics_status_max_concurrency => 'Max Concurrency';

  @override
  String get api_analytics_status_extract_rules_error => 'Extract Rules Error';

  @override
  String get api_analytics_status_4xx => '4xx';

  @override
  String get api_analytics_status_5xx => '5xx';

  @override
  String get api_analytics_status_2xx => '2xx';

  @override
  String get api_analytics_stat_no_credits => 'No Credits';

  @override
  String get api_analytics_stat_extract_rules_errors => 'Extract rules errors';

  @override
  String get api_analytics_tooltip_success => 'Requests completed successfully';

  @override
  String get api_analytics_tooltip_client_error =>
      'Client errors - invalid request parameters or missing data';

  @override
  String get api_analytics_tooltip_server_error =>
      'Server errors - issues with the target website';

  @override
  String get api_analytics_tooltip_extract_rules_error =>
      'The AI-generated extract rules failed to parse the response';

  @override
  String get api_analytics_tooltip_insufficient_credits =>
      'Requests failed due to insufficient credits';

  @override
  String get api_analytics_tooltip_max_concurrency =>
      'Requests rejected due to concurrency limit';

  @override
  String get api_analytics_scope_last_hour => 'Last Hour';

  @override
  String get api_analytics_scope_last_12_hours => 'Last 12 Hours';

  @override
  String get api_analytics_scope_last_24_hours => 'Last 24 Hours';

  @override
  String get api_analytics_scope_last_7_days => 'Last 7 Days';

  @override
  String get api_analytics_scope_last_30_days => 'Last 30 Days';

  @override
  String get api_analytics_column_5_minutes =>
      'Each column represents 5 minutes';

  @override
  String get api_analytics_column_1_hour => 'Each column represents 1 hour';

  @override
  String get api_analytics_column_2_hours => 'Each column represents 2 hours';

  @override
  String get api_analytics_column_1_day => 'Each column represents 1 day';

  @override
  String get api_analytics_request_delay_warning =>
      'A request can take up to 10 minutes to appear here';

  @override
  String get api_analytics_no_requests => 'No requests';

  @override
  String get api_analytics_max_concurrency_exceeded =>
      'Max concurrency exceeded';

  @override
  String get api_analytics_insufficient_credits_chip => 'Insufficient credits';

  @override
  String get api_analytics_last_12_hours => 'Last 12 hours';

  @override
  String api_analytics_total_requests(int count) {
    return 'Total: $count requests';
  }

  @override
  String api_analytics_tooltip_success_count(int count, String percentage) {
    return 'Success: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_4xx_count(int count, String percentage) {
    return '4xx: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_5xx_count(int count, String percentage) {
    return '5xx: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_scraping_bee_error(
    int count,
    String percentage,
  ) {
    return 'ScrapingBee Error: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_no_credits_count(int count, String percentage) {
    return 'No Credits: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_max_concurrency_count(
    int count,
    String percentage,
  ) {
    return 'Max Concurrency: $count ($percentage%)';
  }

  @override
  String get api_analytics_show_less => 'Show less';

  @override
  String get api_analytics_show_details => 'Show details';

  @override
  String get api_analytics_detail_title => 'Title';

  @override
  String get api_analytics_detail_description => 'Description';

  @override
  String get api_analytics_detail_error_object => 'Error Object';

  @override
  String get api_analytics_detail_stack_trace => 'Stack Trace';

  @override
  String get api_analytics_detail_request_payload => 'Request Payload';

  @override
  String get api_analytics_detail_response_data => 'Response Data';

  @override
  String get api_analytics_success_badge => 'SUCCESS';

  @override
  String get api_analytics_collapse => 'Collapse';

  @override
  String get api_analytics_expand => 'Expand';

  @override
  String api_analytics_copied_to_clipboard(String label) {
    return '$label copied to clipboard';
  }

  @override
  String api_analytics_copy_label(String label) {
    return 'Copy $label';
  }

  @override
  String api_analytics_expand_more_lines(int count) {
    return 'Click expand to see $count+ more lines';
  }

  @override
  String get api_analytics_subtitle =>
      'Endpoints you\'ve called in the selected time period';

  @override
  String get api_analytics_scope_tooltip =>
      'Shows endpoints you\'ve interacted with during this time period';

  @override
  String get api_analytics_badge_yours => 'Yours';

  @override
  String get api_analytics_badge_marketplace => 'Marketplace';

  @override
  String get api_analytics_api_key_label => 'API Key:';

  @override
  String get api_analytics_api_key_deleted => 'API Key (deleted)';

  @override
  String get api_analytics_api_key_copied => 'API key copied to clipboard';

  @override
  String get api_analytics_copy_button => 'Copy';

  @override
  String get api_analytics_average_duration_prefix => 'Avg: ';

  @override
  String get scrappable_card_average_duration_tooltip =>
      'Average request duration';

  @override
  String get api_analytics_duration_label => 'Duration';

  @override
  String get api_analytics_load_more_failed =>
      'Failed to load more data. Tap to retry.';

  @override
  String get api_usage_page_title => 'Api Credits & Keys';

  @override
  String get api_usage_refresh => 'Refresh';

  @override
  String get api_usage_retry => 'Retry';

  @override
  String get api_usage_overview => 'Overview';

  @override
  String get api_usage_api_keys => 'API Keys';

  @override
  String get api_usage_history => 'History';

  @override
  String get api_usage_overview_title => 'API Usage Overview';

  @override
  String get api_usage_credit_history => 'Credit History';

  @override
  String get api_usage_new_api_key_created => 'New API Key Created';

  @override
  String get api_usage_copy_api_key_warning =>
      'Please copy and save this API key. You won\'t be able to see it again!';

  @override
  String get api_usage_api_key_copied => 'API key copied to clipboard';

  @override
  String get api_usage_done => 'Done';

  @override
  String get api_usage_deactivate_api_key => 'Deactivate API Key';

  @override
  String get api_usage_deactivate_confirmation =>
      'Are you sure you want to deactivate this API key? This action cannot be undone.';

  @override
  String get api_usage_cancel => 'Cancel';

  @override
  String get api_usage_deactivate => 'Deactivate';

  @override
  String get api_usage_create_key => 'Create Key';

  @override
  String get api_usage_no_api_keys => 'No API keys yet';

  @override
  String get api_usage_purchase_credits => 'Purchase API Credits';

  @override
  String get api_usage_best_value => 'BEST VALUE';

  @override
  String get api_usage_bulk_discount => 'BULK DISCOUNT';

  @override
  String get api_usage_credits_never_expire =>
      'Credits never expire • Instant activation';

  @override
  String api_usage_unit_price(String unitPrice) {
    return 'Unit price: $unitPrice';
  }

  @override
  String get api_usage_ultra_plan_required => 'Ultra Plan Required';

  @override
  String get api_usage_ultra_exclusive_benefit =>
      'Credit packages are an exclusive benefit for Ultra plan subscribers.';

  @override
  String get api_usage_credits_never_expire_benefit =>
      'Credits that never expire';

  @override
  String get api_usage_perfect_for_traffic_spikes =>
      'Perfect for traffic spikes';

  @override
  String get api_usage_maybe_later => 'Maybe Later';

  @override
  String get api_usage_upgrade_to_ultra => 'Upgrade to Ultra';

  @override
  String get api_usage_unlock_credits_message =>
      'Unlock the ability to purchase additional credits that never expire. Perfect for handling traffic spikes and seasonal demands.';

  @override
  String get api_usage_get_credits_title => 'Get Credits That Never Expire';

  @override
  String get api_usage_traffic_spikes_subtitle =>
      'Perfect for traffic spikes & long-term planning';

  @override
  String get api_usage_credits_never_expire_title => 'Credits Never Expire';

  @override
  String get api_usage_credits_never_expire_description =>
      'Unlike subscription credits that reset monthly, purchased credits stay in your account forever while your Ultra plan is active.';

  @override
  String get api_usage_instant_activation_title => 'Instant Activation';

  @override
  String get api_usage_instant_activation_description =>
      'Credits are added to your account immediately after payment - no waiting, no delays.';

  @override
  String get api_usage_scale_without_limits_title => 'Scale Without Limits';

  @override
  String get api_usage_scale_without_limits_description =>
      'Handle traffic spikes, seasonal demands, or special projects without upgrading your monthly plan.';

  @override
  String get api_usage_choose_package => 'Choose Your Package';

  @override
  String get api_usage_100k_credits => '100,000 credits';

  @override
  String get api_usage_1m_credits => '1,000,000 credits';

  @override
  String get api_usage_2_5m_credits => '2,500,000 credits';

  @override
  String get api_usage_small_package_description =>
      'Great for testing and small projects';

  @override
  String get api_usage_medium_package_description =>
      'Best value for growing applications';

  @override
  String get api_usage_large_package_description =>
      'Maximum savings for enterprise needs';

  @override
  String get api_usage_most_popular => 'MOST POPULAR';

  @override
  String get api_usage_best_deal => 'BEST DEAL';

  @override
  String get api_usage_secure_payment_stripe => 'Secure payment via Stripe';

  @override
  String get api_usage_instant_delivery => 'Instant delivery';

  @override
  String get api_usage_not_now => 'Not Now';

  @override
  String get api_usage_get_100k_credits => 'Get 100K Credits';

  @override
  String get api_usage_get_1m_credits => 'Get 1M Credits';

  @override
  String get api_usage_get_2_5m_credits => 'Get 2.5M Credits';

  @override
  String get api_usage_preparing_checkout => 'Preparing checkout...';

  @override
  String get api_usage_redirect_to_stripe =>
      'You\'ll be redirected to Stripe in a moment';

  @override
  String get api_usage_checkout_failed => 'Checkout Failed';

  @override
  String get api_usage_unexpected_error => 'An unexpected error occurred';

  @override
  String get api_usage_close => 'Close';

  @override
  String get api_usage_complete_purchase => 'Complete Your Purchase';

  @override
  String get api_usage_checkout_opened => 'Checkout opened in a new tab';

  @override
  String get api_usage_complete_in_stripe =>
      'Complete your purchase in the Stripe checkout page, then refresh this page to see your new credits.';

  @override
  String get api_usage_secure_payment_powered_by_stripe =>
      'Secure payment powered by Stripe';

  @override
  String get api_usage_refresh_and_close => 'Refresh & Close';

  @override
  String get api_usage_unable_to_verify_account =>
      'Unable to verify account status. Please try again.';

  @override
  String get api_usage_account_refreshed => 'Account refreshed';

  @override
  String get api_usage_credits_overview => 'API Credits Overview';

  @override
  String get api_usage_total_available => 'Total Available';

  @override
  String get api_usage_credits_combined_description =>
      'Credits of purchase and subscription combined';

  @override
  String get api_usage_subscription => 'Subscription';

  @override
  String get api_usage_subscribe_to_unlock => 'Subscribe to unlock a plan';

  @override
  String api_usage_will_renew_monthly(int credits) {
    return 'Will renew monthly $credits';
  }

  @override
  String get api_usage_purchased => 'Purchased';

  @override
  String get api_usage_purchased_description =>
      'One-time purchase credits that never expire';

  @override
  String get api_usage_credits_info =>
      'You can purchase additional credits • Subscription credits renew monthly';

  @override
  String get api_usage_inactive => 'INACTIVE';

  @override
  String api_usage_created_date(String date) {
    return 'Created $date';
  }

  @override
  String api_usage_requests_count(int count) {
    return '$count requests';
  }

  @override
  String get api_usage_last_30_days => 'Last 30 days';

  @override
  String get api_usage_api_key_label => 'API Key';

  @override
  String get api_usage_copy_api_key => 'Copy API Key';

  @override
  String get api_usage_account_id => 'Account ID';

  @override
  String get api_usage_copy_account_id => 'Copy Account ID';

  @override
  String get api_usage_account_id_copied => 'Account ID copied to clipboard';

  @override
  String get api_usage_create_new_api_key => 'Create New API Key';

  @override
  String get api_usage_api_key_name_description =>
      'Give your API key a descriptive name to help you identify it later.';

  @override
  String get api_usage_api_key_name => 'API Key Name';

  @override
  String get api_usage_api_key_name_hint =>
      'e.g., Production Server, Mobile App, Testing';

  @override
  String get api_usage_name_required => 'Please enter a name for the API key';

  @override
  String get api_usage_name_min_length =>
      'Name must be at least 3 characters long';

  @override
  String get api_usage_name_max_length =>
      'Name must be less than 50 characters';

  @override
  String get api_usage_api_key_security_warning =>
      'Whoever has access to this API key will have the same permissions as your account. Keep it secure and do not share it publicly.';

  @override
  String get api_usage_creating => 'Creating...';

  @override
  String get api_usage_create_api_key => 'Create API Key';

  @override
  String get api_usage_no_credit_history => 'No credit history yet';

  @override
  String get api_usage_credit_transactions_appear_here =>
      'Your credit transactions will appear here';

  @override
  String get api_usage_load_more => 'Load More';

  @override
  String get api_usage_monthly_subscription => 'Monthly Subscription';

  @override
  String get api_usage_initial_credit => 'Initial Credit';

  @override
  String get api_usage_welcome_bonus => 'Welcome bonus';

  @override
  String api_usage_plan_date_subtitle(String planName, String date) {
    return '$planName plan • $date';
  }

  @override
  String get api_usage_credit_purchase => 'Credit Purchase';

  @override
  String get api_usage_unknown_transaction => 'Unknown Transaction';

  @override
  String get api_usage_plan_free => 'Free';

  @override
  String get auth_welcome => 'Welcome';

  @override
  String get auth_login_tab => 'Login';

  @override
  String get auth_sign_up_tab => 'Sign Up';

  @override
  String get auth_password_reset_tab => 'Password Reset';

  @override
  String get auth_log_in_button => 'Log In';

  @override
  String get auth_sign_up_button => 'Sign Up';

  @override
  String get auth_email_label => 'Email';

  @override
  String get auth_email_hint => 'Enter your email';

  @override
  String get auth_email_registered_hint => 'The email you registered with';

  @override
  String get auth_password_label => 'Password';

  @override
  String get auth_password_hint => 'Enter your password';

  @override
  String get auth_confirm_password_label => 'Confirm password';

  @override
  String get auth_confirm_password_hint => 'Type your password again';

  @override
  String get auth_user_name_label =>
      'User display name (Typically the company name)';

  @override
  String get auth_user_name_hint => 'User name (or company name)';

  @override
  String get auth_new_password_label => 'New password';

  @override
  String get auth_new_password_hint => 'Define your new password';

  @override
  String get auth_new_password_confirm_hint => 'Type again your new password';

  @override
  String get auth_validation_code_label => 'Validation code';

  @override
  String get auth_validation_code_hint =>
      'Check your email for the validation code';

  @override
  String get auth_confirm_email_button => 'Confirm your email';

  @override
  String auth_check_email(String email) {
    return 'Check your \"$email\"';
  }

  @override
  String get auth_send_verification_code => 'Send verification code';

  @override
  String get auth_verification_code_info =>
      'A verification code will be sent to your email';

  @override
  String get auth_validate_code_button => 'Validate the code sent to email';

  @override
  String get auth_password_reset_success_title =>
      'Password reset successfully!';

  @override
  String get auth_password_reset_success_message =>
      'Now you can log in with the new password';

  @override
  String get auth_email_confirmed_title => 'Email confirmed!';

  @override
  String get auth_email_confirmed_message =>
      'Now you can log in with your email and password.';

  @override
  String get auth_ok_button => 'OK';

  @override
  String get auth_or_divider => 'or';

  @override
  String get auth_continue_with_google => 'Continue with Google';

  @override
  String get auth_signing_in => 'Signing in...';

  @override
  String get auth_google_sign_in_description =>
      'Sign in or create an account with Google';

  @override
  String get auth_google_sign_in_failed =>
      'Google sign-in failed. Please try again or use email.';

  @override
  String get email_typo_dialog_header => 'Did you mean?';

  @override
  String get email_typo_dialog_title =>
      'We noticed a possible typo in your email address';

  @override
  String get email_typo_you_typed => 'You typed';

  @override
  String get email_typo_did_you_mean => 'Did you mean';

  @override
  String get email_typo_use_suggestion => 'Yes, use corrected email';

  @override
  String get email_typo_keep_original => 'No, I typed it correctly';

  @override
  String get auth_go_back => 'Go back';

  @override
  String get auth_change_email => 'Change email';

  @override
  String get dashboard_app_title => 'Zen scrap';

  @override
  String get dashboard_nav_your_endpoints => 'Your endpoints';

  @override
  String get dashboard_nav_marketplace => 'Marketplace';

  @override
  String get dashboard_nav_credits_keys => 'Credits & Keys';

  @override
  String get dashboard_nav_api_analytics => 'Api analytics';

  @override
  String get dashboard_nav_account => 'Account';

  @override
  String get dashboard_nav_log_out => 'Log out';

  @override
  String get dashboard_nav_subscription => 'Subscription';

  @override
  String get dashboard_nav_ai_usage => 'AI Usage';

  @override
  String get dashboard_collapse_tab => 'Collapse tab';

  @override
  String dashboard_app_version(String version) {
    return 'App version: $version';
  }

  @override
  String dashboard_version_short(String version) {
    return 'v$version';
  }

  @override
  String get pricing_per_month => 'Per month';

  @override
  String get pricing_per_year => 'Per year';

  @override
  String get pricing_subtitle =>
      'We have you covered, whether you\'re an unique person running\na side-project, a startup or even an enterprise company.';

  @override
  String get pricing_plan_basic => 'BASIC';

  @override
  String get pricing_plan_basic_subtitle => 'FOR SIDE-PROJECTS';

  @override
  String get pricing_plan_pro => 'PRO';

  @override
  String get pricing_plan_pro_subtitle => 'FOR STARTUP';

  @override
  String get pricing_plan_pro_emphasis => 'MOST POPULAR';

  @override
  String get pricing_plan_ultra => 'ULTRA';

  @override
  String get pricing_plan_ultra_subtitle => 'ENTERPRISE USAGE';

  @override
  String pricing_feature_api_credits(String count) {
    return '$count api credits';
  }

  @override
  String pricing_feature_concurrent_requests(String count) {
    return '$count concurrent requests';
  }

  @override
  String pricing_feature_active_endpoints(String count) {
    return '$count active endpoints';
  }

  @override
  String get pricing_feature_best_ai_model => 'Access a best AI model';

  @override
  String get pricing_feature_priority_support => 'Priority Support';

  @override
  String get pricing_feature_hide_endpoints =>
      'Hide your endpoints from marketplace';

  @override
  String get pricing_feature_copy_endpoints =>
      'Copy endpoints from marketplace';

  @override
  String get pricing_feature_addon_credits =>
      'Ability to purchase one time add-on api credits';

  @override
  String get pricing_sign_in_required => 'Please sign in to subscribe';

  @override
  String get pricing_checkout_error => 'Could not open checkout page';

  @override
  String pricing_error_message(String error) {
    return 'Error: $error';
  }

  @override
  String get marketplace_title => 'Marketplace';

  @override
  String get marketplace_public_scrappables => 'Public Scrappables';

  @override
  String get marketplace_refresh_page => 'Refresh page';

  @override
  String get marketplace_search_hint =>
      'Search for scrappables by name or description...';

  @override
  String get marketplace_error_loading => 'Error loading marketplace';

  @override
  String get marketplace_no_results_found => 'No results found';

  @override
  String get marketplace_no_scrappables_available => 'No scrappables available';

  @override
  String marketplace_no_scrappables_match(String searchQuery) {
    return 'No scrappables match \"$searchQuery\". Try adjusting your search.';
  }

  @override
  String get marketplace_empty_message =>
      'The marketplace is currently empty. Check back later for new scrappables.';

  @override
  String get marketplace_clear_search => 'Clear Search';

  @override
  String marketplace_pagination_range(
    int startItem,
    int endItem,
    int totalCount,
  ) {
    return '$startItem-$endItem of $totalCount';
  }

  @override
  String get marketplace_usage_metrics_title => 'Usage metrics (last 30 days)';

  @override
  String get marketplace_failed_to_load_metrics => 'Failed to load metrics';

  @override
  String get marketplace_no_requests_last_30_days =>
      'No requests in the last 30 days';

  @override
  String get marketplace_metrics_success => 'Success';

  @override
  String get marketplace_metrics_errors => 'Errors';

  @override
  String get marketplace_metrics_total => 'Total';

  @override
  String get marketplace_select_api_key => 'Select API Key';

  @override
  String marketplace_api_key_created(String date) {
    return 'Created: $date';
  }

  @override
  String get marketplace_cancel => 'Cancel';

  @override
  String get marketplace_clone_success_title =>
      'Scrappable Cloned Successfully!';

  @override
  String marketplace_clone_success_message(String name) {
    return '\"$name\" has been added to your endpoints';
  }

  @override
  String get marketplace_clone_private_notice =>
      'The cloned scrappable is private by default. You can make it public from the edit screen.';

  @override
  String get marketplace_go_to_endpoints => 'Go to Endpoints';

  @override
  String get marketplace_edit_scrappable => 'Edit Scrappable';

  @override
  String get marketplace_close => 'Close';

  @override
  String get marketplace_example_response => 'Example Response';

  @override
  String get marketplace_tab_result => 'RESULT';

  @override
  String get marketplace_tab_html => 'HTML';

  @override
  String get marketplace_tab_screenshot => 'Screenshot';

  @override
  String get marketplace_reference_url => 'Reference url used for example:';

  @override
  String get marketplace_open_url => 'Open URL';

  @override
  String get marketplace_copy_url => 'Copy URL';

  @override
  String get marketplace_no_example_response => 'No example response available';

  @override
  String get marketplace_copy => 'Copy';

  @override
  String get marketplace_increase_font_size => 'Increase font size';

  @override
  String get marketplace_decrease_font_size => 'Decrease font size';

  @override
  String get marketplace_no_html_content => 'No HTML content available';

  @override
  String get marketplace_no_screenshot => 'No screenshot available';

  @override
  String get marketplace_result_copied => 'Result copied to clipboard';

  @override
  String get marketplace_html_copied => 'HTML copied to clipboard';

  @override
  String get marketplace_screenshot_info_copied => 'Screenshot info copied';

  @override
  String get marketplace_target_url => 'Target URL:';

  @override
  String get marketplace_change => 'Change';

  @override
  String get marketplace_curl_command => 'Curl Command';

  @override
  String get marketplace_test_endpoint => 'Test Endpoint';

  @override
  String get marketplace_copy_curl_command => 'Copy the test cURL command';

  @override
  String get marketplace_api_configuration => 'API Configuration & Costs';

  @override
  String marketplace_created_date(String date) {
    return 'Created: $date';
  }

  @override
  String marketplace_last_logic_modification(String date) {
    return 'Last logic modification: $date';
  }

  @override
  String get marketplace_clone_to_my_endpoints => 'Clone to My Endpoints';

  @override
  String get marketplace_login_required =>
      'Please log in to use this scrappable.';

  @override
  String get marketplace_no_api_keys =>
      'No API keys found. Please create an API key first to use this scrappable.';

  @override
  String get marketplace_upgrade_required_title => 'Upgrade Required';

  @override
  String get marketplace_clone_feature_pro =>
      'Cloning scrappables from the marketplace is available on Pro and Ultra plans.';

  @override
  String get marketplace_upgrade_benefits_title => 'Upgrade to unlock:';

  @override
  String get marketplace_benefit_clone => 'Clone any marketplace scrappable';

  @override
  String get marketplace_benefit_more_credits => 'More API credits';

  @override
  String get marketplace_benefit_concurrent => 'Higher concurrent requests';

  @override
  String get marketplace_benefit_endpoints => 'More active endpoints';

  @override
  String get marketplace_maybe_later => 'Maybe Later';

  @override
  String get marketplace_view_plans => 'View Plans';

  @override
  String get scrap_session_copied_to_clipboard => 'Copied to clipboard';

  @override
  String get scrap_session_tab_result => 'RESULT';

  @override
  String get scrap_session_tab_html => 'HTML';

  @override
  String get scrap_session_tab_screenshot => 'Screenshot';

  @override
  String get scrap_session_no_json_response => 'No JSON response available';

  @override
  String get scrap_session_no_html_content => 'No HTML content available';

  @override
  String get scrap_session_no_screenshot => 'No screenshot available';

  @override
  String get scrap_session_copy => 'Copy';

  @override
  String get scrap_session_increase_font_size => 'Increase font size';

  @override
  String get scrap_session_decrease_font_size => 'Decrease font size';

  @override
  String get scrap_session_test_suite => 'Test suite';

  @override
  String get scrap_session_scrappable_info => 'Scrappable info';

  @override
  String get scrap_session_powerful_model_upgrade =>
      'Unlock access to the Powerful AI model for superior extraction accuracy and better understanding of complex web pages. Perfect for advanced scraping needs.';

  @override
  String get scrap_session_sign_in_required => 'Sign In Required';

  @override
  String get scrap_session_sign_in_unlock_features =>
      'Sign in to unlock powerful features:';

  @override
  String get scrap_session_advanced_ai_models => 'Advanced AI Models';

  @override
  String get scrap_session_advanced_ai_models_desc =>
      'Access Powerful AI models and other premium features';

  @override
  String get scrap_session_no_time_limits => 'No Time Limits';

  @override
  String get scrap_session_no_time_limits_desc =>
      'Endpoints never expire with a subscription';

  @override
  String get scrap_session_more_api_credits => 'More API Credits';

  @override
  String get scrap_session_more_api_credits_desc =>
      'Get thousands of API credits per month';

  @override
  String get scrap_session_multiple_endpoints => 'Multiple Endpoints';

  @override
  String get scrap_session_multiple_endpoints_desc =>
      'Create and manage multiple scraping endpoints';

  @override
  String get scrap_session_maybe_later => 'Maybe Later';

  @override
  String get scrap_session_sign_in => 'Sign In';

  @override
  String scrap_session_model_changed(String modelName) {
    return 'Scrap AI model changed to $modelName';
  }

  @override
  String get scrap_session_current => 'Current';

  @override
  String get scrap_session_deploy_tooltip =>
      'Continue to edit/use this scrappable\nendpoint by deploying it!';

  @override
  String get scrap_session_deploy_endpoint => 'DEPLOY ENDPOINT';

  @override
  String get scrap_session_discard_changes => 'Discard changes';

  @override
  String get scrap_session_go_back => 'Go back';

  @override
  String get scrap_session_edit_request => 'Edit scrappable request';

  @override
  String get scrap_session_no_test_data => 'No test data available';

  @override
  String get scrap_session_chat_loading => 'Chat is loading...';

  @override
  String get scrap_session_copy_curl => 'Copy the test cURL command';

  @override
  String get scrap_session_analyzing_url => 'Analyzing URL';

  @override
  String scrap_session_thoughts_processed(int count) {
    return '$count thoughts processed';
  }

  @override
  String get scrap_session_ai_thinking => 'AI is thinking...';

  @override
  String get scrap_session_initializing_ai => 'Initializing AI analysis...';

  @override
  String get scrap_session_web_search_grounding => 'Web Search Grounding';

  @override
  String scrap_session_sources_referenced(int count) {
    return '$count sources referenced';
  }

  @override
  String get scrap_session_ai_analyzing_pattern =>
      'Gemini 3 Pro is analyzing your URL pattern...';

  @override
  String get scrap_session_test_endpoint => 'Test endpoint';

  @override
  String get scrap_session_creating_session => 'Creating session...';

  @override
  String get scrap_session_add_api_key => 'Add API key to continue...';

  @override
  String get scrap_session_ask_modification => 'Ask for any modification...';

  @override
  String get scrap_session_message_min_length =>
      'Message must be at least 3 characters';

  @override
  String get scrap_session_message_max_length =>
      'Message must be less than 1000 characters';

  @override
  String get scrap_session_edit_request_title => 'Edit Scrappable Request';

  @override
  String get scrap_session_edit_request_subtitle =>
      'Customize the URL template, path parameters, and query parameters';

  @override
  String scrap_session_path_params_hint(Object postId, Object userId) {
    return 'Path parameters should be wrapped in curly braces like $userId or $postId. They represent dynamic segments in the URL that will be replaced with actual values.';
  }

  @override
  String scrap_session_use_param_name(Object paramName) {
    return 'Use $paramName for path parameters';
  }

  @override
  String get scrap_session_save_changes => 'Save Changes';

  @override
  String get scrap_session_duplicate_param => 'Duplicate Parameter';

  @override
  String get scrap_session_duplicate_path_param =>
      'This path parameter already exists.';

  @override
  String get scrap_session_duplicate_query_param =>
      'This query parameter already exists.';

  @override
  String get scrap_session_missing_path_params => 'Missing Path Parameters';

  @override
  String get scrap_session_unused_path_params => 'Unused Path Parameters';

  @override
  String get scrap_session_request_updated =>
      'Scrappable request updated successfully!';

  @override
  String get scrap_session_close => 'Close';

  @override
  String get scrap_session_chat_loading_disabled_tooltip =>
      'Disabled while AI is processing';

  @override
  String get scrap_session_chat_loading_test_notice =>
      'AI is processing a request. Please wait before running tests.';

  @override
  String get scrap_session_session_expired_tooltip =>
      'Session expired - deploy to continue';

  @override
  String get scrap_session_session_expired_test_notice =>
      'Your test session has expired. Deploy the endpoint to continue using it.';

  @override
  String get scrappables_empty_title =>
      'You did not create any scrappables yet.';

  @override
  String get scrappables_create_first => 'Create your first scrappable';

  @override
  String get scrappables_search_hint =>
      'Search your endpoints by name or description...';

  @override
  String get scrappables_error_loading => 'Error loading endpoints';

  @override
  String get scrappables_no_results => 'No endpoints found';

  @override
  String get scrappables_try_different_keywords =>
      'Try searching with different keywords or adjust your filters.';

  @override
  String get scrappables_try_different_categories =>
      'Try selecting different categories or clear your filters.';

  @override
  String get scrappables_selected_category => 'the selected category';

  @override
  String get scrappables_selected_categories => 'the selected categories';

  @override
  String get scrappables_your_endpoints => 'Your endpoints';

  @override
  String get scrappables_create_new => 'Create new endpoint';

  @override
  String get scrappables_create_dialog_title => 'Create New Scraper';

  @override
  String get scrappables_create_dialog_subtitle => 'AI-powered data extraction';

  @override
  String get scrappables_create_dialog_description =>
      'Enter the URL you want to scrape and describe what data you want to extract. Our AI will analyze the page and create a custom scraper for you.';

  @override
  String get scrappables_create_dialog_hint =>
      'Be specific about the data you need';

  @override
  String get scrappables_create_dialog_cancel => 'Cancel';

  @override
  String get scrappables_create_dialog_create => 'Create Scraper';

  @override
  String get scrappables_create_dialog_creating => 'Creating...';

  @override
  String get common_show_original => 'Show original';

  @override
  String get common_show_translated => 'Show translated';

  @override
  String common_auto_translated(String language) {
    return 'Auto-translated from $language';
  }

  @override
  String get authErrorInvalidCredentialsTitle => 'Login Failed';

  @override
  String get authErrorInvalidCredentialsDescription =>
      'The email or password you entered is incorrect. Please check your credentials and try again.';

  @override
  String get authErrorAccountNotFoundDescription =>
      'We couldn\'t find an account with this email address. Please check the email or create a new account.';

  @override
  String get authErrorAccountLockedTitle => 'Account Locked';

  @override
  String get authErrorAccountDisabledDescription =>
      'Your account has been disabled. Please contact support for assistance.';

  @override
  String get authErrorAccountLockedDescription =>
      'Your account has been temporarily locked due to security concerns. Please try again later or contact support.';

  @override
  String get authErrorEmailExistsTitle => 'Email Already Registered';

  @override
  String get authErrorEmailExistsDescription =>
      'An account with this email address already exists. Please try logging in instead, or use a different email.';

  @override
  String get authErrorInvalidCodeTitle => 'Invalid Code';

  @override
  String get authErrorInvalidCodeDescription =>
      'The verification code you entered is incorrect. Please check the code in your email and try again.';

  @override
  String get authErrorExpiredCodeTitle => 'Code Expired';

  @override
  String get authErrorExpiredCodeDescription =>
      'This verification code has expired. Please request a new code and try again.';

  @override
  String get authErrorWeakPasswordTitle => 'Password Too Weak';

  @override
  String get authErrorWeakPasswordDescription =>
      'Please choose a stronger password. Use at least 8 characters with a mix of letters, numbers, and symbols.';

  @override
  String get authErrorInvalidEmailTitle => 'Invalid Email';

  @override
  String get authErrorInvalidEmailDescription =>
      'Please enter a valid email address.';

  @override
  String get authErrorRateLimitedTitle => 'Too Many Attempts';

  @override
  String get authErrorTooManyAttemptsDescription =>
      'You\'ve made too many attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorLoginRateLimitedDescription =>
      'Too many login attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorVerificationRateLimitedDescription =>
      'Too many verification attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorPasswordResetCodeInvalidDescription =>
      'The password reset code you entered is incorrect. Please check the code in your email and try again.';

  @override
  String get authErrorPasswordResetCodeExpiredDescription =>
      'This password reset code has expired. Please request a new password reset and try again.';

  @override
  String get authErrorPasswordResetRateLimitedDescription =>
      'Too many password reset attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorGoogleCancelledTitle => 'Sign-In Cancelled';

  @override
  String get authErrorGoogleCancelledDescription =>
      'Google sign-in was cancelled. You can try again or use email sign-in instead.';

  @override
  String get authErrorGoogleFailedTitle => 'Google Sign-In Failed';

  @override
  String get authErrorGoogleFailedDescription =>
      'We couldn\'t complete Google sign-in. Please try again or use email sign-in.';

  @override
  String get authErrorGoogleNotVerifiedTitle => 'Account Not Verified';

  @override
  String get authErrorGoogleNotVerifiedDescription =>
      'Your Google account email is not verified. Please verify your Google account and try again.';

  @override
  String get authErrorGoogleDomainRestrictedTitle => 'Domain Not Allowed';

  @override
  String get authErrorGoogleDomainRestrictedDescription =>
      'Sign-in is restricted to specific email domains. Please use an allowed email address.';

  @override
  String get authErrorNetworkTitle => 'Connection Error';

  @override
  String get authErrorNetworkDescription =>
      'Unable to connect to the server. Please check your internet connection and try again.';

  @override
  String get authErrorConnectionRefusedDescription =>
      'Could not reach the server. Please check your internet connection and try again.';

  @override
  String get authErrorServerTitle => 'Server Error';

  @override
  String get authErrorServerDescription =>
      'Something went wrong on our end. Please try again later. If the problem persists, contact support.';

  @override
  String get authErrorTimeoutTitle => 'Request Timeout';

  @override
  String get authErrorTimeoutDescription =>
      'The request took too long. Please check your connection and try again.';

  @override
  String get authErrorUnknownTitle => 'Something Went Wrong';

  @override
  String get authErrorUnknownDescription =>
      'An unexpected error occurred. Please try again. If the problem continues, contact support.';

  @override
  String get authErrorButtonTryAgain => 'Try Again';

  @override
  String get authErrorButtonTryLater => 'Try Later';

  @override
  String get authErrorButtonOk => 'OK';

  @override
  String get ip_block_reason_unknown => 'Unknown reason';

  @override
  String get ip_block_reason_tor_detected => 'Tor exit node detected';

  @override
  String get ip_block_reason_datacenter_abuser =>
      'Datacenter IP with abuse history';

  @override
  String get ip_block_reason_known_abuser => 'Known abusive IP address';

  @override
  String get ip_block_reason_crawler_detected =>
      'Automated bot or crawler detected';

  @override
  String get ip_block_reason_bogon_ip => 'Invalid IP address range';

  @override
  String get payment_success_title => 'Payment Successful!';

  @override
  String get payment_success_message =>
      'Thank you for upgrading your subscription. Your account is being updated.';

  @override
  String get payment_success_instructions_title => 'What\'s Next?';

  @override
  String get payment_success_instructions_message =>
      'Your subscription will be active within a few minutes. Please refresh your account page to see your updated subscription status and new features.';

  @override
  String get payment_success_go_to_account => 'Go to Account';
}
