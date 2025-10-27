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
import 'entities/analytics/scrappable_requests_analytics_item.dart' as _i5;
import 'entities/account/credit_purchase_option.dart' as _i6;
import 'entities/account/plan_tier.dart' as _i7;
import 'entities/analytics/analytics_request_details.dart' as _i8;
import 'entities/analytics/analytics_time_scope.dart' as _i9;
import 'entities/analytics/paginated_scrappable_analytics.dart' as _i10;
import 'entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i11;
import 'entities/analytics/scrappable_request_per_time_scope.dart' as _i12;
import 'entities/account/account.dart' as _i13;
import 'entities/analytics/scrappable_usage_metrics.dart' as _i14;
import 'entities/api_key_response.dart' as _i15;
import 'entities/future_calls/session_prompt.dart' as _i16;
import 'entities/marketplace/marketplace_paginated_item.dart' as _i17;
import 'entities/marketplace/paginated_scrappable_response.dart' as _i18;
import 'entities/marketplace/pagination_metadata.dart' as _i19;
import 'entities/monthly_credits_data.dart' as _i20;
import 'entities/redraft_scrappable_session/create_session_response.dart'
    as _i21;
import 'entities/redraft_scrappable_session/prompt_role_enum.dart' as _i22;
import 'entities/account/api_usage/account_api_usage.dart' as _i23;
import 'entities/account/api_usage/api_credit_history/api_creadit_history_item.dart'
    as _i24;
import 'entities/zenscrap_exception.dart' as _i25;
import 'entities/account/api_usage/api_credit_history/credit_package_purchase.dart'
    as _i26;
import 'entities/account/api_usage/api_credit_history/monthly_subscription_credit_deposit.dart'
    as _i27;
import 'entities/account/account_api_key.dart' as _i28;
import 'entities/scrappable/ai_model.dart' as _i29;
import 'entities/scrappable/byte_test_data.dart' as _i30;
import 'entities/scrappable/reference_test_data.dart' as _i31;
import 'entities/scrappable/request_status.dart' as _i32;
import 'entities/scrappable/scraper_category.dart' as _i33;
import 'entities/scrappable/scrappable.dart' as _i34;
import 'entities/scrappable/scrappable_analytics.dart' as _i35;
import 'entities/scrappable/scrappable_request.dart' as _i36;
import 'entities/scrappable/scrapping_bee_extract_logic.dart' as _i37;
import 'entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i38;
import 'entities/account/api_usage/credit_usage.dart' as _i39;
import 'package:zenscrap_server/src/generated/entities/account/api_usage/api_credit_history/api_creadit_history_item.dart'
    as _i40;
import 'package:zenscrap_server/src/generated/entities/account/account_api_key.dart'
    as _i41;
export 'entities/account/account.dart';
export 'entities/account/account_api_key.dart';
export 'entities/account/api_usage/account_api_usage.dart';
export 'entities/account/api_usage/api_credit_history/api_creadit_history_item.dart';
export 'entities/account/api_usage/api_credit_history/credit_package_purchase.dart';
export 'entities/account/api_usage/api_credit_history/monthly_subscription_credit_deposit.dart';
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
      name: 'credit_history_item',
      dartName: 'CreditHistoryItem',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'credit_history_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'date',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'monthlySubscriptionCreditDepositId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'creaditPackagePurchaseId',
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
          constraintName: 'credit_history_item_fk_0',
          columns: ['monthlySubscriptionCreditDepositId'],
          referenceTable: 'monthly_subscription_credit_deposit',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'credit_history_item_fk_1',
          columns: ['creaditPackagePurchaseId'],
          referenceTable: 'credit_package_purchase',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'credit_history_item_fk_2',
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
          indexName: 'credit_history_item_pkey',
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
      name: 'credit_package_purchase',
      dartName: 'CreditPackagePurchase',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'credit_package_purchase_id_seq\'::regclass)',
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
          indexName: 'credit_package_purchase_pkey',
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
      name: 'monthly_subscription_credit_deposit',
      dartName: 'MonthlySubscriptionCreditDeposit',
      schema: 'public',
      module: 'zenscrap',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'monthly_subscription_credit_deposit_id_seq\'::regclass)',
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
          indexName: 'monthly_subscription_credit_deposit_pkey',
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
    if (t == _i4.TestEndpointCalledSuccessResponse) {
      return _i4.TestEndpointCalledSuccessResponse.fromJson(data) as T;
    }
    if (t == _i4.MessageTextResponse) {
      return _i4.MessageTextResponse.fromJson(data) as T;
    }
    if (t == _i4.CandidateExtractLogicUpdate) {
      return _i4.CandidateExtractLogicUpdate.fromJson(data) as T;
    }
    if (t == _i4.ErrorTextResponse) {
      return _i4.ErrorTextResponse.fromJson(data) as T;
    }
    if (t == _i4.NewExtractRuleResponse) {
      return _i4.NewExtractRuleResponse.fromJson(data) as T;
    }
    if (t == _i4.TestEndpointCalledErrorResponse) {
      return _i4.TestEndpointCalledErrorResponse.fromJson(data) as T;
    }
    if (t == _i5.ScrappableRequestsAnalyticsItem) {
      return _i5.ScrappableRequestsAnalyticsItem.fromJson(data) as T;
    }
    if (t == _i6.CreditPurchaseOption) {
      return _i6.CreditPurchaseOption.fromJson(data) as T;
    }
    if (t == _i7.PlanTier) {
      return _i7.PlanTier.fromJson(data) as T;
    }
    if (t == _i8.AnalyticsRequestDetails) {
      return _i8.AnalyticsRequestDetails.fromJson(data) as T;
    }
    if (t == _i9.AnalyticsTimeScope) {
      return _i9.AnalyticsTimeScope.fromJson(data) as T;
    }
    if (t == _i10.PaginatedScrappableAnalytics) {
      return _i10.PaginatedScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i11.PaginatedScrappableRequestsAnalytics) {
      return _i11.PaginatedScrappableRequestsAnalytics.fromJson(data) as T;
    }
    if (t == _i12.ScrappableRequestPerTimeScope) {
      return _i12.ScrappableRequestPerTimeScope.fromJson(data) as T;
    }
    if (t == _i13.AccountInfo) {
      return _i13.AccountInfo.fromJson(data) as T;
    }
    if (t == _i14.ScrappableUsageMetrics) {
      return _i14.ScrappableUsageMetrics.fromJson(data) as T;
    }
    if (t == _i15.ApiKeyResponse) {
      return _i15.ApiKeyResponse.fromJson(data) as T;
    }
    if (t == _i16.SessionPrompt) {
      return _i16.SessionPrompt.fromJson(data) as T;
    }
    if (t == _i17.MarketPlacePaginatedItem) {
      return _i17.MarketPlacePaginatedItem.fromJson(data) as T;
    }
    if (t == _i18.PaginatedScrappableResponse) {
      return _i18.PaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i19.PaginationMetadata) {
      return _i19.PaginationMetadata.fromJson(data) as T;
    }
    if (t == _i20.MonthlyCreditsData) {
      return _i20.MonthlyCreditsData.fromJson(data) as T;
    }
    if (t == _i21.CreateSessionResponse) {
      return _i21.CreateSessionResponse.fromJson(data) as T;
    }
    if (t == _i22.PromptRole) {
      return _i22.PromptRole.fromJson(data) as T;
    }
    if (t == _i23.AccountApiUsage) {
      return _i23.AccountApiUsage.fromJson(data) as T;
    }
    if (t == _i24.CreditHistoryItem) {
      return _i24.CreditHistoryItem.fromJson(data) as T;
    }
    if (t == _i25.ZenScrapException) {
      return _i25.ZenScrapException.fromJson(data) as T;
    }
    if (t == _i26.CreditPackagePurchase) {
      return _i26.CreditPackagePurchase.fromJson(data) as T;
    }
    if (t == _i27.MonthlySubscriptionCreditDeposit) {
      return _i27.MonthlySubscriptionCreditDeposit.fromJson(data) as T;
    }
    if (t == _i28.AccountApiKey) {
      return _i28.AccountApiKey.fromJson(data) as T;
    }
    if (t == _i29.AiModel) {
      return _i29.AiModel.fromJson(data) as T;
    }
    if (t == _i30.ByteTestData) {
      return _i30.ByteTestData.fromJson(data) as T;
    }
    if (t == _i31.ReferenceTestData) {
      return _i31.ReferenceTestData.fromJson(data) as T;
    }
    if (t == _i32.RequestStatus) {
      return _i32.RequestStatus.fromJson(data) as T;
    }
    if (t == _i33.ScraperCategory) {
      return _i33.ScraperCategory.fromJson(data) as T;
    }
    if (t == _i34.Scrappable) {
      return _i34.Scrappable.fromJson(data) as T;
    }
    if (t == _i35.ScrappableAnalytics) {
      return _i35.ScrappableAnalytics.fromJson(data) as T;
    }
    if (t == _i36.ScrappableRequest) {
      return _i36.ScrappableRequest.fromJson(data) as T;
    }
    if (t == _i37.ScrappingBeeExtractLogic) {
      return _i37.ScrappingBeeExtractLogic.fromJson(data) as T;
    }
    if (t == _i38.UserPaginatedScrappableResponse) {
      return _i38.UserPaginatedScrappableResponse.fromJson(data) as T;
    }
    if (t == _i39.CreditUsage) {
      return _i39.CreditUsage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.TestEndpointCalledSuccessResponse?>()) {
      return (data != null
          ? _i4.TestEndpointCalledSuccessResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.MessageTextResponse?>()) {
      return (data != null ? _i4.MessageTextResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.CandidateExtractLogicUpdate?>()) {
      return (data != null
          ? _i4.CandidateExtractLogicUpdate.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.ErrorTextResponse?>()) {
      return (data != null ? _i4.ErrorTextResponse.fromJson(data) : null) as T;
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
    if (t == _i1.getType<_i5.ScrappableRequestsAnalyticsItem?>()) {
      return (data != null
          ? _i5.ScrappableRequestsAnalyticsItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.CreditPurchaseOption?>()) {
      return (data != null ? _i6.CreditPurchaseOption.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.PlanTier?>()) {
      return (data != null ? _i7.PlanTier.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AnalyticsRequestDetails?>()) {
      return (data != null ? _i8.AnalyticsRequestDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.AnalyticsTimeScope?>()) {
      return (data != null ? _i9.AnalyticsTimeScope.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PaginatedScrappableAnalytics?>()) {
      return (data != null
          ? _i10.PaginatedScrappableAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.PaginatedScrappableRequestsAnalytics?>()) {
      return (data != null
          ? _i11.PaginatedScrappableRequestsAnalytics.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.ScrappableRequestPerTimeScope?>()) {
      return (data != null
          ? _i12.ScrappableRequestPerTimeScope.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.AccountInfo?>()) {
      return (data != null ? _i13.AccountInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ScrappableUsageMetrics?>()) {
      return (data != null ? _i14.ScrappableUsageMetrics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.ApiKeyResponse?>()) {
      return (data != null ? _i15.ApiKeyResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.SessionPrompt?>()) {
      return (data != null ? _i16.SessionPrompt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.MarketPlacePaginatedItem?>()) {
      return (data != null
          ? _i17.MarketPlacePaginatedItem.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i18.PaginatedScrappableResponse?>()) {
      return (data != null
          ? _i18.PaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i19.PaginationMetadata?>()) {
      return (data != null ? _i19.PaginationMetadata.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.MonthlyCreditsData?>()) {
      return (data != null ? _i20.MonthlyCreditsData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.CreateSessionResponse?>()) {
      return (data != null ? _i21.CreateSessionResponse.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.PromptRole?>()) {
      return (data != null ? _i22.PromptRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.AccountApiUsage?>()) {
      return (data != null ? _i23.AccountApiUsage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.CreditHistoryItem?>()) {
      return (data != null ? _i24.CreditHistoryItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ZenScrapException?>()) {
      return (data != null ? _i25.ZenScrapException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CreditPackagePurchase?>()) {
      return (data != null ? _i26.CreditPackagePurchase.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.MonthlySubscriptionCreditDeposit?>()) {
      return (data != null
          ? _i27.MonthlySubscriptionCreditDeposit.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i28.AccountApiKey?>()) {
      return (data != null ? _i28.AccountApiKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.AiModel?>()) {
      return (data != null ? _i29.AiModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.ByteTestData?>()) {
      return (data != null ? _i30.ByteTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.ReferenceTestData?>()) {
      return (data != null ? _i31.ReferenceTestData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.RequestStatus?>()) {
      return (data != null ? _i32.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.ScraperCategory?>()) {
      return (data != null ? _i33.ScraperCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.Scrappable?>()) {
      return (data != null ? _i34.Scrappable.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.ScrappableAnalytics?>()) {
      return (data != null ? _i35.ScrappableAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.ScrappableRequest?>()) {
      return (data != null ? _i36.ScrappableRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.ScrappingBeeExtractLogic?>()) {
      return (data != null
          ? _i37.ScrappingBeeExtractLogic.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i38.UserPaginatedScrappableResponse?>()) {
      return (data != null
          ? _i38.UserPaginatedScrappableResponse.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i39.CreditUsage?>()) {
      return (data != null ? _i39.CreditUsage.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i12.ScrappableRequestPerTimeScope>) {
      return (data as List)
          .map((e) => deserialize<_i12.ScrappableRequestPerTimeScope>(e))
          .toList() as T;
    }
    if (t == List<_i35.ScrappableAnalytics>) {
      return (data as List)
          .map((e) => deserialize<_i35.ScrappableAnalytics>(e))
          .toList() as T;
    }
    if (t == List<_i5.ScrappableRequestsAnalyticsItem>) {
      return (data as List)
          .map((e) => deserialize<_i5.ScrappableRequestsAnalyticsItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i34.Scrappable>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i34.Scrappable>(e)).toList()
          : null) as T;
    }
    if (t == List<_i28.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i28.AccountApiKey>(e))
          .toList() as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == List<_i17.MarketPlacePaginatedItem>) {
      return (data as List)
          .map((e) => deserialize<_i17.MarketPlacePaginatedItem>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i24.CreditHistoryItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i24.CreditHistoryItem>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i28.AccountApiKey>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i28.AccountApiKey>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i35.ScrappableAnalytics>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i35.ScrappableAnalytics>(e))
              .toList()
          : null) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == List<_i34.Scrappable>) {
      return (data as List).map((e) => deserialize<_i34.Scrappable>(e)).toList()
          as T;
    }
    if (t == List<_i40.CreditHistoryItem>) {
      return (data as List)
          .map((e) => deserialize<_i40.CreditHistoryItem>(e))
          .toList() as T;
    }
    if (t == List<_i41.AccountApiKey>) {
      return (data as List)
          .map((e) => deserialize<_i41.AccountApiKey>(e))
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
    if (data is _i4.TestEndpointCalledSuccessResponse) {
      return 'TestEndpointCalledSuccessResponse';
    }
    if (data is _i4.MessageTextResponse) {
      return 'MessageTextResponse';
    }
    if (data is _i4.CandidateExtractLogicUpdate) {
      return 'CandidateExtractLogicUpdate';
    }
    if (data is _i4.ErrorTextResponse) {
      return 'ErrorTextResponse';
    }
    if (data is _i4.NewExtractRuleResponse) {
      return 'NewExtractRuleResponse';
    }
    if (data is _i4.TestEndpointCalledErrorResponse) {
      return 'TestEndpointCalledErrorResponse';
    }
    if (data is _i5.ScrappableRequestsAnalyticsItem) {
      return 'ScrappableRequestsAnalyticsItem';
    }
    if (data is _i6.CreditPurchaseOption) {
      return 'CreditPurchaseOption';
    }
    if (data is _i7.PlanTier) {
      return 'PlanTier';
    }
    if (data is _i8.AnalyticsRequestDetails) {
      return 'AnalyticsRequestDetails';
    }
    if (data is _i9.AnalyticsTimeScope) {
      return 'AnalyticsTimeScope';
    }
    if (data is _i10.PaginatedScrappableAnalytics) {
      return 'PaginatedScrappableAnalytics';
    }
    if (data is _i11.PaginatedScrappableRequestsAnalytics) {
      return 'PaginatedScrappableRequestsAnalytics';
    }
    if (data is _i12.ScrappableRequestPerTimeScope) {
      return 'ScrappableRequestPerTimeScope';
    }
    if (data is _i13.AccountInfo) {
      return 'AccountInfo';
    }
    if (data is _i14.ScrappableUsageMetrics) {
      return 'ScrappableUsageMetrics';
    }
    if (data is _i15.ApiKeyResponse) {
      return 'ApiKeyResponse';
    }
    if (data is _i16.SessionPrompt) {
      return 'SessionPrompt';
    }
    if (data is _i17.MarketPlacePaginatedItem) {
      return 'MarketPlacePaginatedItem';
    }
    if (data is _i18.PaginatedScrappableResponse) {
      return 'PaginatedScrappableResponse';
    }
    if (data is _i19.PaginationMetadata) {
      return 'PaginationMetadata';
    }
    if (data is _i20.MonthlyCreditsData) {
      return 'MonthlyCreditsData';
    }
    if (data is _i21.CreateSessionResponse) {
      return 'CreateSessionResponse';
    }
    if (data is _i22.PromptRole) {
      return 'PromptRole';
    }
    if (data is _i23.AccountApiUsage) {
      return 'AccountApiUsage';
    }
    if (data is _i24.CreditHistoryItem) {
      return 'CreditHistoryItem';
    }
    if (data is _i25.ZenScrapException) {
      return 'ZenScrapException';
    }
    if (data is _i26.CreditPackagePurchase) {
      return 'CreditPackagePurchase';
    }
    if (data is _i27.MonthlySubscriptionCreditDeposit) {
      return 'MonthlySubscriptionCreditDeposit';
    }
    if (data is _i28.AccountApiKey) {
      return 'AccountApiKey';
    }
    if (data is _i29.AiModel) {
      return 'AiModel';
    }
    if (data is _i30.ByteTestData) {
      return 'ByteTestData';
    }
    if (data is _i31.ReferenceTestData) {
      return 'ReferenceTestData';
    }
    if (data is _i32.RequestStatus) {
      return 'RequestStatus';
    }
    if (data is _i33.ScraperCategory) {
      return 'ScraperCategory';
    }
    if (data is _i34.Scrappable) {
      return 'Scrappable';
    }
    if (data is _i35.ScrappableAnalytics) {
      return 'ScrappableAnalytics';
    }
    if (data is _i36.ScrappableRequest) {
      return 'ScrappableRequest';
    }
    if (data is _i37.ScrappingBeeExtractLogic) {
      return 'ScrappingBeeExtractLogic';
    }
    if (data is _i38.UserPaginatedScrappableResponse) {
      return 'UserPaginatedScrappableResponse';
    }
    if (data is _i39.CreditUsage) {
      return 'CreditUsage';
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
    if (dataClassName == 'TestEndpointCalledSuccessResponse') {
      return deserialize<_i4.TestEndpointCalledSuccessResponse>(data['data']);
    }
    if (dataClassName == 'MessageTextResponse') {
      return deserialize<_i4.MessageTextResponse>(data['data']);
    }
    if (dataClassName == 'CandidateExtractLogicUpdate') {
      return deserialize<_i4.CandidateExtractLogicUpdate>(data['data']);
    }
    if (dataClassName == 'ErrorTextResponse') {
      return deserialize<_i4.ErrorTextResponse>(data['data']);
    }
    if (dataClassName == 'NewExtractRuleResponse') {
      return deserialize<_i4.NewExtractRuleResponse>(data['data']);
    }
    if (dataClassName == 'TestEndpointCalledErrorResponse') {
      return deserialize<_i4.TestEndpointCalledErrorResponse>(data['data']);
    }
    if (dataClassName == 'ScrappableRequestsAnalyticsItem') {
      return deserialize<_i5.ScrappableRequestsAnalyticsItem>(data['data']);
    }
    if (dataClassName == 'CreditPurchaseOption') {
      return deserialize<_i6.CreditPurchaseOption>(data['data']);
    }
    if (dataClassName == 'PlanTier') {
      return deserialize<_i7.PlanTier>(data['data']);
    }
    if (dataClassName == 'AnalyticsRequestDetails') {
      return deserialize<_i8.AnalyticsRequestDetails>(data['data']);
    }
    if (dataClassName == 'AnalyticsTimeScope') {
      return deserialize<_i9.AnalyticsTimeScope>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableAnalytics') {
      return deserialize<_i10.PaginatedScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableRequestsAnalytics') {
      return deserialize<_i11.PaginatedScrappableRequestsAnalytics>(
          data['data']);
    }
    if (dataClassName == 'ScrappableRequestPerTimeScope') {
      return deserialize<_i12.ScrappableRequestPerTimeScope>(data['data']);
    }
    if (dataClassName == 'AccountInfo') {
      return deserialize<_i13.AccountInfo>(data['data']);
    }
    if (dataClassName == 'ScrappableUsageMetrics') {
      return deserialize<_i14.ScrappableUsageMetrics>(data['data']);
    }
    if (dataClassName == 'ApiKeyResponse') {
      return deserialize<_i15.ApiKeyResponse>(data['data']);
    }
    if (dataClassName == 'SessionPrompt') {
      return deserialize<_i16.SessionPrompt>(data['data']);
    }
    if (dataClassName == 'MarketPlacePaginatedItem') {
      return deserialize<_i17.MarketPlacePaginatedItem>(data['data']);
    }
    if (dataClassName == 'PaginatedScrappableResponse') {
      return deserialize<_i18.PaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'PaginationMetadata') {
      return deserialize<_i19.PaginationMetadata>(data['data']);
    }
    if (dataClassName == 'MonthlyCreditsData') {
      return deserialize<_i20.MonthlyCreditsData>(data['data']);
    }
    if (dataClassName == 'CreateSessionResponse') {
      return deserialize<_i21.CreateSessionResponse>(data['data']);
    }
    if (dataClassName == 'PromptRole') {
      return deserialize<_i22.PromptRole>(data['data']);
    }
    if (dataClassName == 'AccountApiUsage') {
      return deserialize<_i23.AccountApiUsage>(data['data']);
    }
    if (dataClassName == 'CreditHistoryItem') {
      return deserialize<_i24.CreditHistoryItem>(data['data']);
    }
    if (dataClassName == 'ZenScrapException') {
      return deserialize<_i25.ZenScrapException>(data['data']);
    }
    if (dataClassName == 'CreditPackagePurchase') {
      return deserialize<_i26.CreditPackagePurchase>(data['data']);
    }
    if (dataClassName == 'MonthlySubscriptionCreditDeposit') {
      return deserialize<_i27.MonthlySubscriptionCreditDeposit>(data['data']);
    }
    if (dataClassName == 'AccountApiKey') {
      return deserialize<_i28.AccountApiKey>(data['data']);
    }
    if (dataClassName == 'AiModel') {
      return deserialize<_i29.AiModel>(data['data']);
    }
    if (dataClassName == 'ByteTestData') {
      return deserialize<_i30.ByteTestData>(data['data']);
    }
    if (dataClassName == 'ReferenceTestData') {
      return deserialize<_i31.ReferenceTestData>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i32.RequestStatus>(data['data']);
    }
    if (dataClassName == 'ScraperCategory') {
      return deserialize<_i33.ScraperCategory>(data['data']);
    }
    if (dataClassName == 'Scrappable') {
      return deserialize<_i34.Scrappable>(data['data']);
    }
    if (dataClassName == 'ScrappableAnalytics') {
      return deserialize<_i35.ScrappableAnalytics>(data['data']);
    }
    if (dataClassName == 'ScrappableRequest') {
      return deserialize<_i36.ScrappableRequest>(data['data']);
    }
    if (dataClassName == 'ScrappingBeeExtractLogic') {
      return deserialize<_i37.ScrappingBeeExtractLogic>(data['data']);
    }
    if (dataClassName == 'UserPaginatedScrappableResponse') {
      return deserialize<_i38.UserPaginatedScrappableResponse>(data['data']);
    }
    if (dataClassName == 'CreditUsage') {
      return deserialize<_i39.CreditUsage>(data['data']);
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
      case _i28.AccountApiKey:
        return _i28.AccountApiKey.t;
      case _i23.AccountApiUsage:
        return _i23.AccountApiUsage.t;
      case _i24.CreditHistoryItem:
        return _i24.CreditHistoryItem.t;
      case _i26.CreditPackagePurchase:
        return _i26.CreditPackagePurchase.t;
      case _i27.MonthlySubscriptionCreditDeposit:
        return _i27.MonthlySubscriptionCreditDeposit.t;
      case _i39.CreditUsage:
        return _i39.CreditUsage.t;
      case _i8.AnalyticsRequestDetails:
        return _i8.AnalyticsRequestDetails.t;
      case _i30.ByteTestData:
        return _i30.ByteTestData.t;
      case _i31.ReferenceTestData:
        return _i31.ReferenceTestData.t;
      case _i34.Scrappable:
        return _i34.Scrappable.t;
      case _i35.ScrappableAnalytics:
        return _i35.ScrappableAnalytics.t;
      case _i36.ScrappableRequest:
        return _i36.ScrappableRequest.t;
      case _i37.ScrappingBeeExtractLogic:
        return _i37.ScrappingBeeExtractLogic.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'zenscrap';
}
