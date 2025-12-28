import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/mixins/create_scrappable_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';

/// A dialog that allows users to create a new scrappable by providing
/// a target URL and extraction instructions.
///
/// This dialog follows Material 3 design guidelines and includes:
/// - URL validation (valid URL format, 10-500 characters)
/// - Prompt validation (10-2200 characters)
/// - Loading state during creation
/// - Automatic transition to chat session on success
class CreateScrappableDialog extends ConsumerStatefulWidget {
  const CreateScrappableDialog({super.key});

  /// Shows the dialog and returns true if a scrappable was created successfully.
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateScrappableDialog(),
    );
  }

  @override
  ConsumerState<CreateScrappableDialog> createState() =>
      _CreateScrappableDialogState();
}

class _CreateScrappableDialogState extends ConsumerState<CreateScrappableDialog>
    with CreateScrappableMixin {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _promptController = TextEditingController();
  final _promptFocusNode = FocusNode();
  bool _isCreating = false;
  bool _isPromptExpanded = false;

  @override
  void initState() {
    super.initState();
    _promptFocusNode.addListener(_onPromptFocusChange);
  }

  void _onPromptFocusChange() {
    if (_promptFocusNode.hasFocus && !_isPromptExpanded) {
      setState(() => _isPromptExpanded = true);
    } else if (!_promptFocusNode.hasFocus &&
        _isPromptExpanded &&
        _promptController.text.trim().isEmpty) {
      setState(() => _isPromptExpanded = false);
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _promptController.dispose();
    _promptFocusNode.removeListener(_onPromptFocusChange);
    _promptFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isCreating) return;

    setState(() => _isCreating = true);

    final analytics = ref.read(analyticsServiceProvider);
    final targetUrl = _urlController.text.trim();
    final userPrompt = _promptController.text.trim();

    // Track analytics before closing
    await analytics.trackUserScrappablesCreateNewDialogSubmit(
      targetUrl: targetUrl,
      promptLength: userPrompt.length,
    );

    // Close dialog first, then start creation
    // The parent widget will handle showing the CreatingScrappableDialog
    if (mounted) {
      Navigator.of(context).pop(true);
    }

    // Start creation after dialog is closed (fire and forget)
    // ignore: unawaited_futures
    createScrappableWithTracking(targetUrl: targetUrl, userPrompt: userPrompt);
  }

  String? _validateUrl(String? value) {
    final l10n = AppLocalizations.of(context)!;
    // Normalize URL for validation
    final normalizedUrl = value?.startsWith('http') == true
        ? value
        : 'http://$value';

    return ValidationBuilder()
        .url(l10n.landing_hero_url_validation_invalid)
        .minLength(10, l10n.landing_hero_url_validation_min_length)
        .maxLength(500, l10n.landing_hero_url_validation_max_length)
        .build()(normalizedUrl);
  }

  String? _validatePrompt(String? value) {
    final l10n = AppLocalizations.of(context)!;
    return ValidationBuilder()
        .minLength(30, l10n.landing_hero_prompt_validation_min_length)
        .maxLength(2200, l10n.landing_hero_prompt_validation_max_length)
        .build()(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Responsive dialog sizing
    final dialogMaxWidth = context.responsiveValue(
      compact: MediaQuery.sizeOf(context).width * 0.9, // 90% on mobile
      medium: 520.0,
      expanded: 560.0,
    );
    final dialogMaxHeight = context.responsiveValue(
      compact: MediaQuery.sizeOf(context).height * 0.85, // 85% on mobile
      medium: 600.0,
      expanded: 620.0,
    );
    final dialogBorderRadius = context.responsiveValue(
      compact: 20.0,
      medium: 24.0,
      expanded: 28.0,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: dialogMaxWidth,
          maxHeight: dialogMaxHeight,
        ),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(dialogBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(context, l10n),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.responsiveValue(
                      compact: 20.0,
                      medium: 24.0,
                      expanded: 24.0,
                    ),
                    context.responsiveValue(
                      compact: 12.0,
                      medium: 16.0,
                      expanded: 16.0,
                    ),
                    context.responsiveValue(
                      compact: 20.0,
                      medium: 24.0,
                      expanded: 24.0,
                    ),
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      _buildDescription(context, l10n),
                      SizedBox(
                        height: context.responsiveValue(
                          compact: 20.0,
                          medium: 24.0,
                          expanded: 24.0,
                        ),
                      ),

                      // URL Field
                      _buildUrlField(context, l10n),
                      SizedBox(
                        height: context.responsiveValue(
                          compact: 16.0,
                          medium: 20.0,
                          expanded: 20.0,
                        ),
                      ),

                      // Prompt Field
                      _buildPromptField(context, l10n),
                    ],
                  ),
                ),
              ),

              // Actions
              _buildActions(context, l10n),
            ],
          ),
        ),
      ),
    ).animate().scale(
      begin: const Offset(0.9, 0.9),
      end: const Offset(1, 1),
      duration: 200.ms,
      curve: Curves.easeOutBack,
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final headerPadding = context.responsiveValue(
      compact: 20.0,
      medium: 24.0,
      expanded: 24.0,
    );

    return Container(
      padding: EdgeInsets.all(headerPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.c.primaryContainer,
            context.c.primaryContainer.withAlpha(200),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              context.responsiveValue(
                compact: 10.0,
                medium: 12.0,
                expanded: 12.0,
              ),
            ),
            decoration: BoxDecoration(
              color: context.c.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.c.primary.withAlpha(80),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: context.c.onPrimary,
              size: context.responsiveValue(
                compact: 20.0,
                medium: 24.0,
                expanded: 24.0,
              ),
            ),
          ),
          SizedBox(
            width: context.responsiveValue(
              compact: 12.0,
              medium: 16.0,
              expanded: 16.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.scrappables_create_dialog_title,
                  style: context.t.headlineSmall?.copyWith(
                    color: context.c.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.scrappables_create_dialog_subtitle,
                  style: context.t.bodySmall?.copyWith(
                    color: context.c.onPrimaryContainer.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close_rounded,
              color: context.c.onPrimaryContainer.withAlpha(180),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildDescription(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.secondaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.secondary.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.c.secondary.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: context.c.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.scrappables_create_dialog_description,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSecondaryContainer,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildUrlField(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link_rounded, size: 18, color: context.c.primary),
            const SizedBox(width: 8),

            Text(
              l10n.landing_hero_target_url_label,
              style: context.t.labelLarge?.copyWith(
                color: context.c.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _urlController,
          enabled: !_isCreating,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          validator: _validateUrl,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: l10n.landing_hero_target_url_hint,
            hintStyle: TextStyle(color: context.c.outline.withAlpha(150)),
            prefixIcon: Icon(
              Icons.language_rounded,
              color: context.c.onSurfaceVariant,
            ),
            filled: true,
            fillColor: context.c.surfaceContainerHighest.withAlpha(80),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.c.outline.withAlpha(40)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.c.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.c.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: context.c.error, width: 2),
            ),
          ),
          onFieldSubmitted: (_) => _promptFocusNode.requestFocus(),
        ),
      ],
    ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildPromptField(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              size: 18,
              color: context.c.primary,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.landing_hero_prompt_label,
              style: context.t.labelLarge?.copyWith(
                color: context.c.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _isPromptExpanded ? 160 : 56,
          child: TextFormField(
            controller: _promptController,
            focusNode: _promptFocusNode,
            enabled: !_isCreating,
            maxLines: null,
            minLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            validator: _validatePrompt,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: l10n.landing_hero_prompt_hint,
              hintStyle: TextStyle(color: context.c.outline.withAlpha(150)),
              alignLabelWithHint: true,
              filled: true,
              fillColor: context.c.surfaceContainerHighest.withAlpha(80),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.c.outline.withAlpha(40)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.c.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.c.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: context.c.error, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    final actionPadding = context.responsiveValue(
      compact: 20.0,
      medium: 24.0,
      expanded: 24.0,
    );

    return Container(
      padding: EdgeInsets.all(actionPadding),
      child: Row(
        children: [
          // Character hint
          Expanded(
            child: Text(
              l10n.scrappables_create_dialog_hint,
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurfaceVariant.withAlpha(150),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Cancel button
          TextButton(
            onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
            child: Text(l10n.scrappables_create_dialog_cancel),
          ),
          const SizedBox(width: 12),
          // Create button
          FilledButton.icon(
            onPressed: _isCreating ? null : _handleCreate,
            icon: _isCreating
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.c.onPrimary,
                      ),
                    ),
                  )
                : const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(
              _isCreating
                  ? l10n.scrappables_create_dialog_creating
                  : l10n.scrappables_create_dialog_create,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0);
  }
}
