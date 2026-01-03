import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class PathParametersSection extends StatelessWidget {
  final List<String> pathParams;
  final VoidCallback onAddPathParam;
  final void Function(String param) onRemovePathParam;

  /// When true, the Add Path Parameter button will be disabled.
  final bool isChatLoading;

  /// When true, the session has expired and the Add Path Parameter button will be disabled.
  final bool isExpired;

  const PathParametersSection({
    super.key,
    required this.pathParams,
    required this.onAddPathParam,
    required this.onRemovePathParam,
    this.isChatLoading = false,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Path Parameters',
              style: context.t.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.info_outline,
                size: 18,
                color: context.c.onSurfaceVariant,
              ),
              tooltip:
                  'Path parameters are dynamic parts in the URL template, like {userId} or {postId}',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Define parameter names that should be replaced in the URL using {} syntax',
          style: context.t.bodySmall?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...pathParams.map(
              (param) => _PathParameterChip(
                paramName: param,
                onDelete: () => onRemovePathParam(param),
              ),
            ),
            Tooltip(
              message: isExpired
                  ? AppLocalizations.of(context)!.scrap_session_session_expired_tooltip
                  : (isChatLoading
                      ? AppLocalizations.of(context)!.scrap_session_chat_loading_disabled_tooltip
                      : ''),
              child: ActionChip(
                avatar: Icon(
                  Icons.add,
                  size: 18,
                  color: (isChatLoading || isExpired)
                      ? context.c.onSurface.withAlpha(100)
                      : context.c.primary,
                ),
                label: const Text('Add Path Parameter'),
                onPressed: (isChatLoading || isExpired) ? null : onAddPathParam,
                backgroundColor: context.c.primaryContainer.withAlpha(77),
                side: BorderSide(
                  color: context.c.primary.withAlpha(128),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PathParameterChip extends StatelessWidget {
  final String paramName;
  final VoidCallback onDelete;

  const _PathParameterChip({
    required this.paramName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        '{$paramName}',
        style: context.t.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: context.c.primaryContainer,
      deleteIcon: Icon(
        Icons.close,
        size: 18,
        color: context.c.onPrimaryContainer,
      ),
      onDeleted: onDelete,
      side: BorderSide(
        color: context.c.primary.withAlpha(128),
      ),
    );
  }
}

/// Shows a dialog to add a new path parameter
Future<String?> showAddPathParameterDialog(BuildContext context) async {
  final result = await showTextInputDialog(
    context: context,
    textFields: [
      DialogTextField(
        hintText: 'userId, postId, itemId...',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Parameter name cannot be empty';
          }
          if (value.length > 20) {
            return 'Maximum 20 characters allowed';
          }
          if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
            return 'Must start with a letter and contain only letters, numbers, and underscores';
          }
          return null;
        },
        maxLength: 20,
      ),
    ],
    title: 'Add Path Parameter',
    message:
        'Enter the name of the path parameter. This will be used in the URL template as {paramName}.',
    okLabel: 'Add',
    cancelLabel: 'Cancel',
  );

  if (result != null && result.isNotEmpty) {
    return result.first;
  }
  return null;
}
