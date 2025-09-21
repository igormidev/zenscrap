import 'dart:typed_data';

class TemporaryFiles {
  final String fileName;
  final Uint8List fileContent;
  const TemporaryFiles({required this.fileName, required this.fileContent});
}
