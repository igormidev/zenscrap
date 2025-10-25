import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_provider.dart';

class UserScrappablesSearchBar extends ConsumerStatefulWidget {
  const UserScrappablesSearchBar({super.key});

  @override
  ConsumerState<UserScrappablesSearchBar> createState() =>
      _UserScrappablesSearchBarState();
}

class _UserScrappablesSearchBarState
    extends ConsumerState<UserScrappablesSearchBar> {
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
      ref.read(userScrappablesProvider.notifier).search(value);
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
          hintText: 'Search your endpoints by name or description...',
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
                    ref.read(userScrappablesProvider.notifier).search('');
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
