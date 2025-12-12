import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

/// Creates a default scrappable not found exception with translations.
/// Falls back to English if no language is provided.
ZenScrapException createDefaultNoScrappableException([
  SupportedLanguage lang = SupportedLanguage.en,
]) {
  return createTranslatedException('internal_scrappable_not_found', lang);
}

/// Creates a default authentication exception with translations.
/// Falls back to English if no language is provided.
ZenScrapException createDefaultAuthenticationException([
  SupportedLanguage lang = SupportedLanguage.en,
]) {
  return createTranslatedException('authentication_failed', lang);
}

/// Legacy: Default no scrappable exception (English only).
/// @deprecated Use [createDefaultNoScrappableException] with language parameter instead.
final defaultNoScrappableException = createDefaultNoScrappableException();

/// Legacy: Default authentication exception (English only).
/// @deprecated Use [createDefaultAuthenticationException] with language parameter instead.
final defaultAuthenticationException = createDefaultAuthenticationException();
