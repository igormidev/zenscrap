import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/category_filter.dart';

/// Collapsible category filter section
class CategoryFilterSection extends StatefulWidget {
  const CategoryFilterSection({
    super.key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  final Set<ScraperCategory> selectedCategories;
  final ValueChanged<Set<ScraperCategory>> onCategoriesChanged;

  @override
  State<CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<CategoryFilterSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.outlineVariant.withAlpha(128),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    size: 20,
                    color: context.c.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.selectedCategories.isEmpty
                        ? 'Filter by category'
                        : '${widget.selectedCategories.length} ${widget.selectedCategories.length == 1 ? 'category' : 'categories'} selected',
                    style: context.t.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.c.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: context.c.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: CategoryFilter(
                selectedCategories: widget.selectedCategories,
                onCategoriesChanged: widget.onCategoriesChanged,
              ),
            ),
        ],
      ),
    );
  }
}
