import 'dart:convert';
import 'dart:typed_data';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';

const String systemPrompt =
    '''You are a world class expert in web scraping, web automation and web data extraction. You have deep knowledge about web technologies, HTML, CSS, JavaScript, HTTP protocols, web scraping tools and techniques.
You are also an expert in using ScrapingBee API (https://www.scrapingbee.com/documentation/) to perform web scraping tasks''';

List<GeminiSdkContent> handleInitialPrompts(InitialPayloadData payload) {
  return switch (payload) {
    InitialPayloadDataCreatingFromZero() => creatingFromZeroInitialPrompt(
      payload: payload,
    ),
    InitialPayloadDataEditingExistingWebScrapper() =>
      editingExistingWebScrapperInitialPrompt(payload: payload),
  };
}

List<GeminiSdkContent> creatingFromZeroInitialPrompt({
  required InitialPayloadDataCreatingFromZero payload,
}) {
  // The one used as "url" of scrapping bee
  final String targetUrl = payload.targetExampleUrl;

  final WebScrapperRequest webScrapperRequest = payload.webScrapperRequest;
  final e = JsonEncoder.withIndent('  ');
  final requestJson = webScrapperRequest.toMap();
  final inputBytes = Uint8List.fromList(e.convert(requestJson).codeUnits);

  return [
    // TODO: ADD TEXT TO EXPLAIN WHAT THE JSON IS
    GeminiSdkContent.bytes(data: inputBytes, fileExtension: 'json'),
  ];
}

List<GeminiSdkContent> editingExistingWebScrapperInitialPrompt({
  required InitialPayloadDataEditingExistingWebScrapper payload,
}) {
  final WebScrapperRequest currentRequest = payload.currentRequest;
  final ScrappingBeeFetchSettings currentFetchSettings =
      payload.currentFetchSettings;
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
