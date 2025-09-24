import 'package:test/test.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';

void main() {
  group('Dynamic Proxy Configuration Tests', () {
    late ScrappingBeeProxyConfig proxyConfig;

    setUp(() {
      proxyConfig = ScrappingBeeProxyConfig(
        apiKey: 'test_api_key',
        stealthProxy: true,
        renderJs: true,
        premiumProxy: true,
        countryCode: 'us', // Default country
      );
    });

    test('buildProxyUrl generates correct URL with default country', () {
      final url = proxyConfig.buildProxyUrl();
      expect(
        url,
        equals(
          'http://test_api_key:render_js=True&premium_proxy=True&stealth_proxy=True&country_code=us@proxy.scrapingbee.com:8886',
        ),
      );
    });

    test('buildProxyUrl generates correct URL with dynamic country override', () {
      // Test German proxy
      var url = proxyConfig.buildProxyUrl(dynamicCountryCode: 'de');
      expect(
        url,
        contains('country_code=de'),
      );

      // Test Brazilian proxy
      url = proxyConfig.buildProxyUrl(dynamicCountryCode: 'br');
      expect(
        url,
        contains('country_code=br'),
      );

      // Test Japanese proxy
      url = proxyConfig.buildProxyUrl(dynamicCountryCode: 'jp');
      expect(
        url,
        contains('country_code=jp'),
      );
    });

    test('buildProxyUrl maintains required proxy settings', () {
      final url = proxyConfig.buildProxyUrl(dynamicCountryCode: 'fr');
      
      // Verify all required settings are present
      expect(url, contains('render_js=True'));
      expect(url, contains('premium_proxy=True'));
      expect(url, contains('stealth_proxy=True'));
      expect(url, contains('country_code=fr'));
      expect(url, contains('@proxy.scrapingbee.com:8886'));
    });

    test('buildProxyUrl handles custom parameters', () {
      final customConfig = ScrappingBeeProxyConfig(
        apiKey: 'test_api_key',
        parameters: {
          'custom_param': 'value1',
          'another_param': 'value2',
        },
        premiumProxy: true,
        renderJs: true,
        stealthProxy: true,
      );

      final url = customConfig.buildProxyUrl(dynamicCountryCode: 'gb');
      expect(url, contains('custom_param=value1'));
      expect(url, contains('another_param=value2'));
      expect(url, contains('country_code=gb'));
    });

    test('Example URLs for different regions', () {
      final examples = {
        'Amazon Germany': 'de',
        'Mercado Libre Argentina': 'ar',
        'BBC UK': 'gb',
        'Le Monde France': 'fr',
        'Rakuten Japan': 'jp',
        'Flipkart India': 'in',
        'Alibaba China': 'cn',
      };

      examples.forEach((site, countryCode) {
        final url = proxyConfig.buildProxyUrl(dynamicCountryCode: countryCode);
        print('$site proxy URL: $url');
        expect(url, contains('country_code=$countryCode'));
      });
    });

    test('Playwright launchOptions format example', () {
      // This demonstrates how the AI should format launchOptions for Playwright
      final proxyUrl = proxyConfig.buildProxyUrl(dynamicCountryCode: 'de');

      final launchOptions = {
        'args': ['--proxy-server=$proxyUrl'],
      };

      expect(launchOptions['args']![0], contains('proxy-server='));
      expect(launchOptions['args']![0], contains('country_code=de'));

      print('Playwright launchOptions example:');
      print('''
{
  "url": "https://example.com",
  "launchOptions": {
    "args": ["--proxy-server=$proxyUrl"]
  }
}''');
    });
  });
}