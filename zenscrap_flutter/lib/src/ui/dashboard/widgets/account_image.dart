import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class AccountImage extends StatelessWidget {
  const AccountImage({super.key, required this.image, this.size = 100});

  final String? image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircleAvatar(
          backgroundColor: context.c.primary,
          backgroundImage: image == null ? null : NetworkImage(image!),
          child:
              image == null ? const Icon(Icons.no_photography_rounded) : null,
        ),
      ),
    );
  }
}
