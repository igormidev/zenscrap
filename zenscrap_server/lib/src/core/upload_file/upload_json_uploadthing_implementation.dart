// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:zenscrap_server/src/core/upload_file/i_upload_json.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// UploadThing implementation of IUploadJson interface.
/// Handles uploading and retrieving JSON files from UploadThing storage.
class UploadJsonUploadThingImplementation implements IUploadJson {
  // UploadThing credentials
  static const String _apiKey =
      'sk_live_50efcc1a01a40ba0a04160532d8799fccf38fc835efdb18a3349f7a981061aea';
  static const String _apiBaseUrl = 'https://api.uploadthing.com';

  final _uuid = const Uuid();
  Dio? _dio;

  UploadJsonUploadThingImplementation() {
    // No initialization needed for direct API calls
  }

  /// Initialize Dio for file downloads
  Dio get dio {
    if (_dio == null) {
      _dio = Dio();

      // Configure Dio with custom HttpClient for proper TLS support
      (_dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();

        // Force TLS 1.2 or higher
        client.connectionTimeout = const Duration(seconds: 60);

        return client;
      };

      // Add timeout settings
      _dio!.options.connectTimeout = const Duration(seconds: 60);
      _dio!.options.receiveTimeout = const Duration(seconds: 60);
    }
    return _dio!;
  }

  @override
  Future<String> uploadTranslationJsonFile({
    required Map<String, String> jsonData,
  }) async {
    // Convert JSON data to bytes
    final String jsonString = json.encode(jsonData);
    final Uint8List jsonBytes = Uint8List.fromList(utf8.encode(jsonString));

    // Create a temporary file
    final tempDir = await Directory.systemTemp.createTemp('gobabel_upload');
    final fileName = 'translation_${_uuid.v7()}.json';
    final tempFile = File('${tempDir.path}/$fileName');

    try {
      // Write JSON data to temporary file
      await tempFile.writeAsBytes(jsonBytes);

      // Step 1: Request presigned URL from UploadThing
      final presignedResponse = await _requestPresignedUrl(
        fileName: fileName,
        fileSize: jsonBytes.length,
        contentType: 'application/json',
      );

      // Step 2: Upload file using the presigned URL
      final fileUrl = await _uploadFileToPresignedUrl(
        presignedData: presignedResponse,
        file: tempFile,
        contentType: 'application/json',
      );

      print('Uploaded JSON to UploadThing: $fileUrl');
      return fileUrl;
    } finally {
      // Clean up temporary file
      try {
        await tempFile.delete();
        await tempDir.delete();
      } catch (_) {
        // Ignore cleanup errors
      }
    }
  }

  /// Request presigned URL from UploadThing API
  Future<Map<String, dynamic>> _requestPresignedUrl({
    required String fileName,
    required int fileSize,
    required String contentType,
  }) async {
    final client = http.Client();
    try {
      // Prepare the request to get presigned URLs
      final response = await client.post(
        Uri.parse('$_apiBaseUrl/v6/uploadFiles'),
        headers: {
          'X-Uploadthing-Api-Key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'files': [
            {
              'name': fileName,
              'size': fileSize,
              'type': contentType,
            }
          ],
          'acl': 'public-read',
        }),
      );

      if (response.statusCode != 200) {
        throw ZenScrapException(
          title: 'UploadThing API Error',
          description:
              'Failed to get presigned URL. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }

      final responseData = json.decode(response.body);
      final data = responseData['data'];
      if (data == null || data.isEmpty) {
        throw ZenScrapException(
          title: 'UploadThing API Error',
          description: 'No upload data returned from API',
        );
      }

      return data[0];
    } finally {
      client.close();
    }
  }

  /// Upload file to the presigned URL
  Future<String> _uploadFileToPresignedUrl({
    required Map<String, dynamic> presignedData,
    required File file,
    required String contentType,
  }) async {
    final uploadUrl = presignedData['url'] as String;
    final fields = presignedData['fields'] as Map<String, dynamic>?;
    final fileUrl = presignedData['fileUrl'] as String?;

    if (uploadUrl.isEmpty || fileUrl == null) {
      throw ZenScrapException(
        title: 'UploadThing Upload Error',
        description: 'Invalid presigned URL data',
      );
    }

    // Create multipart request
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

    // Add fields if provided
    if (fields != null) {
      fields.forEach((key, value) {
        request.fields[key] = value.toString();
      });
    }

    // Add file
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(contentType),
      ),
    );

    // Send the request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fileUrl;
    } else {
      throw ZenScrapException(
        title: 'UploadThing Upload Failed',
        description:
            'Failed to upload file. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  @override
  Future<Map<String, String>> retrieveJsonFile({required String url}) async {
    try {
      // UploadThing URLs are public by default, no signing needed
      // Use streaming to download large JSON files efficiently
      final response = await dio.get<ResponseBody>(
        url,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        // Stream the response data
        final stream = response.data!.stream;
        final List<int> bytes = [];

        // Collect the streamed bytes
        await for (final chunk in stream) {
          bytes.addAll(chunk);
        }

        // Decode the JSON
        final String jsonString = utf8.decode(bytes);
        final dynamic jsonDataResponse = json.decode(jsonString);

        if (jsonDataResponse is Map) {
          final Map<String, String> result = {};
          jsonDataResponse.forEach((key, value) {
            if (key is String) {
              result[key] =
                  value?.toString() ?? ''; // Convert null to empty string
            }
          });
          return result;
        } else {
          print('UploadThing retrieval error: Data is not a map. URL: $url');
          throw ZenScrapException(
            title: 'UploadThing Data Error',
            description: 'Retrieved data from $url is not a valid JSON object.',
          );
        }
      } else if (response.statusCode == 202) {
        // 202 Accepted means the file is still being processed
        // Wait a bit and retry
        print('UploadThing file is still processing, retrying in 2 seconds...');
        await Future.delayed(const Duration(seconds: 2));

        // Retry the request
        return retrieveJsonFile(url: url);
      } else {
        print('Error retrieving from UploadThing: ${response.statusCode}');
        throw ZenScrapException(
          title: 'UploadThing Retrieval Error',
          description:
              'Failed to retrieve JSON data from $url. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (error, stackTrace) {
      print(
        'DioError retrieving from UploadThing: "${error.error}"\nResponse: ${error.response?.data}\nStackTrace: $stackTrace',
      );
      throw ZenScrapException(
        title: 'UploadThing Retrieval Error',
        description:
            'Failed to retrieve JSON data from $url. ${error.message}. Status: ${error.response?.statusCode}',
      );
    } catch (error, stackTrace) {
      print(
          'Error retrieving from UploadThing: $error\nStackTrace: $stackTrace');
      if (error is ZenScrapException) {
        rethrow;
      }
      throw ZenScrapException(
        title: 'Retrieval Failed',
        description:
            'An unexpected error occurred while retrieving the JSON data from $url: ${error.toString()}',
      );
    }
  }
}
