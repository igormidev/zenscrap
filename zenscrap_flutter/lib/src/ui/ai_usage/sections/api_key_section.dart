import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_usage_provider.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/widgets/ai_usage_card.dart';

/// Section for managing the user's OpenAI API key.
class ApiKeySection extends ConsumerStatefulWidget {
  final AccountAIUsage aiUsage;

  const ApiKeySection({
    super.key,
    required this.aiUsage,
  });

  @override
  ConsumerState<ApiKeySection> createState() => _ApiKeySectionState();
}

class _ApiKeySectionState extends ConsumerState<ApiKeySection> {
  bool _isUpdating = false;

  bool get hasApiKey =>
      widget.aiUsage.userOpenAiApiKey != null &&
      widget.aiUsage.userOpenAiApiKey!.isNotEmpty;

  Future<void> _showApiKeyDialog({String? currentKey}) async {
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => _ApiKeyInputDialog(
        initialKey: currentKey,
      ),
    );

    if (result != null) {
      await _updateApiKey(result);
    }
  }

  Future<void> _confirmRemoveApiKey() async {
    final l10n = AppLocalizations.of(context)!;

    final result = await showOkCancelAlertDialog(
      context: context,
      title: l10n.ai_usage_api_key_remove_confirm_title,
      message: l10n.ai_usage_api_key_remove_confirm_message,
      okLabel: l10n.ai_usage_api_key_remove,
      cancelLabel: l10n.ai_usage_api_key_cancel,
      isDestructiveAction: true,
    );

    if (result == OkCancelResult.ok) {
      await _updateApiKey(null, isRemoval: true);
    }
  }

  Future<void> _updateApiKey(String? apiKey, {bool isRemoval = false}) async {
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isUpdating = true);

    try {
      final result =
          await ref.read(aiUsageProvider.notifier).updateOpenAiApiKey(apiKey);

      if (!mounted) return;

      result.fold(
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isRemoval
                    ? l10n.ai_usage_api_key_removed
                    : l10n.ai_usage_api_key_updated,
              ),
              backgroundColor: context.c.primary,
            ),
          );
        },
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.description),
              backgroundColor: context.c.error,
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AiUsageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AiUsageCardHeader(
            icon: Icons.key,
            title: l10n.ai_usage_api_key_section_title,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.ai_usage_api_key_description,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(180),
            ),
          ),
          const SizedBox(height: 20),
          _ApiKeyStatusRow(
            hasApiKey: hasApiKey,
            isUpdating: _isUpdating,
            onAdd: () => _showApiKeyDialog(),
            onEdit: () => _showApiKeyDialog(
              currentKey: widget.aiUsage.userOpenAiApiKey,
            ),
            onRemove: _confirmRemoveApiKey,
          ),
        ],
      ),
    );
  }
}

class _ApiKeyInputDialog extends StatefulWidget {
  final String? initialKey;

  const _ApiKeyInputDialog({this.initialKey});

  @override
  State<_ApiKeyInputDialog> createState() => _ApiKeyInputDialogState();
}

class _ApiKeyInputDialogState extends State<_ApiKeyInputDialog> {
  late final TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.ai_usage_api_key_dialog_title),
      content: SizedBox(
        width: context.responsiveValue(
          compact: double.infinity,
          medium: 400,
          expanded: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.ai_usage_api_key_dialog_description,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurface.withAlpha(180),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              obscureText: _obscureText,
              autocorrect: false,
              enableSuggestions: false,
              style: const TextStyle(fontFamily: 'monospace'),
              decoration: InputDecoration(
                hintText: l10n.ai_usage_api_key_dialog_hint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.key),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  tooltip: _obscureText
                      ? l10n.ai_usage_api_key_show
                      : l10n.ai_usage_api_key_hide,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.ai_usage_api_key_cancel),
        ),
        FilledButton(
          onPressed: () {
            final value = _controller.text.trim();
            if (value.isNotEmpty) {
              Navigator.of(context).pop(value);
            }
          },
          child: Text(l10n.ai_usage_api_key_save),
        ),
      ],
    );
  }
}

class _ApiKeyStatusRow extends StatelessWidget {
  final bool hasApiKey;
  final bool isUpdating;
  final VoidCallback onAdd;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _ApiKeyStatusRow({
    required this.hasApiKey,
    required this.isUpdating,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasApiKey
            ? context.c.primaryContainer.withAlpha(80)
            : context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: hasApiKey
            ? Border.all(color: context.c.primary.withAlpha(50))
            : null,
      ),
      child: Row(
        children: [
          Icon(
            hasApiKey ? Icons.check_circle : Icons.info_outline,
            color:
                hasApiKey ? context.c.primary : context.c.onSurface.withAlpha(150),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasApiKey
                      ? l10n.ai_usage_api_key_configured
                      : l10n.ai_usage_api_key_not_configured,
                  style: context.t.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasApiKey ? context.c.primary : null,
                  ),
                ),
                if (hasApiKey)
                  Text(
                    'sk-****',
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.onSurface.withAlpha(150),
                      fontFamily: 'monospace',
                    ),
                  ),
              ],
            ),
          ),
          if (isUpdating)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (hasApiKey) ...[
            TextButton(
              onPressed: onEdit,
              child: Text(l10n.ai_usage_api_key_edit),
            ),
            TextButton(
              onPressed: onRemove,
              style: TextButton.styleFrom(
                foregroundColor: context.c.error,
              ),
              child: Text(l10n.ai_usage_api_key_remove),
            ),
          ] else
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.ai_usage_api_key_add),
            ),
        ],
      ),
    );
  }
}
