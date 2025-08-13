import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class ScrappableTestJsonResponseViewer extends StatelessWidget {
  final Map<String, dynamic> testResponse;
  const ScrappableTestJsonResponseViewer(
      {super.key, required this.testResponse});

  @override
  Widget build(BuildContext context) {
    return JsonView.map(
      testResponse,
    );
  }
}
