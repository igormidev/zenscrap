// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

mixin EditScrappable<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<bool> onEditScrappable(
    Scrappable scrappable,
    String name,
    String description,
    ScraperCategory? category,
    void Function() onSuccess,
  ) async {
    try {
      final client = ref.read(clientProvider);
      final success = await client.editScrappable.call(
        scrappableId: scrappable.id.toString(),
        name: name,
        description: description,
        category: category,
      );

      if (success) {
        onSuccess();

        // Show success message
        if (!context.mounted) return success;

        showSnackbar(
          context,
          'Scrappable updated successfully',
        );
      }

      return success;
    } catch (e) {
      if (mounted) {
        if (!context.mounted) return false;
        showErrorSnackbar(
          context,
          'Error: ${e.toString()}',
        );
      }
      return false;
    }
  }
}
