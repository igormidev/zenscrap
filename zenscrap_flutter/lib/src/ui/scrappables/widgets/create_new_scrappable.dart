import 'package:flutter/material.dart';

/// A button widget for creating new scrappables.
///
/// Displays a filled tonal button with an add icon and customizable label.
class CreateNewScrappable extends StatelessWidget {
  const CreateNewScrappable({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      label: Text(label),
      icon: const Icon(Icons.add),
    );
  }
}
