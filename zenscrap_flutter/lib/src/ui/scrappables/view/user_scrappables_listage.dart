import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/elements/scrappable_grid_listage.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';

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
      unawaited(ref.read(userScrappables.notifier).getScrappables());
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountId = ref.watch(accountProvider).mapOrNull(
          withData: (value) => value.accountInfo.id,
        );
    final List<Scrappable> scrappables = ref.watch(userScrappables).maybeWhen(
          withData: (scrappables) => scrappables,
          orElse: () => <Scrappable>[],
        );

    if (scrappables.isEmpty) {
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
                  unawaited(
                      ref.read(userScrappables.notifier).getScrappables());
                }
              },
              label: Text('Create new endpoint'),
              icon: Icon(Icons.add),
            ),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(height: 16),
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
      ],
    );
  }
}
