import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Generic search bar for scrappables
class ScrappablesSearchBar extends StatefulWidget {
  const ScrappablesSearchBar({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.onSearchStart,
    this.onSearchClear,
  });

  /// Hint text to display in the search field
  final String hintText;

  /// Callback when search value changes (debounced)
  final ValueChanged<String> onSearch;

  /// Optional callback when search starts (for analytics)
  final ValueChanged<String>? onSearchStart;

  /// Optional callback when search is cleared (for analytics)
  final VoidCallback? onSearchClear;

  @override
  State<ScrappablesSearchBar> createState() => _ScrappablesSearchBarState();
}

class _ScrappablesSearchBarState extends State<ScrappablesSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer.resetDebounce(() {
      if (value.isNotEmpty) {
        widget.onSearchStart?.call(value);
      }
      widget.onSearch(value);
    });
  }

  void _onClear() {
    widget.onSearchClear?.call();
    _searchController.clear();
    widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(77),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: context.c.outline.withAlpha(51),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: context.t.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: context.t.bodyMedium?.copyWith(
            color: context.c.onSurfaceVariant.withAlpha(179),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.c.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: _onClear,
                  icon: Icon(
                    Icons.clear_rounded,
                    color: context.c.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
