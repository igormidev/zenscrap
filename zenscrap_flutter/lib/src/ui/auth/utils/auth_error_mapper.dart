import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';

/// Enumeration of all possible authentication error types.
/// Based on Serverpod 3.x auth module error scenarios:
/// - Login errors: invalid credentials, rate limiting
/// - Registration errors: email already exists, invalid verification code
/// - Password reset errors: invalid/expired code, rate limiting
/// - General errors: network issues, server errors
enum AuthErrorType {
  // Login errors
  invalidCredentials,
  accountNotFound,
  accountDisabled,
  accountLocked,

  // Registration errors
  emailAlreadyExists,
  invalidVerificationCode,
  expiredVerificationCode,
  weakPassword,
  invalidEmailFormat,

  // Password reset errors
  passwordResetCodeInvalid,
  passwordResetCodeExpired,
  passwordResetRateLimited,

  // Rate limiting
  tooManyAttempts,
  loginRateLimited,
  verificationRateLimited,

  // Google Sign-In specific errors
  googleSignInCancelled,
  googleSignInFailed,
  googleAccountNotVerified,
  googleAccountDomainRestricted,

  // Network and server errors
  networkError,
  serverError,
  timeout,
  connectionRefused,

  // Generic/unknown error
  unknown,
}

/// Represents a mapped authentication error with user-friendly information.
class AuthError {
  /// The type of authentication error
  final AuthErrorType type;

  /// The original error object or message
  final dynamic originalError;

  /// Whether this error is recoverable (user can try again)
  final bool isRecoverable;

  /// Whether this error should suggest the user to try later
  final bool suggestTryLater;

  const AuthError({
    required this.type,
    this.originalError,
    this.isRecoverable = true,
    this.suggestTryLater = false,
  });

  /// Gets a user-friendly title for the error
  String getTitle(AppLocalizations l10n) {
    switch (type) {
      case AuthErrorType.invalidCredentials:
      case AuthErrorType.accountNotFound:
        return l10n.authErrorInvalidCredentialsTitle;
      case AuthErrorType.accountDisabled:
      case AuthErrorType.accountLocked:
        return l10n.authErrorAccountLockedTitle;
      case AuthErrorType.emailAlreadyExists:
        return l10n.authErrorEmailExistsTitle;
      case AuthErrorType.invalidVerificationCode:
      case AuthErrorType.passwordResetCodeInvalid:
        return l10n.authErrorInvalidCodeTitle;
      case AuthErrorType.expiredVerificationCode:
      case AuthErrorType.passwordResetCodeExpired:
        return l10n.authErrorExpiredCodeTitle;
      case AuthErrorType.weakPassword:
        return l10n.authErrorWeakPasswordTitle;
      case AuthErrorType.invalidEmailFormat:
        return l10n.authErrorInvalidEmailTitle;
      case AuthErrorType.tooManyAttempts:
      case AuthErrorType.loginRateLimited:
      case AuthErrorType.verificationRateLimited:
      case AuthErrorType.passwordResetRateLimited:
        return l10n.authErrorRateLimitedTitle;
      case AuthErrorType.googleSignInCancelled:
        return l10n.authErrorGoogleCancelledTitle;
      case AuthErrorType.googleSignInFailed:
        return l10n.authErrorGoogleFailedTitle;
      case AuthErrorType.googleAccountNotVerified:
        return l10n.authErrorGoogleNotVerifiedTitle;
      case AuthErrorType.googleAccountDomainRestricted:
        return l10n.authErrorGoogleDomainRestrictedTitle;
      case AuthErrorType.networkError:
      case AuthErrorType.connectionRefused:
        return l10n.authErrorNetworkTitle;
      case AuthErrorType.serverError:
        return l10n.authErrorServerTitle;
      case AuthErrorType.timeout:
        return l10n.authErrorTimeoutTitle;
      case AuthErrorType.unknown:
        return l10n.authErrorUnknownTitle;
    }
  }

  /// Gets a user-friendly description for the error
  String getDescription(AppLocalizations l10n) {
    switch (type) {
      case AuthErrorType.invalidCredentials:
        return l10n.authErrorInvalidCredentialsDescription;
      case AuthErrorType.accountNotFound:
        return l10n.authErrorAccountNotFoundDescription;
      case AuthErrorType.accountDisabled:
        return l10n.authErrorAccountDisabledDescription;
      case AuthErrorType.accountLocked:
        return l10n.authErrorAccountLockedDescription;
      case AuthErrorType.emailAlreadyExists:
        return l10n.authErrorEmailExistsDescription;
      case AuthErrorType.invalidVerificationCode:
        return l10n.authErrorInvalidCodeDescription;
      case AuthErrorType.expiredVerificationCode:
        return l10n.authErrorExpiredCodeDescription;
      case AuthErrorType.weakPassword:
        return l10n.authErrorWeakPasswordDescription;
      case AuthErrorType.invalidEmailFormat:
        return l10n.authErrorInvalidEmailDescription;
      case AuthErrorType.tooManyAttempts:
        return l10n.authErrorTooManyAttemptsDescription;
      case AuthErrorType.loginRateLimited:
        return l10n.authErrorLoginRateLimitedDescription;
      case AuthErrorType.verificationRateLimited:
        return l10n.authErrorVerificationRateLimitedDescription;
      case AuthErrorType.passwordResetCodeInvalid:
        return l10n.authErrorPasswordResetCodeInvalidDescription;
      case AuthErrorType.passwordResetCodeExpired:
        return l10n.authErrorPasswordResetCodeExpiredDescription;
      case AuthErrorType.passwordResetRateLimited:
        return l10n.authErrorPasswordResetRateLimitedDescription;
      case AuthErrorType.googleSignInCancelled:
        return l10n.authErrorGoogleCancelledDescription;
      case AuthErrorType.googleSignInFailed:
        return l10n.authErrorGoogleFailedDescription;
      case AuthErrorType.googleAccountNotVerified:
        return l10n.authErrorGoogleNotVerifiedDescription;
      case AuthErrorType.googleAccountDomainRestricted:
        return l10n.authErrorGoogleDomainRestrictedDescription;
      case AuthErrorType.networkError:
        return l10n.authErrorNetworkDescription;
      case AuthErrorType.connectionRefused:
        return l10n.authErrorConnectionRefusedDescription;
      case AuthErrorType.serverError:
        return l10n.authErrorServerDescription;
      case AuthErrorType.timeout:
        return l10n.authErrorTimeoutDescription;
      case AuthErrorType.unknown:
        return l10n.authErrorUnknownDescription;
    }
  }

  /// Gets the appropriate button text for this error
  String getButtonText(AppLocalizations l10n) {
    if (suggestTryLater) {
      return l10n.authErrorButtonTryLater;
    }
    if (!isRecoverable) {
      return l10n.authErrorButtonOk;
    }
    return l10n.authErrorButtonTryAgain;
  }
}

/// Maps authentication errors from various sources to user-friendly AuthError objects.
///
/// Serverpod 3.x auth module does not provide specific exception types.
/// Instead, errors come through:
/// - onError callbacks with generic error objects/strings
/// - errorMessage property on controllers
/// - ServerpodException for server errors
/// - Boolean return values (false = failure)
///
/// This mapper analyzes error messages and exceptions to determine the specific
/// error type and provide appropriate user-facing messages.
class AuthErrorMapper {
  /// Maps any error to an AuthError object.
  ///
  /// [error] can be:
  /// - A String error message
  /// - An Exception object
  /// - A ServerpodException
  /// - Serverpod 3.x auth exceptions (EmailAccountLoginException, etc.)
  /// - Any other error object
  ///
  /// [context] provides additional context about where the error occurred,
  /// which helps in determining the error type more accurately.
  static AuthError mapError(dynamic error, {AuthContext? context}) {
    // Handle null or empty errors
    if (error == null) {
      return const AuthError(type: AuthErrorType.unknown);
    }

    // Convert to string for pattern matching
    final errorString = error.toString().toLowerCase();

    // Debug logging in development
    if (kDebugMode) {
      // ignore: avoid_print
      print('[AuthErrorMapper] Mapping error: $error');
      // ignore: avoid_print
      print('[AuthErrorMapper] Error type: ${error.runtimeType}');
      // ignore: avoid_print
      print('[AuthErrorMapper] Error string: $errorString');
      // ignore: avoid_print
      print('[AuthErrorMapper] Context: $context');
    }

    // Handle Serverpod 3.x specific auth exceptions first
    // These are the typed exceptions from serverpod_auth_idp_client

    // EmailAccountLoginException - login failures (wrong password, rate limit)
    if (error is EmailAccountLoginException) {
      return _mapEmailLoginException(error);
    }

    // EmailAccountRequestException - registration failures
    if (error is EmailAccountRequestException) {
      return _mapEmailRequestException(error);
    }

    // EmailAccountPasswordResetException - password reset failures
    if (error is EmailAccountPasswordResetException) {
      return _mapPasswordResetException(error);
    }

    // InvalidEmailException - email format validation error
    if (error is InvalidEmailException) {
      return AuthError(
        type: AuthErrorType.invalidEmailFormat,
        originalError: error,
      );
    }

    // EmailAlreadyRegisteredException - custom exception for duplicate email
    if (error is EmailAlreadyRegisteredException) {
      return AuthError(
        type: AuthErrorType.emailAlreadyExists,
        originalError: error,
      );
    }

    // Check for ServerpodException
    if (error is ServerpodClientException) {
      return _mapServerpodException(error, context);
    }

    // Check for network-related errors
    if (_isNetworkError(errorString)) {
      return AuthError(
        type: AuthErrorType.networkError,
        originalError: error,
        suggestTryLater: true,
      );
    }

    // Check for timeout errors
    if (_isTimeoutError(errorString)) {
      return AuthError(
        type: AuthErrorType.timeout,
        originalError: error,
        suggestTryLater: true,
      );
    }

    // Map based on context and error message patterns
    return _mapByPattern(errorString, error, context);
  }

  /// Maps EmailAccountLoginException to AuthError.
  /// This handles Serverpod 3.x login-specific errors.
  static AuthError _mapEmailLoginException(EmailAccountLoginException error) {
    return switch (error.reason) {
      EmailAccountLoginExceptionReason.invalidCredentials => AuthError(
          type: AuthErrorType.invalidCredentials,
          originalError: error,
        ),
      EmailAccountLoginExceptionReason.tooManyAttempts => AuthError(
          type: AuthErrorType.loginRateLimited,
          originalError: error,
          suggestTryLater: true,
        ),
      EmailAccountLoginExceptionReason.unknown => AuthError(
          type: AuthErrorType.unknown,
          originalError: error,
        ),
    };
  }

  /// Maps EmailAccountRequestException to AuthError.
  /// This handles Serverpod 3.x registration-specific errors.
  static AuthError _mapEmailRequestException(
      EmailAccountRequestException error) {
    return switch (error.reason) {
      EmailAccountRequestExceptionReason.expired => AuthError(
          type: AuthErrorType.expiredVerificationCode,
          originalError: error,
        ),
      EmailAccountRequestExceptionReason.invalid => AuthError(
          type: AuthErrorType.invalidVerificationCode,
          originalError: error,
        ),
      EmailAccountRequestExceptionReason.policyViolation => AuthError(
          type: AuthErrorType.weakPassword,
          originalError: error,
        ),
      EmailAccountRequestExceptionReason.tooManyAttempts => AuthError(
          type: AuthErrorType.verificationRateLimited,
          originalError: error,
          suggestTryLater: true,
        ),
      EmailAccountRequestExceptionReason.unknown => AuthError(
          type: AuthErrorType.unknown,
          originalError: error,
        ),
    };
  }

  /// Maps EmailAccountPasswordResetException to AuthError.
  /// This handles Serverpod 3.x password reset-specific errors.
  static AuthError _mapPasswordResetException(
      EmailAccountPasswordResetException error) {
    return switch (error.reason) {
      EmailAccountPasswordResetExceptionReason.expired => AuthError(
          type: AuthErrorType.passwordResetCodeExpired,
          originalError: error,
        ),
      EmailAccountPasswordResetExceptionReason.invalid => AuthError(
          type: AuthErrorType.passwordResetCodeInvalid,
          originalError: error,
        ),
      EmailAccountPasswordResetExceptionReason.policyViolation => AuthError(
          type: AuthErrorType.weakPassword,
          originalError: error,
        ),
      EmailAccountPasswordResetExceptionReason.tooManyAttempts => AuthError(
          type: AuthErrorType.passwordResetRateLimited,
          originalError: error,
          suggestTryLater: true,
        ),
      EmailAccountPasswordResetExceptionReason.unknown => AuthError(
          type: AuthErrorType.unknown,
          originalError: error,
        ),
    };
  }

  /// Maps error messages from EmailAuthController's errorMessage property.
  static AuthError mapControllerError(String? errorMessage,
      {AuthContext? context}) {
    if (errorMessage == null || errorMessage.isEmpty) {
      return const AuthError(type: AuthErrorType.unknown);
    }
    return mapError(errorMessage, context: context);
  }

  /// Creates an AuthError for when a user cancels Google Sign-In.
  static AuthError googleSignInCancelled() {
    return const AuthError(
      type: AuthErrorType.googleSignInCancelled,
      isRecoverable: true,
    );
  }

  /// Creates an AuthError for when login fails without specific error message.
  static AuthError loginFailed() {
    return const AuthError(
      type: AuthErrorType.invalidCredentials,
      isRecoverable: true,
    );
  }

  /// Creates an AuthError for when registration fails without specific error message.
  static AuthError registrationFailed() {
    return const AuthError(
      type: AuthErrorType.unknown,
      isRecoverable: true,
    );
  }

  /// Creates an AuthError for when verification code validation fails.
  static AuthError verificationCodeFailed() {
    return const AuthError(
      type: AuthErrorType.invalidVerificationCode,
      isRecoverable: true,
    );
  }

  /// Creates an AuthError for when password reset fails.
  static AuthError passwordResetFailed() {
    return const AuthError(
      type: AuthErrorType.passwordResetCodeInvalid,
      isRecoverable: true,
    );
  }

  // Private helper methods

  static AuthError _mapServerpodException(
      ServerpodClientException exception, AuthContext? context) {
    final message = exception.message.toLowerCase();
    final statusCode = exception.statusCode;

    // 500 Internal Server Error
    if (statusCode == 500) {
      return AuthError(
        type: AuthErrorType.serverError,
        originalError: exception,
        isRecoverable: false,
        suggestTryLater: true,
      );
    }

    // 429 Too Many Requests (rate limiting)
    if (statusCode == 429) {
      final type = switch (context) {
        AuthContext.login => AuthErrorType.loginRateLimited,
        AuthContext.registration => AuthErrorType.verificationRateLimited,
        AuthContext.passwordReset => AuthErrorType.passwordResetRateLimited,
        AuthContext.verification => AuthErrorType.verificationRateLimited,
        _ => AuthErrorType.tooManyAttempts,
      };
      return AuthError(
        type: type,
        originalError: exception,
        suggestTryLater: true,
      );
    }

    // 401 Unauthorized
    if (statusCode == 401) {
      return AuthError(
        type: AuthErrorType.invalidCredentials,
        originalError: exception,
      );
    }

    // 403 Forbidden
    if (statusCode == 403) {
      return AuthError(
        type: AuthErrorType.accountLocked,
        originalError: exception,
        isRecoverable: false,
      );
    }

    // Check message patterns
    return _mapByPattern(message, exception, context);
  }

  static bool _isNetworkError(String errorString) {
    final networkPatterns = [
      'socketexception',
      'socket exception',
      'network',
      'connection failed',
      'connection refused',
      'no internet',
      'unreachable',
      'failed host lookup',
      'host lookup',
      'dns',
      'econnrefused',
      'enotfound',
      'enetunreach',
    ];
    return networkPatterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _isTimeoutError(String errorString) {
    final timeoutPatterns = [
      'timeout',
      'timed out',
      'time out',
      'etimedout',
    ];
    return timeoutPatterns.any((pattern) => errorString.contains(pattern));
  }

  static AuthError _mapByPattern(
      String errorString, dynamic originalError, AuthContext? context) {
    // Rate limiting patterns
    if (_matchesRateLimitPattern(errorString)) {
      final type = switch (context) {
        AuthContext.login => AuthErrorType.loginRateLimited,
        AuthContext.registration => AuthErrorType.verificationRateLimited,
        AuthContext.passwordReset => AuthErrorType.passwordResetRateLimited,
        AuthContext.verification => AuthErrorType.verificationRateLimited,
        _ => AuthErrorType.tooManyAttempts,
      };
      return AuthError(
        type: type,
        originalError: originalError,
        suggestTryLater: true,
      );
    }

    // Invalid credentials patterns
    if (_matchesInvalidCredentialsPattern(errorString)) {
      return AuthError(
        type: AuthErrorType.invalidCredentials,
        originalError: originalError,
      );
    }

    // Email already exists patterns
    if (_matchesEmailExistsPattern(errorString)) {
      return AuthError(
        type: AuthErrorType.emailAlreadyExists,
        originalError: originalError,
      );
    }

    // Invalid verification code patterns
    if (_matchesInvalidCodePattern(errorString)) {
      final type = context == AuthContext.passwordReset
          ? AuthErrorType.passwordResetCodeInvalid
          : AuthErrorType.invalidVerificationCode;
      return AuthError(
        type: type,
        originalError: originalError,
      );
    }

    // Expired code patterns
    if (_matchesExpiredCodePattern(errorString)) {
      final type = context == AuthContext.passwordReset
          ? AuthErrorType.passwordResetCodeExpired
          : AuthErrorType.expiredVerificationCode;
      return AuthError(
        type: type,
        originalError: originalError,
      );
    }

    // Weak password patterns
    if (_matchesWeakPasswordPattern(errorString)) {
      return AuthError(
        type: AuthErrorType.weakPassword,
        originalError: originalError,
      );
    }

    // Account disabled/locked patterns
    if (_matchesAccountLockedPattern(errorString)) {
      return AuthError(
        type: AuthErrorType.accountLocked,
        originalError: originalError,
        isRecoverable: false,
      );
    }

    // Google sign-in specific errors
    if (_matchesGoogleErrorPattern(errorString)) {
      return _mapGoogleError(errorString, originalError);
    }

    // Default to unknown error
    return AuthError(
      type: AuthErrorType.unknown,
      originalError: originalError,
    );
  }

  static bool _matchesRateLimitPattern(String errorString) {
    final patterns = [
      'rate limit',
      'rate-limit',
      'ratelimit',
      'too many',
      'try again later',
      'too many attempts',
      'too many requests',
      'exceeded',
      'limit exceeded',
      'throttle',
      'throttled',
      // Serverpod 3.x patterns
      'toomanyattempts', // EmailAccountLoginExceptionReason.tooManyAttempts
      'too many failed login attempts',
      'too many failed registration attempts',
      'too many failed password reset attempts',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _matchesInvalidCredentialsPattern(String errorString) {
    final patterns = [
      // Generic credential patterns
      'invalid credentials',
      'invalid password',
      'wrong password',
      'incorrect password',
      'password incorrect',
      'invalid email',
      'email not found',
      'user not found',
      'account not found',
      'no account',
      'authentication failed',
      'login failed',
      'invalid login',
      'unauthorized',
      // Serverpod 3.x UserFacingException messages (from convertToUserFacingException)
      'invalid email or password',
      'please check your credentials',
      // Serverpod 3.x exception reason names (when toString() is called)
      'invalidcredentials', // EmailAccountLoginExceptionReason.invalidCredentials
      'emailaccountloginexception',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _matchesEmailExistsPattern(String errorString) {
    final patterns = [
      'email already',
      'email exists',
      'already registered',
      'already in use',
      'account exists',
      'duplicate email',
      'email taken',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _matchesInvalidCodePattern(String errorString) {
    final patterns = [
      'invalid code',
      'invalid verification',
      'wrong code',
      'incorrect code',
      'code invalid',
      'verification failed',
      'code mismatch',
      // Serverpod 3.x patterns
      'invalid verification code',
      'please check and try again',
      'emailaccountrequestexception',
      'emailaccountpasswordresetexception',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _matchesExpiredCodePattern(String errorString) {
    final patterns = [
      'expired',
      'code expired',
      'verification expired',
      'token expired',
      'link expired',
      // Serverpod 3.x patterns
      'verification code has expired',
      'password reset code has expired',
      'please request a new one',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _matchesWeakPasswordPattern(String errorString) {
    final patterns = [
      'weak password',
      'password too weak',
      'password requirements',
      'password must',
      'password should',
      'stronger password',
      'password strength',
      // Serverpod 3.x patterns
      'policyviolation', // EmailAccountRequestExceptionReason.policyViolation
      'does not meet the requirements',
      'choose a different password',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _matchesAccountLockedPattern(String errorString) {
    final patterns = [
      'account locked',
      'account disabled',
      'account suspended',
      'account blocked',
      'access denied',
      'forbidden',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static bool _matchesGoogleErrorPattern(String errorString) {
    final patterns = [
      'google',
      'oauth',
      'sign_in_cancelled',
      'sign_in_failed',
      'popup_closed',
    ];
    return patterns.any((pattern) => errorString.contains(pattern));
  }

  static AuthError _mapGoogleError(String errorString, dynamic originalError) {
    if (errorString.contains('cancelled') ||
        errorString.contains('popup_closed') ||
        errorString.contains('user_cancelled')) {
      return AuthError(
        type: AuthErrorType.googleSignInCancelled,
        originalError: originalError,
      );
    }

    if (errorString.contains('not verified') ||
        errorString.contains('unverified')) {
      return AuthError(
        type: AuthErrorType.googleAccountNotVerified,
        originalError: originalError,
        isRecoverable: false,
      );
    }

    if (errorString.contains('domain') || errorString.contains('restricted')) {
      return AuthError(
        type: AuthErrorType.googleAccountDomainRestricted,
        originalError: originalError,
        isRecoverable: false,
      );
    }

    return AuthError(
      type: AuthErrorType.googleSignInFailed,
      originalError: originalError,
    );
  }
}

/// Context enum to help the error mapper understand where the error occurred.
enum AuthContext {
  login,
  registration,
  verification,
  passwordReset,
  googleSignIn,
}
