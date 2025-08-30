import 'package:flutter/cupertino.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/scraper_category_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    super.key,
    required this.scrappable,
  });

  final Scrappable scrappable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: context.c.primaryContainer.withAlpha(51),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: context.c.primary.withAlpha(51),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            scrappable.category.icon,
            size: 14,
            color: context.c.primary,
          ),
          const SizedBox(width: 4),
          Text(
            scrappable.category.displayName,
            style: context.t.labelSmall?.copyWith(
              color: context.c.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
