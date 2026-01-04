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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'email_already_registered_exception.dart' as _i5;
import 'entities/account/account.dart' as _i6;
import 'entities/account/account_api_key.dart' as _i7;
import 'entities/account/ai_usage/account_ai_usage.dart' as _i8;
import 'entities/account/ai_usage/ai_credit_history/ai_credit_transaction_type.dart'
    as _i9;
import 'entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart'
    as _i10;
import 'entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart'
    as _i11;
import 'entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart'
    as _i12;
import 'entities/account/api_usage/account_api_usage.dart' as _i13;
import 'entities/account/api_usage/api_credit_history/api_credit_history_item.dart'
    as _i14;
import 'entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart'
    as _i15;
import 'entities/account/api_usage/api_credit_history/api_credit_transaction_type.dart'
    as _i16;
import 'entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart'
    as _i17;
import 'entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart'
    as _i18;
import 'entities/account/api_usage/credit_usage.dart' as _i19;
import 'entities/account/credit_purchase_option.dart' as _i20;
import 'entities/account/plan_tier.dart' as _i21;
import 'entities/analytics/analytics_request_details.dart' as _i22;
import 'entities/analytics/analytics_time_scope.dart' as _i23;
import 'entities/analytics/paginated_scrappable_analytics.dart' as _i24;
import 'entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i25;
import 'entities/analytics/scrappable_request_per_time_scope.dart' as _i26;
import 'entities/analytics/scrappable_requests_analytics_item.dart' as _i27;
import 'entities/analytics/scrappable_usage_metrics.dart' as _i28;
import 'entities/api_key_response.dart' as _i29;
import 'entities/auth/user_profile_response.dart' as _i30;
import 'entities/create_scrappable_stream/create_scrappable_stream_item.dart'
    as _i31;
import 'entities/create_scrappable_stream/grounding_metadata_info.dart' as _i32;
import 'entities/create_scrappable_stream/grounding_source_info.dart' as _i33;
import 'entities/future_calls/session_prompt.dart' as _i34;
import 'entities/ip_spending/anonymous_ip_spending.dart' as _i35;
import 'entities/ip_validation/ip_block_reason.dart' as _i36;
import 'entities/ip_validation/ip_validation_cache.dart' as _i37;
import 'entities/marketplace/marketplace_paginated_item.dart' as _i38;
import 'entities/marketplace/paginated_scrappable_response.dart' as _i39;
import 'entities/marketplace/pagination_metadata.dart' as _i40;
import 'entities/monthly_credits_data.dart' as _i41;
import 'entities/redraft_scrappable_session/chat_response.dart' as _i42;
import 'entities/redraft_scrappable_session/create_session_response.dart'
    as _i43;
import 'entities/redraft_scrappable_session/pending_session_commit.dart'
    as _i44;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i45;
import 'entities/scrappable/ai_model.dart' as _i46;
import 'entities/scrappable/auto_fix/auto_fix_attempt.dart' as _i47;
import 'entities/scrappable/auto_fix/auto_fix_attempt_status.dart' as _i48;
import 'entities/scrappable/auto_fix/auto_fix_config.dart' as _i49;
import 'entities/scrappable/auto_fix/auto_fix_session.dart' as _i50;
import 'entities/scrappable/auto_fix/auto_fix_session_status.dart' as _i51;
import 'entities/scrappable/auto_fix/paginated_auto_fix_session_response.dart'
    as _i52;
import 'entities/scrappable/byte_test_data.dart' as _i53;
import 'entities/scrappable/reference_test_data.dart' as _i54;
import 'entities/scrappable/request_status.dart' as _i55;
import 'entities/scrappable/scraper_category.dart' as _i56;
import 'entities/scrappable/scrappable.dart' as _i57;
import 'entities/scrappable/scrappable_analytics.dart' as _i58;
import 'entities/scrappable/scrappable_average_duration.dart' as _i59;
import 'entities/scrappable/scrappable_request.dart' as _i60;
import 'entities/scrappable/scrapping_bee_extract_logic.dart' as _i61;
import 'entities/supported_language.dart' as _i62;
import 'entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i63;
import 'entities/zenscrap_exception.dart' as _i64;
import 'package:zenscrap_server/src/generated/entities/account/account_api_key.dart'
    as _i65;
import 'package:zenscrap_server/src/generated/entities/scrappable/scraper_category.dart'
    as _i66;
export 'email_already_registered_exception.dart';
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/account/ai_usage/account_ai_usage.dart';
export 'entities/account/ai_usage/ai_credit_history/ai_credit_transaction_type.dart';
export 'entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart';
export 'entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart';
export 'entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart';
export 'entities/account/api_usage/account_api_usage.dart';
export 'entities/account/api_usage/api_credit_history/api_credit_history_item.dart';
export 'entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart';
export 'entities/account/api_usage/api_credit_history/api_credit_transaction_type.dart';
export 'entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart';
export 'entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart';
export 'entities/account/api_usage/credit_usage.dart';
export 'entities/account/credit_purchase_option.dart';
export 'entities/account/plan_tier.dart';
export 'entities/analytics/analytics_request_details.dart';
export 'entities/analytics/analytics_time_scope.dart';
export 'entities/analytics/paginated_scrappable_analytics.dart';
export 'entities/analytics/paginated_scrappable_requests_analytics.dart';
export 'entities/analytics/scrappable_request_per_time_scope.dart';
export 'entities/analytics/scrappable_requests_analytics_item.dart';
export 'entities/analytics/scrappable_usage_metrics.dart';
export 'entities/api_key_response.dart';
export 'entities/auth/user_profile_response.dart';
export 'entities/create_scrappable_stream/create_scrappable_stream_item.dart';
export 'entities/create_scrappable_stream/grounding_metadata_info.dart';
export 'entities/create_scrappable_stream/grounding_source_info.dart';
export 'entities/future_calls/session_prompt.dart';
export 'entities/ip_spending/anonymous_ip_spending.dart';
export 'entities/ip_validation/ip_block_reason.dart';
export 'entities/ip_validation/ip_validation_cache.dart';
export 'entities/marketplace/marketplace_paginated_item.dart';
export 'entities/marketplace/paginated_scrappable_response.dart';
export 'entities/marketplace/pagination_metadata.dart';
export 'entities/monthly_credits_data.dart';
export 'entities/redraft_scrappable_session/chat_response.dart';
export 'entities/redraft_scrappable_session/create_session_response.dart';
export 'entities/redraft_scrappable_session/pending_session_commit.dart';
export 'entities/redraft_scrappable_session/prompt_role_enum.dart';
export 'entities/scrappable/ai_model.dart';
export 'entities/scrappable/auto_fix/auto_fix_attempt.dart';
export 'entities/scrappable/auto_fix/auto_fix_attempt_status.dart';
export 'entities/scrappable/auto_fix/auto_fix_config.dart';
export 'entities/scrappable/auto_fix/auto_fix_session.dart';
export 'entities/scrappable/auto_fix/auto_fix_session_status.dart';
export 'entities/scrappable/auto_fix/paginated_auto_fix_session_response.dart';
export 'entities/scrappable/byte_test_data.dart';
export 'entities/scrappable/reference_test_data.dart';
export 'entities/scrappable/request_status.dart';
export 'entities/scrappable/scraper_category.dart';
export 'entities/scrappable/scrappable.dart';
export 'entities/scrappable/scrappable_analytics.dart';
export 'entities/scrappable/scrappable_average_duration.dart';
export 'entities/scrappable/scrappable_request.dart';
export 'entities/scrappable/scrapping_bee_extract_logic.dart';
export 'entities/supported_language.dart';
export 'entities/user_scrappables/user_paginated_scrappable_response.dart';
export 'entities/zenscrap_exception.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'account_ai_usage',
      dartName: 'AccountAIUsage',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'account_ai_usage_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userOpenAiApiKey',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'totalDollarsSpentFromTotalInUSD',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_ai_usage_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'account_api_key',
      dartName: 'AccountApiKey',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'account_api_key_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'apiKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'accountApiUsageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'account_api_key_fk_0',
          columns: ['accountApiUsageId'],
          referenceTable: 'account_api_usage',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_api_key_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'account_api_key_api_key_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'apiKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'account_api_usage',
      dartName: 'AccountApiUsage',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'account_api_usage_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'nanoId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'creditUsageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'account_api_usage_fk_0',
          columns: ['creditUsageId'],
          referenceTable: 'credit_usage',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_api_usage_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'credit_usage_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'creditUsageId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'account_info',
      dartName: 'AccountInfo',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'account_info_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'accountApiUsageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'planTier',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:PlanTier',
        ),
        _i2.ColumnDefinition(
          name: 'stripeCustomerId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'stripeSubscriptionId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'subscriptionStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'subscriptionEndDate',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'accountAIUsageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'account_info_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'account_info_fk_1',
          columns: ['accountApiUsageId'],
          referenceTable: 'account_api_usage',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'account_info_fk_2',
          columns: ['accountAIUsageId'],
          referenceTable: 'account_ai_usage',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_info_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'auth_user_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'account_api_usage_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'accountApiUsageId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_account_ai_usage_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'accountAIUsageId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'ai_credit_history_item',
      dartName: 'AICreditHistoryItem',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'ai_credit_history_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'transactionType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AICreditTransactionType',
        ),
        _i2.ColumnDefinition(
          name: 'monthlySubscriptionAICreditDepositId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'accountAIUsageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'ai_credit_history_item_fk_0',
          columns: ['monthlySubscriptionAICreditDepositId'],
          referenceTable: 'monthly_subscription_ai_credit_deposit',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'ai_credit_history_item_fk_1',
          columns: ['accountAIUsageId'],
          referenceTable: 'account_ai_usage',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'ai_credit_history_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'analytics_request_details',
      dartName: 'AnalyticsRequestDetails',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'analytics_request_details_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'timeStamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'errorObjectAsString',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'errorStackTraceAsString',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'stringifiedPayload',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'stringifiedResponse',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'analytics_request_details_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'analytics_request_details_timestamp_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timeStamp',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'anonymous_ip_spending',
      dartName: 'AnonymousIpSpending',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'anonymous_ip_spending_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'totalSpentUsd',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'lastUpdatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'anonymous_ip_spending_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'anonymous_ip_spending_ip_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ipAddress',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'anonymous_ip_spending_created_at_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'api_credit_history_item',
      dartName: 'ApiCreditHistoryItem',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'api_credit_history_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'transactionType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ApiCreditTransactionType',
        ),
        _i2.ColumnDefinition(
          name: 'monthlySubscriptionApiCreditDepositId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'apiCreditPackagePurchaseId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'accountApiUsageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'api_credit_history_item_fk_0',
          columns: ['monthlySubscriptionApiCreditDepositId'],
          referenceTable: 'monthly_subscription_api_credit_deposit',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'api_credit_history_item_fk_1',
          columns: ['apiCreditPackagePurchaseId'],
          referenceTable: 'api_credit_package_purchase',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'api_credit_history_item_fk_2',
          columns: ['accountApiUsageId'],
          referenceTable: 'account_api_usage',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'api_credit_history_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'api_credit_package_purchase',
      dartName: 'ApiCreditPackagePurchase',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'api_credit_package_purchase_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'value',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'stripePurchaseId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'api_credit_package_purchase_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auto_fix_attempt',
      dartName: 'AutoFixAttempt',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'auto_fix_attempt_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'startedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'completedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'attemptNumber',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'succeeded',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AutoFixAttemptStatus',
          columnDefault: '\'in_progress\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'errorMessage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'aiThinkingLog',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'generatedExtractRules',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'generatedJsScenario',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'validationPassed',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'validationError',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'costUsd',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0.0',
        ),
        _i2.ColumnDefinition(
          name: 'inputTokens',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'outputTokens',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'reasoningTokens',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'sessionId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auto_fix_attempt_fk_0',
          columns: ['sessionId'],
          referenceTable: 'auto_fix_session',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auto_fix_attempt_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_fix_attempt_session_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_fix_attempt_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'startedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auto_fix_config',
      dartName: 'AutoFixConfig',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'auto_fix_config_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'enabled',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'consecutiveErrorThreshold',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '100',
        ),
        _i2.ColumnDefinition(
          name: 'currentConsecutiveErrors',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'lastAttemptAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'inProgress',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'attemptCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'preferredAiModel',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:AiModel?',
        ),
        _i2.ColumnDefinition(
          name: 'scrappableId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auto_fix_config_fk_0',
          columns: ['scrappableId'],
          referenceTable: 'scrappable',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auto_fix_config_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_fix_config_scrappable_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scrappableId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_fix_config_candidates_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'enabled',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'inProgress',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'currentConsecutiveErrors',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auto_fix_session',
      dartName: 'AutoFixSession',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'auto_fix_session_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'completedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AutoFixSessionStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'triggeredAtErrorCount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'configuredThreshold',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'usedAiModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AiModel',
        ),
        _i2.ColumnDefinition(
          name: 'usedUserApiKey',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'successSummary',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'failureReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'totalCostUsd',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0.0',
        ),
        _i2.ColumnDefinition(
          name: 'totalInputTokens',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'totalOutputTokens',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'scrappableId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auto_fix_session_fk_0',
          columns: ['scrappableId'],
          referenceTable: 'scrappable',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auto_fix_session_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_fix_session_scrappable_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scrappableId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'auto_fix_session_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'byte_test_data',
      dartName: 'ByteTestData',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'byte_test_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'referenceHtmlPage',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'referenceSiteScreenshot',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'byte_test_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'credit_usage',
      dartName: 'CreditUsage',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'credit_usage_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'subscriptionCredits',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'purchasedCredits',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'credit_usage_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'ip_validation_cache',
      dartName: 'IpValidationCache',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'ip_validation_cache_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isLegitimate',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'blockReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'blockReasonEnums',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:IpBlockReason>?',
        ),
        _i2.ColumnDefinition(
          name: 'isVpn',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'isProxy',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'isTor',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'isDatacenter',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'isAbuser',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'isCrawler',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'isMobile',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'companyName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'companyType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'countryCode',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'ip_validation_cache_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'ip_validation_cache_ip_address_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ipAddress',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'ip_validation_cache_updated_at_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'updatedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'monthly_subscription_ai_credit_deposit',
      dartName: 'MonthlySubscriptionAICreditDeposit',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'monthly_subscription_ai_credit_deposit_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'creditsAmountInDollars',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'planTier',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:PlanTier',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'monthly_subscription_ai_credit_deposit_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'monthly_subscription_api_credit_deposit',
      dartName: 'MonthlySubscriptionApiCreditDeposit',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'monthly_subscription_api_credit_deposit_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'creditsAmount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'planTier',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:PlanTier',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'monthly_subscription_api_credit_deposit_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'pending_session_commit',
      dartName: 'PendingSessionCommit',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'pending_session_commit_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'sessionId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'scrappableId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'pending_session_commit_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'pending_session_commit_session_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'pending_session_commit_created_at_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrappable',
      dartName: 'Scrappable',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'scrappable_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'accountId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'apiUsageOwnerNanoId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'generalInfosUpdatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'extractRulesUpdatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'nameLanguage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'descriptionLanguage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'testEndpointAvailableUntil',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'willHideFromMarketplace',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'targetRequestId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'referenceTestDataId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ScraperCategory',
        ),
        _i2.ColumnDefinition(
          name: 'isDeleted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'averageDurationInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_fk_0',
          columns: ['accountId'],
          referenceTable: 'account_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_fk_1',
          columns: ['targetRequestId'],
          referenceTable: 'scrappable_target_request',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_fk_2',
          columns: ['referenceTestDataId'],
          referenceTable: 'scrappable_test_data',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_fk_3',
          columns: ['averageDurationInfoId'],
          referenceTable: 'scrappable_average_duration',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_target_request_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'targetRequestId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_reference_test_data_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'referenceTestDataId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrappable_analytics',
      dartName: 'ScrappableAnalytics',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'scrappable_analytics_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'requestStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RequestStatus',
        ),
        _i2.ColumnDefinition(
          name: 'requestedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'attachedNanoId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'attachedApiKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'scrappableId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'detailsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'apiKeyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_analytics_fk_0',
          columns: ['scrappableId'],
          referenceTable: 'scrappable',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_analytics_fk_1',
          columns: ['detailsId'],
          referenceTable: 'analytics_request_details',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_analytics_fk_2',
          columns: ['apiKeyId'],
          referenceTable: 'account_api_key',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_analytics_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_analytics_scrappable_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scrappableId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_analytics_attached_nanoid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attachedNanoId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_analytics_attached_apikey_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attachedApiKey',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_analytics_scrappable_requested_status_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scrappableId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'requestedAt',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'requestStatus',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrappable_average_duration',
      dartName: 'ScrappableAverageDuration',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'scrappable_average_duration_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'averageDuration',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_average_duration_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrappable_target_request',
      dartName: 'ScrappableRequest',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'scrappable_target_request_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'url',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'queryParams',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,String?>',
        ),
        _i2.ColumnDefinition(
          name: 'queryParamsNotRelatedToUrl',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,String?>',
        ),
        _i2.ColumnDefinition(
          name: 'pathParams',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_target_request_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrappable_test_data',
      dartName: 'ReferenceTestData',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'scrappable_test_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'referenceLinkUsed',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'referenceQueryParametersJson',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'scrapResultJson',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'byteDataId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'scrappable_test_data_fk_0',
          columns: ['byteDataId'],
          referenceTable: 'byte_test_data',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_test_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scrapping_bee_extract_logic',
      dartName: 'ScrappingBeeExtractLogic',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'scrapping_bee_extract_logic_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'scrappableId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'extractRules',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'jsScenario',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'renderJs',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'wait',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'waitFor',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'waitBrowser',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'premiumProxy',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'stealthProxy',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'countryCode',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'sessionId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'customGoogle',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'scrapping_bee_extract_logic_fk_0',
          columns: ['scrappableId'],
          referenceTable: 'scrappable',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrapping_bee_extract_logic_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'scrappableId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.EmailAlreadyRegisteredException) {
      return _i5.EmailAlreadyRegisteredException.fromJson(data) as T;
    }
    if (t == _i6.AccountInfo) {
      return _i6.AccountInfo.fromJson(data) as T;
    }
    if (t == _i7.AccountApiKey) {
      return _i7.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i8.AccountAIUsage) {
      return _i8.AccountAIUsage.fromJson(data) as T;
    }
    if (t == _i9.AICreditTransactionType) {
      return _i9.AICreditTransactionType.fromJson(data) as T;
    }
    if (t == _i10.AICreditHistoryItem) {
      return _i10.AICreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i11.MonthlySubscriptionAICreditDeposit) {
      return _i11.MonthlySubscriptionAICreditDeposit.fromJson(data) as T;
    }
    if (t == _i12.PaginatedAICreditHistoryResponse) {
      return _i12.PaginatedAICreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i13.AccountApiUsage) {
      return _i13.AccountApiUsage.fromJson(data) as T;
    }
    if (t == _i14.ApiCreditHistoryItem) {
      return _i14.ApiCreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i15.ApiCreditPackagePurchase) {
      return _i15.ApiCreditPackagePurchase.fromJson(data) as T;
    }
    if (t == _i16.ApiCreditTransactionType) {
      return _i16.ApiCreditTransactionType.fromJson(data) as T;
    }
    if (t == _i17.MonthlySubscriptionApiCreditDeposit) {
      return _i17.MonthlySubscriptionApiCreditDeposit.fromJson(data) as T;
    }
    if (t == _i18.PaginatedApiCreditHistoryResponse) {
      return _i18.PaginatedApiCreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i19.CreditUsage) {
      return _i19.CreditUsage.fromJson(data) as T;
    }
    if (t == _i20.CreditPurchaseOption) {
      return _i20.CreditPurchaseOption.fromJson(data) as T;
    }
    if (t == _i21.PlanTier) {
      return _i21.PlanTier.fromJson(data) as T;
    }
    if (t == _i22.AnalyticsRequestDetails) {
      return _i22.AnalyticsRequestDetails.fromJson(data) as T;
    }
    if (t == _i23.AnalyticsTimeScope) {
      return _i23.AnalyticsTimeScope.fromJson(data) as T;
    }
    if (t == _i24.PaginatedScrappableAnalytics) {
      return _i24.PaginatedScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i25.PaginatedScrappableRequestsAnalytics) {
      return _i25.PaginatedScrappableRequestsAnalytics.fromJson(data) as T;
    }
    if (t == _i26.ScrappableRequestPerTimeScope) {
      return _i26.ScrappableRequestPerTimeScope.fromJson(data) as T;
    }
    if (t == _i27.ScrappableRequestsAnalyticsItem) {
      return _i27.ScrappableRequestsAnalyticsItem.fromJson(data) as T;
    }
    if (t == _i28.ScrappableUsageMetrics) {
      return _i28.ScrappableUsageMetrics.fromJson(data) as T;
    }
    if (t == _i29.ApiKeyResponse) {
      return _i29.ApiKeyResponse.fromJson(data) as T;
    }
    if (t == _i30.UserProfileResponse) {
      return _i30.UserProfileResponse.fromJson(data) as T;
    }
    if (t == _i31.CreateScrappableResult) {
      return _i31.CreateScrappableResult.fromJson(data) as T;
    }
    if (t == _i31.CreateScrappableThinkingChunk) {
      return _i31.CreateScrappableThinkingChunk.fromJson(data) as T;
    }
    if (t == _i32.GroundingMetadataInfo) {
      return _i32.GroundingMetadataInfo.fromJson(data) as T;
    }
    if (t == _i33.GroundingSourceInfo) {
      return _i33.GroundingSourceInfo.fromJson(data) as T;
    }
    if (t == _i34.SessionPrompt) {
      return _i34.SessionPrompt.fromJson(data) as T;
    }
    if (t == _i35.AnonymousIpSpending) {
      return _i35.AnonymousIpSpending.fromJson(data) as T;
    }
    if (t == _i36.IpBlockReason) {
      return _i36.IpBlockReason.fromJson(data) as T;
    }
    if (t == _i37.IpValidationCache) {
      return _i37.IpValidationCache.fromJson(data) as T;
    }
    if (t == _i38.MarketPlacePaginatedItem) {
      return _i38.MarketPlacePaginatedItem.fromJson(data) as T;
    }
    if (t == _i39.PaginatedScrappableResponse) {
      return _i39.PaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i40.PaginationMetadata) {
      return _i40.PaginationMetadata.fromJson(data) as T;
    }
    if (t == _i41.MonthlyCreditsData) {
      return _i41.MonthlyCreditsData.fromJson(data) as T;
    }
    if (t == _i42.ApiKeyUpdatedResponse) {
      return _i42.ApiKeyUpdatedResponse.fromJson(data) as T;
    }
    if (t == _i42.CandidateExtractLogicUpdate) {
      return _i42.CandidateExtractLogicUpdate.fromJson(data) as T;
    }
    if (t == _i42.CreditLimitReachedResponse) {
      return _i42.CreditLimitReachedResponse.fromJson(data) as T;
    }
    if (t == _i42.ErrorTextResponse) {
      return _i42.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i42.HeartbeatResponse) {
      return _i42.HeartbeatResponse.fromJson(data) as T;
    }
    if (t == _i42.IpLimitReachedResponse) {
      return _i42.IpLimitReachedResponse.fromJson(data) as T;
    }
    if (t == _i42.MessageTextResponse) {
      return _i42.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i42.NewExtractRuleResponse) {
      return _i42.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i42.SuspiciousIpResponse) {
      return _i42.SuspiciousIpResponse.fromJson(data) as T;
    }
    if (t == _i42.TestEndpointCalledErrorResponse) {
      return _i42.TestEndpointCalledErrorResponse.fromJson(data) as T;
    }
    if (t == _i42.TestEndpointCalledSuccessResponse) {
      return _i42.TestEndpointCalledSuccessResponse.fromJson(data) as T;
    }
    if (t == _i42.UpdatedScrappableRequestResponse) {
      return _i42.UpdatedScrappableRequestResponse.fromJson(data) as T;
    }
    if (t == _i42.UserApiKeyQuotaExceededResponse) {
      return _i42.UserApiKeyQuotaExceededResponse.fromJson(data) as T;
    }
    if (t == _i43.CreateSessionResponse) {
      return _i43.CreateSessionResponse.fromJson(data) as T;
    }
    if (t == _i44.PendingSessionCommit) {
      return _i44.PendingSessionCommit.fromJson(data) as T;
    }
    if (t == _i45.PromptRole) {
      return _i45.PromptRole.fromJson(data) as T;
    }
    if (t == _i46.AiModel) {
      return _i46.AiModel.fromJson(data) as T;
    }
    if (t == _i47.AutoFixAttempt) {
      return _i47.AutoFixAttempt.fromJson(data) as T;
    }
    if (t == _i48.AutoFixAttemptStatus) {
      return _i48.AutoFixAttemptStatus.fromJson(data) as T;
    }
    if (t == _i49.AutoFixConfig) {
      return _i49.AutoFixConfig.fromJson(data) as T;
    }
    if (t == _i50.AutoFixSession) {
      return _i50.AutoFixSession.fromJson(data) as T;
    }
    if (t == _i51.AutoFixSessionStatus) {
      return _i51.AutoFixSessionStatus.fromJson(data) as T;
    }
    if (t == _i52.PaginatedAutoFixSessionResponse) {
      return _i52.PaginatedAutoFixSessionResponse.fromJson(data) as T;
    }
    if (t == _i53.ByteTestData) {
      return _i53.ByteTestData.fromJson(data) as T;
    }
    if (t == _i54.ReferenceTestData) {
      return _i54.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i55.RequestStatus) {
      return _i55.RequestStatus.fromJson(data) as T;
    }
    if (t == _i56.ScraperCategory) {
      return _i56.ScraperCategory.fromJson(data) as T;
    }
    if (t == _i57.Scrappable) {
      return _i57.Scrappable.fromJson(data) as T;
    }
    if (t == _i58.ScrappableAnalytics) {
      return _i58.ScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i59.ScrappableAverageDuration) {
      return _i59.ScrappableAverageDuration.fromJson(data) as T;
    }
    if (t == _i60.ScrappableRequest) {
      return _i60.ScrappableRequest.fromJson(data) as T;
    }
    if (t == _i61.ScrappingBeeExtractLogic) {
      return _i61.ScrappingBeeExtractLogic.fromJson(data) as T;
    }
    if (t == _i62.SupportedLanguage) {
      return _i62.SupportedLanguage.fromJson(data) as T;
    }
    if (t == _i63.UserPaginatedScrappableResponse) {
      return _i63.UserPaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i64.ZenScrapException) {
      return _i64.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.EmailAlreadyRegisteredException?>()) {
      return (data != null
              ? _i5.EmailAlreadyRegisteredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i6.AccountInfo?>()) {
      return (data != null ? _i6.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AccountApiKey?>()) {
      return (data != null ? _i7.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AccountAIUsage?>()) {
      return (data != null ? _i8.AccountAIUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AICreditTransactionType?>()) {
      return (data != null ? _i9.AICreditTransactionType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.AICreditHistoryItem?>()) {
      return (data != null ? _i10.AICreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.MonthlySubscriptionAICreditDeposit?>()) {
      return (data != null
              ? _i11.MonthlySubscriptionAICreditDeposit.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.PaginatedAICreditHistoryResponse?>()) {
      return (data != null
              ? _i12.PaginatedAICreditHistoryResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.AccountApiUsage?>()) {
      return (data != null ? _i13.AccountApiUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ApiCreditHistoryItem?>()) {
      return (data != null ? _i14.ApiCreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.ApiCreditPackagePurchase?>()) {
      return (data != null
              ? _i15.ApiCreditPackagePurchase.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.ApiCreditTransactionType?>()) {
      return (data != null
              ? _i16.ApiCreditTransactionType.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i17.MonthlySubscriptionApiCreditDeposit?>()) {
      return (data != null
              ? _i17.MonthlySubscriptionApiCreditDeposit.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i18.PaginatedApiCreditHistoryResponse?>()) {
      return (data != null
              ? _i18.PaginatedApiCreditHistoryResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i19.CreditUsage?>()) {
      return (data != null ? _i19.CreditUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.CreditPurchaseOption?>()) {
      return (data != null ? _i20.CreditPurchaseOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.PlanTier?>()) {
      return (data != null ? _i21.PlanTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.AnalyticsRequestDetails?>()) {
      return (data != null ? _i22.AnalyticsRequestDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.AnalyticsTimeScope?>()) {
      return (data != null ? _i23.AnalyticsTimeScope.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.PaginatedScrappableAnalytics?>()) {
      return (data != null
              ? _i24.PaginatedScrappableAnalytics.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i25.PaginatedScrappableRequestsAnalytics?>()) {
      return (data != null
              ? _i25.PaginatedScrappableRequestsAnalytics.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i26.ScrappableRequestPerTimeScope?>()) {
      return (data != null
              ? _i26.ScrappableRequestPerTimeScope.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i27.ScrappableRequestsAnalyticsItem?>()) {
      return (data != null
              ? _i27.ScrappableRequestsAnalyticsItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i28.ScrappableUsageMetrics?>()) {
      return (data != null ? _i28.ScrappableUsageMetrics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.ApiKeyResponse?>()) {
      return (data != null ? _i29.ApiKeyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.UserProfileResponse?>()) {
      return (data != null ? _i30.UserProfileResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.CreateScrappableResult?>()) {
      return (data != null ? _i31.CreateScrappableResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.CreateScrappableThinkingChunk?>()) {
      return (data != null
              ? _i31.CreateScrappableThinkingChunk.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i32.GroundingMetadataInfo?>()) {
      return (data != null ? _i32.GroundingMetadataInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.GroundingSourceInfo?>()) {
      return (data != null ? _i33.GroundingSourceInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.SessionPrompt?>()) {
      return (data != null ? _i34.SessionPrompt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.AnonymousIpSpending?>()) {
      return (data != null ? _i35.AnonymousIpSpending.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.IpBlockReason?>()) {
      return (data != null ? _i36.IpBlockReason.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.IpValidationCache?>()) {
      return (data != null ? _i37.IpValidationCache.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.MarketPlacePaginatedItem?>()) {
      return (data != null
              ? _i38.MarketPlacePaginatedItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i39.PaginatedScrappableResponse?>()) {
      return (data != null
              ? _i39.PaginatedScrappableResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i40.PaginationMetadata?>()) {
      return (data != null ? _i40.PaginationMetadata.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.MonthlyCreditsData?>()) {
      return (data != null ? _i41.MonthlyCreditsData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.ApiKeyUpdatedResponse?>()) {
      return (data != null ? _i42.ApiKeyUpdatedResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.CandidateExtractLogicUpdate?>()) {
      return (data != null
              ? _i42.CandidateExtractLogicUpdate.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i42.CreditLimitReachedResponse?>()) {
      return (data != null
              ? _i42.CreditLimitReachedResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i42.ErrorTextResponse?>()) {
      return (data != null ? _i42.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.HeartbeatResponse?>()) {
      return (data != null ? _i42.HeartbeatResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.IpLimitReachedResponse?>()) {
      return (data != null ? _i42.IpLimitReachedResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.MessageTextResponse?>()) {
      return (data != null ? _i42.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.NewExtractRuleResponse?>()) {
      return (data != null ? _i42.NewExtractRuleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.SuspiciousIpResponse?>()) {
      return (data != null ? _i42.SuspiciousIpResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.TestEndpointCalledErrorResponse?>()) {
      return (data != null
              ? _i42.TestEndpointCalledErrorResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i42.TestEndpointCalledSuccessResponse?>()) {
      return (data != null
              ? _i42.TestEndpointCalledSuccessResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i42.UpdatedScrappableRequestResponse?>()) {
      return (data != null
              ? _i42.UpdatedScrappableRequestResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i42.UserApiKeyQuotaExceededResponse?>()) {
      return (data != null
              ? _i42.UserApiKeyQuotaExceededResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i43.CreateSessionResponse?>()) {
      return (data != null ? _i43.CreateSessionResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.PendingSessionCommit?>()) {
      return (data != null ? _i44.PendingSessionCommit.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.PromptRole?>()) {
      return (data != null ? _i45.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.AiModel?>()) {
      return (data != null ? _i46.AiModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.AutoFixAttempt?>()) {
      return (data != null ? _i47.AutoFixAttempt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.AutoFixAttemptStatus?>()) {
      return (data != null ? _i48.AutoFixAttemptStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.AutoFixConfig?>()) {
      return (data != null ? _i49.AutoFixConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.AutoFixSession?>()) {
      return (data != null ? _i50.AutoFixSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.AutoFixSessionStatus?>()) {
      return (data != null ? _i51.AutoFixSessionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.PaginatedAutoFixSessionResponse?>()) {
      return (data != null
              ? _i52.PaginatedAutoFixSessionResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i53.ByteTestData?>()) {
      return (data != null ? _i53.ByteTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.ReferenceTestData?>()) {
      return (data != null ? _i54.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.RequestStatus?>()) {
      return (data != null ? _i55.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.ScraperCategory?>()) {
      return (data != null ? _i56.ScraperCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.Scrappable?>()) {
      return (data != null ? _i57.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.ScrappableAnalytics?>()) {
      return (data != null ? _i58.ScrappableAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.ScrappableAverageDuration?>()) {
      return (data != null
              ? _i59.ScrappableAverageDuration.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i60.ScrappableRequest?>()) {
      return (data != null ? _i60.ScrappableRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.ScrappingBeeExtractLogic?>()) {
      return (data != null
              ? _i61.ScrappingBeeExtractLogic.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i62.SupportedLanguage?>()) {
      return (data != null ? _i62.SupportedLanguage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.UserPaginatedScrappableResponse?>()) {
      return (data != null
              ? _i63.UserPaginatedScrappableResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i64.ZenScrapException?>()) {
      return (data != null ? _i64.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == List<_i57.Scrappable>) {
      return (data as List).map((e) => deserialize<_i57.Scrappable>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i57.Scrappable>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i57.Scrappable>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i10.AICreditHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i10.AICreditHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i10.AICreditHistoryItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i10.AICreditHistoryItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i14.ApiCreditHistoryItem>) {
      return (data as List)
              .map((e) => deserialize<_i14.ApiCreditHistoryItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i14.ApiCreditHistoryItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i14.ApiCreditHistoryItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i7.AccountApiKey>) {
      return (data as List)
              .map((e) => deserialize<_i7.AccountApiKey>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i7.AccountApiKey>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7.AccountApiKey>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i58.ScrappableAnalytics>) {
      return (data as List)
              .map((e) => deserialize<_i58.ScrappableAnalytics>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.ScrappableRequestsAnalyticsItem>) {
      return (data as List)
              .map((e) => deserialize<_i27.ScrappableRequestsAnalyticsItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.ScrappableRequestPerTimeScope>) {
      return (data as List)
              .map((e) => deserialize<_i26.ScrappableRequestPerTimeScope>(e))
              .toList()
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i33.GroundingSourceInfo>) {
      return (data as List)
              .map((e) => deserialize<_i33.GroundingSourceInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.IpBlockReason>) {
      return (data as List)
              .map((e) => deserialize<_i36.IpBlockReason>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i36.IpBlockReason>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i36.IpBlockReason>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i38.MarketPlacePaginatedItem>) {
      return (data as List)
              .map((e) => deserialize<_i38.MarketPlacePaginatedItem>(e))
              .toList()
          as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String?>(v)),
          )
          as T;
    }
    if (t == List<_i47.AutoFixAttempt>) {
      return (data as List)
              .map((e) => deserialize<_i47.AutoFixAttempt>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i47.AutoFixAttempt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i47.AutoFixAttempt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i50.AutoFixSession>) {
      return (data as List)
              .map((e) => deserialize<_i50.AutoFixSession>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i58.ScrappableAnalytics>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i58.ScrappableAnalytics>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i65.AccountApiKey>) {
      return (data as List)
              .map((e) => deserialize<_i65.AccountApiKey>(e))
              .toList()
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i66.ScraperCategory>) {
      return (data as List)
              .map((e) => deserialize<_i66.ScraperCategory>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i66.ScraperCategory>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i66.ScraperCategory>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String?>(v)),
          )
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.EmailAlreadyRegisteredException => 'EmailAlreadyRegisteredException',
      _i6.AccountInfo => 'AccountInfo',
      _i7.AccountApiKey => 'AccountApiKey',
      _i8.AccountAIUsage => 'AccountAIUsage',
      _i9.AICreditTransactionType => 'AICreditTransactionType',
      _i10.AICreditHistoryItem => 'AICreditHistoryItem',
      _i11.MonthlySubscriptionAICreditDeposit =>
        'MonthlySubscriptionAICreditDeposit',
      _i12.PaginatedAICreditHistoryResponse =>
        'PaginatedAICreditHistoryResponse',
      _i13.AccountApiUsage => 'AccountApiUsage',
      _i14.ApiCreditHistoryItem => 'ApiCreditHistoryItem',
      _i15.ApiCreditPackagePurchase => 'ApiCreditPackagePurchase',
      _i16.ApiCreditTransactionType => 'ApiCreditTransactionType',
      _i17.MonthlySubscriptionApiCreditDeposit =>
        'MonthlySubscriptionApiCreditDeposit',
      _i18.PaginatedApiCreditHistoryResponse =>
        'PaginatedApiCreditHistoryResponse',
      _i19.CreditUsage => 'CreditUsage',
      _i20.CreditPurchaseOption => 'CreditPurchaseOption',
      _i21.PlanTier => 'PlanTier',
      _i22.AnalyticsRequestDetails => 'AnalyticsRequestDetails',
      _i23.AnalyticsTimeScope => 'AnalyticsTimeScope',
      _i24.PaginatedScrappableAnalytics => 'PaginatedScrappableAnalytics',
      _i25.PaginatedScrappableRequestsAnalytics =>
        'PaginatedScrappableRequestsAnalytics',
      _i26.ScrappableRequestPerTimeScope => 'ScrappableRequestPerTimeScope',
      _i27.ScrappableRequestsAnalyticsItem => 'ScrappableRequestsAnalyticsItem',
      _i28.ScrappableUsageMetrics => 'ScrappableUsageMetrics',
      _i29.ApiKeyResponse => 'ApiKeyResponse',
      _i30.UserProfileResponse => 'UserProfileResponse',
      _i31.CreateScrappableResult => 'CreateScrappableResult',
      _i31.CreateScrappableThinkingChunk => 'CreateScrappableThinkingChunk',
      _i32.GroundingMetadataInfo => 'GroundingMetadataInfo',
      _i33.GroundingSourceInfo => 'GroundingSourceInfo',
      _i34.SessionPrompt => 'SessionPrompt',
      _i35.AnonymousIpSpending => 'AnonymousIpSpending',
      _i36.IpBlockReason => 'IpBlockReason',
      _i37.IpValidationCache => 'IpValidationCache',
      _i38.MarketPlacePaginatedItem => 'MarketPlacePaginatedItem',
      _i39.PaginatedScrappableResponse => 'PaginatedScrappableResponse',
      _i40.PaginationMetadata => 'PaginationMetadata',
      _i41.MonthlyCreditsData => 'MonthlyCreditsData',
      _i42.ApiKeyUpdatedResponse => 'ApiKeyUpdatedResponse',
      _i42.CandidateExtractLogicUpdate => 'CandidateExtractLogicUpdate',
      _i42.CreditLimitReachedResponse => 'CreditLimitReachedResponse',
      _i42.ErrorTextResponse => 'ErrorTextResponse',
      _i42.HeartbeatResponse => 'HeartbeatResponse',
      _i42.IpLimitReachedResponse => 'IpLimitReachedResponse',
      _i42.MessageTextResponse => 'MessageTextResponse',
      _i42.NewExtractRuleResponse => 'NewExtractRuleResponse',
      _i42.SuspiciousIpResponse => 'SuspiciousIpResponse',
      _i42.TestEndpointCalledErrorResponse => 'TestEndpointCalledErrorResponse',
      _i42.TestEndpointCalledSuccessResponse =>
        'TestEndpointCalledSuccessResponse',
      _i42.UpdatedScrappableRequestResponse =>
        'UpdatedScrappableRequestResponse',
      _i42.UserApiKeyQuotaExceededResponse => 'UserApiKeyQuotaExceededResponse',
      _i43.CreateSessionResponse => 'CreateSessionResponse',
      _i44.PendingSessionCommit => 'PendingSessionCommit',
      _i45.PromptRole => 'PromptRole',
      _i46.AiModel => 'AiModel',
      _i47.AutoFixAttempt => 'AutoFixAttempt',
      _i48.AutoFixAttemptStatus => 'AutoFixAttemptStatus',
      _i49.AutoFixConfig => 'AutoFixConfig',
      _i50.AutoFixSession => 'AutoFixSession',
      _i51.AutoFixSessionStatus => 'AutoFixSessionStatus',
      _i52.PaginatedAutoFixSessionResponse => 'PaginatedAutoFixSessionResponse',
      _i53.ByteTestData => 'ByteTestData',
      _i54.ReferenceTestData => 'ReferenceTestData',
      _i55.RequestStatus => 'RequestStatus',
      _i56.ScraperCategory => 'ScraperCategory',
      _i57.Scrappable => 'Scrappable',
      _i58.ScrappableAnalytics => 'ScrappableAnalytics',
      _i59.ScrappableAverageDuration => 'ScrappableAverageDuration',
      _i60.ScrappableRequest => 'ScrappableRequest',
      _i61.ScrappingBeeExtractLogic => 'ScrappingBeeExtractLogic',
      _i62.SupportedLanguage => 'SupportedLanguage',
      _i63.UserPaginatedScrappableResponse => 'UserPaginatedScrappableResponse',
      _i64.ZenScrapException => 'ZenScrapException',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('zenscrap.', '');
    }

    switch (data) {
      case _i5.EmailAlreadyRegisteredException():
        return 'EmailAlreadyRegisteredException';
      case _i6.AccountInfo():
        return 'AccountInfo';
      case _i7.AccountApiKey():
        return 'AccountApiKey';
      case _i8.AccountAIUsage():
        return 'AccountAIUsage';
      case _i9.AICreditTransactionType():
        return 'AICreditTransactionType';
      case _i10.AICreditHistoryItem():
        return 'AICreditHistoryItem';
      case _i11.MonthlySubscriptionAICreditDeposit():
        return 'MonthlySubscriptionAICreditDeposit';
      case _i12.PaginatedAICreditHistoryResponse():
        return 'PaginatedAICreditHistoryResponse';
      case _i13.AccountApiUsage():
        return 'AccountApiUsage';
      case _i14.ApiCreditHistoryItem():
        return 'ApiCreditHistoryItem';
      case _i15.ApiCreditPackagePurchase():
        return 'ApiCreditPackagePurchase';
      case _i16.ApiCreditTransactionType():
        return 'ApiCreditTransactionType';
      case _i17.MonthlySubscriptionApiCreditDeposit():
        return 'MonthlySubscriptionApiCreditDeposit';
      case _i18.PaginatedApiCreditHistoryResponse():
        return 'PaginatedApiCreditHistoryResponse';
      case _i19.CreditUsage():
        return 'CreditUsage';
      case _i20.CreditPurchaseOption():
        return 'CreditPurchaseOption';
      case _i21.PlanTier():
        return 'PlanTier';
      case _i22.AnalyticsRequestDetails():
        return 'AnalyticsRequestDetails';
      case _i23.AnalyticsTimeScope():
        return 'AnalyticsTimeScope';
      case _i24.PaginatedScrappableAnalytics():
        return 'PaginatedScrappableAnalytics';
      case _i25.PaginatedScrappableRequestsAnalytics():
        return 'PaginatedScrappableRequestsAnalytics';
      case _i26.ScrappableRequestPerTimeScope():
        return 'ScrappableRequestPerTimeScope';
      case _i27.ScrappableRequestsAnalyticsItem():
        return 'ScrappableRequestsAnalyticsItem';
      case _i28.ScrappableUsageMetrics():
        return 'ScrappableUsageMetrics';
      case _i29.ApiKeyResponse():
        return 'ApiKeyResponse';
      case _i30.UserProfileResponse():
        return 'UserProfileResponse';
      case _i31.CreateScrappableResult():
        return 'CreateScrappableResult';
      case _i31.CreateScrappableThinkingChunk():
        return 'CreateScrappableThinkingChunk';
      case _i32.GroundingMetadataInfo():
        return 'GroundingMetadataInfo';
      case _i33.GroundingSourceInfo():
        return 'GroundingSourceInfo';
      case _i34.SessionPrompt():
        return 'SessionPrompt';
      case _i35.AnonymousIpSpending():
        return 'AnonymousIpSpending';
      case _i36.IpBlockReason():
        return 'IpBlockReason';
      case _i37.IpValidationCache():
        return 'IpValidationCache';
      case _i38.MarketPlacePaginatedItem():
        return 'MarketPlacePaginatedItem';
      case _i39.PaginatedScrappableResponse():
        return 'PaginatedScrappableResponse';
      case _i40.PaginationMetadata():
        return 'PaginationMetadata';
      case _i41.MonthlyCreditsData():
        return 'MonthlyCreditsData';
      case _i42.ApiKeyUpdatedResponse():
        return 'ApiKeyUpdatedResponse';
      case _i42.CandidateExtractLogicUpdate():
        return 'CandidateExtractLogicUpdate';
      case _i42.CreditLimitReachedResponse():
        return 'CreditLimitReachedResponse';
      case _i42.ErrorTextResponse():
        return 'ErrorTextResponse';
      case _i42.HeartbeatResponse():
        return 'HeartbeatResponse';
      case _i42.IpLimitReachedResponse():
        return 'IpLimitReachedResponse';
      case _i42.MessageTextResponse():
        return 'MessageTextResponse';
      case _i42.NewExtractRuleResponse():
        return 'NewExtractRuleResponse';
      case _i42.SuspiciousIpResponse():
        return 'SuspiciousIpResponse';
      case _i42.TestEndpointCalledErrorResponse():
        return 'TestEndpointCalledErrorResponse';
      case _i42.TestEndpointCalledSuccessResponse():
        return 'TestEndpointCalledSuccessResponse';
      case _i42.UpdatedScrappableRequestResponse():
        return 'UpdatedScrappableRequestResponse';
      case _i42.UserApiKeyQuotaExceededResponse():
        return 'UserApiKeyQuotaExceededResponse';
      case _i43.CreateSessionResponse():
        return 'CreateSessionResponse';
      case _i44.PendingSessionCommit():
        return 'PendingSessionCommit';
      case _i45.PromptRole():
        return 'PromptRole';
      case _i46.AiModel():
        return 'AiModel';
      case _i47.AutoFixAttempt():
        return 'AutoFixAttempt';
      case _i48.AutoFixAttemptStatus():
        return 'AutoFixAttemptStatus';
      case _i49.AutoFixConfig():
        return 'AutoFixConfig';
      case _i50.AutoFixSession():
        return 'AutoFixSession';
      case _i51.AutoFixSessionStatus():
        return 'AutoFixSessionStatus';
      case _i52.PaginatedAutoFixSessionResponse():
        return 'PaginatedAutoFixSessionResponse';
      case _i53.ByteTestData():
        return 'ByteTestData';
      case _i54.ReferenceTestData():
        return 'ReferenceTestData';
      case _i55.RequestStatus():
        return 'RequestStatus';
      case _i56.ScraperCategory():
        return 'ScraperCategory';
      case _i57.Scrappable():
        return 'Scrappable';
      case _i58.ScrappableAnalytics():
        return 'ScrappableAnalytics';
      case _i59.ScrappableAverageDuration():
        return 'ScrappableAverageDuration';
      case _i60.ScrappableRequest():
        return 'ScrappableRequest';
      case _i61.ScrappingBeeExtractLogic():
        return 'ScrappingBeeExtractLogic';
      case _i62.SupportedLanguage():
        return 'SupportedLanguage';
      case _i63.UserPaginatedScrappableResponse():
        return 'UserPaginatedScrappableResponse';
      case _i64.ZenScrapException():
        return 'ZenScrapException';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'EmailAlreadyRegisteredException') {
      return deserialize<_i5.EmailAlreadyRegisteredException>(data['data']);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i6.AccountInfo>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i7.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'AccountAIUsage') {
      return deserialize<_i8.AccountAIUsage>(data['data']);
    }
    if (dataClassName == 'AICreditTransactionType') {
      return deserialize<_i9.AICreditTransactionType>(data['data']);
    }
    if (dataClassName == 'AICreditHistoryItem') {
      return deserialize<_i10.AICreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionAICreditDeposit') {
      return deserialize<_i11.MonthlySubscriptionAICreditDeposit>(data['data']);
    }
    if (dataClassName == 'PaginatedAICreditHistoryResponse') {
      return deserialize<_i12.PaginatedAICreditHistoryResponse>(data['data']);
    }
    if (dataClassName == 'AccountApiUsage') {
      return deserialize<_i13.AccountApiUsage>(data['data']);
    }
    if (dataClassName == 'ApiCreditHistoryItem') {
      return deserialize<_i14.ApiCreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'ApiCreditPackagePurchase') {
      return deserialize<_i15.ApiCreditPackagePurchase>(data['data']);
    }
    if (dataClassName == 'ApiCreditTransactionType') {
      return deserialize<_i16.ApiCreditTransactionType>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionApiCreditDeposit') {
      return deserialize<_i17.MonthlySubscriptionApiCreditDeposit>(
        data['data'],
      );
    }
    if (dataClassName == 'PaginatedApiCreditHistoryResponse') {
      return deserialize<_i18.PaginatedApiCreditHistoryResponse>(data['data']);
    }
    if (dataClassName == 'CreditUsage') {
      return deserialize<_i19.CreditUsage>(data['data']);
    }
    if (dataClassName == 'CreditPurchaseOption') {
      return deserialize<_i20.CreditPurchaseOption>(data['data']);
    }
    if (dataClassName == 'PlanTier') {
      return deserialize<_i21.PlanTier>(data['data']);
    }
    if (dataClassName == 'AnalyticsRequestDetails') {
      return deserialize<_i22.AnalyticsRequestDetails>(data['data']);
    }
    if (dataClassName == 'AnalyticsTimeScope') {
      return deserialize<_i23.AnalyticsTimeScope>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableAnalytics') {
      return deserialize<_i24.PaginatedScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableRequestsAnalytics') {
      return deserialize<_i25.PaginatedScrappableRequestsAnalytics>(
        data['data'],
      );
    }
    if (dataClassName == 'ScrappableRequestPerTimeScope') {
      return deserialize<_i26.ScrappableRequestPerTimeScope>(data['data']);
    }
    if (dataClassName == 'ScrappableRequestsAnalyticsItem') {
      return deserialize<_i27.ScrappableRequestsAnalyticsItem>(data['data']);
    }
    if (dataClassName == 'ScrappableUsageMetrics') {
      return deserialize<_i28.ScrappableUsageMetrics>(data['data']);
    }
    if (dataClassName == 'ApiKeyResponse') {
      return deserialize<_i29.ApiKeyResponse>(data['data']);
    }
    if (dataClassName == 'UserProfileResponse') {
      return deserialize<_i30.UserProfileResponse>(data['data']);
    }
    if (dataClassName == 'CreateScrappableResult') {
      return deserialize<_i31.CreateScrappableResult>(data['data']);
    }
    if (dataClassName == 'CreateScrappableThinkingChunk') {
      return deserialize<_i31.CreateScrappableThinkingChunk>(data['data']);
    }
    if (dataClassName == 'GroundingMetadataInfo') {
      return deserialize<_i32.GroundingMetadataInfo>(data['data']);
    }
    if (dataClassName == 'GroundingSourceInfo') {
      return deserialize<_i33.GroundingSourceInfo>(data['data']);
    }
    if (dataClassName == 'SessionPrompt') {
      return deserialize<_i34.SessionPrompt>(data['data']);
    }
    if (dataClassName == 'AnonymousIpSpending') {
      return deserialize<_i35.AnonymousIpSpending>(data['data']);
    }
    if (dataClassName == 'IpBlockReason') {
      return deserialize<_i36.IpBlockReason>(data['data']);
    }
    if (dataClassName == 'IpValidationCache') {
      return deserialize<_i37.IpValidationCache>(data['data']);
    }
    if (dataClassName == 'MarketPlacePaginatedItem') {
      return deserialize<_i38.MarketPlacePaginatedItem>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableResponse') {
      return deserialize<_i39.PaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginationMetadata') {
      return deserialize<_i40.PaginationMetadata>(data['data']);
    }
    if (dataClassName == 'MonthlyCreditsData') {
      return deserialize<_i41.MonthlyCreditsData>(data['data']);
    }
    if (dataClassName == 'ApiKeyUpdatedResponse') {
      return deserialize<_i42.ApiKeyUpdatedResponse>(data['data']);
    }
    if (dataClassName == 'CandidateExtractLogicUpdate') {
      return deserialize<_i42.CandidateExtractLogicUpdate>(data['data']);
    }
    if (dataClassName == 'CreditLimitReachedResponse') {
      return deserialize<_i42.CreditLimitReachedResponse>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i42.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'HeartbeatResponse') {
      return deserialize<_i42.HeartbeatResponse>(data['data']);
    }
    if (dataClassName == 'IpLimitReachedResponse') {
      return deserialize<_i42.IpLimitReachedResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i42.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i42.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'SuspiciousIpResponse') {
      return deserialize<_i42.SuspiciousIpResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledErrorResponse') {
      return deserialize<_i42.TestEndpointCalledErrorResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledSuccessResponse') {
      return deserialize<_i42.TestEndpointCalledSuccessResponse>(data['data']);
    }
    if (dataClassName == 'UpdatedScrappableRequestResponse') {
      return deserialize<_i42.UpdatedScrappableRequestResponse>(data['data']);
    }
    if (dataClassName == 'UserApiKeyQuotaExceededResponse') {
      return deserialize<_i42.UserApiKeyQuotaExceededResponse>(data['data']);
    }
    if (dataClassName == 'CreateSessionResponse') {
      return deserialize<_i43.CreateSessionResponse>(data['data']);
    }
    if (dataClassName == 'PendingSessionCommit') {
      return deserialize<_i44.PendingSessionCommit>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i45.PromptRole>(data['data']);
    }
    if (dataClassName == 'AiModel') {
      return deserialize<_i46.AiModel>(data['data']);
    }
    if (dataClassName == 'AutoFixAttempt') {
      return deserialize<_i47.AutoFixAttempt>(data['data']);
    }
    if (dataClassName == 'AutoFixAttemptStatus') {
      return deserialize<_i48.AutoFixAttemptStatus>(data['data']);
    }
    if (dataClassName == 'AutoFixConfig') {
      return deserialize<_i49.AutoFixConfig>(data['data']);
    }
    if (dataClassName == 'AutoFixSession') {
      return deserialize<_i50.AutoFixSession>(data['data']);
    }
    if (dataClassName == 'AutoFixSessionStatus') {
      return deserialize<_i51.AutoFixSessionStatus>(data['data']);
    }
    if (dataClassName == 'PaginatedAutoFixSessionResponse') {
      return deserialize<_i52.PaginatedAutoFixSessionResponse>(data['data']);
    }
    if (dataClassName == 'ByteTestData') {
      return deserialize<_i53.ByteTestData>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i54.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i55.RequestStatus>(data['data']);
    }
    if (dataClassName == 'ScraperCategory') {
      return deserialize<_i56.ScraperCategory>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i57.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableAnalytics') {
      return deserialize<_i58.ScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'ScrappableAverageDuration') {
      return deserialize<_i59.ScrappableAverageDuration>(data['data']);
    }
    if (dataClassName == 'ScrappableRequest') {
      return deserialize<_i60.ScrappableRequest>(data['data']);
    }
    if (dataClassName == 'ScrappingBeeExtractLogic') {
      return deserialize<_i61.ScrappingBeeExtractLogic>(data['data']);
    }
    if (dataClassName == 'SupportedLanguage') {
      return deserialize<_i62.SupportedLanguage>(data['data']);
    }
    if (dataClassName == 'UserPaginatedScrappableResponse') {
      return deserialize<_i63.UserPaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i64.ZenScrapException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i6.AccountInfo:
        return _i6.AccountInfo.t;
      case _i7.AccountApiKey:
        return _i7.AccountApiKey.t;
      case _i8.AccountAIUsage:
        return _i8.AccountAIUsage.t;
      case _i10.AICreditHistoryItem:
        return _i10.AICreditHistoryItem.t;
      case _i11.MonthlySubscriptionAICreditDeposit:
        return _i11.MonthlySubscriptionAICreditDeposit.t;
      case _i13.AccountApiUsage:
        return _i13.AccountApiUsage.t;
      case _i14.ApiCreditHistoryItem:
        return _i14.ApiCreditHistoryItem.t;
      case _i15.ApiCreditPackagePurchase:
        return _i15.ApiCreditPackagePurchase.t;
      case _i17.MonthlySubscriptionApiCreditDeposit:
        return _i17.MonthlySubscriptionApiCreditDeposit.t;
      case _i19.CreditUsage:
        return _i19.CreditUsage.t;
      case _i22.AnalyticsRequestDetails:
        return _i22.AnalyticsRequestDetails.t;
      case _i35.AnonymousIpSpending:
        return _i35.AnonymousIpSpending.t;
      case _i37.IpValidationCache:
        return _i37.IpValidationCache.t;
      case _i44.PendingSessionCommit:
        return _i44.PendingSessionCommit.t;
      case _i47.AutoFixAttempt:
        return _i47.AutoFixAttempt.t;
      case _i49.AutoFixConfig:
        return _i49.AutoFixConfig.t;
      case _i50.AutoFixSession:
        return _i50.AutoFixSession.t;
      case _i53.ByteTestData:
        return _i53.ByteTestData.t;
      case _i54.ReferenceTestData:
        return _i54.ReferenceTestData.t;
      case _i57.Scrappable:
        return _i57.Scrappable.t;
      case _i58.ScrappableAnalytics:
        return _i58.ScrappableAnalytics.t;
      case _i59.ScrappableAverageDuration:
        return _i59.ScrappableAverageDuration.t;
      case _i60.ScrappableRequest:
        return _i60.ScrappableRequest.t;
      case _i61.ScrappingBeeExtractLogic:
        return _i61.ScrappingBeeExtractLogic.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'zenscrap';
}

/// Maps any `Record`s known to this [Protocol] to their JSON representation
///
/// Throws in case the record type is not known.
///
/// This method will return `null` (only) for `null` inputs.
Map<String, dynamic>? mapRecordToJson(Record? record) {
  if (record == null) {
    return null;
  }
  throw Exception('Unsupported record type ${record.runtimeType}');
}

/// Maps container types (like [List], [Map], [Set]) containing
/// [Record]s or non-String-keyed [Map]s to their JSON representation.
///
/// It should not be called for [SerializableModel] types. These
/// handle the "[Record] in container" mapping internally already.
///
/// It is only supposed to be called from generated protocol code.
///
/// Returns either a `List<dynamic>` (for List, Sets, and Maps with
/// non-String keys) or a `Map<String, dynamic>` in case the input was
/// a `Map<String, …>`.
Object? mapContainerToJson(Object obj) {
  if (obj is! Iterable && obj is! Map) {
    throw ArgumentError.value(
      obj,
      'obj',
      'The object to serialize should be of type List, Map, or Set',
    );
  }

  dynamic mapIfNeeded(Object? obj) {
    return switch (obj) {
      Record record => mapRecordToJson(record),
      Iterable iterable => mapContainerToJson(iterable),
      Map map => mapContainerToJson(map),
      Object? value => value,
    };
  }

  switch (obj) {
    case Map<String, dynamic>():
      return {
        for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
      };
    case Map():
      return [
        for (var entry in obj.entries)
          {
            'k': mapIfNeeded(entry.key),
            'v': mapIfNeeded(entry.value),
          },
      ];

    case Iterable():
      return [
        for (var e in obj) mapIfNeeded(e),
      ];
  }

  return obj;
}
