import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
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
    final statusInfo = _getStatusInfo();
    final hasDetails = widget.analytics.details != null;

    return Container(
      // height: _isExpanded ? 500 : 72, // Fixed height when no details to show
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded
              ? statusInfo.color.withAlpha(100)
              : context.c.outline.withAlpha(50),
          // width: _isExpanded ? 2 : 2,
        ),
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
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo() {
    switch (widget.analytics.requestStatus) {
      case RequestStatus.success:
        return _StatusInfo(
          color: Colors.green,
          icon: Icons.check_circle,
          text: 'Success',
        );
      case RequestStatus.clientError:
        return _StatusInfo(
          color: Colors.orange,
          icon: Icons.warning,
          text: 'Client Error',
        );
      case RequestStatus.serverError:
        return _StatusInfo(
          color: Colors.red,
          icon: Icons.error,
          text: 'Server Error',
        );
      case RequestStatus.insufficientCredits:
        return _StatusInfo(
          color: Colors.purple,
          icon: Icons.credit_card_off,
          text: 'Insufficient Credits',
        );
      case RequestStatus.maxConcurrencyExceeded:
        return _StatusInfo(
          color: Colors.cyan,
          icon: Icons.traffic,
          text: 'Max Concurrency',
        );
      case RequestStatus.failedAtScrappingBee:
        return _StatusInfo(
          color: const Color(0xFFE91E63),
          icon: Icons.bug_report,
          text: 'Extract Rules Error',
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
  final VoidCallback? onToggleExpand;

  const _MainRow({
    required this.statusInfo,
    required this.dateFormat,
    required this.requestedAt,
    required this.isExpanded,
    required this.hasDetails,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusInfo.color.withAlpha(30),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: statusInfo.color.withAlpha(80),
              ),
            ),
            child: Text(
              statusInfo.text,
              style: context.t.bodyMedium?.copyWith(
                color: statusInfo.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Spacer(),

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
            IconButton(
              onPressed: onToggleExpand,
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: statusInfo.color,
              ),
              tooltip: isExpanded ? 'Show less' : 'Show details',
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

  const _DetailsSection({
    required this.details,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title if present
          if (details.title != null) ...[
            _DetailField(
              label: 'Title',
              value: details.title!,
              statusColor: statusColor,
            ),
            const SizedBox(height: 16),
          ],

          // Description if present
          if (details.description != null) ...[
            _DetailField(
              label: 'Description',
              value: details.description!,
              statusColor: statusColor,
            ),
            const SizedBox(height: 16),
          ],

          // Error object if present
          if (details.errorObjectAsString != null) ...[
            _DetailField(
              label: 'Error Object',
              value: details.errorObjectAsString!,
              statusColor: statusColor,
              isError: true,
            ),
            const SizedBox(height: 16),
          ],

          // Stack trace if present
          if (details.errorStackTraceAsString != null) ...[
            _DetailField(
              label: 'Stack Trace',
              value: details.errorStackTraceAsString!,
              statusColor: statusColor,
              isError: true,
              isMonospace: true,
            ),
            const SizedBox(height: 16),
          ],

          // Payload (always present)
          _JsonField(
            label: 'Request Payload',
            icon: Icons.upload_outlined,
            json: details.stringifiedPayload,
            statusColor: statusColor,
          ),

          // Response (only for successful requests)
          if (details.stringifiedResponse != null) ...[
            const SizedBox(height: 16),
            _JsonField(
              label: 'Response Data',
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
    final formattedJson = _formatJson();
    final lineCount = formattedJson.split('\n').length;
    final shouldCollapse = lineCount > 10;
    final displayColor =
        widget.isSuccess ? Colors.green : widget.statusColor;

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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SUCCESS',
                  style: context.t.labelSmall?.copyWith(
                    color: Colors.green,
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
                tooltip: _isExpanded ? 'Collapse' : 'Expand',
              ),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: formattedJson));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.label} copied to clipboard'),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: displayColor,
                  ),
                );
              },
              tooltip: 'Copy ${widget.label.toLowerCase()}',
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
                ? Colors.green.withAlpha(15)
                : context.c.surfaceContainerHighest.withAlpha(77),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSuccess
                  ? Colors.green.withAlpha(51)
                  : context.c.outline.withAlpha(51),
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
                                  ? Colors.green.withAlpha(15)
                                  : context.c.surfaceContainerHighest
                                      .withAlpha(77))
                              .withAlpha(0),
                          widget.isSuccess
                              ? Colors.green.withAlpha(15)
                              : context.c.surfaceContainerHighest.withAlpha(77),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Click expand to see ${lineCount - 10}+ more lines',
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
