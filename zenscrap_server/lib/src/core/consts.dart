/// Default AI usage credits in dollars that users receive monthly.
/// This amount is reset every month for each user.
const double kDefaultMonthlyAICreditsInDollars = 10.0;

/// Maximum spending limit in dollars for anonymous (not logged in) users per session.
const double kAnonymousSessionSpendingLimitInDollars = 10.0;

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
