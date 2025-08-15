import 'dart:typed_data';

extension ByteDataAsUint8List on ByteData {
  Uint8List get asUint8List {
    return Uint8List.sublistView(this);
  }
}

extension Uint8ListAsByteData on Uint8List {
  ByteData get asByteData {
    return ByteData.view(
      buffer,
      offsetInBytes,
      lengthInBytes,
    );
  }
}
