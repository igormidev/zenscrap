import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';

class MarketplaceSearchBar extends ConsumerStatefulWidget {
  const MarketplaceSearchBar({super.key});

  @override
  ConsumerState<MarketplaceSearchBar> createState() =>
      _MarketplaceSearchBarState();
}

class _MarketplaceSearchBarState extends ConsumerState<MarketplaceSearchBar> {
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
      ref.read(marketplaceProvider.notifier).search(value);
    });
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
          hintText: 'Search for scrappables by name or description...',
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
                  onPressed: () {
                    _searchController.clear();
                    ref.read(marketplaceProvider.notifier).search('');
                  },
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