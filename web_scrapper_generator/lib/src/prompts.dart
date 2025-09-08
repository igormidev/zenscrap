import 'dart:convert';
import 'dart:typed_data';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';

const String systemPrompt =
    '''You are a world class expert in web scraping, web automation and web data extraction. You have deep knowledge about web technologies, HTML, CSS, JavaScript, HTTP protocols, web scraping tools and techniques.
You are also an expert in using ScrapingBee API (https://www.scrapingbee.com/documentation/) to perform web scraping tasks''';

List<GeminiSdkContent> getStartConversationContextContents({
  required WebScrapperRequest currentRequest,
  required ScrappingBeeFetchSettings currentFetchSettings,
}) {
  final e = JsonEncoder.withIndent('  ');
  final currentRequestJson = currentRequest.toMap();
  final currentFetchSettingsJson = currentFetchSettings.toMap();

  final inputJson = {
    'currentRequest': currentRequestJson,
    'currentFetchSettings': currentFetchSettingsJson,
  };
  final inputBytes = Uint8List.fromList(e.convert(inputJson).codeUnits);

  return [GeminiSdkContent.bytes(data: inputBytes, fileExtension: 'json')];
}
