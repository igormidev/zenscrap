// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';

mixin EditScrappable<T extends ConsumerStatefulWidget> on ConsumerState<T> {
// mixin EditScrappable<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<bool> onEditScrappable(
    Scrappable scrappable,
    String name,
    String description,
    ScraperCategory category,
    bool? willHideFromMarketplace,
    void Function() onSuccess,
  ) async {
    final client = ref.read(clientProvider);
    final result = await client
        .editScrappable(
          scrappableId: scrappable.id!,
          name: name,
          description: description,
          category: category,
          willHideFromMarketplace: willHideFromMarketplace,
        )
        .toResult;

    return result.fold(
      (success) {
        if (success) {
          onSuccess();

          // Show success message
          if (context.mounted) {
            showSnackbar(
              context,
              'Scrappable updated successfully',
            );
          }
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
  }
}
