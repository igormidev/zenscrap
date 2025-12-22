import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

class ScrappableHeader extends StatelessWidget {
  final Scrappable scrappable;

  const ScrappableHeader({
    super.key,
    required this.scrappable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
        bottom: context.responsiveValue(
          compact: 12.0,
          medium: 16.0,
          expanded: 16.0,
        ),
        left: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
        right: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
      ),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(
          bottom: BorderSide(
            color: context.c.outline.withAlpha(50),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: context.c.primary,
                size: context.responsiveValue(
                  compact: 20.0,
                  medium: 24.0,
                  expanded: 24.0,
                ),
              ),
              SizedBox(
                width: context.responsiveValue(
                  compact: 8.0,
                  medium: 8.0,
                  expanded: 8.0,
                ),
              ),
              Expanded(
                child: Text(
                  scrappable.name,
                  style: context.t.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (scrappable.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              scrappable.description,
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurface.withAlpha(150),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
