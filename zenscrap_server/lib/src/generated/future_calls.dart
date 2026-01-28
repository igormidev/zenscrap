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
import 'dart:async' as _i2;
import '../core/auto_fix/periodic_auto_fix_scrappables.dart' as _i3;
import '../core/mixins/api_helper_mixin.dart' as _i4;

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
  void initialize(
    _i1.FutureCallManager futureCallManager,
    String serverId,
  ) {
    var registeredFutureCalls = <String, _i1.FutureCall>{
      'PeriodicAutoFixBrokenScrappablesInvokeFutureCall':
          PeriodicAutoFixBrokenScrappablesInvokeFutureCall(),
      'PeriodicCacheCleanupInvokeFutureCall':
          PeriodicCacheCleanupInvokeFutureCall(),
      'PeriodicCleanupOldAnalyticsDetailsInvokeFutureCall':
          PeriodicCleanupOldAnalyticsDetailsInvokeFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  @override
  _FutureCallRef callAtTime(
    DateTime time, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          time,
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          DateTime.now().toUtc().add(delay),
          _effectiveServerId,
          identifier,
        );
      },
    );
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

  late final periodicCacheCleanup = _PeriodicCacheCleanupFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final periodicCleanupOldAnalyticsDetails =
      _PeriodicCleanupOldAnalyticsDetailsFutureCallDispatcher(
        _invokeFutureCall,
      );
}

class _PeriodicAutoFixBrokenScrappablesFutureCallDispatcher {
  _PeriodicAutoFixBrokenScrappablesFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? _) {
    return _invokeFutureCall(
      'PeriodicAutoFixBrokenScrappablesInvokeFutureCall',
      _,
    );
  }
}

class _PeriodicCacheCleanupFutureCallDispatcher {
  _PeriodicCacheCleanupFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? _) {
    return _invokeFutureCall(
      'PeriodicCacheCleanupInvokeFutureCall',
      _,
    );
  }
}

class _PeriodicCleanupOldAnalyticsDetailsFutureCallDispatcher {
  _PeriodicCleanupOldAnalyticsDetailsFutureCallDispatcher(
    this._invokeFutureCall,
  );

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? _) {
    return _invokeFutureCall(
      'PeriodicCleanupOldAnalyticsDetailsInvokeFutureCall',
      _,
    );
  }
}

class PeriodicAutoFixBrokenScrappablesInvokeFutureCall
    extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? _,
  ) async {
    await _i3.PeriodicAutoFixBrokenScrappables().invoke(
      session,
      _,
    );
  }
}

class PeriodicCacheCleanupInvokeFutureCall
    extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? _,
  ) async {
    await _i4.PeriodicCacheCleanup().invoke(
      session,
      _,
    );
  }
}

class PeriodicCleanupOldAnalyticsDetailsInvokeFutureCall
    extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? _,
  ) async {
    await _i4.PeriodicCleanupOldAnalyticsDetails().invoke(
      session,
      _,
    );
  }
}
