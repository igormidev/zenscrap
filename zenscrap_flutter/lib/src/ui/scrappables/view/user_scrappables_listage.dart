import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/elements/scrappable_grid_listage.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/widgets/user_scrappables_search_bar.dart';

class UserScrappablesListage extends ConsumerStatefulWidget {
  const UserScrappablesListage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserScrappablesListageState();
}

class _UserScrappablesListageState extends ConsumerState<UserScrappablesListage>
    with EditScrappable {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(userScrappablesProvider.notifier).getScrappables());
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountId = ref.watch(accountProvider).mapOrNull(
          withData: (value) => value.accountInfo.id,
        );
    final state = ref.watch(userScrappablesProvider);

    return state.map(
      initial: (_) => EmptyScrappableListageIndicatorPage(),
      loading: (_) => EmptyScrappableListageIndicatorPage(),
      withError: (_) => EmptyScrappableListageIndicatorPage(),
      withData: (data) {
        final response = data.response;
        final searchQuery = data.searchQuery;
        final scrappables = response.data;
        final pagination = response.pagination;

        if (scrappables.isEmpty && searchQuery.isEmpty) {
          return EmptyScrappableListageIndicatorPage();
        }

        return Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Your endpoints',
                  style: context.t.displaySmall,
                ),
                Spacer(),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    ref.read(scrapChatProvider.notifier).reset();
                    final result = await context.push('/scrappable-form');
                    if (result == true) {
                      unawaited(ref
                          .read(userScrappablesProvider.notifier)
                          .getScrappables());
                    }
                  },
                  label: Text('Create new endpoint'),
                  icon: Icon(Icons.add),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UserScrappablesSearchBar(),
            ),
            SizedBox(height: 16),
            if (scrappables.isEmpty && searchQuery.isNotEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: context.c.onSurfaceVariant.withAlpha(128),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No endpoints found',
                        style: context.t.titleLarge?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try searching with different keywords',
                        style: context.t.bodyMedium?.copyWith(
                          color: context.c.onSurfaceVariant.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ScrappableGridListage(
                        itemCount: scrappables.length,
                        itemBuilder: (context, index) {
                          final scrappable = scrappables[index];
                          return ScrappableCardIndicator(
                            accountId: accountId,
                            scrappable: scrappable,
                          );
                        },
                      ),
                    ),
                    if (pagination.hasNextPage) ...[
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FilledButton.tonal(
                          onPressed: () {
                            ref
                                .read(userScrappablesProvider.notifier)
                                .changePage(pagination.currentPage + 1);
                          },
                          child: Text(
                            'Load more (${pagination.currentPage}/${pagination.totalPages})',
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
