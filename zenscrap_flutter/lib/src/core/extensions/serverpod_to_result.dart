import 'package:result_dart/result_dart.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';

extension ServerpodToResultExt<T extends Object> on Future<T> {
  AsyncResultDart<T, ZenScrapException> get toResult async {
    try {
      return Success(await this);
    } on ZenScrapException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(defaultException);
    }
  }
}

extension ServerpodToResultVoidExt on Future<void> {
  AsyncResultDart<void, ZenScrapException> get toResult async {
    try {
      await this;
      return const Success(Unit);
    } on ZenScrapException catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(e);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace);
      return Failure(defaultException);
    }
  }
}
