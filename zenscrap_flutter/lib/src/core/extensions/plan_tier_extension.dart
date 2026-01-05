import 'package:zenscrap_client/zenscrap_client.dart';

extension PlanTierExtension on PlanTier {
  String get apiCreditsAddedPerMonth {
    return switch (this) {
      PlanTier.none => '1K',
      PlanTier.basic => '50K',
      PlanTier.pro => '200K',
      PlanTier.ultra => '1M',
    };
  }

  int get apiCreditsAddedPerMonthInt {
    return switch (this) {
      PlanTier.none => 1000,
      PlanTier.basic => 50000,
      PlanTier.pro => 200000,
      PlanTier.ultra => 1000000,
    };
  }

  String get displayName {
    return switch (this) {
      PlanTier.none => 'None',
      PlanTier.basic => 'Basic',
      PlanTier.pro => 'Pro',
      PlanTier.ultra => 'Ultra',
    };
  }

  int get maxScrappables {
    return switch (this) {
      PlanTier.none => 1,
      PlanTier.basic => 3,
      PlanTier.pro => 10,
      PlanTier.ultra => 100,
    };
  }

  PlanTier get nextTier {
    return switch (this) {
      PlanTier.none => PlanTier.basic,
      PlanTier.basic => PlanTier.pro,
      PlanTier.pro => PlanTier.ultra,
      PlanTier.ultra => PlanTier.ultra,
    };
  }
}
