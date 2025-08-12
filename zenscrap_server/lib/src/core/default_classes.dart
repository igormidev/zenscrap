import 'package:zenscrap_server/src/generated/entities/zenscrap_exception.dart';

final defaultNoScrappableException = ZenScrapException(
  title: 'Scrappable not found',
  description: 'This could be a internal error, please contact support.',
);

final defaultAuthenticationException = ZenScrapException(
  title: 'Authentication Failed',
  description: 'User must be logged in to access this resource',
);
