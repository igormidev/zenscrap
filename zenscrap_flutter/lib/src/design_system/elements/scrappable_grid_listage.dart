import 'package:flutter/material.dart';

class ScrappableGridListage extends StatelessWidget {
  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;
  const ScrappableGridListage({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / 500).floor();
        final crossAxisCount = count < 1 ? 1 : count;

        return GridView.builder(
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 220,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
