import 'package:zenscrap_server/src/generated/protocol.dart';

extension PlanTierExt on PlanTier {
  /// The user has a subscription to a plan tier.
  /// Each month, the user receives a certain number of api credits based on their plan tier.
  int get apiCreditsToBeAddedPerMonth {
    return switch (this) {
      PlanTier.none => 0,
      PlanTier.base => 50000,
      PlanTier.pro => 200000,
      PlanTier.unlimited => 1000000,
    };
  }

  /// The number of api-calls/concurrent requests allowed by the user's current plan.
  int get numberOfConcurrentRequestsAllowedByPlan {
    return switch (this) {
      PlanTier.none => 0,
      PlanTier.base => 10,
      PlanTier.pro => 30,
      PlanTier.unlimited => 100,
    };
  }
}
