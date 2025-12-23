import 'package:zenscrap_server/src/core/ip_validation/ip_validation_result.dart';

/// Interface for IP address validation services.
///
/// Implementations of this interface should check whether an IP address
/// is legitimate or suspicious (e.g., VPN, proxy, Tor, datacenter, known abuser).
///
/// The interface is designed to be resilient: if the validation service
/// is unavailable, implementations should return a fallback result that
/// assumes the IP is legitimate, rather than blocking users.
///
/// Example usage:
/// ```dart
/// final validator = IpApiValidationService(apiKey: 'your-api-key');
/// final result = await validator.validateIp('192.168.1.1');
///
/// if (!result.isLegitimate) {
///   throw SuspiciousIpException(result.blockReason ?? 'Suspicious IP detected');
/// }
/// ```
abstract class IIpValidationService {
  /// Validates an IP address and returns detailed information about it.
  ///
  /// Returns an [IpValidationResult] containing:
  /// - Whether the IP is legitimate
  /// - Risk indicators (VPN, proxy, Tor, datacenter, abuser, crawler)
  /// - Geolocation information (country, city)
  /// - Company/ASN information
  ///
  /// **Error Handling:**
  /// If the validation service is unavailable, rate-limited, or returns an error,
  /// this method should return [IpValidationResult.fallback()] instead of throwing.
  /// This ensures users are not blocked due to service outages.
  ///
  /// **Parameters:**
  /// - [ipAddress]: The IP address to validate (IPv4 or IPv6).
  ///
  /// **Returns:**
  /// An [IpValidationResult] with validation details.
  Future<IpValidationResult> validateIp(String ipAddress);

  /// Validates an IP address and checks if it should be allowed to proceed.
  ///
  /// This is a convenience method that validates the IP and returns only
  /// the legitimacy status.
  ///
  /// Returns `true` if the IP is legitimate, `false` if suspicious.
  /// Always returns `true` on fallback (service unavailable).
  Future<bool> isLegitimateIp(String ipAddress) async {
    final result = await validateIp(ipAddress);
    return result.isLegitimate;
  }
}
