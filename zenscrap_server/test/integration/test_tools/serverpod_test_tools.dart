/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_test/serverpod_test.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'package:zenscrap_server/src/generated/entities/auth/user_profile_response.dart'
    as _i5;
import 'package:zenscrap_server/src/generated/entities/account/account.dart'
    as _i6;
import 'package:zenscrap_server/src/generated/entities/supported_language.dart'
    as _i7;
import 'package:zenscrap_server/src/generated/entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart'
    as _i8;
import 'package:zenscrap_server/src/generated/entities/account/ai_usage/account_ai_usage.dart'
    as _i9;
import 'package:zenscrap_server/src/generated/entities/scrappable/auto_fix/paginated_auto_fix_session_response.dart'
    as _i10;
import 'package:zenscrap_server/src/generated/entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart'
    as _i11;
import 'package:zenscrap_server/src/generated/entities/account/account_api_key.dart'
    as _i12;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i13;
import 'package:zenscrap_server/src/generated/entities/account/api_usage/account_api_usage.dart'
    as _i14;
import 'package:zenscrap_server/src/generated/entities/api_key_response.dart'
    as _i15;
import 'package:zenscrap_server/src/generated/entities/account/credit_purchase_option.dart'
    as _i16;
import 'package:zenscrap_server/src/generated/entities/scrappable/scrappable.dart'
    as _i17;
import 'package:zenscrap_server/src/generated/entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i18;
import 'package:zenscrap_server/src/generated/entities/analytics/analytics_time_scope.dart'
    as _i19;
import 'package:zenscrap_server/src/generated/entities/analytics/paginated_scrappable_analytics.dart'
    as _i20;
import 'package:zenscrap_server/src/generated/entities/analytics/scrappable_usage_metrics.dart'
    as _i21;
import 'package:zenscrap_server/src/generated/entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i22;
import 'package:zenscrap_server/src/generated/entities/scrappable/scraper_category.dart'
    as _i23;
import 'package:zenscrap_server/src/generated/entities/create_scrappable_stream/create_scrappable_stream_item.dart'
    as _i24;
import 'dart:convert' as _i25;
import 'package:zenscrap_server/src/generated/entities/scrappable/ai_model.dart'
    as _i26;
import 'package:zenscrap_server/src/generated/entities/marketplace/paginated_scrappable_response.dart'
    as _i27;
import 'package:zenscrap_server/src/generated/entities/scrappable/byte_test_data.dart'
    as _i28;
import 'package:zenscrap_server/src/generated/entities/account/plan_tier.dart'
    as _i29;
import 'package:zenscrap_server/src/generated/entities/redraft_scrappable_session/create_session_response.dart'
    as _i30;
import 'package:zenscrap_server/src/generated/entities/redraft_scrappable_session/chat_response.dart'
    as _i31;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/periodic_auto_fix_broken_scrappables_run_model.dart'
    as _i32;
import 'package:zenscrap_server/src/generated/future_calls.dart' as _i33;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/periodic_set_requests_analytics_run_model.dart'
    as _i34;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/periodic_cache_cleanup_run_model.dart'
    as _i35;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/periodic_cleanup_old_analytics_details_run_model.dart'
    as _i36;
import 'package:zenscrap_server/src/generated/entities/future_calls/session_prompt.dart'
    as _i37;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/cleanup_expired_ip_spending_future_call_run_model.dart'
    as _i38;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/cleanup_expired_ip_validation_cache_future_call_run_model.dart'
    as _i39;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/cleanup_expired_pending_commits_future_call_run_model.dart'
    as _i40;
import 'package:zenscrap_server/src/generated/future_calls_generated_models/email_idp_cleanup_future_call_run_model.dart'
    as _i41;
import 'package:zenscrap_server/src/generated/entities/monthly_credits_data.dart'
    as _i42;
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
/// [testServerOutputMode] Options for controlling test server output during test execution. Defaults to `TestServerOutputMode.normal`.
/// ```dart
/// /// Options for controlling test server output during test execution.
/// enum TestServerOutputMode {
///   /// Default mode - only stderr is printed (stdout suppressed).
///   /// This hides normal startup/shutdown logs while preserving error messages.
///   normal,
///
///   /// All logging - both stdout and stderr are printed.
///   /// Useful for debugging when you need to see all server output.
///   verbose,
///
///   /// No logging - both stdout and stderr are suppressed.
///   /// Completely silent mode, useful when you don't want any server output.
///   silent,
/// }
/// ```
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
  _i1.TestServerOutputMode? testServerOutputMode,
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
      testServerOutputMode: testServerOutputMode,
      experimentalFeatures: experimentalFeatures,
      runtimeParametersBuilder: runtimeParametersBuilder,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
    maybeTestServerOutputMode: testServerOutputMode,
  )(testClosure);
}

class TestEndpoints {
  late final futureCalls = _FutureCalls();

  late final _EmailIdpEndpoint emailIdp;

  late final _GoogleIdpEndpoint googleIdp;

  late final _RefreshJwtTokensEndpoint refreshJwtTokens;

  late final _UserProfileEndpoint userProfile;

  late final _PrivateAccountEndpoint privateAccount;

  late final _PrivateAiUsageEndpoint privateAiUsage;

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
    emailIdp = _EmailIdpEndpoint(
      endpoints,
      serializationManager,
    );
    googleIdp = _GoogleIdpEndpoint(
      endpoints,
      serializationManager,
    );
    refreshJwtTokens = _RefreshJwtTokensEndpoint(
      endpoints,
      serializationManager,
    );
    userProfile = _UserProfileEndpoint(
      endpoints,
      serializationManager,
    );
    privateAccount = _PrivateAccountEndpoint(
      endpoints,
      serializationManager,
    );
    privateAiUsage = _PrivateAiUsageEndpoint(
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

class _FutureCalls {
  late final periodicAutoFixBrokenScrappables =
      _PeriodicAutoFixBrokenScrappablesFutureCall();

  late final periodicSetRequestsAnalytics =
      _PeriodicSetRequestsAnalyticsFutureCall();

  late final periodicCacheCleanup = _PeriodicCacheCleanupFutureCall();

  late final periodicCleanupOldAnalyticsDetails =
      _PeriodicCleanupOldAnalyticsDetailsFutureCall();

  late final testScrappableDispose = _TestScrappableDisposeFutureCall();

  late final sessionPrompt = _SessionPromptFutureCall();

  late final cleanupExpiredIpSpending = _CleanupExpiredIpSpendingFutureCall();

  late final cleanupExpiredIpValidationCache =
      _CleanupExpiredIpValidationCacheFutureCall();

  late final cleanupExpiredPendingCommits =
      _CleanupExpiredPendingCommitsFutureCall();

  late final emailIdpCleanup = _EmailIdpCleanupFutureCall();

  late final monthlySubscriptionCredits =
      _MonthlySubscriptionCreditsFutureCall();
}

class _EmailIdpEndpoint {
  _EmailIdpEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i2.UuidValue> startRegistration(
    _i1.TestSessionBuilder sessionBuilder, {
    required String email,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'startRegistration',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'startRegistration',
          parameters: _i1.testObjectToJson({'email': email}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i2.UuidValue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.AuthSuccess> login(
    _i1.TestSessionBuilder sessionBuilder, {
    required String email,
    required String password,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'login',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'login',
          parameters: _i1.testObjectToJson({
            'email': email,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i4.AuthSuccess> finishRegistration(
    _i1.TestSessionBuilder sessionBuilder, {
    required String registrationToken,
    required String password,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'finishRegistration',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'finishRegistration',
          parameters: _i1.testObjectToJson({
            'registrationToken': registrationToken,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> verifyRegistrationCode(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'verifyRegistrationCode',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'verifyRegistrationCode',
          parameters: _i1.testObjectToJson({
            'accountRequestId': accountRequestId,
            'verificationCode': verificationCode,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i2.UuidValue> startPasswordReset(
    _i1.TestSessionBuilder sessionBuilder, {
    required String email,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'startPasswordReset',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'startPasswordReset',
          parameters: _i1.testObjectToJson({'email': email}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i2.UuidValue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> verifyPasswordResetCode(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'verifyPasswordResetCode',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'verifyPasswordResetCode',
          parameters: _i1.testObjectToJson({
            'passwordResetRequestId': passwordResetRequestId,
            'verificationCode': verificationCode,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> finishPasswordReset(
    _i1.TestSessionBuilder sessionBuilder, {
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'finishPasswordReset',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'finishPasswordReset',
          parameters: _i1.testObjectToJson({
            'finishPasswordResetToken': finishPasswordResetToken,
            'newPassword': newPassword,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> hasAccount(_i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'hasAccount',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'hasAccount',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _GoogleIdpEndpoint {
  _GoogleIdpEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i4.AuthSuccess> login(
    _i1.TestSessionBuilder sessionBuilder, {
    required String idToken,
    required String? accessToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'googleIdp',
            method: 'login',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'googleIdp',
          methodName: 'login',
          parameters: _i1.testObjectToJson({
            'idToken': idToken,
            'accessToken': accessToken,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> hasAccount(_i1.TestSessionBuilder sessionBuilder) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'googleIdp',
            method: 'hasAccount',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'googleIdp',
          methodName: 'hasAccount',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _RefreshJwtTokensEndpoint {
  _RefreshJwtTokensEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i4.AuthSuccess> refreshAccessToken(
    _i1.TestSessionBuilder sessionBuilder, {
    required String refreshToken,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'refreshJwtTokens',
            method: 'refreshAccessToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'refreshJwtTokens',
          methodName: 'refreshAccessToken',
          parameters: _i1.testObjectToJson({'refreshToken': refreshToken}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i4.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _UserProfileEndpoint {
  _UserProfileEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i5.UserProfileResponse> getCurrentUserProfile(
    _i1.TestSessionBuilder sessionBuilder,
  ) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'userProfile',
            method: 'getCurrentUserProfile',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'userProfile',
          methodName: 'getCurrentUserProfile',
          parameters: _i1.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i5.UserProfileResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PrivateAccountEndpoint {
  _PrivateAccountEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i6.AccountInfo> getAccountInfo(
    _i1.TestSessionBuilder sessionBuilder, {
    required int? initialScrappableId,
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'initialScrappableId': initialScrappableId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i6.AccountInfo>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _PrivateAiUsageEndpoint {
  _PrivateAiUsageEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _i2.EndpointDispatch _endpointDispatch;

  final _i2.SerializationManager _serializationManager;

  _i3.Future<_i8.PaginatedAICreditHistoryResponse> getAiCreditHistory(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'privateAiUsage',
            method: 'getAiCreditHistory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateAiUsage',
          methodName: 'getAiCreditHistory',
          parameters: _i1.testObjectToJson({
            'page': page,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i8.PaginatedAICreditHistoryResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i9.AccountAIUsage> getAiUsageInfo(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'privateAiUsage',
            method: 'getAiUsageInfo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateAiUsage',
          methodName: 'getAiUsageInfo',
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i9.AccountAIUsage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i9.AccountAIUsage> updateOpenAiApiKey(
    _i1.TestSessionBuilder sessionBuilder, {
    String? apiKey,
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'privateAiUsage',
            method: 'updateOpenAiApiKey',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateAiUsage',
          methodName: 'updateOpenAiApiKey',
          parameters: _i1.testObjectToJson({
            'apiKey': apiKey,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i9.AccountAIUsage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i10.PaginatedAutoFixSessionResponse> getAutoFixSessions(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'privateAiUsage',
            method: 'getAutoFixSessions',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateAiUsage',
          methodName: 'getAutoFixSessions',
          parameters: _i1.testObjectToJson({
            'page': page,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i10.PaginatedAutoFixSessionResponse>);
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

  _i3.Future<_i11.PaginatedApiCreditHistoryResponse> getApiCreditHistory(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'privateApiUsage',
            method: 'getApiCreditHistory',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateApiUsage',
          methodName: 'getApiCreditHistory',
          parameters: _i1.testObjectToJson({
            'page': page,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i11.PaginatedApiCreditHistoryResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i12.AccountApiKey> createApiKey(
    _i1.TestSessionBuilder sessionBuilder, {
    required String name,
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'name': name,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i12.AccountApiKey>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> deactivateApiKey(
    _i1.TestSessionBuilder sessionBuilder, {
    required int apiKeyId,
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'apiKeyId': apiKeyId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<List<_i12.AccountApiKey>> getActiveApiKeys(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<List<_i12.AccountApiKey>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<int, int>> getApiKeyUsageStats(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue = await _localCallContext.method
            .call(
              _localUniqueSession,
              _localCallContext.arguments,
            )
            .then((map) => _i13.Protocol().deserialize<Map<int, int>>(map));
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i14.AccountApiUsage> getApiUsageInfo(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i14.AccountApiUsage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i15.ApiKeyResponse> getApiKeysWithStats(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i15.ApiKeyResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> createCreditPurchaseCheckout(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i16.CreditPurchaseOption creditPackage,
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'creditPackage': creditPackage,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
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

  _i3.Future<_i17.Scrappable> cloneFromMarketplace(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i17.Scrappable>);
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

  _i3.Future<_i18.PaginatedScrappableRequestsAnalytics>
  getScrappableAnalyticsWithScope(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    required _i19.AnalyticsTimeScope scope,
    required _i7.SupportedLanguage language,
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
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i18.PaginatedScrappableRequestsAnalytics>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i20.PaginatedScrappableAnalytics> getScrappableAnalytics(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
    required int page,
    required _i7.SupportedLanguage language,
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
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i20.PaginatedScrappableAnalytics>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i21.ScrappableUsageMetrics> getScrappableUsageMetrics(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i21.ScrappableUsageMetrics>);
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

  _i3.Future<_i6.AccountInfo> syncSubscriptionFromStripe(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'privateSubscription',
            method: 'syncSubscriptionFromStripe',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'privateSubscription',
          methodName: 'syncSubscriptionFromStripe',
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i6.AccountInfo>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> createCheckoutSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required String planTier,
    required bool isYearly,
    required _i7.SupportedLanguage language,
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
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<Map<String, dynamic>> getSubscriptionStatus(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<Map<String, dynamic>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<bool> cancelSubscription(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<String> createCustomerPortalSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({'language': language}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<String>);
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

  _i3.Future<_i22.UserPaginatedScrappableResponse> call(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    String? searchQuery,
    List<_i23.ScraperCategory>? categories,
    required _i7.SupportedLanguage language,
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
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i22.UserPaginatedScrappableResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i17.Scrappable> getScrappableById(
    _i1.TestSessionBuilder sessionBuilder,
    int scrappableId, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i17.Scrappable>);
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

  _i3.Stream<_i24.CreateScrappableStreamItem> call(
    _i1.TestSessionBuilder sessionBuilder, {
    required String referenceLink,
    required _i7.SupportedLanguage language,
  }) {
    var _localTestStreamManager =
        _i1.TestStreamManager<_i24.CreateScrappableStreamItem>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'createScrappable',
              method: 'call',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'createScrappable',
              methodName: 'call',
              arguments: {
                'referenceLink': referenceLink,
                'language': _i25.jsonDecode(
                  _i2.SerializationManager.encode(language),
                ),
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
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
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
    required _i7.SupportedLanguage language,
    _i23.ScraperCategory? category,
    bool? willHideFromMarketplace,
    bool? autoFixEnabled,
    int? autoFixConsecutiveErrorThreshold,
    _i26.AiModel? autoFixPreferredAiModel,
    bool? autoFixUseAutoAiModel,
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
            'language': language,
            'category': category,
            'willHideFromMarketplace': willHideFromMarketplace,
            'autoFixEnabled': autoFixEnabled,
            'autoFixConsecutiveErrorThreshold':
                autoFixConsecutiveErrorThreshold,
            'autoFixPreferredAiModel': autoFixPreferredAiModel,
            'autoFixUseAutoAiModel': autoFixUseAutoAiModel,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<bool>);
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

  _i3.Future<_i27.PaginatedScrappableResponse> getItems(
    _i1.TestSessionBuilder sessionBuilder, {
    required int page,
    String? searchQuery,
    List<_i23.ScraperCategory>? categories,
    required _i7.SupportedLanguage language,
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
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i27.PaginatedScrappableResponse>);
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

  _i3.Future<_i28.ByteTestData?> getByteTestData(
    _i1.TestSessionBuilder sessionBuilder,
    int scrappableId, {
    required _i7.SupportedLanguage language,
  }) async {
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
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i28.ByteTestData?>);
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
    required _i29.PlanTier planTier,
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
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
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
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'sessionUuid': sessionUuid,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
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
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> updateUserApiKey(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionId,
    required String openAiApiKey,
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'scrappableChatSession',
            method: 'updateUserApiKey',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'updateUserApiKey',
          parameters: _i1.testObjectToJson({
            'sessionId': sessionId,
            'openAiApiKey': openAiApiKey,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<void> updateScrappableRequest(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
    required String url,
    required List<String> pathParams,
    required Map<String, String?> queryParams,
    required _i7.SupportedLanguage language,
  }) async {
    return _i1.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
            endpoint: 'scrappableChatSession',
            method: 'updateScrappableRequest',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'scrappableChatSession',
          methodName: 'updateScrappableRequest',
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'url': url,
            'pathParams': pathParams,
            'queryParams': queryParams,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Future<_i30.CreateSessionResponse> createSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required int scrappableId,
    required _i7.SupportedLanguage language,
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
          parameters: _i1.testObjectToJson({
            'scrappableId': scrappableId,
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<_i30.CreateSessionResponse>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _i3.Stream<_i31.ChatResponse> listenToScrappableRedraftSession(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionUuid,
    required _i7.SupportedLanguage language,
  }) {
    var _localTestStreamManager = _i1.TestStreamManager<_i31.ChatResponse>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'scrappableChatSession',
              method: 'listenToScrappableRedraftSession',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'scrappableChatSession',
              methodName: 'listenToScrappableRedraftSession',
              arguments: {
                'sessionUuid': sessionUuid,
                'language': _i25.jsonDecode(
                  _i2.SerializationManager.encode(language),
                ),
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

  _i3.Future<void> changeChatModel(
    _i1.TestSessionBuilder sessionBuilder, {
    required String sessionUuid,
    required _i26.AiModel aiModel,
    required _i7.SupportedLanguage language,
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
            'language': language,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _i3.Future<void>);
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
    required _i7.SupportedLanguage language,
  }) {
    var _localTestStreamManager = _i1.TestStreamManager<String>();
    _i1.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _i1.InternalTestSessionBuilder).internalBuild(
              endpoint: 'scrappableChatSession',
              method: 'sendPromptMessage',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'scrappableChatSession',
              methodName: 'sendPromptMessage',
              arguments: {
                'sessionId': sessionId,
                'userPrompt': userPrompt,
                'language': _i25.jsonDecode(
                  _i2.SerializationManager.encode(language),
                ),
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

class _PeriodicAutoFixBrokenScrappablesFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i32.PeriodicAutoFixBrokenScrappablesRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.PeriodicAutoFixBrokenScrappablesRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _PeriodicSetRequestsAnalyticsFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i34.PeriodicSetRequestsAnalyticsRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.PeriodicSetRequestsAnalyticsRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _PeriodicCacheCleanupFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i35.PeriodicCacheCleanupRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.PeriodicCacheCleanupRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _PeriodicCleanupOldAnalyticsDetailsFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i36.PeriodicCleanupOldAnalyticsDetailsRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.PeriodicCleanupOldAnalyticsDetailsRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _TestScrappableDisposeFutureCall {
  Future<void> disposeSession(
    _i1.TestSessionBuilder sessionBuilder,
    _i30.CreateSessionResponse object,
  ) async {
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.TestScrappableDisposeDisposeSessionFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _SessionPromptFutureCall {
  Future<void> processPrompt(
    _i1.TestSessionBuilder sessionBuilder,
    _i37.SessionPrompt object,
  ) async {
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.SessionPromptProcessPromptFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _CleanupExpiredIpSpendingFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i38.CleanupExpiredIpSpendingFutureCallRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.CleanupExpiredIpSpendingRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _CleanupExpiredIpValidationCacheFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i39.CleanupExpiredIpValidationCacheFutureCallRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.CleanupExpiredIpValidationCacheRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _CleanupExpiredPendingCommitsFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i40.CleanupExpiredPendingCommitsFutureCallRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.CleanupExpiredPendingCommitsRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _EmailIdpCleanupFutureCall {
  Future<void> run(
    _i1.TestSessionBuilder sessionBuilder, [
    bool? _,
  ]) async {
    var object = _i41.EmailIdpCleanupFutureCallRunModel(_: _);
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.EmailIdpCleanupRunFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _MonthlySubscriptionCreditsFutureCall {
  Future<void> addCredits(
    _i1.TestSessionBuilder sessionBuilder,
    _i42.MonthlyCreditsData object,
  ) async {
    var _localUniqueSession = (sessionBuilder as _i1.InternalTestSessionBuilder)
        .internalBuild();
    try {
      await _i33.MonthlySubscriptionCreditsAddCreditsFutureCall().invoke(
        _localUniqueSession,
        object,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}
