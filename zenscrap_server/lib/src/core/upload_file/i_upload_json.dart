/// Abstract interface for uploading and retrieving JSON files from cloud storage.
abstract class IUploadJson {
  /// Uploads JSON data to cloud storage.
  ///
  /// The [jsonData] is a map that will be converted to a JSON string.
  /// Uses streaming to handle large JSON files efficiently.
  ///
  /// Returns a Future<String> which is the public URL to download the JSON.
  Future<String> uploadTranslationJsonFile({
    required Map<String, String> jsonData,
  });

  /// Retrieves a JSON record from cloud storage with streaming support.
  ///
  /// [url]: The public URL of the JSON file to retrieve.
  /// Returns a Future<Map<String, String>> containing the JSON data.
  /// Uses streaming to handle large JSON files efficiently.
  Future<Map<String, String>> retrieveJsonFile({required String url});
}
