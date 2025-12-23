import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';

/// Extension to provide localized strings for IpBlockReason enum values.
///
/// This extension maps each IP block reason to its translated string
/// based on the current app locale.
extension IpBlockReasonExtension on IpBlockReason {
  /// Returns the localized display name for this IP block reason.
  ///
  /// Example:
  /// ```dart
  /// final reason = IpBlockReason.torDetected;
  /// final localized = reason.localizedName(context);
  /// // Returns: "Tor exit node detected" (or translated equivalent)
  /// ```
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case IpBlockReason.unknown:
        return l10n.ip_block_reason_unknown;
      case IpBlockReason.torDetected:
        return l10n.ip_block_reason_tor_detected;
      case IpBlockReason.datacenterAbuser:
        return l10n.ip_block_reason_datacenter_abuser;
      case IpBlockReason.knownAbuser:
        return l10n.ip_block_reason_known_abuser;
      case IpBlockReason.crawlerDetected:
        return l10n.ip_block_reason_crawler_detected;
      case IpBlockReason.bogonIp:
        return l10n.ip_block_reason_bogon_ip;
    }
  }

  /// Returns the icon that represents this IP block reason.
  IconData get icon {
    switch (this) {
      case IpBlockReason.unknown:
        return Icons.help_outline;
      case IpBlockReason.torDetected:
        return Icons.shield_outlined;
      case IpBlockReason.datacenterAbuser:
        return Icons.dns_outlined;
      case IpBlockReason.knownAbuser:
        return Icons.block;
      case IpBlockReason.crawlerDetected:
        return Icons.smart_toy_outlined;
      case IpBlockReason.bogonIp:
        return Icons.warning_amber_rounded;
    }
  }
}

/// Helper extension for lists of IpBlockReason
extension IpBlockReasonListExtension on List<IpBlockReason> {
  /// Returns a comma-separated string of localized IP block reasons.
  ///
  /// Example:
  /// ```dart
  /// final reasons = [IpBlockReason.torDetected, IpBlockReason.knownAbuser];
  /// final text = reasons.localizedJoined(context);
  /// // Returns: "Tor exit node detected, Known abusive IP address"
  /// ```
  String localizedJoined(BuildContext context, {String separator = ', '}) {
    return map((reason) => reason.localizedName(context)).join(separator);
  }
}
