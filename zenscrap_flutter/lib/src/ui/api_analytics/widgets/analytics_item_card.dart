import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/duration_extension.dart';
import 'package:zenscrap_flutter/src/core/extensions/request_status_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class AnalyticsItemCard extends StatefulWidget {
  final ScrappableAnalytics analytics;
  final DateFormat dateFormat;

  const AnalyticsItemCard({
    super.key,
    required this.analytics,
    required this.dateFormat,
  });

  @override
  State<AnalyticsItemCard> createState() => _AnalyticsItemCardState();
}

class _AnalyticsItemCardState extends State<AnalyticsItemCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(context);
    final hasDetails = widget.analytics.details != null;

    return Container(
      // height: _isExpanded ? 500 : 72; // Fixed height when no details to show
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded
              ? statusInfo.color.withAlpha(80)
              : context.c.outline.withAlpha(30),
          width: _isExpanded ? 1.5 : 1,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: statusInfo.color.withAlpha(15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main row with status info
          _MainRow(
            statusInfo: statusInfo,
            dateFormat: widget.dateFormat,
            requestedAt: widget.analytics.requestedAt,
            isExpanded: _isExpanded,
            hasDetails: hasDetails,
            duration: widget.analytics.duration,
            onToggleExpand: hasDetails
                ? () => setState(() => _isExpanded = !_isExpanded)
                : null,
          ),

          // Expanded details section
          if (hasDetails) ...[
            // Divider(color: context.c.outline.withAlpha(51)),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: SizedBox(
                height: _isExpanded ? 400 : 0,
                child: _DetailsSection(
                  details: widget.analytics.details!,
                  statusColor: statusInfo.color,
                  apiKey: widget.analytics.apiKey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = widget.analytics.requestStatus;
    switch (status) {
      case RequestStatus.success:
        return _StatusInfo(
          color: status.color,
          icon: status.icon,
          text: l10n.api_analytics_status_success,
        );
      case RequestStatus.clientError:
        return _StatusInfo(
          color: status.color,
          icon: status.icon,
          text: l10n.api_analytics_status_client_error,
        );
      case RequestStatus.serverError:
        return _StatusInfo(
          color: status.color,
          icon: status.icon,
          text: l10n.api_analytics_status_server_error,
        );
      case RequestStatus.insufficientCredits:
        return _StatusInfo(
          color: status.color,
          icon: status.icon,
          text: l10n.api_analytics_status_insufficient_credits,
        );
      case RequestStatus.maxConcurrencyExceeded:
        return _StatusInfo(
          color: status.color,
          icon: status.icon,
          text: l10n.api_analytics_status_max_concurrency,
        );
      case RequestStatus.failedAtScrappingBee:
        return _StatusInfo(
          color: status.color,
          icon: status.icon,
          text: l10n.api_analytics_status_extract_rules_error,
        );
    }
  }
}

class _MainRow extends StatelessWidget {
  final _StatusInfo statusInfo;
  final DateFormat dateFormat;
  final DateTime requestedAt;
  final bool isExpanded;
  final bool hasDetails;
  final Duration? duration;
  final VoidCallback? onToggleExpand;

  const _MainRow({
    required this.statusInfo,
    required this.dateFormat,
    required this.requestedAt,
    required this.isExpanded,
    required this.hasDetails,
    this.duration,
    this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Status icon
          Icon(
            statusInfo.icon,
            color: statusInfo.color,
            size: 24,
          ),
          const SizedBox(width: 16),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusInfo.color.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: statusInfo.color.withAlpha(50),
              ),
            ),
            child: Text(
              statusInfo.text,
              style: context.t.bodyMedium?.copyWith(
                color: statusInfo.color.withAlpha(220),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Spacer(),

          // Duration badge (if available)
          if (duration != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: context.c.secondaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 14,
                    color: context.c.onSecondaryContainer.withAlpha(180),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    duration!.formatted,
                    style: context.t.labelSmall?.copyWith(
                      color: context.c.onSecondaryContainer.withAlpha(200),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Date/time
          Text(
            dateFormat.format(requestedAt),
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),

          // Expand/collapse button
          if (hasDetails) ...[
            const SizedBox(width: 8),
            Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return IconButton(
                  onPressed: onToggleExpand,
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: statusInfo.color,
                  ),
                  tooltip: isExpanded ? l10n.api_analytics_show_less : l10n.api_analytics_show_details,
                );
              }
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final AnalyticsRequestDetails details;
  final Color statusColor;
  final AccountApiKey? apiKey;

  const _DetailsSection({
    required this.details,
    required this.statusColor,
    this.apiKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // API Key section
          _ApiKeySection(apiKey: apiKey),
          const SizedBox(height: 16),

          // Title if present
          if (details.title != null) ...[
            _DetailField(
              label: l10n.api_analytics_detail_title,
              value: details.title!,
              statusColor: statusColor,
            ),
            const SizedBox(height: 16),
          ],

          // Description if present
          if (details.description != null) ...[
            _DetailField(
              label: l10n.api_analytics_detail_description,
              value: details.description!,
              statusColor: statusColor,
            ),
            const SizedBox(height: 16),
          ],

          // Error object if present
          if (details.errorObjectAsString != null) ...[
            _DetailField(
              label: l10n.api_analytics_detail_error_object,
              value: details.errorObjectAsString!,
              statusColor: statusColor,
              isError: true,
            ),
            const SizedBox(height: 16),
          ],

          // Stack trace if present
          if (details.errorStackTraceAsString != null) ...[
            _DetailField(
              label: l10n.api_analytics_detail_stack_trace,
              value: details.errorStackTraceAsString!,
              statusColor: statusColor,
              isError: true,
              isMonospace: true,
            ),
            const SizedBox(height: 16),
          ],

          // Payload (always present)
          _JsonField(
            label: l10n.api_analytics_detail_request_payload,
            icon: Icons.upload_outlined,
            json: details.stringifiedPayload,
            statusColor: statusColor,
          ),

          // Response (only for successful requests)
          if (details.stringifiedResponse != null) ...[
            const SizedBox(height: 16),
            _JsonField(
              label: l10n.api_analytics_detail_response_data,
              icon: Icons.download_outlined,
              json: details.stringifiedResponse!,
              statusColor: statusColor,
              isSuccess: true,
            ),
          ],

          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  final Color statusColor;
  final bool isError;
  final bool isMonospace;

  const _DetailField({
    required this.label,
    required this.value,
    required this.statusColor,
    this.isError = false,
    this.isMonospace = false,
  });

  String _formatValue() {
    // Try to decode as JSON
    final decoded = tryDecode(value);
    if (decoded != null) {
      // Successfully decoded as JSON, format with indentation
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(decoded);
    }
    // Not valid JSON, return as is
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final formattedValue = _formatValue();
    final isJson = tryDecode(value) != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              size: 16,
              color: statusColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.t.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isError
                ? context.c.errorContainer.withAlpha(26)
                : context.c.surfaceContainerHighest.withAlpha(77),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isError
                  ? context.c.error.withAlpha(51)
                  : context.c.outline.withAlpha(51),
            ),
          ),
          child: SelectableText(
            formattedValue,
            style: context.t.bodySmall?.copyWith(
              fontFamily: (isMonospace || isJson) ? 'monospace' : null,
              color: isError ? context.c.error : context.c.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _JsonField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String json;
  final Color statusColor;
  final bool isSuccess;

  const _JsonField({
    required this.label,
    required this.icon,
    required this.json,
    required this.statusColor,
    this.isSuccess = false,
  });

  @override
  State<_JsonField> createState() => _JsonFieldState();
}

class _JsonFieldState extends State<_JsonField> {
  bool _isExpanded = false;

  String _formatJson() {
    final decoded = tryDecode(widget.json);
    if (decoded != null) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(decoded);
    }
    return widget.json;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formattedJson = _formatJson();
    final lineCount = formattedJson.split('\n').length;
    final shouldCollapse = lineCount > 10;
    final displayColor =
        widget.isSuccess ? RequestStatus.success.color : widget.statusColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: displayColor,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: context.t.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: displayColor,
              ),
            ),
            if (widget.isSuccess) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: RequestStatus.success.color.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l10n.api_analytics_success_badge,
                  style: context.t.labelSmall?.copyWith(
                    color: RequestStatus.success.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (shouldCollapse)
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.unfold_less : Icons.unfold_more,
                  size: 18,
                ),
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                tooltip: _isExpanded ? l10n.api_analytics_collapse : l10n.api_analytics_expand,
              ),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: formattedJson));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.api_analytics_copied_to_clipboard(widget.label)),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: displayColor,
                  ),
                );
              },
              tooltip: l10n.api_analytics_copy_label(widget.label.toLowerCase()),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight:
                shouldCollapse && !_isExpanded ? 200 : double.infinity,
          ),
          decoration: BoxDecoration(
            color: widget.isSuccess
                ? RequestStatus.success.color.withAlpha(12)
                : context.c.surfaceContainerHighest.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSuccess
                  ? RequestStatus.success.color.withAlpha(40)
                  : context.c.outline.withAlpha(30),
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  formattedJson,
                  style: context.t.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: context.c.onSurface,
                  ),
                ),
              ),
              if (shouldCollapse && !_isExpanded)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          (widget.isSuccess
                                  ? RequestStatus.success.color.withAlpha(12)
                                  : context.c.surfaceContainerHighest
                                      .withAlpha(50))
                              .withAlpha(0),
                          widget.isSuccess
                              ? RequestStatus.success.color.withAlpha(12)
                              : context.c.surfaceContainerHighest.withAlpha(50),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        l10n.api_analytics_expand_more_lines(lineCount - 10),
                        style: context.t.labelSmall?.copyWith(
                          color: context.c.onSurface.withAlpha(150),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String text;

  _StatusInfo({
    required this.color,
    required this.icon,
    required this.text,
  });
}

/// Censors an API key showing only first 4 and last 4 characters
String _censorApiKey(String key) {
  if (key.length <= 8) return '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022';
  return '${key.substring(0, 4)}...${key.substring(key.length - 4)}';
}

class _ApiKeySection extends StatelessWidget {
  final AccountApiKey? apiKey;

  const _ApiKeySection({this.apiKey});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // If API key is null (deleted), show a placeholder
    if (apiKey == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.c.surfaceContainerHighest.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.c.outline.withAlpha(30),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.vpn_key_outlined,
              size: 18,
              color: context.c.onSurface.withAlpha(100),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.api_analytics_api_key_deleted,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurface.withAlpha(100),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    final censoredKey = _censorApiKey(apiKey!.apiKey);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.c.primaryContainer.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.primary.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // API Key name row
          Row(
            children: [
              Icon(
                Icons.vpn_key,
                size: 18,
                color: context.c.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.api_analytics_api_key_label,
                style: context.t.labelMedium?.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  apiKey!.name,
                  style: context.t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Censored key value with copy button
          Row(
            children: [
              const SizedBox(width: 26), // Align with name above
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: context.c.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.c.outline.withAlpha(30),
                  ),
                ),
                child: Text(
                  censoredKey,
                  style: context.t.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: context.c.onSurface.withAlpha(180),
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 32,
                child: TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: apiKey!.apiKey));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.api_analytics_api_key_copied),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: context.c.primary,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: context.c.primary,
                  ),
                  label: Text(
                    l10n.api_analytics_copy_button,
                    style: context.t.labelSmall?.copyWith(
                      color: context.c.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
