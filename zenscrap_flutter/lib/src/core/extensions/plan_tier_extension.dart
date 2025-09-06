import 'package:zenscrap_client/zenscrap_client.dart';

extension PlanTierExtension on PlanTier {
  String get apiCreditsAddedPerMonth {
    return switch (this) {
      PlanTier.none => '0',
      PlanTier.basic => '50K',
      PlanTier.pro => '200K',
      PlanTier.ultra => '1M',
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
}
