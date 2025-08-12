import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart' as adaptive_dialog;
import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

Future<void> handleBabelException(
  BuildContext context,
  ZenScrapException? exception, {
  FutureOr<void> Function()? onDismisseed,
}) async {
  await errorDialogLock.synchronized(() async {
    await adaptive_dialog.showOkAlertDialog(
      context: context,
      title: (exception ?? defaultException).title,
      message: (exception ?? defaultException).description,
      barrierDismissible: false,
    );
    await onDismisseed?.call();
  });
}

final errorDialogLock = Lock();

final ZenScrapException defaultException = ZenScrapException(
  title: 'Error',
  description: 'An unknown error occurred.',
);

Future<void> showErrorDialog(
  BuildContext context, {
  required String title,
  required String description,
}) async {
  await adaptive_dialog.showOkAlertDialog(
    context: context,
    title: title,
    message: description,
    barrierDismissible: false,
    // Add an error icon to the dialog
    builder: (context, child) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error, color: Colors.red, size: 48),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}
