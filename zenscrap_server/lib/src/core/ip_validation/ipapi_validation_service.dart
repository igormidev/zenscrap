import 'package:dio/dio.dart';
import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/ip_validation/i_ip_validation_service.dart';
import 'package:zenscrap_server/src/core/ip_validation/ip_validation_result.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Duration for which cached IP validation results are considered valid.
const Duration kIpValidationCacheDuration = Duration(hours: 72);

/// IP validation service implementation using ipapi.is API.
///
/// ipapi.is provides comprehensive IP intelligence including:
/// - VPN, Proxy, Tor detection
/// - Datacenter/hosting detection
/// - Known abuser flagging
/// - Crawler/bot detection
/// - Geolocation data
///
/// API Documentation: https://ipapi.is/
///
/// **Free Tier Limits:** 1,000 requests per day
///
/// **Error Handling:**
/// If the API is unavailable, rate-limited, or returns an error, this
/// implementation returns a fallback result that assumes the IP is legitimate.
/// This ensures users are not blocked due to service outages.
class IpApiValidationService extends IIpValidationService {
  final String apiKey;
  final Dio _dio;

  /// Callback for logging messages (e.g., session.log).
  final void Function(String message)? onLog;

  /// Creates an instance of [IpApiValidationService].
  ///
  /// [apiKey] - Your ipapi.is API key.
  /// [dio] - Optional Dio instance for testing/mocking.
  /// [onLog] - Optional callback for logging (e.g., `session.log`).
  IpApiValidationService({required this.apiKey, Dio? dio, this.onLog})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  @override
  Future<IpValidationResult> validateIp(String ipAddress) async {
    try {
      onLog?.call('[IpApiValidation] Validating IP: $ipAddress');

      final response = await _dio.get<Map<String, dynamic>>(
        'https://api.ipapi.is/',
        queryParameters: {'q': ipAddress, 'key': apiKey},
        options: Options(
          responseType: ResponseType.json,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return _parseResponse(ipAddress, response.data!);
      }

      // Handle 4xx errors (rate limit, invalid API key, etc.)
      if (response.statusCode == 429) {
        onLog?.call(
          '[IpApiValidation] Rate limit exceeded, using fallback for $ipAddress',
        );
        return IpValidationResult.fallback(ipAddress: ipAddress);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        onLog?.call(
          '[IpApiValidation] Invalid API key, using fallback for $ipAddress',
        );
        return IpValidationResult.fallback(ipAddress: ipAddress);
      }

      // For any other 4xx error, use fallback
      onLog?.call(
        '[IpApiValidation] Unexpected status ${response.statusCode}, using fallback for $ipAddress',
      );
      return IpValidationResult.fallback(ipAddress: ipAddress);
    } on DioException catch (e) {
      // Network errors, timeouts, etc. - use fallback
      onLog?.call(
        '[IpApiValidation] Network error for $ipAddress: ${e.message}, using fallback',
      );
      return IpValidationResult.fallback(ipAddress: ipAddress);
    } catch (e) {
      // Any other unexpected error - use fallback
      onLog?.call(
        '[IpApiValidation] Unexpected error for $ipAddress: $e, using fallback',
      );
      return IpValidationResult.fallback(ipAddress: ipAddress);
    }
  }

  /// Parses the ipapi.is response and creates an [IpValidationResult].
  IpValidationResult _parseResponse(
    String ipAddress,
    Map<String, dynamic> data,
  ) {
    // Extract risk indicators
    final bool isVpn = data['is_vpn'] as bool? ?? false;
    final bool isProxy = data['is_proxy'] as bool? ?? false;
    final bool isTor = data['is_tor'] as bool? ?? false;
    final bool isDatacenter = data['is_datacenter'] as bool? ?? false;
    final bool isAbuser = data['is_abuser'] as bool? ?? false;
    final bool isCrawler = data['is_crawler'] as bool? ?? false;
    final bool isMobile = data['is_mobile'] as bool? ?? false;
    final bool isBogon = data['is_bogon'] as bool? ?? false;

    // Extract company info
    final companyData = data['company'] as Map<String, dynamic>?;
    final String? companyName = companyData?['name'] as String?;
    final String? companyType = companyData?['type'] as String?;

    // Extract location info
    final locationData = data['location'] as Map<String, dynamic>?;
    final String? countryCode = locationData?['country_code'] as String?;
    final String? city = locationData?['city'] as String?;

    // Extract timing info
    final double? elapsedMs = (data['elapsed_ms'] as num?)?.toDouble();

    // Determine if IP should be blocked based on risk indicators
    final List<IpBlockReason> blockReasons = [];

    // VPN detection - logged but NOT blocked (many legitimate users use VPNs)
    // if (isVpn) {
    //   blockReasons.add(IpBlockReason.vpnDetected);
    // }

    // Proxy detection - logged but NOT blocked (corporate networks use proxies)
    // if (isProxy) {
    //   blockReasons.add(IpBlockReason.proxyDetected);
    // }

    // Block Tor - high anonymity, commonly used for abuse
    if (isTor) {
      blockReasons.add(IpBlockReason.torDetected);
    }

    // Block datacenter IPs - likely bots, not real users
    // Exception: Some legitimate users might be on cloud VMs, so we only block
    // if combined with other indicators OR if they're known abusers
    if (isDatacenter && (isAbuser || isCrawler)) {
      blockReasons.add(IpBlockReason.datacenterAbuser);
    }

    // Block known abusers - flagged for previous malicious activity
    if (isAbuser) {
      blockReasons.add(IpBlockReason.knownAbuser);
    }

    // Block crawlers/bots - not real users
    if (isCrawler) {
      blockReasons.add(IpBlockReason.crawlerDetected);
    }

    // Block bogon IPs - invalid/reserved IP ranges
    if (isBogon) {
      blockReasons.add(IpBlockReason.bogonIp);
    }

    // If any block reasons, mark as suspicious
    if (blockReasons.isNotEmpty) {
      final blockReason = blockReasons.map((r) => r.name).join(', ');
      onLog?.call('[IpApiValidation] IP $ipAddress blocked: $blockReason');

      return IpValidationResult.suspicious(
        ipAddress: ipAddress,
        blockReason: blockReason,
        blockReasonEnums: blockReasons,
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

    // IP is legitimate
    onLog?.call(
      '[IpApiValidation] IP $ipAddress validated as legitimate (country: $countryCode)',
    );

    return IpValidationResult.legitimate(
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

  /// Validates an IP address with caching support.
  ///
  /// This method first checks the database cache for a valid (non-expired) entry.
  /// If found, it returns the cached result without making an API call.
  /// If not found or expired, it calls the API and updates the cache.
  ///
  /// [session] - The Serverpod session for database access.
  /// [ipAddress] - The IP address to validate.
  ///
  /// Returns an [IpValidationResult] indicating whether the IP is legitimate.
  Future<IpValidationResult> validateIpWithCache(
    Session session,
    String ipAddress,
  ) async {
    try {
      // Check cache first
      final cachedEntry = await IpValidationCache.db.findFirstRow(
        session,
        where: (t) => t.ipAddress.equals(ipAddress),
      );

      if (cachedEntry != null) {
        // Check if cache entry is still valid (within 72 hours)
        final cacheAge = DateTime.now().difference(cachedEntry.updatedAt);
        if (cacheAge < kIpValidationCacheDuration) {
          onLog?.call(
            '[IpApiValidation] Cache HIT for IP $ipAddress (age: ${cacheAge.inMinutes} minutes)',
          );

          // Return cached result
          if (cachedEntry.isLegitimate) {
            return IpValidationResult.legitimate(
              ipAddress: cachedEntry.ipAddress,
              isVpn: cachedEntry.isVpn,
              isProxy: cachedEntry.isProxy,
              isTor: cachedEntry.isTor,
              isDatacenter: cachedEntry.isDatacenter,
              isAbuser: cachedEntry.isAbuser,
              isCrawler: cachedEntry.isCrawler,
              isMobile: cachedEntry.isMobile,
              companyName: cachedEntry.companyName,
              companyType: cachedEntry.companyType,
              countryCode: cachedEntry.countryCode,
              city: cachedEntry.city,
            );
          } else {
            return IpValidationResult.suspicious(
              ipAddress: cachedEntry.ipAddress,
              blockReason: cachedEntry.blockReason ?? 'Unknown',
              blockReasonEnums: cachedEntry.blockReasonEnums,
              isVpn: cachedEntry.isVpn,
              isProxy: cachedEntry.isProxy,
              isTor: cachedEntry.isTor,
              isDatacenter: cachedEntry.isDatacenter,
              isAbuser: cachedEntry.isAbuser,
              isCrawler: cachedEntry.isCrawler,
              isMobile: cachedEntry.isMobile,
              companyName: cachedEntry.companyName,
              companyType: cachedEntry.companyType,
              countryCode: cachedEntry.countryCode,
              city: cachedEntry.city,
            );
          }
        } else {
          onLog?.call(
            '[IpApiValidation] Cache EXPIRED for IP $ipAddress (age: ${cacheAge.inHours} hours)',
          );
        }
      } else {
        onLog?.call('[IpApiValidation] Cache MISS for IP $ipAddress');
      }

      // Cache miss or expired - call API
      final result = await validateIp(ipAddress);

      // Don't cache fallback results (service unavailable)
      if (result.isFallback) {
        onLog?.call(
          '[IpApiValidation] Not caching fallback result for IP $ipAddress',
        );
        return result;
      }

      // Update or insert cache entry
      try {
        final now = DateTime.now();
        final cacheEntry = IpValidationCache(
          ipAddress: result.ipAddress,
          updatedAt: now,
          isLegitimate: result.isLegitimate,
          blockReason: result.blockReason,
          blockReasonEnums: result.blockReasonEnums,
          isVpn: result.isVpn,
          isProxy: result.isProxy,
          isTor: result.isTor,
          isDatacenter: result.isDatacenter,
          isAbuser: result.isAbuser,
          isCrawler: result.isCrawler,
          isMobile: result.isMobile,
          companyName: result.companyName,
          companyType: result.companyType,
          countryCode: result.countryCode,
          city: result.city,
        );

        if (cachedEntry != null) {
          // Update existing entry
          await IpValidationCache.db.updateRow(
            session,
            cacheEntry.copyWith(id: cachedEntry.id),
          );
          onLog?.call('[IpApiValidation] Updated cache for IP $ipAddress');
        } else {
          // Insert new entry
          await IpValidationCache.db.insertRow(session, cacheEntry);
          onLog?.call('[IpApiValidation] Inserted cache for IP $ipAddress');
        }
      } catch (e) {
        // Cache operation failed - log but don't fail the validation
        onLog?.call(
          '[IpApiValidation] Failed to update cache for IP $ipAddress: $e',
        );
      }

      return result;
    } catch (e) {
      // If cache operations fail completely, fall back to direct API call
      onLog?.call(
        '[IpApiValidation] Cache error for IP $ipAddress: $e, falling back to API',
      );
      return validateIp(ipAddress);
    }
  }
}
