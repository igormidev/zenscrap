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
import 'future_calls_generated_models/periodic_auto_fix_broken_scrappables_run_model.dart'
    as _i2;
import 'future_calls_generated_models/periodic_set_requests_analytics_run_model.dart'
    as _i3;
import 'future_calls_generated_models/periodic_cache_cleanup_run_model.dart'
    as _i4;
import 'future_calls_generated_models/periodic_cleanup_old_analytics_details_run_model.dart'
    as _i5;
import 'package:zenscrap_server/src/generated/entities/redraft_scrappable_session/create_session_response.dart'
    as _i6;
import 'package:zenscrap_server/src/generated/entities/future_calls/session_prompt.dart'
    as _i7;
import 'future_calls_generated_models/cleanup_expired_ip_spending_future_call_run_model.dart'
    as _i8;
import 'future_calls_generated_models/cleanup_expired_ip_validation_cache_future_call_run_model.dart'
    as _i9;
import 'future_calls_generated_models/cleanup_expired_pending_commits_future_call_run_model.dart'
    as _i10;
import 'future_calls_generated_models/email_idp_cleanup_future_call_run_model.dart'
    as _i11;
import 'package:zenscrap_server/src/generated/entities/monthly_credits_data.dart'
    as _i12;
import 'dart:async' as _i13;
import '../core/auto_fix/periodic_auto_fix_scrappables.dart' as _i14;
import '../core/mixins/api_helper_mixin.dart' as _i15;
import '../endpoints/public/scrappable_chat_session.dart' as _i16;
import '../future_calls/cleanup_expired_ip_spending_future_call.dart' as _i17;
import '../future_calls/cleanup_expired_ip_validation_cache_future_call.dart'
    as _i18;
import '../future_calls/cleanup_expired_pending_commits_future_call.dart'
    as _i19;
import '../future_calls/email_idp_cleanup_future_call.dart' as _i20;
import '../future_calls/monthly_subscription_credits_future_call.dart' as _i21;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _i1.SerializableModel? object);

extension ServerpodFutureCallsGetter on _i1.Serverpod {
  /// Generated future calls.
  FutureCalls get futureCalls => FutureCalls();
}

class FutureCalls extends _i1.FutureCallDispatch<_FutureCallRef> {
  FutureCalls._();

  factory FutureCalls() {
    return _instance;
  }

  static final FutureCalls _instance = FutureCalls._();

  _i1.FutureCallManager? _futureCallManager;

  String? _serverId;

  String get _effectiveServerId {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _serverId!;
  }

  _i1.FutureCallManager get _effectiveFutureCallManager {
    if (_futureCallManager == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _futureCallManager!;
  }

  @override
  void initialize(_i1.FutureCallManager futureCallManager, String serverId) {
    var registeredFutureCalls = <String, _i1.FutureCall>{
      'PeriodicAutoFixBrokenScrappablesRunFutureCall':
          PeriodicAutoFixBrokenScrappablesRunFutureCall(),
      'PeriodicSetRequestsAnalyticsRunFutureCall':
          PeriodicSetRequestsAnalyticsRunFutureCall(),
      'PeriodicCacheCleanupRunFutureCall': PeriodicCacheCleanupRunFutureCall(),
      'PeriodicCleanupOldAnalyticsDetailsRunFutureCall':
          PeriodicCleanupOldAnalyticsDetailsRunFutureCall(),
      'TestScrappableDisposeDisposeSessionFutureCall':
          TestScrappableDisposeDisposeSessionFutureCall(),
      'SessionPromptProcessPromptFutureCall':
          SessionPromptProcessPromptFutureCall(),
      'CleanupExpiredIpSpendingRunFutureCall':
          CleanupExpiredIpSpendingRunFutureCall(),
      'CleanupExpiredIpValidationCacheRunFutureCall':
          CleanupExpiredIpValidationCacheRunFutureCall(),
      'CleanupExpiredPendingCommitsRunFutureCall':
          CleanupExpiredPendingCommitsRunFutureCall(),
      'EmailIdpCleanupRunFutureCall': EmailIdpCleanupRunFutureCall(),
      'MonthlySubscriptionCreditsAddCreditsFutureCall':
          MonthlySubscriptionCreditsAddCreditsFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  @override
  _FutureCallRef callAtTime(DateTime time, {String? identifier}) {
    return _FutureCallRef((name, object) {
      return _effectiveFutureCallManager.scheduleFutureCall(
        name,
        object,
        time,
        _effectiveServerId,
        identifier,
      );
    });
  }

  @override
  _FutureCallRef callWithDelay(Duration delay, {String? identifier}) {
    return _FutureCallRef((name, object) {
      return _effectiveFutureCallManager.scheduleFutureCall(
        name,
        object,
        DateTime.now().toUtc().add(delay),
        _effectiveServerId,
        identifier,
      );
    });
  }

  @override
  Future<void> cancel(String identifier) async {
    await _effectiveFutureCallManager.cancelFutureCall(identifier);
  }
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  late final periodicAutoFixBrokenScrappables =
      _PeriodicAutoFixBrokenScrappablesFutureCallDispatcher(_invokeFutureCall);

  late final periodicSetRequestsAnalytics =
      _PeriodicSetRequestsAnalyticsFutureCallDispatcher(_invokeFutureCall);

  late final periodicCacheCleanup = _PeriodicCacheCleanupFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final periodicCleanupOldAnalyticsDetails =
      _PeriodicCleanupOldAnalyticsDetailsFutureCallDispatcher(
        _invokeFutureCall,
      );

  late final testScrappableDispose = _TestScrappableDisposeFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final sessionPrompt = _SessionPromptFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final cleanupExpiredIpSpending =
      _CleanupExpiredIpSpendingFutureCallDispatcher(_invokeFutureCall);

  late final cleanupExpiredIpValidationCache =
      _CleanupExpiredIpValidationCacheFutureCallDispatcher(_invokeFutureCall);

  late final cleanupExpiredPendingCommits =
      _CleanupExpiredPendingCommitsFutureCallDispatcher(_invokeFutureCall);

  late final emailIdpCleanup = _EmailIdpCleanupFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final monthlySubscriptionCredits =
      _MonthlySubscriptionCreditsFutureCallDispatcher(_invokeFutureCall);
}

class _PeriodicAutoFixBrokenScrappablesFutureCallDispatcher {
  _PeriodicAutoFixBrokenScrappablesFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i2.PeriodicAutoFixBrokenScrappablesRunModel(_: _);
    return _invokeFutureCall(
      'PeriodicAutoFixBrokenScrappablesRunFutureCall',
      object,
    );
  }
}

class _PeriodicSetRequestsAnalyticsFutureCallDispatcher {
  _PeriodicSetRequestsAnalyticsFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i3.PeriodicSetRequestsAnalyticsRunModel(_: _);
    return _invokeFutureCall(
      'PeriodicSetRequestsAnalyticsRunFutureCall',
      object,
    );
  }
}

class _PeriodicCacheCleanupFutureCallDispatcher {
  _PeriodicCacheCleanupFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i4.PeriodicCacheCleanupRunModel(_: _);
    return _invokeFutureCall('PeriodicCacheCleanupRunFutureCall', object);
  }
}

class _PeriodicCleanupOldAnalyticsDetailsFutureCallDispatcher {
  _PeriodicCleanupOldAnalyticsDetailsFutureCallDispatcher(
    this._invokeFutureCall,
  );

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i5.PeriodicCleanupOldAnalyticsDetailsRunModel(_: _);
    return _invokeFutureCall(
      'PeriodicCleanupOldAnalyticsDetailsRunFutureCall',
      object,
    );
  }
}

class _TestScrappableDisposeFutureCallDispatcher {
  _TestScrappableDisposeFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> disposeSession(_i6.CreateSessionResponse object) {
    return _invokeFutureCall(
      'TestScrappableDisposeDisposeSessionFutureCall',
      object,
    );
  }
}

class _SessionPromptFutureCallDispatcher {
  _SessionPromptFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> processPrompt(_i7.SessionPrompt object) {
    return _invokeFutureCall('SessionPromptProcessPromptFutureCall', object);
  }
}

class _CleanupExpiredIpSpendingFutureCallDispatcher {
  _CleanupExpiredIpSpendingFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i8.CleanupExpiredIpSpendingFutureCallRunModel(_: _);
    return _invokeFutureCall('CleanupExpiredIpSpendingRunFutureCall', object);
  }
}

class _CleanupExpiredIpValidationCacheFutureCallDispatcher {
  _CleanupExpiredIpValidationCacheFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i9.CleanupExpiredIpValidationCacheFutureCallRunModel(_: _);
    return _invokeFutureCall(
      'CleanupExpiredIpValidationCacheRunFutureCall',
      object,
    );
  }
}

class _CleanupExpiredPendingCommitsFutureCallDispatcher {
  _CleanupExpiredPendingCommitsFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i10.CleanupExpiredPendingCommitsFutureCallRunModel(_: _);
    return _invokeFutureCall(
      'CleanupExpiredPendingCommitsRunFutureCall',
      object,
    );
  }
}

class _EmailIdpCleanupFutureCallDispatcher {
  _EmailIdpCleanupFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> run([bool? _]) {
    var object = _i11.EmailIdpCleanupFutureCallRunModel(_: _);
    return _invokeFutureCall('EmailIdpCleanupRunFutureCall', object);
  }
}

class _MonthlySubscriptionCreditsFutureCallDispatcher {
  _MonthlySubscriptionCreditsFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> addCredits(_i12.MonthlyCreditsData object) {
    return _invokeFutureCall(
      'MonthlySubscriptionCreditsAddCreditsFutureCall',
      object,
    );
  }
}

class PeriodicAutoFixBrokenScrappablesRunFutureCall
    extends _i1.FutureCall<_i2.PeriodicAutoFixBrokenScrappablesRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i2.PeriodicAutoFixBrokenScrappablesRunModel? object,
  ) async {
    if (object != null) {
      await _i14.PeriodicAutoFixBrokenScrappables().run(session, object._);
    }
  }
}

class PeriodicSetRequestsAnalyticsRunFutureCall
    extends _i1.FutureCall<_i3.PeriodicSetRequestsAnalyticsRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i3.PeriodicSetRequestsAnalyticsRunModel? object,
  ) async {
    if (object != null) {
      await _i15.PeriodicSetRequestsAnalytics().run(session, object._);
    }
  }
}

class PeriodicCacheCleanupRunFutureCall
    extends _i1.FutureCall<_i4.PeriodicCacheCleanupRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i4.PeriodicCacheCleanupRunModel? object,
  ) async {
    if (object != null) {
      await _i15.PeriodicCacheCleanup().run(session, object._);
    }
  }
}

class PeriodicCleanupOldAnalyticsDetailsRunFutureCall
    extends _i1.FutureCall<_i5.PeriodicCleanupOldAnalyticsDetailsRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i5.PeriodicCleanupOldAnalyticsDetailsRunModel? object,
  ) async {
    if (object != null) {
      await _i15.PeriodicCleanupOldAnalyticsDetails().run(session, object._);
    }
  }
}

class TestScrappableDisposeDisposeSessionFutureCall
    extends _i1.FutureCall<_i6.CreateSessionResponse> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i6.CreateSessionResponse? object,
  ) async {
    await _i16.TestScrappableDisposeFutureCall().disposeSession(
      session,
      object!,
    );
  }
}

class SessionPromptProcessPromptFutureCall
    extends _i1.FutureCall<_i7.SessionPrompt> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i7.SessionPrompt? object,
  ) async {
    await _i16.SessionPromptFutureCall().processPrompt(session, object!);
  }
}

class CleanupExpiredIpSpendingRunFutureCall
    extends _i1.FutureCall<_i8.CleanupExpiredIpSpendingFutureCallRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i8.CleanupExpiredIpSpendingFutureCallRunModel? object,
  ) async {
    if (object != null) {
      await _i17.CleanupExpiredIpSpendingFutureCall().run(session, object._);
    }
  }
}

class CleanupExpiredIpValidationCacheRunFutureCall
    extends
        _i1.FutureCall<_i9.CleanupExpiredIpValidationCacheFutureCallRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i9.CleanupExpiredIpValidationCacheFutureCallRunModel? object,
  ) async {
    if (object != null) {
      await _i18.CleanupExpiredIpValidationCacheFutureCall().run(
        session,
        object._,
      );
    }
  }
}

class CleanupExpiredPendingCommitsRunFutureCall
    extends
        _i1.FutureCall<_i10.CleanupExpiredPendingCommitsFutureCallRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i10.CleanupExpiredPendingCommitsFutureCallRunModel? object,
  ) async {
    if (object != null) {
      await _i19.CleanupExpiredPendingCommitsFutureCall().run(
        session,
        object._,
      );
    }
  }
}

class EmailIdpCleanupRunFutureCall
    extends _i1.FutureCall<_i11.EmailIdpCleanupFutureCallRunModel> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i11.EmailIdpCleanupFutureCallRunModel? object,
  ) async {
    if (object != null) {
      await _i20.EmailIdpCleanupFutureCall().run(session, object._);
    }
  }
}

class MonthlySubscriptionCreditsAddCreditsFutureCall
    extends _i1.FutureCall<_i12.MonthlyCreditsData> {
  @override
  _i13.Future<void> invoke(
    _i1.Session session,
    _i12.MonthlyCreditsData? object,
  ) async {
    await _i21.MonthlySubscriptionCreditsFutureCall().addCredits(
      session,
      object!,
    );
  }
}
