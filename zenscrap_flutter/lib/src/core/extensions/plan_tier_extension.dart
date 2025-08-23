import 'package:zenscrap_client/zenscrap_client.dart';

extension PlanTierExtension on PlanTier {
  String get displayName {
    return switch (this) {
      PlanTier.none => 'None',
      PlanTier.base => 'Base',
      PlanTier.pro => 'Pro',
      PlanTier.unlimited => 'Unlimited',
    };
  }
}
