import 'package:zenscrap_client/zenscrap_client.dart';

extension PlanTierExtension on PlanTier {
  String get apiCreditsAddedPerMonth {
    return switch (this) {
      PlanTier.none => '1K',
      PlanTier.basic => '250K',
      PlanTier.pro => '1M',
      PlanTier.ultra => '4M',
    };
  }

  int get apiCreditsAddedPerMonthInt {
    return switch (this) {
      PlanTier.none => 1000,
      PlanTier.basic => 250000,
      PlanTier.pro => 1000000,
      PlanTier.ultra => 4000000,
    };
  }

  String get displayName {
    return switch (this) {
      PlanTier.none => 'Free',
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
