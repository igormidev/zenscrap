import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Displays a circular avatar for the user's account image.
/// Falls back to a no-photo icon if no image is provided.
///
/// The [size] parameter allows callers to specify the appropriate size
/// for their responsive context. Common sizes:
/// - Compact drawer/mobile: 80-100
/// - Expanded drawer: 100-120
/// - Navigation rail: 60
/// - App bar: 32
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
