import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';

class UserScrappablesListage extends ConsumerStatefulWidget {
  const UserScrappablesListage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserScrappablesListageState();
}

class _UserScrappablesListageState
    extends ConsumerState<UserScrappablesListage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(userScrappables.notifier).getScrappables());
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Scrappable> scrappables = ref.watch(userScrappables).maybeWhen(
          withData: (scrappables) => scrappables,
          orElse: () => <Scrappable>[],
        );

    if (scrappables.isEmpty) {
      return EmptyScrappableListageIndicatorPage();
    }

    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 20),
            Text(
              'Your endpoints',
              style: context.t.displaySmall,
            ),
            Spacer(),
            FilledButton.tonalIcon(
              onPressed: () {},
              label: Text('Create new endpoint'),
              icon: Icon(Icons.add),
            ),
            SizedBox(width: 20),
          ],
        ),
        Divider(height: 1),
        Expanded(
          child: GridView.builder(
            itemCount: scrappables.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 1.5,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            itemBuilder: (context, index) {
              final scrappable = scrappables[index];
              return ScrappableCardIndicator(
                scrappable: scrappable,
                onTap: () {
                  context.push('/scrappable-form');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
