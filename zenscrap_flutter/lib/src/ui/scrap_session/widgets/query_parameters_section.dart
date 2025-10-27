import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class QueryParametersSection extends StatelessWidget {
  final Map<String, String?> queryParams;
  final VoidCallback onAddQueryParam;
  final void Function(String key) onRemoveQueryParam;
  final void Function(String key) onEditQueryParam;

  const QueryParametersSection({
    super.key,
    required this.queryParams,
    required this.onAddQueryParam,
    required this.onRemoveQueryParam,
    required this.onEditQueryParam,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Query Parameters',
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
                  'Query parameters are optional parameters in the URL, like ?sort=asc&filter=all',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Define optional query parameters. If you provide a default value, it will be used when the user doesn\'t specify one.',
          style: context.t.bodySmall?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        if (queryParams.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.c.surfaceContainerHighest.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.c.outline.withAlpha(51),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: context.c.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No query parameters defined yet. Click "Add Query Parameter" to add one.',
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: queryParams.entries
                .map(
                  (entry) => QueryParameterCard(
                    paramKey: entry.key,
                    paramValue: entry.value,
                    onDelete: () => onRemoveQueryParam(entry.key),
                    onEdit: () => onEditQueryParam(entry.key),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onAddQueryParam,
          icon: const Icon(Icons.add),
          label: const Text('Add Query Parameter'),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.c.primary,
            side: BorderSide(color: context.c.primary),
          ),
        ),
      ],
    );
  }
}

class QueryParameterCard extends StatelessWidget {
  final String paramKey;
  final String? paramValue;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const QueryParameterCard({
    super.key,
    required this.paramKey,
    required this.paramValue,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: context.c.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.c.outline.withAlpha(77),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.label_outline,
                        size: 16,
                        color: context.c.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        paramKey,
                        style: context.t.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.data_object,
                        size: 16,
                        color: context.c.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          paramValue ?? 'No default value (dynamic)',
                          style: context.t.bodySmall?.copyWith(
                            color: paramValue == null
                                ? context.c.onSurfaceVariant.withAlpha(153)
                                : context.c.onSurfaceVariant,
                            fontFamily: 'monospace',
                            fontStyle: paramValue == null
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: context.c.primary,
              ),
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: context.c.error,
              ),
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Model for query parameter dialog result
class QueryParameterDialogResult {
  final String key;
  final String? value;

  QueryParameterDialogResult({
    required this.key,
    required this.value,
  });
}

/// Shows a dialog to add or edit a query parameter
Future<QueryParameterDialogResult?> showQueryParameterDialog(
  BuildContext context, {
  String? initialKey,
  String? initialValue,
  bool isEdit = false,
}) async {
  final result = await showTextInputDialog(
    context: context,
    textFields: [
      DialogTextField(
        hintText: 'e.g., sort, filter, page',
        initialText: initialKey,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Parameter name cannot be empty';
          }
          if (value.length > 30) {
            return 'Maximum 30 characters allowed';
          }
          if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
            return 'Must start with a letter and contain only letters, numbers, and underscores';
          }
          return null;
        },
        maxLength: 30,
      ),
      DialogTextField(
        hintText: 'Default value (optional)',
        initialText: initialValue,
        validator: (value) {
          // Value is optional, so no validation needed
          return null;
        },
      ),
    ],
    title: isEdit ? 'Edit Query Parameter' : 'Add Query Parameter',
    message: isEdit
        ? 'Update the query parameter key and default value.'
        : 'Enter the query parameter name and an optional default value. If you don\'t provide a default value, the parameter will be treated as dynamic (user must provide it).',
    okLabel: isEdit ? 'Update' : 'Add',
    cancelLabel: 'Cancel',
  );

  if (result != null && result.isNotEmpty) {
    final key = result[0];
    final value = result.length > 1 && result[1].isNotEmpty ? result[1] : null;
    return QueryParameterDialogResult(key: key, value: value);
  }
  return null;
}
