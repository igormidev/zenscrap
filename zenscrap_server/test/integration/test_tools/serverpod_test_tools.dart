/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:zenscrap_server/src/generated/entities/account/account.dart'
    as _i4;
import 'package:zenscrap_server/src/generated/entities/account/api_usage/api_credit_history/api_creadit_history_item.dart'
    as _i5;
import 'package:zenscrap_server/src/generated/entities/account/account_api_key.dart'
    as _i6;
import 'package:zenscrap_server/src/generated/entities/account/api_usage/account_api_usage.dart'
    as _i7;
import 'package:zenscrap_server/src/generated/entities/api_key_response.dart'
    as _i8;
import 'package:zenscrap_server/src/generated/entities/account/credit_purchase_option.dart'
    as _i9;
import 'package:zenscrap_server/src/generated/entities/scrappable/scrappable.dart'
    as _i10;
import 'package:zenscrap_server/src/generated/entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i11;
import 'package:zenscrap_server/src/generated/entities/analytics/analytics_time_scope.dart'
    as _i12;
import 'package:zenscrap_server/src/generated/entities/analytics/paginated_scrappable_analytics.dart'
    as _i13;
import 'package:zenscrap_server/src/generated/entities/analytics/scrappable_usage_metrics.dart'
    as _i14;
import 'package:zenscrap_server/src/generated/entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i15;
import 'package:zenscrap_server/src/generated/entities/scrappable/scraper_category.dart'
    as _i16;
import 'package:zenscrap_server/src/generated/entities/marketplace/paginated_scrappable_response.dart'
    as _i17;
import 'package:zenscrap_server/src/generated/entities/scrappable/byte_test_data.dart'
    as _i18;
import 'package:zenscrap_server/src/generated/entities/account/plan_tier.dart'
    as _i19;
import 'package:zenscrap_server/src/generated/entities/redraft_scrappable_session/create_session_response.dart'
    as _i20;
import 'package:zenscrap_server/src/generated/entities/redraft_scrappable_session/chat_response.dart'
    as _i21;
import 'package:zenscrap_server/src/generated/entities/scrappable/ai_model.dart'
    as _i22;
import 'package:zenscrap_server/src/generated/protocol.dart';
import 'package:zenscrap_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [applyMigrations] Whether pending migrations should be applied when starting Serverpod. Defaults to `true`
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [rollbackDatabase] Options for when to rollback the database during the test lifecycle.
/// By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
/// Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
/// ```dart
/// /// Options for when to rollback the database during the test lifecycle.
/// enum RollbackDatabase {
///   /// After each test. This is the default.
///   afterEach,
///
///   /// After all tests.
///   afterAll,
///
///   /// Disable rolling back the database.
///   disabled,
/// }
/// ```
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 30)`.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
@_i1.isTestGroup
void withServerpod(
  String testGroupName,
  _i1.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  bool? enableSessionLogging,
  _i2.ExperimentalFeatures? experimentalFeatures,
  _i1.RollbackDatabase? rollbackDatabase,
  String? runMode,
  _i2.RuntimeParametersListBuilder? runtimeParametersBuilder,
  _i2.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
}) {
  _i1.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _i1.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      experimentalFeatures: experimentalFeatures,
      runtimeParametersBuilder: runtimeParametersBuilder,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
  )(testClosure);
}

class TestEndpoints {
  late final _PrivateAccountEndpoint privateAccount;

  late final _PrivateApiUsageEndpoint privateApiUsage;

  late final _PrivateCloneScrappableEndpoint privateCloneScrappable;

  late final _PrivateScrappableAnalyticsEndpoint privateScrappableAnalytics;

  late final _PrivateSubscriptionEndpoint privateSubscription;

  late final _PrivateUserScrappablesEndpoint privateUserScrappables;

  late final _CreateScrappableEndpoint createScrappable;

  late final _DeleteScrappableEndpoint deleteScrappable;

  late final _EditScrappableEndpoint editScrappable;

  late final _MarketplaceEndpoint marketplace;

  late final _PublicScrappableEndpoint publicScrappable;

  late final _PublicTierEndpoint publicTier;

  late final _ScrappableChatSession scrappableChatSession;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _i1.InternalTestEndpoints {
  @override
  void initialize(
    _i2.SerializationManager serializationManager,
    _i2.EndpointDispatch endpoints,
  ) {
    privateAccount = _PrivateAccountEndpoint(
      endpoints,
      serializationManager,
    );
    privateApiUsage = _PrivateApiUsageEndpoint(
      endpoints,
      serializationManager,
    );
    privateCloneScrappable = _PrivateCloneScrappableEndpoint(
      endpoints,
      serializationManager,
    );
    privateScrappableAnalytics = _PrivateScrappableAnalyticsEndpoint(
      endpoints,
      serializationManager,
    );
    privateSubscription = _PrivateSubscriptionEndpoint(
      endpoints,
      serializationManager,
    );
    privateUserScrappables = _PrivateUserScrappablesEndpoint(
      endpoints,
      serializationManager,
    );
    createScrappable = _CreateScrappableEndpoint(
      endpoints,
      serializationManager,
    );
    deleteScrappable = _DeleteScrappableEndpoint(
      endpoints,
      serializationManager,
    );
    editScrappable = _EditScrappableEndpoint(
      endpoints,
      serializationManager,
    );
    marketplace = _MarketplaceEndpoint(
      endpoints,
      serializationManager,
    );
    publicScrappable = _PublicScrappableEndpoint(
      endpoints,
      serializationManager,
    );
    publicTier = _PublicTierEndpoint(
      endpoints,
      serializationManager,
    );
    scrappableChatSession = _ScrappableChatSession(
      endpoints,
      serializationManager,
    );
  }
}

class _PrivateAccountEndpoint {
  _PrivateAccountEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i4.AccountInfo> getAccountInfo(
    _i1.TestSessionBuilder sessionBuilder, {
    required int? initialScrappableId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateAccount',
        method: 'getAccountInfo',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateAccount',
          methodName: 'getAccountInfo',
          parameters: _i1
              .testObjectToJson({'initialScrappableId': initialScrappableId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i4.AccountInfo>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PrivateApiUsageEndpoint {
  _PrivateApiUsageEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<List<_i5.CreditHistoryItem>> getCreditHistory(
    _i1.TestSessionBuilder sessionBuilder, {
    required int offset,
    required int limit,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'getCreditHistory',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'getCreditHistory',
          parameters: _i1.testObjectToJson({
            'offset': offset,
            'limit': limit,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i5.CreditHistoryItem>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i6.AccountApiKey> createApiKey(
    _i1.TestSessionBuilder sessionBuilder, {
    required String name,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'createApiKey',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'createApiKey',
          parameters: _i1.testObjectToJson({'name': name}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i6.AccountApiKey>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deactivateApiKey(
    _i1.TestSessionBuilder sessionBuilder, {
    required int apiKeyId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'deactivateApiKey',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'deactivateApiKey',
          parameters: _i1.testObjectToJson({'apiKeyId': apiKeyId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i6.AccountApiKey>> getActiveApiKeys(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'getActiveApiKeys',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'getActiveApiKeys',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<List<_i6.AccountApiKey>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<int, int>> getApiKeyUsageStats(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'getApiKeyUsageStats',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'getApiKeyUsageStats',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<Map<int, int>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i7.AccountApiUsage> getApiUsageInfo(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'getApiUsageInfo',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'getApiUsageInfo',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i7.AccountApiUsage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i8.ApiKeyResponse> getApiKeysWithStats(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'getApiKeysWithStats',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'getApiKeysWithStats',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i8.ApiKeyResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> createCreditPurchaseCheckout(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i9.CreditPurchaseOption creditPackage,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateApiUsage',
        method: 'createCreditPurchaseCheckout',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'createCreditPurchaseCheckout',
          parameters: _i1.testObjectToJson({'creditPackage': creditPackage}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PrivateCloneScrappableEndpoint {
  _PrivateCloneScrappableEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i10.Scrappable> cloneFromMarketplace(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateCloneScrappable',
        method: 'cloneFromMarketplace',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateCloneScrappable',
          methodName: 'cloneFromMarketplace',
          parameters: _i1.testObjectToJson({'scrappableId': scrappableId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i10.Scrappable>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PrivateScrappableAnalyticsEndpoint {
  _PrivateScrappableAnalyticsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i11.PaginatedScrappableRequestsAnalytics>
      getScrappableAnalyticsWithScope(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    required _i12.AnalyticsTimeScope scope,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateScrappableAnalytics',
        method: 'getScrappableAnalyticsWithScope',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateScrappableAnalytics',
          methodName: 'getScrappableAnalyticsWithScope',
          parameters: _i1.testObjectToJson({
            'page': page,
            'scope': scope,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i11.PaginatedScrappableRequestsAnalytics>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i13.PaginatedScrappableAnalytics> getScrappableAnalytics(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
    required int page,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateScrappableAnalytics',
        method: 'getScrappableAnalytics',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateScrappableAnalytics',
          methodName: 'getScrappableAnalytics',
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'page': page,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i13.PaginatedScrappableAnalytics>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i14.ScrappableUsageMetrics> getScrappableUsageMetrics(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateScrappableAnalytics',
        method: 'getScrappableUsageMetrics',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateScrappableAnalytics',
          methodName: 'getScrappableUsageMetrics',
          parameters: _i1.testObjectToJson({'scrappableId': scrappableId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i14.ScrappableUsageMetrics>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PrivateSubscriptionEndpoint {
  _PrivateSubscriptionEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<String> createCheckoutSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required String planTier,
    required bool isYearly,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateSubscription',
        method: 'createCheckoutSession',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateSubscription',
          methodName: 'createCheckoutSession',
          parameters: _i1.testObjectToJson({
            'planTier': planTier,
            'isYearly': isYearly,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<String, dynamic>> getSubscriptionStatus(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateSubscription',
        method: 'getSubscriptionStatus',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateSubscription',
          methodName: 'getSubscriptionStatus',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<Map<String, dynamic>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> cancelSubscription(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateSubscription',
        method: 'cancelSubscription',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateSubscription',
          methodName: 'cancelSubscription',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> createCustomerPortalSession(
      _i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateSubscription',
        method: 'createCustomerPortalSession',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateSubscription',
          methodName: 'createCustomerPortalSession',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PrivateUserScrappablesEndpoint {
  _PrivateUserScrappablesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i15.UserPaginatedScrappableResponse> call(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    String? searchQuery,
    List<_i16.ScraperCategory>? categories,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateUserScrappables',
        method: 'call',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateUserScrappables',
          methodName: 'call',
          parameters: _i1.testObjectToJson({
            'page': page,
            'searchQuery': searchQuery,
            'categories': categories,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i15.UserPaginatedScrappableResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i10.Scrappable> getScrappableById(
    _i1.TestSessionBuilder sessionBuilder,
    int scrappableId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'privateUserScrappables',
        method: 'getScrappableById',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateUserScrappables',
          methodName: 'getScrappableById',
          parameters: _i1.testObjectToJson({'scrappableId': scrappableId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i10.Scrappable>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CreateScrappableEndpoint {
  _CreateScrappableEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Stream<_i10.Scrappable> call(
    _i1.TestSessionBuilder sessionBuilder, {
    required String referenceLink,
  }) {
    var _localTestStreamManager = _i1.TestStreamManager<_i10.Scrappable>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
          endpoint: 'createScrappable',
          method: 'call',
        );
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'createScrappable',
          methodName: 'call',
          arguments: {'referenceLink': referenceLink},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _DeleteScrappableEndpoint {
  _DeleteScrappableEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> call(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'deleteScrappable',
        method: 'call',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'deleteScrappable',
          methodName: 'call',
          parameters: _i1.testObjectToJson({'scrappableId': scrappableId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _EditScrappableEndpoint {
  _EditScrappableEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<bool> call(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
    required String name,
    required String description,
    _i16.ScraperCategory? category,
    bool? willHideFromMarketplace,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'editScrappable',
        method: 'call',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'editScrappable',
          methodName: 'call',
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'name': name,
            'description': description,
            'category': category,
            'willHideFromMarketplace': willHideFromMarketplace,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _MarketplaceEndpoint {
  _MarketplaceEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i17.PaginatedScrappableResponse> getItems(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    String? searchQuery,
    List<_i16.ScraperCategory>? categories,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'marketplace',
        method: 'getItems',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'marketplace',
          methodName: 'getItems',
          parameters: _i1.testObjectToJson({
            'page': page,
            'searchQuery': searchQuery,
            'categories': categories,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i17.PaginatedScrappableResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PublicScrappableEndpoint {
  _PublicScrappableEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i18.ByteTestData?> getByteTestData(
    _i1.TestSessionBuilder sessionBuilder,
    int scrappableId,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'publicScrappable',
        method: 'getByteTestData',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'publicScrappable',
          methodName: 'getByteTestData',
          parameters: _i1.testObjectToJson({'scrappableId': scrappableId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i18.ByteTestData?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PublicTierEndpoint {
  _PublicTierEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> updatePlayerTier(
    _i1.TestSessionBuilder sessionBuilder, {
    required String email,
    required String tierManipulationKey,
    required _i19.PlanTier planTier,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'publicTier',
        method: 'updatePlayerTier',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'publicTier',
          methodName: 'updatePlayerTier',
          parameters: _i1.testObjectToJson({
            'email': email,
            'tierManipulationKey': tierManipulationKey,
            'planTier': planTier,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ScrappableChatSession {
  _ScrappableChatSession(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<void> commitCurrentEditState(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionUuid,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'scrappableChatSession',
        method: 'commitCurrentEditState',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'commitCurrentEditState',
          parameters: _i1.testObjectToJson({'sessionUuid': sessionUuid}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> disposeSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'scrappableChatSession',
        method: 'disposeSession',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'disposeSession',
          parameters: _i1.testObjectToJson({'sessionId': sessionId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i20.CreateSessionResponse> createSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'scrappableChatSession',
        method: 'createSession',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'createSession',
          parameters: _i1.testObjectToJson({'scrappableId': scrappableId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<_i20.CreateSessionResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Stream<_i21.ChatResponse> listenToScrappableRedraftSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionUuid,
  }) {
    var _localTestStreamManager = _i1.TestStreamManager<_i21.ChatResponse>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
          endpoint: 'scrappableChatSession',
          method: 'listenToScrappableRedraftSession',
        );
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'listenToScrappableRedraftSession',
          arguments: {'sessionUuid': sessionUuid},
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }

  _i3.Future<void> changeChatModel(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionUuid,
    required _i22.AiModel aiModel,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
        endpoint: 'scrappableChatSession',
        method: 'changeChatModel',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'changeChatModel',
          parameters: _i1.testObjectToJson({
            'sessionUuid': sessionUuid,
            'aiModel': aiModel,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await (_localCallContext.method.call(
          _localUniqueSession,
          _localCallContext.arguments,
        ) as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Stream<String> sendPromptMessage(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionId,
    required String userPrompt,
  }) {
    var _localTestStreamManager = _i1.TestStreamManager<String>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
          endpoint: 'scrappableChatSession',
          method: 'sendPromptMessage',
        );
        var _localCallContext =
            await _endpointDispatch.getMethodStreamCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'sendPromptMessage',
          arguments: {
            'sessionId': sessionId,
            'userPrompt': userPrompt,
          },
          requestedInputStreams: [],
          serializationManager: _serializationManager,
        );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}
