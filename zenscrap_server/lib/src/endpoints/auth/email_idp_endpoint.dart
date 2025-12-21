import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Email Identity Provider Endpoint
/// Exposes email/password authentication endpoints for the client
/// Handles registration, login, password reset, and email verification
/// Required by Serverpod 3.1 IDP authentication system
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
  }) async {
    // Check if email is already registered before starting registration
    // The base implementation returns an invalid ID if email exists,
    // but doesn't inform the client. We throw an exception instead.
    final existingAccount = await AuthServices.instance.emailIdp.admin
        .findAccount(session, email: email);

    if (existingAccount != null) {
      session.log(
        'Registration blocked: email "$email" is already registered',
        level: LogLevel.info,
      );
      // Throw custom exception that the client can catch and handle.
      // The exception toString() contains "already registered" which triggers
      // AuthErrorMapper's emailAlreadyExists pattern matching.
      throw EmailAlreadyRegisteredException(email: email);
    }

    return super.startRegistration(session, email: email);
  }

  @override
  Future<AuthSuccess> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    session.log(
      '[DEBUG] Login attempt for email: $email, password length: ${password.length}',
      level: LogLevel.info,
    );

    try {
      final result = await super.login(session, email: email, password: password);
      session.log(
        '[DEBUG] Login successful for email: $email',
        level: LogLevel.info,
      );
      return result;
    } catch (e, stackTrace) {
      session.log(
        '[DEBUG] Login failed for email: $email, error: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<AuthSuccess> finishRegistration(
    Session session, {
    required String registrationToken,
    required String password,
  }) async {
    session.log(
      '[DEBUG] finishRegistration called with token length: ${registrationToken.length}, password length: ${password.length}',
      level: LogLevel.info,
    );

    try {
      final result = await super.finishRegistration(
        session,
        registrationToken: registrationToken,
        password: password,
      );
      session.log(
        '[DEBUG] finishRegistration successful',
        level: LogLevel.info,
      );
      return result;
    } catch (e, stackTrace) {
      session.log(
        '[DEBUG] finishRegistration failed, error: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
