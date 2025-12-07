/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'entities/redraft_scrappable_session/chat_response.dart' as _i4;
import 'entities/analytics/scrappable_request_per_time_scope.dart' as _i5;
import 'entities/account/api_usage/credit_usage.dart' as _i6;
import 'entities/account/credit_purchase_option.dart' as _i7;
import 'entities/account/plan_tier.dart' as _i8;
import 'entities/analytics/analytics_request_details.dart' as _i9;
import 'entities/analytics/analytics_time_scope.dart' as _i10;
import 'entities/analytics/paginated_scrappable_analytics.dart' as _i11;
import 'entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i12;
import 'entities/account/account.dart' as _i13;
import 'entities/analytics/scrappable_requests_analytics_item.dart' as _i14;
import 'entities/analytics/scrappable_usage_metrics.dart' as _i15;
import 'entities/api_key_response.dart' as _i16;
import 'entities/future_calls/session_prompt.dart' as _i17;
import 'entities/marketplace/marketplace_paginated_item.dart' as _i18;
import 'entities/marketplace/paginated_scrappable_response.dart' as _i19;
import 'entities/marketplace/pagination_metadata.dart' as _i20;
import 'entities/monthly_credits_data.dart' as _i21;
import 'entities/redraft_scrappable_session/create_session_response.dart'
    as _i22;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i23;
import 'entities/account/ai_usage/account_ai_usage.dart' as _i24;
import 'entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart'
    as _i25;
import 'entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart'
    as _i26;
import 'entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart'
    as _i27;
import 'entities/account/api_usage/account_api_usage.dart' as _i28;
import 'entities/account/api_usage/api_credit_history/api_credit_history_item.dart'
    as _i29;
import 'entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart'
    as _i30;
import 'entities/zenscrap_exception.dart' as _i31;
import 'entities/account/account_api_key.dart' as _i32;
import 'entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart'
    as _i33;
import 'entities/scrappable/ai_model.dart' as _i34;
import 'entities/scrappable/auto_fix/auto_fix_attempt.dart' as _i35;
import 'entities/scrappable/auto_fix/auto_fix_attempt_status.dart' as _i36;
import 'entities/scrappable/auto_fix/auto_fix_config.dart' as _i37;
import 'entities/scrappable/auto_fix/auto_fix_session.dart' as _i38;
import 'entities/scrappable/auto_fix/auto_fix_session_status.dart' as _i39;
import 'entities/scrappable/byte_test_data.dart' as _i40;
import 'entities/scrappable/reference_test_data.dart' as _i41;
import 'entities/scrappable/request_status.dart' as _i42;
import 'entities/scrappable/scraper_category.dart' as _i43;
import 'entities/scrappable/scrappable.dart' as _i44;
import 'entities/scrappable/scrappable_analytics.dart' as _i45;
import 'entities/scrappable/scrappable_request.dart' as _i46;
import 'entities/scrappable/scrapping_bee_extract_logic.dart' as _i47;
import 'entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i48;
import 'entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart'
    as _i49;
import 'package:zenscrap_server/src/generated/entities/account/account_api_key.dart'
    as _i50;
import 'package:zenscrap_server/src/generated/entities/scrappable/scraper_category.dart'
    as _i51;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/account/ai_usage/account_ai_usage.dart';
export 'entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart';
export 'entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart';
export 'entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart';
export 'entities/account/api_usage/account_api_usage.dart';
export 'entities/account/api_usage/api_credit_history/api_credit_history_item.dart';
export 'entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart';
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
export 'entities/future_calls/session_prompt.dart';
export 'entities/marketplace/marketplace_paginated_item.dart';
export 'entities/marketplace/paginated_scrappable_response.dart';
export 'entities/marketplace/pagination_metadata.dart';
export 'entities/monthly_credits_data.dart';
export 'entities/redraft_scrappable_session/chat_response.dart';
export 'entities/redraft_scrappable_session/create_session_response.dart';
export 'entities/redraft_scrappable_session/prompt_role_enum.dart';
export 'entities/scrappable/ai_model.dart';
export 'entities/scrappable/auto_fix/auto_fix_attempt.dart';
export 'entities/scrappable/auto_fix/auto_fix_attempt_status.dart';
export 'entities/scrappable/auto_fix/auto_fix_config.dart';
export 'entities/scrappable/auto_fix/auto_fix_session.dart';
export 'entities/scrappable/auto_fix/auto_fix_session_status.dart';
export 'entities/scrappable/byte_test_data.dart';
export 'entities/scrappable/reference_test_data.dart';
export 'entities/scrappable/request_status.dart';
export 'entities/scrappable/scraper_category.dart';
export 'entities/scrappable/scrappable.dart';
export 'entities/scrappable/scrappable_analytics.dart';
export 'entities/scrappable/scrappable_request.dart';
export 'entities/scrappable/scrapping_bee_extract_logic.dart';
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_api_key_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'account_api_usage_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
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
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_info_id_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            )
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
            )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:AutoFixAttemptStatus',
          columnDefault: '0',
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auto_fix_attempt_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
          columnType: _i2.ColumnType.bigint,
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auto_fix_config_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:AutoFixSessionStatus',
          columnDefault: '0',
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
          columnType: _i2.ColumnType.bigint,
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auto_fix_session_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:ScraperCategory',
        ),
        _i2.ColumnDefinition(
          name: 'isDeleted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
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
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
            )
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
          columnType: _i2.ColumnType.bigint,
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
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_analytics_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'scrappable_analytics_attached_nanoid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attachedNanoId',
            )
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
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrappable_test_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scrapping_bee_extract_logic_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.UserApiKeyQuotaExceededResponse) {
      return _i4.UserApiKeyQuotaExceededResponse.fromJson(data) as T;
    }
    if (t == _i4.TestEndpointCalledSuccessResponse) {
      return _i4.TestEndpointCalledSuccessResponse.fromJson(data) as T;
    }
    if (t == _i4.ApiKeyUpdatedResponse) {
      return _i4.ApiKeyUpdatedResponse.fromJson(data) as T;
    }
    if (t == _i4.CandidateExtractLogicUpdate) {
      return _i4.CandidateExtractLogicUpdate.fromJson(data) as T;
    }
    if (t == _i4.CreditLimitReachedResponse) {
      return _i4.CreditLimitReachedResponse.fromJson(data) as T;
    }
    if (t == _i4.ErrorTextResponse) {
      return _i4.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i4.MessageTextResponse) {
      return _i4.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i4.NewExtractRuleResponse) {
      return _i4.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i4.TestEndpointCalledErrorResponse) {
      return _i4.TestEndpointCalledErrorResponse.fromJson(data) as T;
    }
    if (t == _i4.UpdatedScrappableRequestResponse) {
      return _i4.UpdatedScrappableRequestResponse.fromJson(data) as T;
    }
    if (t == _i5.ScrappableRequestPerTimeScope) {
      return _i5.ScrappableRequestPerTimeScope.fromJson(data) as T;
    }
    if (t == _i6.CreditUsage) {
      return _i6.CreditUsage.fromJson(data) as T;
    }
    if (t == _i7.CreditPurchaseOption) {
      return _i7.CreditPurchaseOption.fromJson(data) as T;
    }
    if (t == _i8.PlanTier) {
      return _i8.PlanTier.fromJson(data) as T;
    }
    if (t == _i9.AnalyticsRequestDetails) {
      return _i9.AnalyticsRequestDetails.fromJson(data) as T;
    }
    if (t == _i10.AnalyticsTimeScope) {
      return _i10.AnalyticsTimeScope.fromJson(data) as T;
    }
    if (t == _i11.PaginatedScrappableAnalytics) {
      return _i11.PaginatedScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i12.PaginatedScrappableRequestsAnalytics) {
      return _i12.PaginatedScrappableRequestsAnalytics.fromJson(data) as T;
    }
    if (t == _i13.AccountInfo) {
      return _i13.AccountInfo.fromJson(data) as T;
    }
    if (t == _i14.ScrappableRequestsAnalyticsItem) {
      return _i14.ScrappableRequestsAnalyticsItem.fromJson(data) as T;
    }
    if (t == _i15.ScrappableUsageMetrics) {
      return _i15.ScrappableUsageMetrics.fromJson(data) as T;
    }
    if (t == _i16.ApiKeyResponse) {
      return _i16.ApiKeyResponse.fromJson(data) as T;
    }
    if (t == _i17.SessionPrompt) {
      return _i17.SessionPrompt.fromJson(data) as T;
    }
    if (t == _i18.MarketPlacePaginatedItem) {
      return _i18.MarketPlacePaginatedItem.fromJson(data) as T;
    }
    if (t == _i19.PaginatedScrappableResponse) {
      return _i19.PaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i20.PaginationMetadata) {
      return _i20.PaginationMetadata.fromJson(data) as T;
    }
    if (t == _i21.MonthlyCreditsData) {
      return _i21.MonthlyCreditsData.fromJson(data) as T;
    }
    if (t == _i22.CreateSessionResponse) {
      return _i22.CreateSessionResponse.fromJson(data) as T;
    }
    if (t == _i23.PromptRole) {
      return _i23.PromptRole.fromJson(data) as T;
    }
    if (t == _i24.AccountAIUsage) {
      return _i24.AccountAIUsage.fromJson(data) as T;
    }
    if (t == _i25.AICreditHistoryItem) {
      return _i25.AICreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i26.MonthlySubscriptionAICreditDeposit) {
      return _i26.MonthlySubscriptionAICreditDeposit.fromJson(data) as T;
    }
    if (t == _i27.PaginatedAICreditHistoryResponse) {
      return _i27.PaginatedAICreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i28.AccountApiUsage) {
      return _i28.AccountApiUsage.fromJson(data) as T;
    }
    if (t == _i29.ApiCreditHistoryItem) {
      return _i29.ApiCreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i30.ApiCreditPackagePurchase) {
      return _i30.ApiCreditPackagePurchase.fromJson(data) as T;
    }
    if (t == _i31.ZenScrapException) {
      return _i31.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i32.AccountApiKey) {
      return _i32.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i33.PaginatedApiCreditHistoryResponse) {
      return _i33.PaginatedApiCreditHistoryResponse.fromJson(data) as T;
    }
    if (t == _i34.AiModel) {
      return _i34.AiModel.fromJson(data) as T;
    }
    if (t == _i35.AutoFixAttempt) {
      return _i35.AutoFixAttempt.fromJson(data) as T;
    }
    if (t == _i36.AutoFixAttemptStatus) {
      return _i36.AutoFixAttemptStatus.fromJson(data) as T;
    }
    if (t == _i37.AutoFixConfig) {
      return _i37.AutoFixConfig.fromJson(data) as T;
    }
    if (t == _i38.AutoFixSession) {
      return _i38.AutoFixSession.fromJson(data) as T;
    }
    if (t == _i39.AutoFixSessionStatus) {
      return _i39.AutoFixSessionStatus.fromJson(data) as T;
    }
    if (t == _i40.ByteTestData) {
      return _i40.ByteTestData.fromJson(data) as T;
    }
    if (t == _i41.ReferenceTestData) {
      return _i41.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i42.RequestStatus) {
      return _i42.RequestStatus.fromJson(data) as T;
    }
    if (t == _i43.ScraperCategory) {
      return _i43.ScraperCategory.fromJson(data) as T;
    }
    if (t == _i44.Scrappable) {
      return _i44.Scrappable.fromJson(data) as T;
    }
    if (t == _i45.ScrappableAnalytics) {
      return _i45.ScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i46.ScrappableRequest) {
      return _i46.ScrappableRequest.fromJson(data) as T;
    }
    if (t == _i47.ScrappingBeeExtractLogic) {
      return _i47.ScrappingBeeExtractLogic.fromJson(data) as T;
    }
    if (t == _i48.UserPaginatedScrappableResponse) {
      return _i48.UserPaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i49.MonthlySubscriptionApiCreditDeposit) {
      return _i49.MonthlySubscriptionApiCreditDeposit.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.UserApiKeyQuotaExceededResponse?>()) {
      return (data != null
          ? _i4.UserApiKeyQuotaExceededResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.TestEndpointCalledSuccessResponse?>()) {
      return (data != null
          ? _i4.TestEndpointCalledSuccessResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.ApiKeyUpdatedResponse?>()) {
      return (data != null ? _i4.ApiKeyUpdatedResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.CandidateExtractLogicUpdate?>()) {
      return (data != null
          ? _i4.CandidateExtractLogicUpdate.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.CreditLimitReachedResponse?>()) {
      return (data != null
          ? _i4.CreditLimitReachedResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.ErrorTextResponse?>()) {
      return (data != null ? _i4.ErrorTextResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.MessageTextResponse?>()) {
      return (data != null ? _i4.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.NewExtractRuleResponse?>()) {
      return (data != null ? _i4.NewExtractRuleResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.TestEndpointCalledErrorResponse?>()) {
      return (data != null
          ? _i4.TestEndpointCalledErrorResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.UpdatedScrappableRequestResponse?>()) {
      return (data != null
          ? _i4.UpdatedScrappableRequestResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.ScrappableRequestPerTimeScope?>()) {
      return (data != null
          ? _i5.ScrappableRequestPerTimeScope.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.CreditUsage?>()) {
      return (data != null ? _i6.CreditUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CreditPurchaseOption?>()) {
      return (data != null ? _i7.CreditPurchaseOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.PlanTier?>()) {
      return (data != null ? _i8.PlanTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AnalyticsRequestDetails?>()) {
      return (data != null ? _i9.AnalyticsRequestDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.AnalyticsTimeScope?>()) {
      return (data != null ? _i10.AnalyticsTimeScope.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.PaginatedScrappableAnalytics?>()) {
      return (data != null
          ? _i11.PaginatedScrappableAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.PaginatedScrappableRequestsAnalytics?>()) {
      return (data != null
          ? _i12.PaginatedScrappableRequestsAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.AccountInfo?>()) {
      return (data != null ? _i13.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ScrappableRequestsAnalyticsItem?>()) {
      return (data != null
          ? _i14.ScrappableRequestsAnalyticsItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.ScrappableUsageMetrics?>()) {
      return (data != null ? _i15.ScrappableUsageMetrics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.ApiKeyResponse?>()) {
      return (data != null ? _i16.ApiKeyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.SessionPrompt?>()) {
      return (data != null ? _i17.SessionPrompt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.MarketPlacePaginatedItem?>()) {
      return (data != null
          ? _i18.MarketPlacePaginatedItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i19.PaginatedScrappableResponse?>()) {
      return (data != null
          ? _i19.PaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i20.PaginationMetadata?>()) {
      return (data != null ? _i20.PaginationMetadata.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.MonthlyCreditsData?>()) {
      return (data != null ? _i21.MonthlyCreditsData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.CreateSessionResponse?>()) {
      return (data != null ? _i22.CreateSessionResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.PromptRole?>()) {
      return (data != null ? _i23.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.AccountAIUsage?>()) {
      return (data != null ? _i24.AccountAIUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.AICreditHistoryItem?>()) {
      return (data != null ? _i25.AICreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.MonthlySubscriptionAICreditDeposit?>()) {
      return (data != null
          ? _i26.MonthlySubscriptionAICreditDeposit.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i27.PaginatedAICreditHistoryResponse?>()) {
      return (data != null
          ? _i27.PaginatedAICreditHistoryResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i28.AccountApiUsage?>()) {
      return (data != null ? _i28.AccountApiUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.ApiCreditHistoryItem?>()) {
      return (data != null ? _i29.ApiCreditHistoryItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.ApiCreditPackagePurchase?>()) {
      return (data != null
          ? _i30.ApiCreditPackagePurchase.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i31.ZenScrapException?>()) {
      return (data != null ? _i31.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.AccountApiKey?>()) {
      return (data != null ? _i32.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.PaginatedApiCreditHistoryResponse?>()) {
      return (data != null
          ? _i33.PaginatedApiCreditHistoryResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i34.AiModel?>()) {
      return (data != null ? _i34.AiModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.AutoFixAttempt?>()) {
      return (data != null ? _i35.AutoFixAttempt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.AutoFixAttemptStatus?>()) {
      return (data != null ? _i36.AutoFixAttemptStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.AutoFixConfig?>()) {
      return (data != null ? _i37.AutoFixConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.AutoFixSession?>()) {
      return (data != null ? _i38.AutoFixSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.AutoFixSessionStatus?>()) {
      return (data != null ? _i39.AutoFixSessionStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.ByteTestData?>()) {
      return (data != null ? _i40.ByteTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.ReferenceTestData?>()) {
      return (data != null ? _i41.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.RequestStatus?>()) {
      return (data != null ? _i42.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ScraperCategory?>()) {
      return (data != null ? _i43.ScraperCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.Scrappable?>()) {
      return (data != null ? _i44.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.ScrappableAnalytics?>()) {
      return (data != null ? _i45.ScrappableAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.ScrappableRequest?>()) {
      return (data != null ? _i46.ScrappableRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.ScrappingBeeExtractLogic?>()) {
      return (data != null
          ? _i47.ScrappingBeeExtractLogic.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i48.UserPaginatedScrappableResponse?>()) {
      return (data != null
          ? _i48.UserPaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i49.MonthlySubscriptionApiCreditDeposit?>()) {
      return (data != null
          ? _i49.MonthlySubscriptionApiCreditDeposit.fromJson(data)
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == List<_i45.ScrappableAnalytics>) {
      return (data as List)
          .map((e) => deserialize<_i45.ScrappableAnalytics>(e))
          .toList() as T;
    }
    if (t == List<_i14.ScrappableRequestsAnalyticsItem>) {
      return (data as List)
          .map((e) => deserialize<_i14.ScrappableRequestsAnalyticsItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i44.Scrappable>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i44.Scrappable>(e)).toList()
          : null) as T;
    }
    if (t == List<_i5.ScrappableRequestPerTimeScope>) {
      return (data as List)
          .map((e) => deserialize<_i5.ScrappableRequestPerTimeScope>(e))
          .toList() as T;
    }
    if (t == List<_i32.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i32.AccountApiKey>(e))
          .toList() as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == List<_i18.MarketPlacePaginatedItem>) {
      return (data as List)
          .map((e) => deserialize<_i18.MarketPlacePaginatedItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i25.AICreditHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i25.AICreditHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i25.AICreditHistoryItem>) {
      return (data as List)
          .map((e) => deserialize<_i25.AICreditHistoryItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i29.ApiCreditHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i29.ApiCreditHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i32.AccountApiKey>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i32.AccountApiKey>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i29.ApiCreditHistoryItem>) {
      return (data as List)
          .map((e) => deserialize<_i29.ApiCreditHistoryItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i35.AutoFixAttempt>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i35.AutoFixAttempt>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i45.ScrappableAnalytics>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i45.ScrappableAnalytics>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i38.AutoFixSession>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i38.AutoFixSession>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i44.Scrappable>) {
      return (data as List).map((e) => deserialize<_i44.Scrappable>(e)).toList()
          as T;
    }
    if (t == List<_i50.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i50.AccountApiKey>(e))
          .toList() as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<dynamic>(v))) as T;
    }
    if (t == _i1.getType<List<_i51.ScraperCategory>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i51.ScraperCategory>(e))
              .toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i4.UserApiKeyQuotaExceededResponse) {
      return 'UserApiKeyQuotaExceededResponse';
    }
    if (data is _i4.TestEndpointCalledSuccessResponse) {
      return 'TestEndpointCalledSuccessResponse';
    }
    if (data is _i4.ApiKeyUpdatedResponse) {
      return 'ApiKeyUpdatedResponse';
    }
    if (data is _i4.CandidateExtractLogicUpdate) {
      return 'CandidateExtractLogicUpdate';
    }
    if (data is _i4.CreditLimitReachedResponse) {
      return 'CreditLimitReachedResponse';
    }
    if (data is _i4.ErrorTextResponse) {
      return 'ErrorTextResponse';
    }
    if (data is _i4.MessageTextResponse) {
      return 'MessageTextResponse';
    }
    if (data is _i4.NewExtractRuleResponse) {
      return 'NewExtractRuleResponse';
    }
    if (data is _i4.TestEndpointCalledErrorResponse) {
      return 'TestEndpointCalledErrorResponse';
    }
    if (data is _i4.UpdatedScrappableRequestResponse) {
      return 'UpdatedScrappableRequestResponse';
    }
    if (data is _i5.ScrappableRequestPerTimeScope) {
      return 'ScrappableRequestPerTimeScope';
    }
    if (data is _i6.CreditUsage) {
      return 'CreditUsage';
    }
    if (data is _i7.CreditPurchaseOption) {
      return 'CreditPurchaseOption';
    }
    if (data is _i8.PlanTier) {
      return 'PlanTier';
    }
    if (data is _i9.AnalyticsRequestDetails) {
      return 'AnalyticsRequestDetails';
    }
    if (data is _i10.AnalyticsTimeScope) {
      return 'AnalyticsTimeScope';
    }
    if (data is _i11.PaginatedScrappableAnalytics) {
      return 'PaginatedScrappableAnalytics';
    }
    if (data is _i12.PaginatedScrappableRequestsAnalytics) {
      return 'PaginatedScrappableRequestsAnalytics';
    }
    if (data is _i13.AccountInfo) {
      return 'AccountInfo';
    }
    if (data is _i14.ScrappableRequestsAnalyticsItem) {
      return 'ScrappableRequestsAnalyticsItem';
    }
    if (data is _i15.ScrappableUsageMetrics) {
      return 'ScrappableUsageMetrics';
    }
    if (data is _i16.ApiKeyResponse) {
      return 'ApiKeyResponse';
    }
    if (data is _i17.SessionPrompt) {
      return 'SessionPrompt';
    }
    if (data is _i18.MarketPlacePaginatedItem) {
      return 'MarketPlacePaginatedItem';
    }
    if (data is _i19.PaginatedScrappableResponse) {
      return 'PaginatedScrappableResponse';
    }
    if (data is _i20.PaginationMetadata) {
      return 'PaginationMetadata';
    }
    if (data is _i21.MonthlyCreditsData) {
      return 'MonthlyCreditsData';
    }
    if (data is _i22.CreateSessionResponse) {
      return 'CreateSessionResponse';
    }
    if (data is _i23.PromptRole) {
      return 'PromptRole';
    }
    if (data is _i24.AccountAIUsage) {
      return 'AccountAIUsage';
    }
    if (data is _i25.AICreditHistoryItem) {
      return 'AICreditHistoryItem';
    }
    if (data is _i26.MonthlySubscriptionAICreditDeposit) {
      return 'MonthlySubscriptionAICreditDeposit';
    }
    if (data is _i27.PaginatedAICreditHistoryResponse) {
      return 'PaginatedAICreditHistoryResponse';
    }
    if (data is _i28.AccountApiUsage) {
      return 'AccountApiUsage';
    }
    if (data is _i29.ApiCreditHistoryItem) {
      return 'ApiCreditHistoryItem';
    }
    if (data is _i30.ApiCreditPackagePurchase) {
      return 'ApiCreditPackagePurchase';
    }
    if (data is _i31.ZenScrapException) {
      return 'ZenScrapException';
    }
    if (data is _i32.AccountApiKey) {
      return 'AccountApiKey';
    }
    if (data is _i33.PaginatedApiCreditHistoryResponse) {
      return 'PaginatedApiCreditHistoryResponse';
    }
    if (data is _i34.AiModel) {
      return 'AiModel';
    }
    if (data is _i35.AutoFixAttempt) {
      return 'AutoFixAttempt';
    }
    if (data is _i36.AutoFixAttemptStatus) {
      return 'AutoFixAttemptStatus';
    }
    if (data is _i37.AutoFixConfig) {
      return 'AutoFixConfig';
    }
    if (data is _i38.AutoFixSession) {
      return 'AutoFixSession';
    }
    if (data is _i39.AutoFixSessionStatus) {
      return 'AutoFixSessionStatus';
    }
    if (data is _i40.ByteTestData) {
      return 'ByteTestData';
    }
    if (data is _i41.ReferenceTestData) {
      return 'ReferenceTestData';
    }
    if (data is _i42.RequestStatus) {
      return 'RequestStatus';
    }
    if (data is _i43.ScraperCategory) {
      return 'ScraperCategory';
    }
    if (data is _i44.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i45.ScrappableAnalytics) {
      return 'ScrappableAnalytics';
    }
    if (data is _i46.ScrappableRequest) {
      return 'ScrappableRequest';
    }
    if (data is _i47.ScrappingBeeExtractLogic) {
      return 'ScrappingBeeExtractLogic';
    }
    if (data is _i48.UserPaginatedScrappableResponse) {
      return 'UserPaginatedScrappableResponse';
    }
    if (data is _i49.MonthlySubscriptionApiCreditDeposit) {
      return 'MonthlySubscriptionApiCreditDeposit';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'UserApiKeyQuotaExceededResponse') {
      return deserialize<_i4.UserApiKeyQuotaExceededResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledSuccessResponse') {
      return deserialize<_i4.TestEndpointCalledSuccessResponse>(data['data']);
    }
    if (dataClassName == 'ApiKeyUpdatedResponse') {
      return deserialize<_i4.ApiKeyUpdatedResponse>(data['data']);
    }
    if (dataClassName == 'CandidateExtractLogicUpdate') {
      return deserialize<_i4.CandidateExtractLogicUpdate>(data['data']);
    }
    if (dataClassName == 'CreditLimitReachedResponse') {
      return deserialize<_i4.CreditLimitReachedResponse>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i4.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i4.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i4.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledErrorResponse') {
      return deserialize<_i4.TestEndpointCalledErrorResponse>(data['data']);
    }
    if (dataClassName == 'UpdatedScrappableRequestResponse') {
      return deserialize<_i4.UpdatedScrappableRequestResponse>(data['data']);
    }
    if (dataClassName == 'ScrappableRequestPerTimeScope') {
      return deserialize<_i5.ScrappableRequestPerTimeScope>(data['data']);
    }
    if (dataClassName == 'CreditUsage') {
      return deserialize<_i6.CreditUsage>(data['data']);
    }
    if (dataClassName == 'CreditPurchaseOption') {
      return deserialize<_i7.CreditPurchaseOption>(data['data']);
    }
    if (dataClassName == 'PlanTier') {
      return deserialize<_i8.PlanTier>(data['data']);
    }
    if (dataClassName == 'AnalyticsRequestDetails') {
      return deserialize<_i9.AnalyticsRequestDetails>(data['data']);
    }
    if (dataClassName == 'AnalyticsTimeScope') {
      return deserialize<_i10.AnalyticsTimeScope>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableAnalytics') {
      return deserialize<_i11.PaginatedScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableRequestsAnalytics') {
      return deserialize<_i12.PaginatedScrappableRequestsAnalytics>(
          data['data']);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i13.AccountInfo>(data['data']);
    }
    if (dataClassName == 'ScrappableRequestsAnalyticsItem') {
      return deserialize<_i14.ScrappableRequestsAnalyticsItem>(data['data']);
    }
    if (dataClassName == 'ScrappableUsageMetrics') {
      return deserialize<_i15.ScrappableUsageMetrics>(data['data']);
    }
    if (dataClassName == 'ApiKeyResponse') {
      return deserialize<_i16.ApiKeyResponse>(data['data']);
    }
    if (dataClassName == 'SessionPrompt') {
      return deserialize<_i17.SessionPrompt>(data['data']);
    }
    if (dataClassName == 'MarketPlacePaginatedItem') {
      return deserialize<_i18.MarketPlacePaginatedItem>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableResponse') {
      return deserialize<_i19.PaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginationMetadata') {
      return deserialize<_i20.PaginationMetadata>(data['data']);
    }
    if (dataClassName == 'MonthlyCreditsData') {
      return deserialize<_i21.MonthlyCreditsData>(data['data']);
    }
    if (dataClassName == 'CreateSessionResponse') {
      return deserialize<_i22.CreateSessionResponse>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i23.PromptRole>(data['data']);
    }
    if (dataClassName == 'AccountAIUsage') {
      return deserialize<_i24.AccountAIUsage>(data['data']);
    }
    if (dataClassName == 'AICreditHistoryItem') {
      return deserialize<_i25.AICreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionAICreditDeposit') {
      return deserialize<_i26.MonthlySubscriptionAICreditDeposit>(data['data']);
    }
    if (dataClassName == 'PaginatedAICreditHistoryResponse') {
      return deserialize<_i27.PaginatedAICreditHistoryResponse>(data['data']);
    }
    if (dataClassName == 'AccountApiUsage') {
      return deserialize<_i28.AccountApiUsage>(data['data']);
    }
    if (dataClassName == 'ApiCreditHistoryItem') {
      return deserialize<_i29.ApiCreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'ApiCreditPackagePurchase') {
      return deserialize<_i30.ApiCreditPackagePurchase>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i31.ZenScrapException>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i32.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'PaginatedApiCreditHistoryResponse') {
      return deserialize<_i33.PaginatedApiCreditHistoryResponse>(data['data']);
    }
    if (dataClassName == 'AiModel') {
      return deserialize<_i34.AiModel>(data['data']);
    }
    if (dataClassName == 'AutoFixAttempt') {
      return deserialize<_i35.AutoFixAttempt>(data['data']);
    }
    if (dataClassName == 'AutoFixAttemptStatus') {
      return deserialize<_i36.AutoFixAttemptStatus>(data['data']);
    }
    if (dataClassName == 'AutoFixConfig') {
      return deserialize<_i37.AutoFixConfig>(data['data']);
    }
    if (dataClassName == 'AutoFixSession') {
      return deserialize<_i38.AutoFixSession>(data['data']);
    }
    if (dataClassName == 'AutoFixSessionStatus') {
      return deserialize<_i39.AutoFixSessionStatus>(data['data']);
    }
    if (dataClassName == 'ByteTestData') {
      return deserialize<_i40.ByteTestData>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i41.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i42.RequestStatus>(data['data']);
    }
    if (dataClassName == 'ScraperCategory') {
      return deserialize<_i43.ScraperCategory>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i44.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableAnalytics') {
      return deserialize<_i45.ScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'ScrappableRequest') {
      return deserialize<_i46.ScrappableRequest>(data['data']);
    }
    if (dataClassName == 'ScrappingBeeExtractLogic') {
      return deserialize<_i47.ScrappingBeeExtractLogic>(data['data']);
    }
    if (dataClassName == 'UserPaginatedScrappableResponse') {
      return deserialize<_i48.UserPaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionApiCreditDeposit') {
      return deserialize<_i49.MonthlySubscriptionApiCreditDeposit>(
          data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
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
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i13.AccountInfo:
        return _i13.AccountInfo.t;
      case _i32.AccountApiKey:
        return _i32.AccountApiKey.t;
      case _i24.AccountAIUsage:
        return _i24.AccountAIUsage.t;
      case _i25.AICreditHistoryItem:
        return _i25.AICreditHistoryItem.t;
      case _i26.MonthlySubscriptionAICreditDeposit:
        return _i26.MonthlySubscriptionAICreditDeposit.t;
      case _i28.AccountApiUsage:
        return _i28.AccountApiUsage.t;
      case _i29.ApiCreditHistoryItem:
        return _i29.ApiCreditHistoryItem.t;
      case _i30.ApiCreditPackagePurchase:
        return _i30.ApiCreditPackagePurchase.t;
      case _i49.MonthlySubscriptionApiCreditDeposit:
        return _i49.MonthlySubscriptionApiCreditDeposit.t;
      case _i6.CreditUsage:
        return _i6.CreditUsage.t;
      case _i9.AnalyticsRequestDetails:
        return _i9.AnalyticsRequestDetails.t;
      case _i35.AutoFixAttempt:
        return _i35.AutoFixAttempt.t;
      case _i37.AutoFixConfig:
        return _i37.AutoFixConfig.t;
      case _i38.AutoFixSession:
        return _i38.AutoFixSession.t;
      case _i40.ByteTestData:
        return _i40.ByteTestData.t;
      case _i41.ReferenceTestData:
        return _i41.ReferenceTestData.t;
      case _i44.Scrappable:
        return _i44.Scrappable.t;
      case _i45.ScrappableAnalytics:
        return _i45.ScrappableAnalytics.t;
      case _i46.ScrappableRequest:
        return _i46.ScrappableRequest.t;
      case _i47.ScrappingBeeExtractLogic:
        return _i47.ScrappingBeeExtractLogic.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'zenscrap';
}
