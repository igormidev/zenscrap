import 'package:zenscrap_client/zenscrap_client.dart';

extension PlanTierExtension on PlanTier {
  String get displayName {
    return switch (this) {
      PlanTier.none => 'None',
      PlanTier.basic => 'Basic',
      PlanTier.pro => 'Pro',
      PlanTier.ultra => 'Ultra',
    };
  }
}
