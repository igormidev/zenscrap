import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/path_parameters_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/query_parameters_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/url_syntax_textfield.dart';

class EditScrappableRequestDialog extends ConsumerStatefulWidget {
  final ScrappableRequest scrappableRequest;
  final int scrappableId;

  /// When true, action buttons like Save Changes and Add Parameter will be disabled.
  final bool isChatLoading;

  /// When true, the session has expired and action buttons will be disabled.
  final bool isExpired;

  const EditScrappableRequestDialog({
    super.key,
    required this.scrappableRequest,
    required this.scrappableId,
    this.isChatLoading = false,
    this.isExpired = false,
  });

  @override
  ConsumerState<EditScrappableRequestDialog> createState() =>
      _EditScrappableRequestDialogState();
}

class _EditScrappableRequestDialogState
    extends ConsumerState<EditScrappableRequestDialog> {
  late final HighlightTextEditingController _urlController;
  late List<String> _pathParams;
  late Map<String, String?> _queryParams;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _urlController =
        HighlightTextEditingController(text: widget.scrappableRequest.url);
    _pathParams = List.from(widget.scrappableRequest.pathParams);
    _queryParams = Map.from(widget.scrappableRequest.queryParams);

    // Initialize the controller with path parameters
    _urlController.updatePathParameters(_pathParams);
    _urlController.addListener(_onUrlChanged);
  }

  @override
  void dispose() {
    _urlController.removeListener(_onUrlChanged);
    _urlController.dispose();
    super.dispose();
  }

  void _onUrlChanged() {
    _markAsChanged();
  }

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _handleAddPathParam() async {
    final l10n = AppLocalizations.of(context)!;
    final paramName = await showAddPathParameterDialog(context);
    if (paramName != null && paramName.isNotEmpty) {
      if (_pathParams.contains(paramName)) {
        if (mounted) {
          await showErrorDialog(
            context,
            title: l10n.scrap_session_duplicate_param,
            description: l10n.scrap_session_duplicate_path_param,
          );
        }
        return;
      }

      setState(() {
        _pathParams.add(paramName);
        _urlController.updatePathParameters(_pathParams);
        _markAsChanged();
      });

      // Update URL to show the new parameter
      final currentUrl = _urlController.text;
      if (!currentUrl.contains('{$paramName}')) {
        _urlController.text = '$currentUrl/{$paramName}';
      }
    }
  }

  void _handleRemovePathParam(String param) {
    setState(() {
      _pathParams.remove(param);
      _urlController.updatePathParameters(_pathParams);
      _markAsChanged();
    });
  }

  Future<void> _handleAddQueryParam() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showQueryParameterDialog(context);
    if (result != null) {
      if (_queryParams.containsKey(result.key)) {
        if (mounted) {
          await showErrorDialog(
            context,
            title: l10n.scrap_session_duplicate_param,
            description: l10n.scrap_session_duplicate_query_param,
          );
        }
        return;
      }

      setState(() {
        _queryParams[result.key] = result.value;
        _markAsChanged();
      });
    }
  }

  void _handleRemoveQueryParam(String key) {
    setState(() {
      _queryParams.remove(key);
      _markAsChanged();
    });
  }

  Future<void> _handleEditQueryParam(String oldKey) async {
    final currentValue = _queryParams[oldKey];
    final result = await showQueryParameterDialog(
      context,
      initialKey: oldKey,
      initialValue: currentValue,
      isEdit: true,
    );

    if (result != null) {
      setState(() {
        if (result.key != oldKey) {
          // Key changed, remove old and add new
          _queryParams.remove(oldKey);
        }
        _queryParams[result.key] = result.value;
        _markAsChanged();
      });
    }
  }

  Future<void> _handleSave() async {
    // Validate that all path parameters in URL are defined
    final url = _urlController.text;
    final urlPathParams = _extractPathParamsFromUrl(url);

    final l10n = AppLocalizations.of(context)!;
    // Check if all path params in URL are in the pathParams list
    final missingParams =
        urlPathParams.where((param) => !_pathParams.contains(param)).toList();
    if (missingParams.isNotEmpty) {
      await showErrorDialog(
        context,
        title: l10n.scrap_session_missing_path_params,
        description:
            'The following path parameters are used in the URL but not defined: ${missingParams.join(", ")}\n\nPlease add them to the path parameters section or remove them from the URL.',
      );
      return;
    }

    // Check if all defined path params are used in URL
    final unusedParams =
        _pathParams.where((param) => !urlPathParams.contains(param)).toList();
    if (unusedParams.isNotEmpty) {
      await showErrorDialog(
        context,
        title: l10n.scrap_session_unused_path_params,
        description:
            'The following path parameters are defined but not used in the URL: ${unusedParams.join(", ")}\n\nPlease use them in the URL as {paramName} or remove them from the path parameters section.',
      );
      return;
    }

    // Call API to update the scrappable request
    final client = ref.read(clientProvider);
    final language = ref.read(currentLanguageProvider);
    final result = await client.scrappableChatSession
        .updateScrappableRequest(
          scrappableId: widget.scrappableId,
          url: url,
          pathParams: _pathParams,
          queryParams: _queryParams,
          language: language,
        )
        .toResult;

    result.fold(
      (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.scrap_session_request_updated),
            ),
          );
          Navigator.of(context).pop();
        }
      },
      (error) {
        if (mounted) {
          handleBabelException(context, error);
        }
      },
    );
  }

  List<String> _extractPathParamsFromUrl(String url) {
    final regex = RegExp(r'\{([^}]+)\}');
    final matches = regex.allMatches(url);
    return matches.map((match) => match.group(1)!).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 700,
            expanded: 900,
          ),
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Container(
          padding: EdgeInsets.all(
            context.responsiveValue(
              compact: 16.0,
              medium: 20.0,
              expanded: 24.0,
            ),
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.c.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.edit_document,
                    size: 34,
                    color: context.c.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.scrap_session_edit_request_title,
                        style: context.t.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.scrap_session_edit_request_subtitle,
                        style: context.t.bodyMedium?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.scrap_session_close,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Info card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.c.primaryContainer.withAlpha(51),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.c.primary.withAlpha(77),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: context.c.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.scrap_session_path_params_hint('postId', 'userId'),
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // URL Section - Responsive Layout
                    ResponsiveBuilder(
                      compact: (context, constraints) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _urlController,
                            decoration: InputDecoration(
                              hintText: 'https://example.com/users/{userId}',
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              helperText: l10n.scrap_session_use_param_name('{paramName}'),
                              helperMaxLines: 2,
                            ),
                            style: context.t.bodyMedium?.copyWith(
                              fontFamily: 'monospace',
                            ),
                            maxLines: 3,
                            minLines: 1,
                            onChanged: (_) => _markAsChanged(),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 48,
                            child: Tooltip(
                              message: widget.isExpired
                                  ? l10n.scrap_session_session_expired_tooltip
                                  : (widget.isChatLoading
                                      ? l10n.scrap_session_chat_loading_disabled_tooltip
                                      : ''),
                              child: FilledButton.icon(
                                onPressed: (_hasChanges && !widget.isChatLoading && !widget.isExpired)
                                    ? _handleSave
                                    : null,
                                icon: const Icon(Icons.save),
                                label: Text(l10n.scrap_session_save_changes),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      expanded: (context, constraints) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _urlController,
                              decoration: InputDecoration(
                                hintText: 'https://example.com/users/{userId}',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                helperText: l10n.scrap_session_use_param_name('{paramName}'),
                                helperMaxLines: 2,
                              ),
                              style: context.t.bodyMedium?.copyWith(
                                fontFamily: 'monospace',
                              ),
                              maxLines: 3,
                              minLines: 1,
                              onChanged: (_) => _markAsChanged(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 48,
                            child: Tooltip(
                              message: widget.isExpired
                                  ? l10n.scrap_session_session_expired_tooltip
                                  : (widget.isChatLoading
                                      ? l10n.scrap_session_chat_loading_disabled_tooltip
                                      : ''),
                              child: FilledButton.icon(
                                onPressed: (_hasChanges && !widget.isChatLoading && !widget.isExpired)
                                    ? _handleSave
                                    : null,
                                icon: const Icon(Icons.save),
                                label: Text(l10n.scrap_session_save_changes),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Path Parameters Section
                    PathParametersSection(
                      pathParams: _pathParams,
                      onAddPathParam: _handleAddPathParam,
                      onRemovePathParam: _handleRemovePathParam,
                      isChatLoading: widget.isChatLoading,
                      isExpired: widget.isExpired,
                    ),
                    const SizedBox(height: 8),

                    // Query Parameters Section
                    QueryParametersSection(
                      queryParams: _queryParams,
                      onAddQueryParam: _handleAddQueryParam,
                      onRemoveQueryParam: _handleRemoveQueryParam,
                      onEditQueryParam: _handleEditQueryParam,
                      isChatLoading: widget.isChatLoading,
                      isExpired: widget.isExpired,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
