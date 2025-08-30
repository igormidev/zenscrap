import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/edit_scrappable_dialog.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';

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
    final List<Scrappable> scrappables = ref.watch(userScrappables).maybeWhen(
          withData: (scrappables) => scrappables,
          orElse: () => <Scrappable>[],
        );

    if (scrappables.isEmpty) {
      return EmptyScrappableListageIndicatorPage();
    }

    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            SizedBox(width: 20),
            Text(
              'Your endpoints',
              style: context.t.displaySmall,
            ),
            Spacer(),
            FilledButton.tonalIcon(
              onPressed: () {
                context.push('/scrappable-form');
              },
              label: Text('Create new endpoint'),
              icon: Icon(Icons.add),
            ),
            SizedBox(width: 20),
          ],
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constaints) {
            final optimalCrossAxisCount = (constaints.maxWidth / 480).floor();
            return GridView.builder(
              itemCount: scrappables.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: optimalCrossAxisCount,
                mainAxisExtent: 220,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              itemBuilder: (context, index) {
                final scrappable = scrappables[index];
                return ScrappableCardIndicator(
                  scrappable: scrappable,
                  onEdit: () async {
                    await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => EditScrappableDialog(
                        scrappable: scrappable,
                        onSave: (name, description, category,
                            willHideFromMarketplace) async {
                          return onEditScrappable(
                            scrappable,
                            name,
                            description,
                            category,
                            willHideFromMarketplace,
                            () {
                              unawaited(ref
                                  .read(userScrappables.notifier)
                                  .getScrappables());
                            },
                          );
                        },
                        onDelete: () async {
                          final client = ref.read(clientProvider);
                          final result = await client.deleteScrappable
                              .call(
                                scrappableId: scrappable.id.toString(),
                              )
                              .toResult;

                          return result.fold(
                            (success) {
                              // Refresh the scrappables list
                              unawaited(ref
                                  .read(userScrappables.notifier)
                                  .getScrappables());
                              if (context.mounted) {
                                showSnackbar(
                                  context,
                                  'Scrappable deleted successfully',
                                );
                              }
                              return success;
                            },
                            (error) {
                              if (context.mounted) {
                                handleBabelException(context, error);
                              }
                              return false;
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
