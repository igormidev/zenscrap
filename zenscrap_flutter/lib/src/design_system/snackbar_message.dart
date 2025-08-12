import 'package:flutter/material.dart';

enum SnackBarType {
  message,
  error,
  success,
}

void showErrorSnackbar(BuildContext context, [String? message]) {
  _showSnackBar(
    context,
    message ?? 'An error occurred',
    SnackBarType.error,
  );
}

void showSnackbar(BuildContext context, String message) {
  _showSnackBar(
    context,
    message,
    SnackBarType.message,
  );
}

void _showSnackBar(
  BuildContext context,
  String message,
  SnackBarType type,
) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: switch (type) {
            SnackBarType.message => Theme.of(context).colorScheme.onSecondary,
            SnackBarType.error => Theme.of(context).colorScheme.onError,
            SnackBarType.success => Colors.white,
          },
        ),
      ),
      backgroundColor: switch (type) {
        SnackBarType.message => Theme.of(context).colorScheme.secondary,
        SnackBarType.error => Theme.of(context).colorScheme.error,
        SnackBarType.success => Colors.green,
      },
    ));
}
