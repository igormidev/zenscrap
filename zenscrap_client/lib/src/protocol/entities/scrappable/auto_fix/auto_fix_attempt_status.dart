/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

enum AutoFixAttemptStatus implements _i1.SerializableModel {
  in_progress,
  validation_failed,
  ai_error,
  api_error,
  success;

  static AutoFixAttemptStatus fromJson(int index) {
    switch (index) {
      case 0:
        return AutoFixAttemptStatus.in_progress;
      case 1:
        return AutoFixAttemptStatus.validation_failed;
      case 2:
        return AutoFixAttemptStatus.ai_error;
      case 3:
        return AutoFixAttemptStatus.api_error;
      case 4:
        return AutoFixAttemptStatus.success;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "AutoFixAttemptStatus"');
    }
  }

  @override
  int toJson() => index;

  @override
  String toString() => name;
}
