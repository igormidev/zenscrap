/// Default AI usage credits in dollars that users receive monthly.
/// This amount is reset every month for each user.
const double kDefaultMonthlyAICreditsInDollars = 10.0;

/// Maximum spending limit in dollars for anonymous (not logged in) users per session.
const double kAnonymousSessionSpendingLimitInDollars = 10.0;

/// Maximum spending limit in dollars per IP address within a 7-day rolling window.
/// This prevents abuse by anonymous users who create multiple sessions.
/// After 7 days, the spending record is cleaned up and the IP can spend again.
const double kAnonymousIpSpendingLimitInDollars = 17.50;

/// Duration after which anonymous IP spending records are cleaned up.
/// This allows users to use the platform again after the cooldown period.
const Duration kAnonymousIpSpendingResetDuration = Duration(days: 7);

/// Duration after which pending session commits are cleaned up.
/// This gives users 24 hours to deploy changes after their session expires.
const Duration kPendingSessionCommitMaxAge = Duration(hours: 24);

/// Interval at which the pending session commit cleanup FutureCall runs.
const Duration kPendingSessionCommitCleanupInterval = Duration(hours: 1);

// =============================================================================
// OpenAI GPT-5 Family Pricing (as of December 2025)
// Prices per million tokens
// Source: https://pricepertoken.com/pricing-page/model/openai-gpt-5
// =============================================================================

/// GPT-5 Mini input token price per million tokens ($0.25)
const double kGpt5MiniInputPricePerMillionTokens = 0.25;

/// GPT-5 Mini output token price per million tokens ($2.00)
const double kGpt5MiniOutputPricePerMillionTokens = 2.00;

/// GPT-5.1 input token price per million tokens ($1.25)
const double kGpt51InputPricePerMillionTokens = 1.25;

/// GPT-5.1 output token price per million tokens ($10.00)
const double kGpt51OutputPricePerMillionTokens = 10.00;

/// GPT-5 input token price per million tokens ($1.25) - same as GPT-5.1
const double kGpt5InputPricePerMillionTokens = 1.25;

/// GPT-5 output token price per million tokens ($10.00) - same as GPT-5.1
const double kGpt5OutputPricePerMillionTokens = 10.00;

// =============================================================================
// Pagination Constants
// =============================================================================

/// Page size for scrappable analytics summary view (grid of scrappables with
/// aggregated request counts per time scope).
const int kAnalyticsSummaryPageSize = 20;

/// Page size for detailed analytics view (individual request logs for a
/// specific scrappable).
const int kAnalyticsDetailPageSize = 30;

/// Page size for credit history views (API credits and AI credits).
/// Used in both API usage and AI usage history endpoints.
const int kCreditHistoryPageSize = 6;

/// Page size for auto-fix session history.
const int kAutoFixSessionPageSize = 10;

/// Page size for scrappable grid views (marketplace and user scrappables).
const int kScrappableGridPageSize = 12;
