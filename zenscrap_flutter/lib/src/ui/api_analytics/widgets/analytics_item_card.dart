import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class AnalyticsItemCard extends StatelessWidget {
  final ScrappableAnalytics analytics;
  final DateFormat dateFormat;

  const AnalyticsItemCard({
    super.key,
    required this.analytics,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          statusInfo.icon,
          color: statusInfo.color,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusInfo.color.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                statusInfo.text,
                style: context.t.bodySmall?.copyWith(
                  color: statusInfo.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              dateFormat.format(analytics.requestedAt),
              style: context.t.bodyMedium,
            ),
          ],
        ),
        trailing: Text(
          analytics.attachedApiKey,
          style: context.t.bodySmall?.copyWith(
            color: context.c.onSurface.withAlpha(150),
          ),
        ),
      ),
    );
  }

  _StatusInfo _getStatusInfo() {
    switch (analytics.requestStatus) {
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
    }
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
