import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/scraper_category_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// A reusable category filter widget that allows multi-selection of categories.
///
/// This widget displays all available [ScraperCategory] values as filterable chips
/// in a wrap layout. Users can select/deselect categories by tapping them.
///
/// Example usage:
/// ```dart
/// CategoryFilter(
///   selectedCategories: selectedCategories,
///   onCategoriesChanged: (newCategories) {
///     setState(() => selectedCategories = newCategories);
///   },
/// )
/// ```
class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  /// The currently selected categories
  final Set<ScraperCategory> selectedCategories;

  /// Callback when the category selection changes
  final ValueChanged<Set<ScraperCategory>> onCategoriesChanged;

  void _toggleCategory(ScraperCategory category) {
    final newSelection = Set<ScraperCategory>.from(selectedCategories);
    if (newSelection.contains(category)) {
      newSelection.remove(category);
    } else {
      newSelection.add(category);
    }
    onCategoriesChanged(newSelection);
  }

  void _clearAll() {
    onCategoriesChanged({});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _CategoryFilterHeader(
          selectedCount: selectedCategories.length,
          onClearAll: selectedCategories.isEmpty ? null : _clearAll,
        ),
        const SizedBox(height: 12),
        _CategoryChipGrid(
          selectedCategories: selectedCategories,
          onCategoryToggled: _toggleCategory,
        ),
      ],
    );
  }
}

class _CategoryFilterHeader extends StatelessWidget {
  const _CategoryFilterHeader({
    required this.selectedCount,
    required this.onClearAll,
  });

  final int selectedCount;
  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          selectedCount == 0
              ? 'Filter by category'
              : 'Categories ($selectedCount selected)',
          style: context.t.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.c.onSurface,
          ),
        ),
        if (onClearAll != null)
          TextButton.icon(
            onPressed: onClearAll,
            icon: Icon(
              Icons.clear_rounded,
              size: 18,
              color: context.c.primary,
            ),
            label: Text(
              'Clear all',
              style: context.t.labelMedium?.copyWith(
                color: context.c.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }
}

class _CategoryChipGrid extends StatelessWidget {
  const _CategoryChipGrid({
    required this.selectedCategories,
    required this.onCategoryToggled,
  });

  final Set<ScraperCategory> selectedCategories;
  final ValueChanged<ScraperCategory> onCategoryToggled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ScraperCategory.values.map((category) {
        return _CategoryFilterChip(
          category: category,
          isSelected: selectedCategories.contains(category),
          onTap: () => onCategoryToggled(category),
        );
      }).toList(),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final ScraperCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onTap(),
      avatar: Icon(
        category.icon,
        size: 18,
        color: isSelected ? context.c.onPrimary : context.c.primary,
      ),
      label: Text(
        category.displayName,
        style: context.t.labelMedium?.copyWith(
          color: isSelected ? context.c.onPrimary : context.c.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      backgroundColor: context.c.surface,
      selectedColor: context.c.primary,
      checkmarkColor: context.c.onPrimary,
      side: BorderSide(
        color: isSelected
            ? context.c.primary
            : context.c.outline.withAlpha(102),
        width: isSelected ? 2 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: const EdgeInsets.only(left: 4),
      visualDensity: VisualDensity.comfortable,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
