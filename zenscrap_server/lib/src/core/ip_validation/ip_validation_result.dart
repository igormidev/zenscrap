import 'package:zenscrap_server/src/generated/protocol.dart';

/// Result of an IP address validation check.
///
/// Contains information about whether the IP is legitimate and various
/// risk indicators that were detected.
class IpValidationResult {
  /// Whether the IP is considered legitimate for using the service.
  ///
  /// This is `true` if the IP passed all checks, `false` if any suspicious
  /// indicators were detected.
  final bool isLegitimate;

  /// Human-readable reason for blocking (if [isLegitimate] is `false`).
  final String? blockReason;

  /// Enum values representing the block reasons (for translation support).
  final List<IpBlockReason>? blockReasonEnums;

  /// The IP address that was validated.
  final String ipAddress;

  /// Whether the IP is associated with a VPN service.
  final bool isVpn;

  /// Whether the IP is associated with a proxy service.
  final bool isProxy;

  /// Whether the IP is a Tor exit node.
  final bool isTor;

  /// Whether the IP is from a datacenter (cloud hosting, etc.).
  final bool isDatacenter;

  /// Whether the IP has been flagged as abusive.
  final bool isAbuser;

  /// Whether the IP is a known web crawler/bot.
  final bool isCrawler;

  /// Whether the IP is from a mobile network.
  final bool isMobile;

  /// The company/organization that owns the IP (if known).
  final String? companyName;

  /// The type of company (e.g., "isp", "datacenter", "government").
  final String? companyType;

  /// Country code of the IP location (e.g., "US", "BR").
  final String? countryCode;

  /// City of the IP location.
  final String? city;

  /// Time taken by the validation service (in milliseconds).
  final double? elapsedMs;

  /// Whether this result was from a fallback (e.g., service was unavailable).
  ///
  /// If `true`, the IP was assumed legitimate because the validation service
  /// could not be reached.
  final bool isFallback;

  const IpValidationResult({
    required this.isLegitimate,
    required this.ipAddress,
    this.blockReason,
    this.blockReasonEnums,
    this.isVpn = false,
    this.isProxy = false,
    this.isTor = false,
    this.isDatacenter = false,
    this.isAbuser = false,
    this.isCrawler = false,
    this.isMobile = false,
    this.companyName,
    this.companyType,
    this.countryCode,
    this.city,
    this.elapsedMs,
    this.isFallback = false,
  });

  /// Creates a result indicating the IP is legitimate.
  ///
  /// Used when the IP passes all validation checks.
  factory IpValidationResult.legitimate({
    required String ipAddress,
    bool isVpn = false,
    bool isProxy = false,
    bool isTor = false,
    bool isDatacenter = false,
    bool isAbuser = false,
    bool isCrawler = false,
    bool isMobile = false,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
    double? elapsedMs,
  }) {
    return IpValidationResult(
      isLegitimate: true,
      ipAddress: ipAddress,
      isVpn: isVpn,
      isProxy: isProxy,
      isTor: isTor,
      isDatacenter: isDatacenter,
      isAbuser: isAbuser,
      isCrawler: isCrawler,
      isMobile: isMobile,
      companyName: companyName,
      companyType: companyType,
      countryCode: countryCode,
      city: city,
      elapsedMs: elapsedMs,
    );
  }

  /// Creates a result indicating the IP is suspicious and should be blocked.
  ///
  /// [blockReason] should describe why the IP was flagged.
  /// [blockReasonEnums] contains the enum values for translation support.
  factory IpValidationResult.suspicious({
    required String ipAddress,
    required String blockReason,
    List<IpBlockReason>? blockReasonEnums,
    bool isVpn = false,
    bool isProxy = false,
    bool isTor = false,
    bool isDatacenter = false,
    bool isAbuser = false,
    bool isCrawler = false,
    bool isMobile = false,
    String? companyName,
    String? companyType,
    String? countryCode,
    String? city,
    double? elapsedMs,
  }) {
    return IpValidationResult(
      isLegitimate: false,
      ipAddress: ipAddress,
      blockReason: blockReason,
      blockReasonEnums: blockReasonEnums,
      isVpn: isVpn,
      isProxy: isProxy,
      isTor: isTor,
      isDatacenter: isDatacenter,
      isAbuser: isAbuser,
      isCrawler: isCrawler,
      isMobile: isMobile,
      companyName: companyName,
      companyType: companyType,
      countryCode: countryCode,
      city: city,
      elapsedMs: elapsedMs,
    );
  }

  /// Creates a fallback result when the validation service is unavailable.
  ///
  /// The IP is assumed legitimate to avoid blocking users when the service
  /// is down or rate-limited.
  factory IpValidationResult.fallback({
    required String ipAddress,
  }) {
    return IpValidationResult(
      isLegitimate: true,
      ipAddress: ipAddress,
      isFallback: true,
    );
  }

  /// Returns a list of reasons why this IP was flagged as suspicious.
  ///
  /// Empty if the IP is legitimate.
  List<String> get suspiciousIndicators {
    final indicators = <String>[];
    if (isVpn) indicators.add('VPN');
    if (isProxy) indicators.add('Proxy');
    if (isTor) indicators.add('Tor');
    if (isDatacenter) indicators.add('Datacenter');
    if (isAbuser) indicators.add('Known Abuser');
    if (isCrawler) indicators.add('Crawler/Bot');
    return indicators;
  }

  @override
  String toString() {
    if (isFallback) {
      return 'IpValidationResult(ip: $ipAddress, fallback: true, legitimate: true)';
    }
    if (isLegitimate) {
      return 'IpValidationResult(ip: $ipAddress, legitimate: true, country: $countryCode)';
    }
    return 'IpValidationResult(ip: $ipAddress, legitimate: false, reason: $blockReason, indicators: $suspiciousIndicators)';
  }
}
