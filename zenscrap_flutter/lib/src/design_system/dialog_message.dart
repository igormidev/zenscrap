import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? message,
  required void Function()? onConfirm,
  String confirmButtonText = 'Confirm',
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: message != null ? BabelText(message) : null,
        actions: [
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop();
            },
            child: Text(confirmButtonText),
          ),
        ],
      );
    },
  );
}

Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  String? message,
  void Function()? onConfirm,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        icon: const Icon(Icons.check_circle, color: Colors.green),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}
