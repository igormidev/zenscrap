import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:zenscrap_server/src/core/ip_validation/ipapi_validation_service.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Mock Dio implementation for testing without network calls
class MockDio implements Dio {
  final Map<String, dynamic>? responseData;
  final int? statusCode;
  final DioException? error;

  MockDio({
    this.responseData,
    this.statusCode = 200,
    this.error,
  });

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (error != null) {
      throw error!;
    }

    return Response<T>(
      data: responseData as T,
      statusCode: statusCode,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('IpApiValidationService', () {
    const testApiKey = 'test-api-key';

    test('legitimate IP (US Army) returns isLegitimate = true', () async {
      // Test data from actual ipapi.is response (147.241.247.111)
      final mockResponse = {
        'ip': '147.241.247.111',
        'rir': 'ARIN',
        'is_bogon': false,
        'is_mobile': false,
        'is_satellite': false,
        'is_crawler': false,
        'is_datacenter': false,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': false,
        'company': {
          'name': 'Headquarters, USAISC',
          'abuser_score': '0 (Very Low)',
          'domain': 'www.army.mil',
          'type': 'government',
          'network': '147.241.0.0 - 147.241.255.255',
          'whois': 'https://api.ipapi.is/?whois=147.241.0.0'
        },
        'abuse': {
          'name': 'Headquarters, USAISC',
          'address': 'NETC-ANC CONUS TNOSC, Fort Huachuca, AZ, 85613, US',
          'email': 'disa.columbus.ns.mbx.arin-registrations@mail.mil',
          'phone': '+1-844-347-2457'
        },
        'asn': {
          'asn': 668,
          'abuser_score': '0 (Very Low)',
          'route': '147.241.192.0/18',
          'descr': 'DNIC-AS-00668, US',
          'country': 'us',
          'active': true,
          'org': 'United States Department of Defense (DoD)',
          'domain': 'defense.gov',
          'abuse': 'disa.columbus.ns.mbx.hostmaster-dod-nic@mail.mil',
          'type': 'government',
          'created': '1990-04-24',
          'updated': '2025-09-12',
          'rir': 'ARIN',
          'whois': 'https://api.ipapi.is/?whois=AS668'
        },
        'location': {
          'is_eu_member': false,
          'calling_code': '1',
          'currency_code': 'USD',
          'continent': 'NA',
          'country': 'United States',
          'country_code': 'US',
          'state': 'Arizona',
          'city': 'Sierra Vista',
          'latitude': 31.55454,
          'longitude': -110.30369,
          'zip': '85671',
          'timezone': 'America/Phoenix',
          'local_time': '2025-12-23T00:36:57-07:00',
          'local_time_unix': 1766475417,
          'is_dst': false
        },
        'elapsed_ms': 0.43
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('147.241.247.111');

      expect(result.isLegitimate, isTrue);
      expect(result.blockReason, isNull);
      expect(result.blockReasonEnums, isNull);
      expect(result.ipAddress, equals('147.241.247.111'));
      expect(result.countryCode, equals('US'));
      expect(result.city, equals('Sierra Vista'));
      expect(result.companyName, equals('Headquarters, USAISC'));
      expect(result.companyType, equals('government'));
      expect(result.isVpn, isFalse);
      expect(result.isProxy, isFalse);
      expect(result.isTor, isFalse);
      expect(result.isDatacenter, isFalse);
      expect(result.isAbuser, isFalse);
      expect(result.isCrawler, isFalse);
    });

    test('Tor IP (is_tor: true) returns blocked with torDetected enum',
        () async {
      final mockResponse = {
        'ip': '185.220.101.1',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': false,
        'is_datacenter': false,
        'is_tor': true,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': false,
        'location': {'country_code': 'DE', 'city': 'Frankfurt'},
        'company': {'name': 'Tor Exit Node', 'type': 'hosting'},
        'elapsed_ms': 0.5
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('185.220.101.1');

      expect(result.isLegitimate, isFalse);
      expect(result.blockReason, equals('torDetected'));
      expect(result.blockReasonEnums, isNotNull);
      expect(result.blockReasonEnums, hasLength(1));
      expect(result.blockReasonEnums?.first, equals(IpBlockReason.torDetected));
      expect(result.isTor, isTrue);
    });

    test('known abuser (is_abuser: true) returns blocked with knownAbuser enum',
        () async {
      final mockResponse = {
        'ip': '192.168.1.100',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': false,
        'is_datacenter': false,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': true,
        'location': {'country_code': 'US', 'city': 'New York'},
        'company': {'name': 'Abusive ISP', 'type': 'isp'},
        'elapsed_ms': 0.4
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('192.168.1.100');

      expect(result.isLegitimate, isFalse);
      expect(result.blockReason, equals('knownAbuser'));
      expect(result.blockReasonEnums, isNotNull);
      expect(result.blockReasonEnums, hasLength(1));
      expect(
          result.blockReasonEnums?.first, equals(IpBlockReason.knownAbuser));
      expect(result.isAbuser, isTrue);
    });

    test('crawler (is_crawler: true) returns blocked with crawlerDetected enum',
        () async {
      final mockResponse = {
        'ip': '66.249.66.1',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': true,
        'is_datacenter': false,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': false,
        'location': {'country_code': 'US', 'city': 'Mountain View'},
        'company': {'name': 'Google', 'type': 'business'},
        'elapsed_ms': 0.3
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('66.249.66.1');

      expect(result.isLegitimate, isFalse);
      expect(result.blockReason, equals('crawlerDetected'));
      expect(result.blockReasonEnums, isNotNull);
      expect(result.blockReasonEnums, hasLength(1));
      expect(result.blockReasonEnums?.first,
          equals(IpBlockReason.crawlerDetected));
      expect(result.isCrawler, isTrue);
    });

    test('bogon IP (is_bogon: true) returns blocked with bogonIp enum',
        () async {
      final mockResponse = {
        'ip': '192.168.1.1',
        'is_bogon': true,
        'is_mobile': false,
        'is_crawler': false,
        'is_datacenter': false,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': false,
        'location': null,
        'company': null,
        'elapsed_ms': 0.2
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('192.168.1.1');

      expect(result.isLegitimate, isFalse);
      expect(result.blockReason, equals('bogonIp'));
      expect(result.blockReasonEnums, isNotNull);
      expect(result.blockReasonEnums, hasLength(1));
      expect(result.blockReasonEnums?.first, equals(IpBlockReason.bogonIp));
    });

    test(
        'datacenter with abuser (is_datacenter: true, is_abuser: true) returns blocked',
        () async {
      final mockResponse = {
        'ip': '45.142.212.61',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': false,
        'is_datacenter': true,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': true,
        'location': {'country_code': 'NL', 'city': 'Amsterdam'},
        'company': {'name': 'DigitalOcean', 'type': 'datacenter'},
        'elapsed_ms': 0.5
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('45.142.212.61');

      expect(result.isLegitimate, isFalse);
      expect(result.blockReason, equals('datacenterAbuser, knownAbuser'));
      expect(result.blockReasonEnums, isNotNull);
      expect(result.blockReasonEnums, hasLength(2));
      expect(result.blockReasonEnums,
          containsAll([IpBlockReason.datacenterAbuser, IpBlockReason.knownAbuser]));
      expect(result.isDatacenter, isTrue);
      expect(result.isAbuser, isTrue);
    });

    test(
        'datacenter with crawler (is_datacenter: true, is_crawler: true) returns blocked',
        () async {
      final mockResponse = {
        'ip': '45.142.212.62',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': true,
        'is_datacenter': true,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': false,
        'location': {'country_code': 'NL', 'city': 'Amsterdam'},
        'company': {'name': 'DigitalOcean', 'type': 'datacenter'},
        'elapsed_ms': 0.5
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('45.142.212.62');

      expect(result.isLegitimate, isFalse);
      expect(result.blockReason, equals('datacenterAbuser, crawlerDetected'));
      expect(result.blockReasonEnums, isNotNull);
      expect(result.blockReasonEnums, hasLength(2));
      expect(
          result.blockReasonEnums,
          containsAll([
            IpBlockReason.datacenterAbuser,
            IpBlockReason.crawlerDetected
          ]));
      expect(result.isDatacenter, isTrue);
      expect(result.isCrawler, isTrue);
    });

    test('VPN alone (is_vpn: true) does NOT block', () async {
      final mockResponse = {
        'ip': '104.28.15.100',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': false,
        'is_datacenter': false,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': true,
        'is_abuser': false,
        'location': {'country_code': 'US', 'city': 'Los Angeles'},
        'company': {'name': 'NordVPN', 'type': 'vpn'},
        'elapsed_ms': 0.4
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('104.28.15.100');

      expect(result.isLegitimate, isTrue);
      expect(result.blockReason, isNull);
      expect(result.blockReasonEnums, isNull);
      expect(result.isVpn, isTrue);
    });

    test('proxy alone (is_proxy: true) does NOT block', () async {
      final mockResponse = {
        'ip': '8.8.8.8',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': false,
        'is_datacenter': false,
        'is_tor': false,
        'is_proxy': true,
        'is_vpn': false,
        'is_abuser': false,
        'location': {'country_code': 'US', 'city': 'Mountain View'},
        'company': {'name': 'Corporate Proxy', 'type': 'business'},
        'elapsed_ms': 0.3
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('8.8.8.8');

      expect(result.isLegitimate, isTrue);
      expect(result.blockReason, isNull);
      expect(result.blockReasonEnums, isNull);
      expect(result.isProxy, isTrue);
    });

    test('API error returns fallback result', () async {
      final mockDio = MockDio(
        error: DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        ),
      );
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('1.2.3.4');

      expect(result.isLegitimate, isTrue);
      expect(result.isFallback, isTrue);
      expect(result.ipAddress, equals('1.2.3.4'));
    });

    test('rate limit (429) returns fallback result', () async {
      final mockDio = MockDio(statusCode: 429);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('1.2.3.4');

      expect(result.isLegitimate, isTrue);
      expect(result.isFallback, isTrue);
      expect(result.ipAddress, equals('1.2.3.4'));
    });

    test('invalid API key (401) returns fallback result', () async {
      final mockDio = MockDio(statusCode: 401);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('1.2.3.4');

      expect(result.isLegitimate, isTrue);
      expect(result.isFallback, isTrue);
      expect(result.ipAddress, equals('1.2.3.4'));
    });

    test('datacenter alone (without abuser/crawler) does NOT block', () async {
      final mockResponse = {
        'ip': '142.251.220.46',
        'is_bogon': false,
        'is_mobile': false,
        'is_crawler': false,
        'is_datacenter': true,
        'is_tor': false,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': false,
        'location': {'country_code': 'US', 'city': 'Mountain View'},
        'company': {'name': 'Google Cloud', 'type': 'datacenter'},
        'elapsed_ms': 0.4
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('142.251.220.46');

      expect(result.isLegitimate, isTrue);
      expect(result.blockReason, isNull);
      expect(result.blockReasonEnums, isNull);
      expect(result.isDatacenter, isTrue);
    });

    test('multiple block reasons combine correctly', () async {
      final mockResponse = {
        'ip': '1.2.3.4',
        'is_bogon': true,
        'is_mobile': false,
        'is_crawler': true,
        'is_datacenter': false,
        'is_tor': true,
        'is_proxy': false,
        'is_vpn': false,
        'is_abuser': true,
        'location': {'country_code': 'XX', 'city': 'Unknown'},
        'company': null,
        'elapsed_ms': 0.2
      };

      final mockDio = MockDio(responseData: mockResponse);
      final service = IpApiValidationService(apiKey: testApiKey, dio: mockDio);

      final result = await service.validateIp('1.2.3.4');

      expect(result.isLegitimate, isFalse);
      expect(result.blockReason,
          equals('torDetected, knownAbuser, crawlerDetected, bogonIp'));
      expect(result.blockReasonEnums, isNotNull);
      expect(result.blockReasonEnums, hasLength(4));
      expect(
          result.blockReasonEnums,
          containsAll([
            IpBlockReason.torDetected,
            IpBlockReason.knownAbuser,
            IpBlockReason.crawlerDetected,
            IpBlockReason.bogonIp
          ]));
    });
  });
}
