import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class ApiKeySelectorDialog extends StatelessWidget {
  final List<AccountApiKey> apiKeys;
  final AccountApiKey selectedKey;

  const ApiKeySelectorDialog({
    super.key,
    required this.apiKeys,
    required this.selectedKey,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select API Key'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: apiKeys.length,
          itemBuilder: (context, index) {
            final apiKey = apiKeys[index];
            final isSelected = apiKey.apiKey == selectedKey.apiKey;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? context.c.primary
                      : context.c.outline.withAlpha(51),
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected
                    ? context.c.primary.withAlpha(26)
                    : context.c.surfaceContainerHighest.withAlpha(51),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pop(apiKey);
                },
                title: Text(
                  apiKey.name,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${apiKey.apiKey.substring(0, 8)}...${apiKey.apiKey.substring(apiKey.apiKey.length - 8)}',
                      style: context.t.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: context.c.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Created: ${_formatDate(apiKey.createdAt)}',
                      style: context.t.labelSmall?.copyWith(
                        color: context.c.onSurfaceVariant.withAlpha(179),
                      ),
                    ),
                  ],
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: context.c.primary,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}