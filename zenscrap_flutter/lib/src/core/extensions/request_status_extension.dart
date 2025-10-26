import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

extension RequestStatusColors on RequestStatus {
  Color get color {
    switch (this) {
      case RequestStatus.success:
        return const Color(0xFF4CAF50); // Green
      case RequestStatus.clientError:
        return const Color(0xFFFF9800); // Orange
      case RequestStatus.serverError:
        return const Color(0xFFF44336); // Red
      case RequestStatus.insufficientCredits:
        return const Color(0xFF9C27B0); // Purple
      case RequestStatus.maxConcurrencyExceeded:
        return const Color(0xFF00BCD4); // Cyan
    }
  }

  IconData get icon {
    switch (this) {
      case RequestStatus.success:
        return Icons.check_circle;
      case RequestStatus.clientError:
        return Icons.warning;
      case RequestStatus.serverError:
        return Icons.error;
      case RequestStatus.insufficientCredits:
        return Icons.money_off;
      case RequestStatus.maxConcurrencyExceeded:
        return Icons.speed;
    }
  }

  String get label {
    switch (this) {
      case RequestStatus.success:
        return 'Success';
      case RequestStatus.clientError:
        return '4xx';
      case RequestStatus.serverError:
        return '5xx';
      case RequestStatus.insufficientCredits:
        return 'No Credits';
      case RequestStatus.maxConcurrencyExceeded:
        return 'Max Concurrency';
    }
  }
}
