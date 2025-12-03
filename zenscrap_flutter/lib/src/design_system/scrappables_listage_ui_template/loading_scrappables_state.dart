import 'package:flutter/material.dart';

/// Loading state widget for scrappables list
class LoadingScrappablesState extends StatelessWidget {
  const LoadingScrappablesState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
