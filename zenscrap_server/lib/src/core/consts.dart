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
