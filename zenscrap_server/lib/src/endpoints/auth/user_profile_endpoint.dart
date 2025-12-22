import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Endpoint for retrieving authenticated user's profile information.
/// This endpoint requires the user to be logged in and returns their
/// profile details including email, name, and profile image URL.
class UserProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the current authenticated user's profile information.
  ///
  /// This method retrieves the user profile from the authentication system
  /// after a successful login (e.g., Google OAuth, email/password).
  ///
  /// Returns a [UserProfileResponse] containing:
  /// - email: The user's email address
  /// - fullName: The user's full name (if available)
  /// - userName: The user's display name
  /// - imageUrl: URL to the user's profile image (if available)
  ///
  /// Throws a [ZenScrapException] if the user is not authenticated
  /// or if the profile cannot be retrieved.
  Future<UserProfileResponse> getCurrentUserProfile(Session session) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw ZenScrapException(
        title: 'Authentication Required',
        description: 'You must be logged in to access your profile.',
      );
    }

    // Get user profile using the Serverpod IDP extension
    final userProfile = await authenticationInfo.userProfile(session);

    if (userProfile == null) {
      throw ZenScrapException(
        title: 'Profile Not Found',
        description: 'Unable to retrieve user profile information.',
      );
    }

    return UserProfileResponse(
      email: userProfile.email,
      fullName: userProfile.fullName,
      userName: userProfile.userName,
      imageUrl: userProfile.imageUrl?.toString(),
    );
  }
}
