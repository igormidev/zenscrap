import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

extension RequestStatusColors on RequestStatus {
  /// Returns a soft, pastel color for the status.
  /// These colors are more muted and easier on the eyes while maintaining
  /// good readability and accessibility.
  Color get color {
    switch (this) {
      case RequestStatus.success:
        return const Color(0xFF66A675); // Soft sage green
      case RequestStatus.clientError:
        return const Color(0xFFD4915E); // Soft amber/peach
      case RequestStatus.serverError:
        return const Color(0xFFCB7171); // Soft coral/rose
      case RequestStatus.insufficientCredits:
        return const Color(0xFF9B7BB8); // Soft lavender
      case RequestStatus.maxConcurrencyExceeded:
        return const Color(0xFF5BA3A8); // Soft teal
      case RequestStatus.failedAtScrappingBee:
        return const Color(0xFFBF7A91); // Soft dusty rose
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
      case RequestStatus.failedAtScrappingBee:
        return Icons.bug_report;
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
      case RequestStatus.failedAtScrappingBee:
        return 'Extract Rules Error';
    }
  }
}
