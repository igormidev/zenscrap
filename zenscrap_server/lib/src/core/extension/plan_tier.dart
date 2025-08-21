import 'package:zenscrap_server/src/generated/protocol.dart';

extension PlanTierExt on PlanTier {
  /// Returns the maximum number of concurrent requests allowed for this plan tier.
  int get maxConcurrentRequests {
    return switch (this) {
      PlanTier.none => 0,
      PlanTier.base => 10,
      PlanTier.pro => 30,
      PlanTier.unlimited => 100,
    };
  }
}
