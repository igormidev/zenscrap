import 'package:serverpod/serverpod.dart';

class PrivateSubscriptionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  // Create the logic to generate subscription checkout with pre-filled email link
}
