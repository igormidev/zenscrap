import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class CreateApiKeyDialog extends StatefulWidget {
  /// Callback that creates the API key and returns it (or null on failure)
  final Future<AccountApiKey?> Function(String) onCreateApiKey;

  const CreateApiKeyDialog({
    super.key,
    required this.onCreateApiKey,
  });

  @override
  State<CreateApiKeyDialog> createState() => _CreateApiKeyDialogState();
}

class _CreateApiKeyDialogState extends State<CreateApiKeyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isCreating = true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      final newKey = await widget.onCreateApiKey(_nameController.text.trim());
      // Close dialog and return the created key (or null)
      if (mounted) {
        Navigator.of(context).pop(newKey);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
      }
      // Error handling is done in the parent widget
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.c.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.vpn_key,
                      color: context.c.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.api_usage_create_new_api_key,
                      style: context.t.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: context.c.onSurface.withAlpha(150),
                    ),
                    onPressed:
                        _isCreating ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                l10n.api_usage_api_key_name_description,
                style: context.t.bodyMedium?.copyWith(
                  color: context.c.onSurface.withAlpha(150),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                enabled: !_isCreating,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.api_usage_api_key_name,
                  hintText: l10n.api_usage_api_key_name_hint,
                  prefixIcon: Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: context.c.surfaceContainerHighest.withAlpha(50),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.api_usage_name_required;
                  }
                  if (value.trim().length < 3) {
                    return l10n.api_usage_name_min_length;
                  }
                  if (value.trim().length > 50) {
                    return l10n.api_usage_name_max_length;
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _handleCreate(),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.c.tertiaryContainer.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.c.tertiary.withAlpha(50),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: context.c.tertiary,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.api_usage_api_key_security_warning,
                        style: context.t.bodySmall?.copyWith(
                          color: context.c.onSurface.withAlpha(150),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isCreating ? null : () => Navigator.of(context).pop(),
                    child: Text(l10n.api_usage_cancel),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isCreating ? null : _handleCreate,
                    icon: _isCreating
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  context.c.onPrimary),
                            ),
                          )
                        : Icon(Icons.add),
                    label: Text(_isCreating ? l10n.api_usage_creating : l10n.api_usage_create_api_key),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
