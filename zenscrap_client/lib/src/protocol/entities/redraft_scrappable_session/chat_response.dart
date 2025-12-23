/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../../protocol.dart' as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'prompt_role_enum.dart' as _i3;
import '../scrappable/scrapping_bee_extract_logic.dart' as _i4;
import '../scrappable/reference_test_data.dart' as _i5;
import 'package:zenscrap_client/src/protocol/protocol.dart' as _i6;
import '../scrappable/scrappable_request.dart' as _i7;
import '../ip_validation/ip_block_reason.dart' as _i8;
part 'responses/api_key_updated_response.dart';
part 'responses/candidate_extract_logic_update.dart';
part 'responses/credit_limit_reached_response.dart';
part 'responses/error_text_response.dart';
part 'responses/ip_limit_reached_response.dart';
part 'responses/message_text_response.dart';
part 'responses/new_extract_rule_response.dart';
part 'responses/suspicious_ip_response.dart';
part 'responses/test_endpoint_called_error_response.dart';
part 'responses/test_endpoint_called_success_response.dart';
part 'responses/updated_scrappable_request_response.dart';
part 'responses/user_api_key_quota_exceeded_response.dart';

sealed class ChatResponse implements _i2.SerializableModel {
  ChatResponse({
    required this.role,
    required this.expectsFollowUp,
  });

  _i3.PromptRole role;

  bool expectsFollowUp;

  /// Returns a shallow copy of this [ChatResponse]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  ChatResponse copyWith({
    _i3.PromptRole? role,
    bool? expectsFollowUp,
  });
}

class _Undefined {}
