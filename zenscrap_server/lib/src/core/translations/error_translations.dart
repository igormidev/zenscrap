import 'package:zenscrap_server/src/generated/protocol.dart';

/// Provides translated error titles and descriptions for all supported languages.
///
/// Usage:
/// ```dart
/// final title = getErrorTitle('account_not_found', language);
/// final description = getErrorDescription('account_not_found', language);
/// ```

/// Gets the translated error title for the given key and language.
/// Falls back to English if the key or language is not found.
String getErrorTitle(String key, SupportedLanguage lang) {
  return _errorTitles[key]?[lang] ?? _errorTitles[key]?[SupportedLanguage.en] ?? key;
}

/// Gets the translated error description for the given key and language.
/// Falls back to English if the key or language is not found.
String getErrorDescription(String key, SupportedLanguage lang) {
  return _errorDescriptions[key]?[lang] ?? _errorDescriptions[key]?[SupportedLanguage.en] ?? key;
}

/// Gets a translated error description with parameter substitution.
/// Parameters should be passed as a map, e.g., {'count': '5', 'plan': 'Pro'}
/// Placeholders in the description should be in the format {paramName}.
String getErrorDescriptionWithParams(
  String key,
  SupportedLanguage lang,
  Map<String, String> params,
) {
  String description = getErrorDescription(key, lang);
  params.forEach((paramKey, paramValue) {
    description = description.replaceAll('{$paramKey}', paramValue);
  });
  return description;
}

/// Creates a ZenScrapException with translated title and description.
ZenScrapException createTranslatedException(
  String key,
  SupportedLanguage lang, {
  Map<String, String>? params,
}) {
  return ZenScrapException(
    title: getErrorTitle(key, lang),
    description: params != null
        ? getErrorDescriptionWithParams(key, lang, params)
        : getErrorDescription(key, lang),
  );
}

// ============================================================================
// Error Titles
// ============================================================================

const Map<String, Map<SupportedLanguage, String>> _errorTitles = {
  // Authentication errors
  'authentication_failed': {
    SupportedLanguage.en: 'Authentication Failed',
    SupportedLanguage.es: 'Autenticacion Fallida',
    SupportedLanguage.de: 'Authentifizierung fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de l\'authentification',
    SupportedLanguage.ptBR: 'Falha na Autenticacao',
    SupportedLanguage.ja: '認証に失敗しました',
  },
  'user_not_authenticated': {
    SupportedLanguage.en: 'User Not Authenticated',
    SupportedLanguage.es: 'Usuario No Autenticado',
    SupportedLanguage.de: 'Benutzer nicht authentifiziert',
    SupportedLanguage.fr: 'Utilisateur non authentifie',
    SupportedLanguage.ptBR: 'Usuario Nao Autenticado',
    SupportedLanguage.ja: 'ユーザーが認証されていません',
  },

  // Account errors
  'account_not_found': {
    SupportedLanguage.en: 'Account Not Found',
    SupportedLanguage.es: 'Cuenta No Encontrada',
    SupportedLanguage.de: 'Konto nicht gefunden',
    SupportedLanguage.fr: 'Compte non trouve',
    SupportedLanguage.ptBR: 'Conta Nao Encontrada',
    SupportedLanguage.ja: 'アカウントが見つかりません',
  },
  'account_creation_failed': {
    SupportedLanguage.en: 'Account Creation Failed',
    SupportedLanguage.es: 'Error al Crear Cuenta',
    SupportedLanguage.de: 'Kontoerstellung fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de la creation du compte',
    SupportedLanguage.ptBR: 'Falha na Criacao da Conta',
    SupportedLanguage.ja: 'アカウントの作成に失敗しました',
  },
  'database_error': {
    SupportedLanguage.en: 'Database Error',
    SupportedLanguage.es: 'Error de Base de Datos',
    SupportedLanguage.de: 'Datenbankfehler',
    SupportedLanguage.fr: 'Erreur de base de donnees',
    SupportedLanguage.ptBR: 'Erro no Banco de Dados',
    SupportedLanguage.ja: 'データベースエラー',
  },

  // Scrappable errors
  'scrappable_not_found': {
    SupportedLanguage.en: 'Scrappable Not Found',
    SupportedLanguage.es: 'Scrappable No Encontrado',
    SupportedLanguage.de: 'Scrappable nicht gefunden',
    SupportedLanguage.fr: 'Scrappable non trouve',
    SupportedLanguage.ptBR: 'Scrappable Nao Encontrado',
    SupportedLanguage.ja: 'Scrappableが見つかりません',
  },
  'scrappable_already_attached': {
    SupportedLanguage.en: 'Scrappable Already Attached',
    SupportedLanguage.es: 'Scrappable Ya Vinculado',
    SupportedLanguage.de: 'Scrappable bereits angehangt',
    SupportedLanguage.fr: 'Scrappable deja attache',
    SupportedLanguage.ptBR: 'Scrappable Ja Vinculado',
    SupportedLanguage.ja: 'Scrappableは既に関連付けられています',
  },
  'endpoint_limit_reached': {
    SupportedLanguage.en: 'Endpoint Limit Reached',
    SupportedLanguage.es: 'Limite de Endpoints Alcanzado',
    SupportedLanguage.de: 'Endpunkt-Limit erreicht',
    SupportedLanguage.fr: 'Limite des endpoints atteinte',
    SupportedLanguage.ptBR: 'Limite de Endpoints Atingido',
    SupportedLanguage.ja: 'エンドポイントの制限に達しました',
  },

  // API Key errors
  'api_key_not_found': {
    SupportedLanguage.en: 'API Key Not Found',
    SupportedLanguage.es: 'Clave API No Encontrada',
    SupportedLanguage.de: 'API-Schlussel nicht gefunden',
    SupportedLanguage.fr: 'Cle API non trouvee',
    SupportedLanguage.ptBR: 'Chave API Nao Encontrada',
    SupportedLanguage.ja: 'APIキーが見つかりません',
  },
  'cannot_deactivate_api_key': {
    SupportedLanguage.en: 'Cannot Deactivate',
    SupportedLanguage.es: 'No Se Puede Desactivar',
    SupportedLanguage.de: 'Kann nicht deaktiviert werden',
    SupportedLanguage.fr: 'Impossible de desactiver',
    SupportedLanguage.ptBR: 'Nao e Possivel Desativar',
    SupportedLanguage.ja: '無効化できません',
  },

  // Subscription/Plan errors
  'ultra_plan_required': {
    SupportedLanguage.en: 'Ultra Plan Required',
    SupportedLanguage.es: 'Se Requiere Plan Ultra',
    SupportedLanguage.de: 'Ultra-Plan erforderlich',
    SupportedLanguage.fr: 'Plan Ultra requis',
    SupportedLanguage.ptBR: 'Plano Ultra Necessario',
    SupportedLanguage.ja: 'Ultraプランが必要です',
  },
  'upgrade_required': {
    SupportedLanguage.en: 'Upgrade Required',
    SupportedLanguage.es: 'Actualizacion Requerida',
    SupportedLanguage.de: 'Upgrade erforderlich',
    SupportedLanguage.fr: 'Mise a niveau requise',
    SupportedLanguage.ptBR: 'Atualizacao Necessaria',
    SupportedLanguage.ja: 'アップグレードが必要です',
  },
  'checkout_creation_failed': {
    SupportedLanguage.en: 'Checkout Creation Failed',
    SupportedLanguage.es: 'Error al Crear Checkout',
    SupportedLanguage.de: 'Checkout-Erstellung fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de la creation du paiement',
    SupportedLanguage.ptBR: 'Falha na Criacao do Checkout',
    SupportedLanguage.ja: 'チェックアウトの作成に失敗しました',
  },
  'no_active_subscription': {
    SupportedLanguage.en: 'No Active Subscription',
    SupportedLanguage.es: 'Sin Suscripcion Activa',
    SupportedLanguage.de: 'Kein aktives Abonnement',
    SupportedLanguage.fr: 'Pas d\'abonnement actif',
    SupportedLanguage.ptBR: 'Sem Assinatura Ativa',
    SupportedLanguage.ja: 'アクティブなサブスクリプションがありません',
  },
  'already_subscribed': {
    SupportedLanguage.en: 'Already Subscribed',
    SupportedLanguage.es: 'Ya Suscrito',
    SupportedLanguage.de: 'Bereits abonniert',
    SupportedLanguage.fr: 'Deja abonne',
    SupportedLanguage.ptBR: 'Ja Inscrito',
    SupportedLanguage.ja: '既に購読済みです',
  },
  'subscription_error': {
    SupportedLanguage.en: 'Subscription Error',
    SupportedLanguage.es: 'Error de Suscripcion',
    SupportedLanguage.de: 'Abonnementfehler',
    SupportedLanguage.fr: 'Erreur d\'abonnement',
    SupportedLanguage.ptBR: 'Erro de Assinatura',
    SupportedLanguage.ja: 'サブスクリプションエラー',
  },
  'no_stripe_customer': {
    SupportedLanguage.en: 'No Stripe Customer',
    SupportedLanguage.es: 'Sin Cliente de Stripe',
    SupportedLanguage.de: 'Kein Stripe-Kunde',
    SupportedLanguage.fr: 'Pas de client Stripe',
    SupportedLanguage.ptBR: 'Sem Cliente Stripe',
    SupportedLanguage.ja: 'Stripeの顧客がいません',
  },
  'user_email_not_found': {
    SupportedLanguage.en: 'User Email Not Found',
    SupportedLanguage.es: 'Correo del Usuario No Encontrado',
    SupportedLanguage.de: 'Benutzer-E-Mail nicht gefunden',
    SupportedLanguage.fr: 'Email de l\'utilisateur non trouve',
    SupportedLanguage.ptBR: 'Email do Usuario Nao Encontrado',
    SupportedLanguage.ja: 'ユーザーのメールが見つかりません',
  },

  // Access errors
  'access_denied': {
    SupportedLanguage.en: 'Access Denied',
    SupportedLanguage.es: 'Acceso Denegado',
    SupportedLanguage.de: 'Zugriff verweigert',
    SupportedLanguage.fr: 'Acces refuse',
    SupportedLanguage.ptBR: 'Acesso Negado',
    SupportedLanguage.ja: 'アクセスが拒否されました',
  },
  'permission_denied': {
    SupportedLanguage.en: 'Permission Denied',
    SupportedLanguage.es: 'Permiso Denegado',
    SupportedLanguage.de: 'Berechtigung verweigert',
    SupportedLanguage.fr: 'Permission refusee',
    SupportedLanguage.ptBR: 'Permissao Negada',
    SupportedLanguage.ja: '権限がありません',
  },

  // Usage limit errors
  'usage_limit_reached': {
    SupportedLanguage.en: 'Usage Limit Reached',
    SupportedLanguage.es: 'Limite de Uso Alcanzado',
    SupportedLanguage.de: 'Nutzungslimit erreicht',
    SupportedLanguage.fr: 'Limite d\'utilisation atteinte',
    SupportedLanguage.ptBR: 'Limite de Uso Atingido',
    SupportedLanguage.ja: '使用制限に達しました',
  },
  'ai_credits_exhausted': {
    SupportedLanguage.en: 'AI Credits Exhausted',
    SupportedLanguage.es: 'Creditos de IA Agotados',
    SupportedLanguage.de: 'KI-Guthaben aufgebraucht',
    SupportedLanguage.fr: 'Credits IA epuises',
    SupportedLanguage.ptBR: 'Creditos de IA Esgotados',
    SupportedLanguage.ja: 'AIクレジットが不足しています',
  },

  // Delete errors
  'already_deleted': {
    SupportedLanguage.en: 'Already Deleted',
    SupportedLanguage.es: 'Ya Eliminado',
    SupportedLanguage.de: 'Bereits geloscht',
    SupportedLanguage.fr: 'Deja supprime',
    SupportedLanguage.ptBR: 'Ja Excluido',
    SupportedLanguage.ja: '既に削除されています',
  },
  'delete_failed': {
    SupportedLanguage.en: 'Delete Failed',
    SupportedLanguage.es: 'Error al Eliminar',
    SupportedLanguage.de: 'Loschen fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de la suppression',
    SupportedLanguage.ptBR: 'Falha ao Excluir',
    SupportedLanguage.ja: '削除に失敗しました',
  },
  'update_failed': {
    SupportedLanguage.en: 'Update Failed',
    SupportedLanguage.es: 'Error al Actualizar',
    SupportedLanguage.de: 'Aktualisierung fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de la mise a jour',
    SupportedLanguage.ptBR: 'Falha ao Atualizar',
    SupportedLanguage.ja: '更新に失敗しました',
  },

  // Validation errors
  'invalid_name': {
    SupportedLanguage.en: 'Invalid Name',
    SupportedLanguage.es: 'Nombre Invalido',
    SupportedLanguage.de: 'Unzultiger Name',
    SupportedLanguage.fr: 'Nom invalide',
    SupportedLanguage.ptBR: 'Nome Invalido',
    SupportedLanguage.ja: '無効な名前',
  },
  'name_too_long': {
    SupportedLanguage.en: 'Name Too Long',
    SupportedLanguage.es: 'Nombre Muy Largo',
    SupportedLanguage.de: 'Name zu lang',
    SupportedLanguage.fr: 'Nom trop long',
    SupportedLanguage.ptBR: 'Nome Muito Longo',
    SupportedLanguage.ja: '名前が長すぎます',
  },
  'invalid_description': {
    SupportedLanguage.en: 'Invalid Description',
    SupportedLanguage.es: 'Descripcion Invalida',
    SupportedLanguage.de: 'Unzultige Beschreibung',
    SupportedLanguage.fr: 'Description invalide',
    SupportedLanguage.ptBR: 'Descricao Invalida',
    SupportedLanguage.ja: '無効な説明',
  },
  'description_too_long': {
    SupportedLanguage.en: 'Description Too Long',
    SupportedLanguage.es: 'Descripcion Muy Larga',
    SupportedLanguage.de: 'Beschreibung zu lang',
    SupportedLanguage.fr: 'Description trop longue',
    SupportedLanguage.ptBR: 'Descricao Muito Longa',
    SupportedLanguage.ja: '説明が長すぎます',
  },
  'invalid_api_key': {
    SupportedLanguage.en: 'Invalid API Key',
    SupportedLanguage.es: 'Clave API Invalida',
    SupportedLanguage.de: 'Unzultiger API-Schlussel',
    SupportedLanguage.fr: 'Cle API invalide',
    SupportedLanguage.ptBR: 'Chave API Invalida',
    SupportedLanguage.ja: '無効なAPIキー',
  },

  // Scrappable availability errors
  'scrappable_not_available': {
    SupportedLanguage.en: 'Scrappable Not Available',
    SupportedLanguage.es: 'Scrappable No Disponible',
    SupportedLanguage.de: 'Scrappable nicht verfugbar',
    SupportedLanguage.fr: 'Scrappable non disponible',
    SupportedLanguage.ptBR: 'Scrappable Nao Disponivel',
    SupportedLanguage.ja: 'Scrappableは利用できません',
  },

  // Session errors
  'session_not_found': {
    SupportedLanguage.en: 'Session Not Found',
    SupportedLanguage.es: 'Sesion No Encontrada',
    SupportedLanguage.de: 'Sitzung nicht gefunden',
    SupportedLanguage.fr: 'Session non trouvee',
    SupportedLanguage.ptBR: 'Sessao Nao Encontrada',
    SupportedLanguage.ja: 'セッションが見つかりません',
  },
  'session_already_opened': {
    SupportedLanguage.en: 'Session Already Opened',
    SupportedLanguage.es: 'Sesion Ya Abierta',
    SupportedLanguage.de: 'Sitzung bereits geoffnet',
    SupportedLanguage.fr: 'Session deja ouverte',
    SupportedLanguage.ptBR: 'Sessao Ja Aberta',
    SupportedLanguage.ja: 'セッションは既に開いています',
  },
  'ai_usage_record_not_found': {
    SupportedLanguage.en: 'AI Usage Record Not Found',
    SupportedLanguage.es: 'Registro de Uso de IA No Encontrado',
    SupportedLanguage.de: 'KI-Nutzungsdatensatz nicht gefunden',
    SupportedLanguage.fr: 'Enregistrement d\'utilisation IA non trouve',
    SupportedLanguage.ptBR: 'Registro de Uso de IA Nao Encontrado',
    SupportedLanguage.ja: 'AI使用記録が見つかりません',
  },
  'failed_to_save_api_key': {
    SupportedLanguage.en: 'Failed to Save API Key',
    SupportedLanguage.es: 'Error al Guardar Clave API',
    SupportedLanguage.de: 'API-Schlussel speichern fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de l\'enregistrement de la cle API',
    SupportedLanguage.ptBR: 'Falha ao Salvar Chave API',
    SupportedLanguage.ja: 'APIキーの保存に失敗しました',
  },

  // AI generation errors
  'ai_generation_failed': {
    SupportedLanguage.en: 'AI Generation Failed',
    SupportedLanguage.es: 'Error en la Generacion de IA',
    SupportedLanguage.de: 'KI-Generierung fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de la generation IA',
    SupportedLanguage.ptBR: 'Falha na Geracao de IA',
    SupportedLanguage.ja: 'AI生成に失敗しました',
  },

  // Ultra plan specific
  'ultra_plan_required_marketplace': {
    SupportedLanguage.en: 'Ultra Plan Required',
    SupportedLanguage.es: 'Se Requiere Plan Ultra',
    SupportedLanguage.de: 'Ultra-Plan erforderlich',
    SupportedLanguage.fr: 'Plan Ultra requis',
    SupportedLanguage.ptBR: 'Plano Ultra Necessario',
    SupportedLanguage.ja: 'Ultraプランが必要です',
  },

  // API Helper errors
  'missing_path_parameter': {
    SupportedLanguage.en: 'Missing Path Parameter',
    SupportedLanguage.es: 'Parametro de Ruta Faltante',
    SupportedLanguage.de: 'Fehlender Pfadparameter',
    SupportedLanguage.fr: 'Parametre de chemin manquant',
    SupportedLanguage.ptBR: 'Parametro de Caminho Faltando',
    SupportedLanguage.ja: 'パスパラメータがありません',
  },
  'unexpected_error': {
    SupportedLanguage.en: 'Unexpected Error',
    SupportedLanguage.es: 'Error Inesperado',
    SupportedLanguage.de: 'Unerwarteter Fehler',
    SupportedLanguage.fr: 'Erreur inattendue',
    SupportedLanguage.ptBR: 'Erro Inesperado',
    SupportedLanguage.ja: '予期しないエラー',
  },
  'test_data_not_found': {
    SupportedLanguage.en: 'Test Data Not Found',
    SupportedLanguage.es: 'Datos de Prueba No Encontrados',
    SupportedLanguage.de: 'Testdaten nicht gefunden',
    SupportedLanguage.fr: 'Donnees de test non trouvees',
    SupportedLanguage.ptBR: 'Dados de Teste Nao Encontrados',
    SupportedLanguage.ja: 'テストデータが見つかりません',
  },
  'no_credit_usage_model': {
    SupportedLanguage.en: 'No Credit Usage Model Found',
    SupportedLanguage.es: 'Modelo de Uso de Creditos No Encontrado',
    SupportedLanguage.de: 'Kein Kreditnutzungsmodell gefunden',
    SupportedLanguage.fr: 'Modele d\'utilisation des credits non trouve',
    SupportedLanguage.ptBR: 'Modelo de Uso de Creditos Nao Encontrado',
    SupportedLanguage.ja: 'クレジット使用モデルが見つかりません',
  },
  'api_key_not_found_active': {
    SupportedLanguage.en: 'Valid API Key Not Found',
    SupportedLanguage.es: 'Clave API Valida No Encontrada',
    SupportedLanguage.de: 'Gultiger API-Schlussel nicht gefunden',
    SupportedLanguage.fr: 'Cle API valide non trouvee',
    SupportedLanguage.ptBR: 'Chave API Valida Nao Encontrada',
    SupportedLanguage.ja: '有効なAPIキーが見つかりません',
  },
  'no_active_test_session': {
    SupportedLanguage.en: 'No Active Test Session Found',
    SupportedLanguage.es: 'Sesion de Prueba Activa No Encontrada',
    SupportedLanguage.de: 'Keine aktive Testsitzung gefunden',
    SupportedLanguage.fr: 'Aucune session de test active trouvee',
    SupportedLanguage.ptBR: 'Sessao de Teste Ativa Nao Encontrada',
    SupportedLanguage.ja: 'アクティブなテストセッションが見つかりません',
  },
  'test_period_expired': {
    SupportedLanguage.en: 'Test Period Expired',
    SupportedLanguage.es: 'Periodo de Prueba Expirado',
    SupportedLanguage.de: 'Testzeitraum abgelaufen',
    SupportedLanguage.fr: 'Periode de test expiree',
    SupportedLanguage.ptBR: 'Periodo de Teste Expirado',
    SupportedLanguage.ja: 'テスト期間が終了しました',
  },
  'api_key_database_not_found': {
    SupportedLanguage.en: 'API Key Not Found',
    SupportedLanguage.es: 'Clave API No Encontrada',
    SupportedLanguage.de: 'API-Schlussel nicht gefunden',
    SupportedLanguage.fr: 'Cle API non trouvee',
    SupportedLanguage.ptBR: 'Chave API Nao Encontrada',
    SupportedLanguage.ja: 'APIキーが見つかりません',
  },
  'insufficient_credits': {
    SupportedLanguage.en: 'Insufficient Credits',
    SupportedLanguage.es: 'Creditos Insuficientes',
    SupportedLanguage.de: 'Unzureichendes Guthaben',
    SupportedLanguage.fr: 'Credits insuffisants',
    SupportedLanguage.ptBR: 'Creditos Insuficientes',
    SupportedLanguage.ja: 'クレジットが不足しています',
  },
  'missing_extract_rules': {
    SupportedLanguage.en: 'Missing Extract Rules',
    SupportedLanguage.es: 'Reglas de Extraccion Faltantes',
    SupportedLanguage.de: 'Fehlende Extraktionsregeln',
    SupportedLanguage.fr: 'Regles d\'extraction manquantes',
    SupportedLanguage.ptBR: 'Regras de Extracao Faltando',
    SupportedLanguage.ja: '抽出ルールがありません',
  },
  'invalid_api_key_account': {
    SupportedLanguage.en: 'Invalid API Key',
    SupportedLanguage.es: 'Clave API Invalida',
    SupportedLanguage.de: 'Ungultiger API-Schlussel',
    SupportedLanguage.fr: 'Cle API invalide',
    SupportedLanguage.ptBR: 'Chave API Invalida',
    SupportedLanguage.ja: '無効なAPIキー',
  },
  'concurrency_limit_exceeded': {
    SupportedLanguage.en: 'Concurrency Limit Exceeded',
    SupportedLanguage.es: 'Limite de Concurrencia Excedido',
    SupportedLanguage.de: 'Gleichzeitigkeitslimit uberschritten',
    SupportedLanguage.fr: 'Limite de concurrence depassee',
    SupportedLanguage.ptBR: 'Limite de Concorrencia Excedido',
    SupportedLanguage.ja: '同時接続数の制限を超えました',
  },
  'api_scrappable_not_found': {
    SupportedLanguage.en: 'Scrappable Not Found',
    SupportedLanguage.es: 'Scrappable No Encontrado',
    SupportedLanguage.de: 'Scrappable nicht gefunden',
    SupportedLanguage.fr: 'Scrappable non trouve',
    SupportedLanguage.ptBR: 'Scrappable Nao Encontrado',
    SupportedLanguage.ja: 'Scrappableが見つかりません',
  },
  'invalid_api_key_format': {
    SupportedLanguage.en: 'Invalid API Key Format',
    SupportedLanguage.es: 'Formato de Clave API Invalido',
    SupportedLanguage.de: 'Ungultiges API-Schlussel-Format',
    SupportedLanguage.fr: 'Format de cle API invalide',
    SupportedLanguage.ptBR: 'Formato de Chave API Invalido',
    SupportedLanguage.ja: '無効なAPIキー形式',
  },
  'openai_api_key_invalid': {
    SupportedLanguage.en: 'Invalid OpenAI API Key',
    SupportedLanguage.es: 'Clave API de OpenAI Invalida',
    SupportedLanguage.de: 'Ungueltiger OpenAI API-Schluessel',
    SupportedLanguage.fr: 'Cle API OpenAI invalide',
    SupportedLanguage.ptBR: 'Chave API OpenAI Invalida',
    SupportedLanguage.ja: '無効なOpenAI APIキー',
  },
  'openai_api_key_validation_failed': {
    SupportedLanguage.en: 'API Key Validation Failed',
    SupportedLanguage.es: 'Error en la Validacion de la Clave API',
    SupportedLanguage.de: 'API-Schluessel-Validierung fehlgeschlagen',
    SupportedLanguage.fr: 'Echec de la validation de la cle API',
    SupportedLanguage.ptBR: 'Falha na Validacao da Chave API',
    SupportedLanguage.ja: 'APIキーの検証に失敗しました',
  },

  // Deploy endpoint errors
  'no_byte_data_to_deploy': {
    SupportedLanguage.en: 'No Byte Data to Deploy',
    SupportedLanguage.es: 'Sin Datos de Bytes para Desplegar',
    SupportedLanguage.de: 'Keine Byte-Daten zum Bereitstellen',
    SupportedLanguage.fr: 'Aucune donnee d\'octets a deployer',
    SupportedLanguage.ptBR: 'Sem Dados de Bytes para Implantar',
    SupportedLanguage.ja: 'デプロイするバイトデータがありません',
  },
  'authentication_or_reference_data': {
    SupportedLanguage.en: 'Authentication Required or Reference Data Not Found',
    SupportedLanguage.es: 'Autenticacion Requerida o Datos de Referencia No Encontrados',
    SupportedLanguage.de: 'Authentifizierung erforderlich oder Referenzdaten nicht gefunden',
    SupportedLanguage.fr: 'Authentification requise ou donnees de reference non trouvees',
    SupportedLanguage.ptBR: 'Autenticacao Necessaria ou Dados de Referencia Nao Encontrados',
    SupportedLanguage.ja: '認証が必要またはリファレンスデータが見つかりません',
  },

  // Default classes errors
  'internal_scrappable_not_found': {
    SupportedLanguage.en: 'Scrappable Not Found',
    SupportedLanguage.es: 'Scrappable No Encontrado',
    SupportedLanguage.de: 'Scrappable nicht gefunden',
    SupportedLanguage.fr: 'Scrappable non trouve',
    SupportedLanguage.ptBR: 'Scrappable Nao Encontrado',
    SupportedLanguage.ja: 'Scrappableが見つかりません',
  },

  // Auto-fix configuration errors
  'auto_fix_threshold_too_low': {
    SupportedLanguage.en: 'Invalid Threshold',
    SupportedLanguage.es: 'Umbral Invalido',
    SupportedLanguage.de: 'Unzultiger Schwellenwert',
    SupportedLanguage.fr: 'Seuil invalide',
    SupportedLanguage.ptBR: 'Limite Invalido',
    SupportedLanguage.ja: '無効なしきい値',
  },
  'auto_fix_threshold_too_high': {
    SupportedLanguage.en: 'Threshold Too High',
    SupportedLanguage.es: 'Umbral Muy Alto',
    SupportedLanguage.de: 'Schwellenwert zu hoch',
    SupportedLanguage.fr: 'Seuil trop eleve',
    SupportedLanguage.ptBR: 'Limite Muito Alto',
    SupportedLanguage.ja: 'しきい値が高すぎます',
  },

  // IP Validation errors
  'suspicious_ip_detected': {
    SupportedLanguage.en: 'Suspicious Connection Detected',
    SupportedLanguage.es: 'Conexion Sospechosa Detectada',
    SupportedLanguage.de: 'Verdachtige Verbindung erkannt',
    SupportedLanguage.fr: 'Connexion suspecte detectee',
    SupportedLanguage.ptBR: 'Conexao Suspeita Detectada',
    SupportedLanguage.ja: '不審な接続が検出されました',
  },
};

// ============================================================================
// Error Descriptions
// ============================================================================

const Map<String, Map<SupportedLanguage, String>> _errorDescriptions = {
  // Authentication errors
  'authentication_failed': {
    SupportedLanguage.en: 'User must be logged in to access this resource.',
    SupportedLanguage.es: 'El usuario debe iniciar sesion para acceder a este recurso.',
    SupportedLanguage.de: 'Der Benutzer muss angemeldet sein, um auf diese Ressource zuzugreifen.',
    SupportedLanguage.fr: 'L\'utilisateur doit etre connecte pour acceder a cette ressource.',
    SupportedLanguage.ptBR: 'O usuario deve estar logado para acessar este recurso.',
    SupportedLanguage.ja: 'このリソースにアクセスするにはログインが必要です。',
  },
  'user_not_authenticated': {
    SupportedLanguage.en: 'You must be logged in to access your scrappables.',
    SupportedLanguage.es: 'Debes iniciar sesion para acceder a tus scrappables.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um auf Ihre Scrappables zuzugreifen.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour acceder a vos scrappables.',
    SupportedLanguage.ptBR: 'Voce deve estar logado para acessar seus scrappables.',
    SupportedLanguage.ja: 'scrappablesにアクセスするにはログインが必要です。',
  },

  // Account errors
  'account_not_found': {
    SupportedLanguage.en: 'Unable to find account information.',
    SupportedLanguage.es: 'No se pudo encontrar la informacion de la cuenta.',
    SupportedLanguage.de: 'Kontoinformationen konnten nicht gefunden werden.',
    SupportedLanguage.fr: 'Impossible de trouver les informations du compte.',
    SupportedLanguage.ptBR: 'Nao foi possivel encontrar as informacoes da conta.',
    SupportedLanguage.ja: 'アカウント情報が見つかりませんでした。',
  },
  'account_not_found_for_user': {
    SupportedLanguage.en: 'No account found for the authenticated user.',
    SupportedLanguage.es: 'No se encontro cuenta para el usuario autenticado.',
    SupportedLanguage.de: 'Kein Konto fur den authentifizierten Benutzer gefunden.',
    SupportedLanguage.fr: 'Aucun compte trouve pour l\'utilisateur authentifie.',
    SupportedLanguage.ptBR: 'Nenhuma conta encontrada para o usuario autenticado.',
    SupportedLanguage.ja: '認証済みユーザーのアカウントが見つかりませんでした。',
  },
  'account_creation_failed': {
    SupportedLanguage.en: 'Unable to create new account. Please try again later.',
    SupportedLanguage.es: 'No se pudo crear la nueva cuenta. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Neues Konto konnte nicht erstellt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Impossible de creer un nouveau compte. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Nao foi possivel criar uma nova conta. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: '新しいアカウントを作成できませんでした。後でもう一度お試しください。',
  },
  'account_creation_internal_error': {
    SupportedLanguage.en: 'This is an internal error. Please try again later.',
    SupportedLanguage.es: 'Este es un error interno. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Dies ist ein interner Fehler. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Ceci est une erreur interne. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Este e um erro interno. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'これは内部エラーです。後でもう一度お試しください。',
  },
  'database_error': {
    SupportedLanguage.en: 'Failed to retrieve account information. Please try again later.',
    SupportedLanguage.es: 'Error al recuperar la informacion de la cuenta. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Kontoinformationen konnten nicht abgerufen werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Echec de la recuperation des informations du compte. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao recuperar as informacoes da conta. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'アカウント情報の取得に失敗しました。後でもう一度お試しください。',
  },

  // Scrappable errors
  'scrappable_not_found': {
    SupportedLanguage.en: 'The requested scrappable does not exist.',
    SupportedLanguage.es: 'El scrappable solicitado no existe.',
    SupportedLanguage.de: 'Das angeforderte Scrappable existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable demande n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable solicitado nao existe.',
    SupportedLanguage.ja: 'リクエストされたscrappableは存在しません。',
  },
  'scrappable_not_found_attach': {
    SupportedLanguage.en: 'The scrappable you are trying to attach does not exist.',
    SupportedLanguage.es: 'El scrappable que intentas vincular no existe.',
    SupportedLanguage.de: 'Das Scrappable, das Sie anhangen mochten, existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable que vous essayez d\'attacher n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable que voce esta tentando vincular nao existe.',
    SupportedLanguage.ja: '関連付けようとしているscrappableは存在しません。',
  },
  'scrappable_not_found_clone': {
    SupportedLanguage.en: 'The scrappable you are trying to clone does not exist.',
    SupportedLanguage.es: 'El scrappable que intentas clonar no existe.',
    SupportedLanguage.de: 'Das Scrappable, das Sie klonen mochten, existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable que vous essayez de cloner n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable que voce esta tentando clonar nao existe.',
    SupportedLanguage.ja: '複製しようとしているscrappableは存在しません。',
  },
  'scrappable_not_found_or_no_access': {
    SupportedLanguage.en: 'The requested scrappable was not found or you do not have access to it.',
    SupportedLanguage.es: 'El scrappable solicitado no se encontro o no tienes acceso a el.',
    SupportedLanguage.de: 'Das angeforderte Scrappable wurde nicht gefunden oder Sie haben keinen Zugriff darauf.',
    SupportedLanguage.fr: 'Le scrappable demande n\'a pas ete trouve ou vous n\'y avez pas acces.',
    SupportedLanguage.ptBR: 'O scrappable solicitado nao foi encontrado ou voce nao tem acesso a ele.',
    SupportedLanguage.ja: 'リクエストされたscrappableが見つからないか、アクセス権限がありません。',
  },
  'scrappable_already_attached': {
    SupportedLanguage.en: 'The scrappable you are trying to attach is already linked to another account.',
    SupportedLanguage.es: 'El scrappable que intentas vincular ya esta vinculado a otra cuenta.',
    SupportedLanguage.de: 'Das Scrappable, das Sie anhangen mochten, ist bereits mit einem anderen Konto verknupft.',
    SupportedLanguage.fr: 'Le scrappable que vous essayez d\'attacher est deja lie a un autre compte.',
    SupportedLanguage.ptBR: 'O scrappable que voce esta tentando vincular ja esta vinculado a outra conta.',
    SupportedLanguage.ja: '関連付けようとしているscrappableは既に別のアカウントにリンクされています。',
  },
  'endpoint_limit_reached': {
    SupportedLanguage.en: 'You have reached the maximum number of endpoints ({maxAllowed}) for your {planName} plan. Please upgrade your plan to attach more endpoints.',
    SupportedLanguage.es: 'Has alcanzado el numero maximo de endpoints ({maxAllowed}) para tu plan {planName}. Por favor, actualiza tu plan para vincular mas endpoints.',
    SupportedLanguage.de: 'Sie haben die maximale Anzahl von Endpunkten ({maxAllowed}) fur Ihren {planName}-Plan erreicht. Bitte aktualisieren Sie Ihren Plan, um weitere Endpunkte anzuhangen.',
    SupportedLanguage.fr: 'Vous avez atteint le nombre maximum d\'endpoints ({maxAllowed}) pour votre plan {planName}. Veuillez mettre a niveau votre plan pour attacher plus d\'endpoints.',
    SupportedLanguage.ptBR: 'Voce atingiu o numero maximo de endpoints ({maxAllowed}) para seu plano {planName}. Por favor, atualize seu plano para vincular mais endpoints.',
    SupportedLanguage.ja: '{planName}プランのエンドポイント数の上限({maxAllowed})に達しました。より多くのエンドポイントを追加するにはプランをアップグレードしてください。',
  },
  'scrappable_private_cannot_clone': {
    SupportedLanguage.en: 'This scrappable is private and cannot be cloned.',
    SupportedLanguage.es: 'Este scrappable es privado y no se puede clonar.',
    SupportedLanguage.de: 'Dieses Scrappable ist privat und kann nicht geklont werden.',
    SupportedLanguage.fr: 'Ce scrappable est prive et ne peut pas etre clone.',
    SupportedLanguage.ptBR: 'Este scrappable e privado e nao pode ser clonado.',
    SupportedLanguage.ja: 'このscrappableはプライベートであり、複製できません。',
  },

  // API Key errors
  'api_key_not_found': {
    SupportedLanguage.en: 'The specified API key was not found or does not belong to your account.',
    SupportedLanguage.es: 'La clave API especificada no se encontro o no pertenece a tu cuenta.',
    SupportedLanguage.de: 'Der angegebene API-Schlussel wurde nicht gefunden oder gehort nicht zu Ihrem Konto.',
    SupportedLanguage.fr: 'La cle API specifiee n\'a pas ete trouvee ou n\'appartient pas a votre compte.',
    SupportedLanguage.ptBR: 'A chave API especificada nao foi encontrada ou nao pertence a sua conta.',
    SupportedLanguage.ja: '指定されたAPIキーが見つからないか、アカウントに属していません。',
  },
  'cannot_deactivate_api_key': {
    SupportedLanguage.en: 'You must have at least one active API key.',
    SupportedLanguage.es: 'Debes tener al menos una clave API activa.',
    SupportedLanguage.de: 'Sie mussen mindestens einen aktiven API-Schlussel haben.',
    SupportedLanguage.fr: 'Vous devez avoir au moins une cle API active.',
    SupportedLanguage.ptBR: 'Voce deve ter pelo menos uma chave API ativa.',
    SupportedLanguage.ja: '少なくとも1つのアクティブなAPIキーが必要です。',
  },

  // Subscription/Plan errors
  'ultra_plan_required': {
    SupportedLanguage.en: 'Credit packages are only available for Ultra plan subscribers. Please upgrade to Ultra to purchase additional credits.',
    SupportedLanguage.es: 'Los paquetes de creditos solo estan disponibles para suscriptores del plan Ultra. Por favor, actualiza a Ultra para comprar creditos adicionales.',
    SupportedLanguage.de: 'Kreditpakete sind nur fur Ultra-Plan-Abonnenten verfugbar. Bitte aktualisieren Sie auf Ultra, um zusatzliche Credits zu erwerben.',
    SupportedLanguage.fr: 'Les packs de credits sont disponibles uniquement pour les abonnes au plan Ultra. Veuillez passer a Ultra pour acheter des credits supplementaires.',
    SupportedLanguage.ptBR: 'Os pacotes de creditos estao disponiveis apenas para assinantes do plano Ultra. Por favor, atualize para Ultra para comprar creditos adicionais.',
    SupportedLanguage.ja: 'クレジットパッケージはUltraプランの購読者のみ利用可能です。追加クレジットを購入するにはUltraにアップグレードしてください。',
  },
  'upgrade_required_clone': {
    SupportedLanguage.en: 'Cloning marketplace scrappables requires an Ultra plan.',
    SupportedLanguage.es: 'Clonar scrappables del marketplace requiere un plan Ultra.',
    SupportedLanguage.de: 'Das Klonen von Marketplace-Scrappables erfordert einen Ultra-Plan.',
    SupportedLanguage.fr: 'Le clonage des scrappables du marketplace necessite un plan Ultra.',
    SupportedLanguage.ptBR: 'Clonar scrappables do marketplace requer um plano Ultra.',
    SupportedLanguage.ja: 'マーケットプレイスのscrappablesを複製するにはUltraプランが必要です。',
  },
  'checkout_creation_failed': {
    SupportedLanguage.en: 'Failed to create checkout session.',
    SupportedLanguage.es: 'Error al crear la sesion de checkout.',
    SupportedLanguage.de: 'Checkout-Sitzung konnte nicht erstellt werden.',
    SupportedLanguage.fr: 'Echec de la creation de la session de paiement.',
    SupportedLanguage.ptBR: 'Falha ao criar sessao de checkout.',
    SupportedLanguage.ja: 'チェックアウトセッションの作成に失敗しました。',
  },
  'no_active_subscription': {
    SupportedLanguage.en: 'No active subscription found.',
    SupportedLanguage.es: 'No se encontro suscripcion activa.',
    SupportedLanguage.de: 'Kein aktives Abonnement gefunden.',
    SupportedLanguage.fr: 'Aucun abonnement actif trouve.',
    SupportedLanguage.ptBR: 'Nenhuma assinatura ativa encontrada.',
    SupportedLanguage.ja: 'アクティブなサブスクリプションが見つかりません。',
  },
  'already_subscribed': {
    SupportedLanguage.en: 'User already has an active subscription.',
    SupportedLanguage.es: 'El usuario ya tiene una suscripcion activa.',
    SupportedLanguage.de: 'Benutzer hat bereits ein aktives Abonnement.',
    SupportedLanguage.fr: 'L\'utilisateur a deja un abonnement actif.',
    SupportedLanguage.ptBR: 'O usuario ja possui uma assinatura ativa.',
    SupportedLanguage.ja: 'ユーザーは既にアクティブなサブスクリプションを持っています。',
  },
  'subscription_cancel_failed': {
    SupportedLanguage.en: 'Failed to cancel subscription. Please try again later.',
    SupportedLanguage.es: 'Error al cancelar la suscripcion. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Abonnement konnte nicht gekundigt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Echec de l\'annulation de l\'abonnement. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao cancelar a assinatura. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'サブスクリプションのキャンセルに失敗しました。後でもう一度お試しください。',
  },
  'subscription_checkout_failed': {
    SupportedLanguage.en: 'Failed to create checkout session. Please try again later.',
    SupportedLanguage.es: 'Error al crear la sesion de checkout. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Checkout-Sitzung konnte nicht erstellt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Echec de la creation de la session de paiement. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao criar sessao de checkout. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'チェックアウトセッションの作成に失敗しました。後でもう一度お試しください。',
  },
  'customer_portal_failed': {
    SupportedLanguage.en: 'Failed to create customer portal session. Please try again later.',
    SupportedLanguage.es: 'Error al crear la sesion del portal del cliente. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Kundenportalsitzung konnte nicht erstellt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Echec de la creation de la session du portail client. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao criar sessao do portal do cliente. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'カスタマーポータルセッションの作成に失敗しました。後でもう一度お試しください。',
  },
  'no_stripe_customer': {
    SupportedLanguage.en: 'No Stripe customer found. Please subscribe to a plan first.',
    SupportedLanguage.es: 'No se encontro cliente de Stripe. Por favor, suscribete a un plan primero.',
    SupportedLanguage.de: 'Kein Stripe-Kunde gefunden. Bitte abonnieren Sie zuerst einen Plan.',
    SupportedLanguage.fr: 'Aucun client Stripe trouve. Veuillez d\'abord vous abonner a un plan.',
    SupportedLanguage.ptBR: 'Nenhum cliente Stripe encontrado. Por favor, assine um plano primeiro.',
    SupportedLanguage.ja: 'Stripeの顧客が見つかりません。最初にプランに登録してください。',
  },
  'user_email_not_found': {
    SupportedLanguage.en: 'User email not found.',
    SupportedLanguage.es: 'Correo electronico del usuario no encontrado.',
    SupportedLanguage.de: 'Benutzer-E-Mail nicht gefunden.',
    SupportedLanguage.fr: 'Email de l\'utilisateur non trouve.',
    SupportedLanguage.ptBR: 'Email do usuario nao encontrado.',
    SupportedLanguage.ja: 'ユーザーのメールアドレスが見つかりません。',
  },

  // Access errors
  'access_denied_permission': {
    SupportedLanguage.en: 'You do not have permission to access this scrappable.',
    SupportedLanguage.es: 'No tienes permiso para acceder a este scrappable.',
    SupportedLanguage.de: 'Sie haben keine Berechtigung, auf dieses Scrappable zuzugreifen.',
    SupportedLanguage.fr: 'Vous n\'avez pas la permission d\'acceder a ce scrappable.',
    SupportedLanguage.ptBR: 'Voce nao tem permissao para acessar este scrappable.',
    SupportedLanguage.ja: 'このscrappableにアクセスする権限がありません。',
  },
  'permission_denied_delete': {
    SupportedLanguage.en: 'You do not have permission to delete this scrappable.',
    SupportedLanguage.es: 'No tienes permiso para eliminar este scrappable.',
    SupportedLanguage.de: 'Sie haben keine Berechtigung, dieses Scrappable zu loschen.',
    SupportedLanguage.fr: 'Vous n\'avez pas la permission de supprimer ce scrappable.',
    SupportedLanguage.ptBR: 'Voce nao tem permissao para excluir este scrappable.',
    SupportedLanguage.ja: 'このscrappableを削除する権限がありません。',
  },
  'permission_denied_edit': {
    SupportedLanguage.en: 'You do not have permission to edit this scrappable.',
    SupportedLanguage.es: 'No tienes permiso para editar este scrappable.',
    SupportedLanguage.de: 'Sie haben keine Berechtigung, dieses Scrappable zu bearbeiten.',
    SupportedLanguage.fr: 'Vous n\'avez pas la permission de modifier ce scrappable.',
    SupportedLanguage.ptBR: 'Voce nao tem permissao para editar este scrappable.',
    SupportedLanguage.ja: 'このscrappableを編集する権限がありません。',
  },

  // Usage limit errors
  'usage_limit_reached': {
    SupportedLanguage.en: 'You have reached the spending limit for your IP address (\${limit}). This limit resets in {timeStr}, or you can create an account to get monthly AI credits.',
    SupportedLanguage.es: 'Has alcanzado el limite de gasto para tu direccion IP (\${limit}). Este limite se restablece en {timeStr}, o puedes crear una cuenta para obtener creditos de IA mensuales.',
    SupportedLanguage.de: 'Sie haben das Ausgabenlimit fur Ihre IP-Adresse erreicht (\${limit}). Dieses Limit wird in {timeStr} zuruckgesetzt, oder Sie konnen ein Konto erstellen, um monatliche KI-Guthaben zu erhalten.',
    SupportedLanguage.fr: 'Vous avez atteint la limite de depenses pour votre adresse IP (\${limit}). Cette limite sera reinitialise dans {timeStr}, ou vous pouvez creer un compte pour obtenir des credits IA mensuels.',
    SupportedLanguage.ptBR: 'Voce atingiu o limite de gastos para seu endereco IP (\${limit}). Este limite sera redefinido em {timeStr}, ou voce pode criar uma conta para obter creditos de IA mensais.',
    SupportedLanguage.ja: 'IPアドレスの使用制限に達しました（\${limit}）。この制限は{timeStr}でリセットされます。月次AIクレジットを取得するにはアカウントを作成してください。',
  },
  'ai_credits_exhausted': {
    SupportedLanguage.en: 'You have used all your AI credits for this month (\${limit} limit). Credits will reset next month, or you can add your own OpenAI API key in account settings to continue without limits.',
    SupportedLanguage.es: 'Has usado todos tus creditos de IA para este mes (limite de \${limit}). Los creditos se restablecera el proximo mes, o puedes agregar tu propia clave API de OpenAI en la configuracion de tu cuenta para continuar sin limites.',
    SupportedLanguage.de: 'Sie haben alle Ihre KI-Guthaben fur diesen Monat aufgebraucht (Limit: \${limit}). Die Guthaben werden nachsten Monat zuruckgesetzt, oder Sie konnen Ihren eigenen OpenAI API-Schlussel in den Kontoeinstellungen hinzufugen, um ohne Limits fortzufahren.',
    SupportedLanguage.fr: 'Vous avez utilise tous vos credits IA pour ce mois (limite de \${limit}). Les credits seront reinitialises le mois prochain, ou vous pouvez ajouter votre propre cle API OpenAI dans les parametres du compte pour continuer sans limites.',
    SupportedLanguage.ptBR: 'Voce usou todos os seus creditos de IA para este mes (limite de \${limit}). Os creditos serao redefinidos no proximo mes, ou voce pode adicionar sua propria chave API do OpenAI nas configuracoes da conta para continuar sem limites.',
    SupportedLanguage.ja: '今月のAIクレジットをすべて使い切りました（\${limit}の制限）。クレジットは来月リセットされます。制限なく続けるにはアカウント設定でOpenAI APIキーを追加してください。',
  },

  // IP Validation errors
  'suspicious_ip_detected': {
    SupportedLanguage.en: 'Your connection has been flagged as suspicious ({reason}). To protect our service from abuse, we cannot process requests from VPNs, proxies, Tor, or known malicious IPs. Please disable your VPN/proxy or create an account to continue.',
    SupportedLanguage.es: 'Tu conexion ha sido marcada como sospechosa ({reason}). Para proteger nuestro servicio del abuso, no podemos procesar solicitudes de VPNs, proxies, Tor o IPs maliciosas conocidas. Por favor, desactiva tu VPN/proxy o crea una cuenta para continuar.',
    SupportedLanguage.de: 'Ihre Verbindung wurde als verdachtig eingestuft ({reason}). Zum Schutz unseres Dienstes vor Missbrauch konnen wir keine Anfragen von VPNs, Proxys, Tor oder bekannten bosartigen IPs verarbeiten. Bitte deaktivieren Sie Ihr VPN/Proxy oder erstellen Sie ein Konto, um fortzufahren.',
    SupportedLanguage.fr: 'Votre connexion a ete signalee comme suspecte ({reason}). Pour proteger notre service contre les abus, nous ne pouvons pas traiter les requetes provenant de VPN, proxys, Tor ou d\'IPs malveillantes connues. Veuillez desactiver votre VPN/proxy ou creer un compte pour continuer.',
    SupportedLanguage.ptBR: 'Sua conexao foi marcada como suspeita ({reason}). Para proteger nosso servico contra abusos, nao podemos processar solicitacoes de VPNs, proxies, Tor ou IPs maliciosos conhecidos. Por favor, desative seu VPN/proxy ou crie uma conta para continuar.',
    SupportedLanguage.ja: 'お使いの接続が不審としてフラグ付けされました（{reason}）。サービスの悪用を防ぐため、VPN、プロキシ、Tor、または既知の悪意あるIPからのリクエストは処理できません。VPN/プロキシを無効にするか、アカウントを作成して続行してください。',
  },

  // Delete errors
  'already_deleted': {
    SupportedLanguage.en: 'This scrappable has already been deleted.',
    SupportedLanguage.es: 'Este scrappable ya ha sido eliminado.',
    SupportedLanguage.de: 'Dieses Scrappable wurde bereits geloscht.',
    SupportedLanguage.fr: 'Ce scrappable a deja ete supprime.',
    SupportedLanguage.ptBR: 'Este scrappable ja foi excluido.',
    SupportedLanguage.ja: 'このscrappableは既に削除されています。',
  },
  'delete_failed': {
    SupportedLanguage.en: 'Failed to delete the scrappable. Please try again.',
    SupportedLanguage.es: 'Error al eliminar el scrappable. Por favor, intentelo de nuevo.',
    SupportedLanguage.de: 'Das Scrappable konnte nicht geloscht werden. Bitte versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Echec de la suppression du scrappable. Veuillez reessayer.',
    SupportedLanguage.ptBR: 'Falha ao excluir o scrappable. Por favor, tente novamente.',
    SupportedLanguage.ja: 'scrappableの削除に失敗しました。もう一度お試しください。',
  },
  'update_failed': {
    SupportedLanguage.en: 'Failed to update the scrappable. Please try again.',
    SupportedLanguage.es: 'Error al actualizar el scrappable. Por favor, intentelo de nuevo.',
    SupportedLanguage.de: 'Das Scrappable konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Echec de la mise a jour du scrappable. Veuillez reessayer.',
    SupportedLanguage.ptBR: 'Falha ao atualizar o scrappable. Por favor, tente novamente.',
    SupportedLanguage.ja: 'scrappableの更新に失敗しました。もう一度お試しください。',
  },

  // Validation errors
  'invalid_name': {
    SupportedLanguage.en: 'Scrappable name cannot be empty.',
    SupportedLanguage.es: 'El nombre del scrappable no puede estar vacio.',
    SupportedLanguage.de: 'Der Scrappable-Name darf nicht leer sein.',
    SupportedLanguage.fr: 'Le nom du scrappable ne peut pas etre vide.',
    SupportedLanguage.ptBR: 'O nome do scrappable nao pode estar vazio.',
    SupportedLanguage.ja: 'scrappableの名前を空にすることはできません。',
  },
  'name_too_long': {
    SupportedLanguage.en: 'Scrappable name must be {maxLength} characters or less.',
    SupportedLanguage.es: 'El nombre del scrappable debe tener {maxLength} caracteres o menos.',
    SupportedLanguage.de: 'Der Scrappable-Name darf hochstens {maxLength} Zeichen lang sein.',
    SupportedLanguage.fr: 'Le nom du scrappable doit contenir {maxLength} caracteres ou moins.',
    SupportedLanguage.ptBR: 'O nome do scrappable deve ter {maxLength} caracteres ou menos.',
    SupportedLanguage.ja: 'scrappableの名前は{maxLength}文字以下にしてください。',
  },
  'invalid_description': {
    SupportedLanguage.en: 'Scrappable description cannot be empty.',
    SupportedLanguage.es: 'La descripcion del scrappable no puede estar vacia.',
    SupportedLanguage.de: 'Die Scrappable-Beschreibung darf nicht leer sein.',
    SupportedLanguage.fr: 'La description du scrappable ne peut pas etre vide.',
    SupportedLanguage.ptBR: 'A descricao do scrappable nao pode estar vazia.',
    SupportedLanguage.ja: 'scrappableの説明を空にすることはできません。',
  },
  'description_too_long': {
    SupportedLanguage.en: 'Scrappable description must be {maxLength} characters or less.',
    SupportedLanguage.es: 'La descripcion del scrappable debe tener {maxLength} caracteres o menos.',
    SupportedLanguage.de: 'Die Scrappable-Beschreibung darf hochstens {maxLength} Zeichen lang sein.',
    SupportedLanguage.fr: 'La description du scrappable doit contenir {maxLength} caracteres ou moins.',
    SupportedLanguage.ptBR: 'A descricao do scrappable deve ter {maxLength} caracteres ou menos.',
    SupportedLanguage.ja: 'scrappableの説明は{maxLength}文字以下にしてください。',
  },
  'invalid_api_key': {
    SupportedLanguage.en: 'Please provide a valid OpenAI API key.',
    SupportedLanguage.es: 'Por favor, proporciona una clave API de OpenAI valida.',
    SupportedLanguage.de: 'Bitte geben Sie einen gultigen OpenAI API-Schlussel an.',
    SupportedLanguage.fr: 'Veuillez fournir une cle API OpenAI valide.',
    SupportedLanguage.ptBR: 'Por favor, forneca uma chave API do OpenAI valida.',
    SupportedLanguage.ja: '有効なOpenAI APIキーを入力してください。',
  },

  // Scrappable availability errors
  'scrappable_not_available': {
    SupportedLanguage.en: 'The requested scrappable is not available.',
    SupportedLanguage.es: 'El scrappable solicitado no esta disponible.',
    SupportedLanguage.de: 'Das angeforderte Scrappable ist nicht verfugbar.',
    SupportedLanguage.fr: 'Le scrappable demande n\'est pas disponible.',
    SupportedLanguage.ptBR: 'O scrappable solicitado nao esta disponivel.',
    SupportedLanguage.ja: 'リクエストされたscrappableは利用できません。',
  },
  'scrappable_not_found_by_id': {
    SupportedLanguage.en: 'The scrappable with the provided ID does not exist.',
    SupportedLanguage.es: 'El scrappable con el ID proporcionado no existe.',
    SupportedLanguage.de: 'Das Scrappable mit der angegebenen ID existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable avec l\'ID fourni n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable com o ID fornecido nao existe.',
    SupportedLanguage.ja: '指定されたIDのscrappableは存在しません。',
  },

  // Session errors
  'session_not_found': {
    SupportedLanguage.en: 'No active session found with the provided ID.',
    SupportedLanguage.es: 'No se encontro ninguna sesion activa con el ID proporcionado.',
    SupportedLanguage.de: 'Keine aktive Sitzung mit der angegebenen ID gefunden.',
    SupportedLanguage.fr: 'Aucune session active trouvee avec l\'ID fourni.',
    SupportedLanguage.ptBR: 'Nenhuma sessao ativa encontrada com o ID fornecido.',
    SupportedLanguage.ja: '指定されたIDのアクティブなセッションが見つかりません。',
  },
  'session_already_opened': {
    SupportedLanguage.en: 'There is already an opened session for this scrappable. Please close the existing session before creating a new one.',
    SupportedLanguage.es: 'Ya hay una sesion abierta para este scrappable. Por favor, cierra la sesion existente antes de crear una nueva.',
    SupportedLanguage.de: 'Es gibt bereits eine geoffnete Sitzung fur dieses Scrappable. Bitte schliessen Sie die bestehende Sitzung, bevor Sie eine neue erstellen.',
    SupportedLanguage.fr: 'Il existe deja une session ouverte pour ce scrappable. Veuillez fermer la session existante avant d\'en creer une nouvelle.',
    SupportedLanguage.ptBR: 'Ja existe uma sessao aberta para este scrappable. Por favor, feche a sessao existente antes de criar uma nova.',
    SupportedLanguage.ja: 'このscrappableには既にセッションが開いています。新しいセッションを作成する前に既存のセッションを閉じてください。',
  },
  'ai_usage_record_not_found': {
    SupportedLanguage.en: 'Could not find your AI usage record.',
    SupportedLanguage.es: 'No se pudo encontrar tu registro de uso de IA.',
    SupportedLanguage.de: 'Ihr KI-Nutzungsdatensatz konnte nicht gefunden werden.',
    SupportedLanguage.fr: 'Impossible de trouver votre enregistrement d\'utilisation IA.',
    SupportedLanguage.ptBR: 'Nao foi possivel encontrar seu registro de uso de IA.',
    SupportedLanguage.ja: 'AI使用記録が見つかりませんでした。',
  },
  'failed_to_save_api_key': {
    SupportedLanguage.en: 'Could not save your API key. Please try again.',
    SupportedLanguage.es: 'No se pudo guardar tu clave API. Por favor, intentelo de nuevo.',
    SupportedLanguage.de: 'Ihr API-Schlussel konnte nicht gespeichert werden. Bitte versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Impossible d\'enregistrer votre cle API. Veuillez reessayer.',
    SupportedLanguage.ptBR: 'Nao foi possivel salvar sua chave API. Por favor, tente novamente.',
    SupportedLanguage.ja: 'APIキーを保存できませんでした。もう一度お試しください。',
  },

  // Authentication errors for specific actions
  'authentication_required_delete': {
    SupportedLanguage.en: 'You must be logged in to delete this scrappable.',
    SupportedLanguage.es: 'Debes iniciar sesion para eliminar este scrappable.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um dieses Scrappable zu loschen.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour supprimer ce scrappable.',
    SupportedLanguage.ptBR: 'Voce deve estar logado para excluir este scrappable.',
    SupportedLanguage.ja: 'このscrappableを削除するにはログインが必要です。',
  },
  'authentication_required_edit': {
    SupportedLanguage.en: 'You must be logged in to edit this scrappable.',
    SupportedLanguage.es: 'Debes iniciar sesion para editar este scrappable.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um dieses Scrappable zu bearbeiten.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour modifier ce scrappable.',
    SupportedLanguage.ptBR: 'Voce deve estar logado para editar este scrappable.',
    SupportedLanguage.ja: 'このscrappableを編集するにはログインが必要です。',
  },
  'authentication_required_marketplace': {
    SupportedLanguage.en: 'You must be logged in to hide scrappables from marketplace.',
    SupportedLanguage.es: 'Debes iniciar sesion para ocultar scrappables del marketplace.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um Scrappables vom Marketplace zu verstecken.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour masquer les scrappables du marketplace.',
    SupportedLanguage.ptBR: 'Voce deve estar logado para ocultar scrappables do marketplace.',
    SupportedLanguage.ja: 'マーケットプレイスからscrappableを非表示にするにはログインが必要です。',
  },
  'authentication_required_api_key': {
    SupportedLanguage.en: 'You must be logged in to add an API key.',
    SupportedLanguage.es: 'Debes iniciar sesion para agregar una clave API.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um einen API-Schlussel hinzuzufugen.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour ajouter une cle API.',
    SupportedLanguage.ptBR: 'Voce deve estar logado para adicionar uma chave API.',
    SupportedLanguage.ja: 'APIキーを追加するにはログインが必要です。',
  },
  'authentication_required_session': {
    SupportedLanguage.en: 'You must be the owner of this scrappable to create a session for it.',
    SupportedLanguage.es: 'Debes ser el propietario de este scrappable para crear una sesion para el.',
    SupportedLanguage.de: 'Sie mussen der Besitzer dieses Scrappables sein, um eine Sitzung dafur zu erstellen.',
    SupportedLanguage.fr: 'Vous devez etre le proprietaire de ce scrappable pour creer une session.',
    SupportedLanguage.ptBR: 'Voce deve ser o proprietario deste scrappable para criar uma sessao para ele.',
    SupportedLanguage.ja: 'セッションを作成するにはこのscrappableの所有者である必要があります。',
  },
  'authentication_required_ai_model': {
    SupportedLanguage.en: 'You must be logged in to use this AI model.',
    SupportedLanguage.es: 'Debes iniciar sesion para usar este modelo de IA.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um dieses KI-Modell zu verwenden.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour utiliser ce modele IA.',
    SupportedLanguage.ptBR: 'Voce deve estar logado para usar este modelo de IA.',
    SupportedLanguage.ja: 'このAIモデルを使用するにはログインが必要です。',
  },

  // AI generation errors
  'ai_generation_failed': {
    SupportedLanguage.en: 'An unexpected error occurred while generating the scrappable. Please try again later.',
    SupportedLanguage.es: 'Ocurrio un error inesperado al generar el scrappable. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Beim Generieren des Scrappables ist ein unerwarteter Fehler aufgetreten. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Une erreur inattendue s\'est produite lors de la generation du scrappable. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Ocorreu um erro inesperado ao gerar o scrappable. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'scrappableの生成中に予期しないエラーが発生しました。後でもう一度お試しください。',
  },

  // Ultra plan specific
  'ultra_plan_required_marketplace': {
    SupportedLanguage.en: 'Hiding scrappables from marketplace is only available for Ultra plan users.',
    SupportedLanguage.es: 'Ocultar scrappables del marketplace solo esta disponible para usuarios del plan Ultra.',
    SupportedLanguage.de: 'Das Verstecken von Scrappables vom Marketplace ist nur fur Ultra-Plan-Benutzer verfugbar.',
    SupportedLanguage.fr: 'Masquer les scrappables du marketplace est disponible uniquement pour les utilisateurs du plan Ultra.',
    SupportedLanguage.ptBR: 'Ocultar scrappables do marketplace esta disponivel apenas para usuarios do plano Ultra.',
    SupportedLanguage.ja: 'マーケットプレイスからscrappableを非表示にするにはUltraプランが必要です。',
  },

  // Upgrade errors
  'upgrade_required_ai_model': {
    SupportedLanguage.en: 'You need at least a Pro plan to use this AI model. Upgrade your plan to access advanced AI models.',
    SupportedLanguage.es: 'Necesitas al menos un plan Pro para usar este modelo de IA. Actualiza tu plan para acceder a modelos de IA avanzados.',
    SupportedLanguage.de: 'Sie benotigen mindestens einen Pro-Plan, um dieses KI-Modell zu verwenden. Aktualisieren Sie Ihren Plan, um auf erweiterte KI-Modelle zuzugreifen.',
    SupportedLanguage.fr: 'Vous avez besoin d\'au moins un plan Pro pour utiliser ce modele IA. Mettez a niveau votre plan pour acceder aux modeles IA avances.',
    SupportedLanguage.ptBR: 'Voce precisa de pelo menos um plano Pro para usar este modelo de IA. Atualize seu plano para acessar modelos de IA avancados.',
    SupportedLanguage.ja: 'このAIモデルを使用するにはProプラン以上が必要です。高度なAIモデルにアクセスするにはプランをアップグレードしてください。',
  },

  // API Helper error descriptions
  'missing_path_parameter': {
    SupportedLanguage.en: 'Required path parameter "{pathParam}" was not provided in the payload.',
    SupportedLanguage.es: 'El parametro de ruta requerido "{pathParam}" no fue proporcionado en el payload.',
    SupportedLanguage.de: 'Der erforderliche Pfadparameter "{pathParam}" wurde nicht in der Nutzlast bereitgestellt.',
    SupportedLanguage.fr: 'Le parametre de chemin requis "{pathParam}" n\'a pas ete fourni dans la charge utile.',
    SupportedLanguage.ptBR: 'O parametro de caminho obrigatorio "{pathParam}" nao foi fornecido no payload.',
    SupportedLanguage.ja: '必須のパスパラメータ "{pathParam}" がペイロードに含まれていません。',
  },
  'unexpected_error': {
    SupportedLanguage.en: 'An unexpected error occurred. Please try again later.',
    SupportedLanguage.es: 'Ocurrio un error inesperado. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Une erreur inattendue s\'est produite. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: '予期しないエラーが発生しました。後でもう一度お試しください。',
  },
  'test_data_not_found': {
    SupportedLanguage.en: 'No reference test data found for this scrappable session.',
    SupportedLanguage.es: 'No se encontraron datos de prueba de referencia para esta sesion de scrappable.',
    SupportedLanguage.de: 'Keine Referenztestdaten fur diese Scrappable-Sitzung gefunden.',
    SupportedLanguage.fr: 'Aucune donnee de test de reference trouvee pour cette session scrappable.',
    SupportedLanguage.ptBR: 'Nenhum dado de teste de referencia encontrado para esta sessao de scrappable.',
    SupportedLanguage.ja: 'このscrappableセッションのリファレンステストデータが見つかりません。',
  },
  'no_credit_usage_model': {
    SupportedLanguage.en: 'No credit usage model found for the provided API key: {apiKey}. It could be that the account was deleted or has no plan assigned - check in your API key tab on ZenScrap site.',
    SupportedLanguage.es: 'No se encontro modelo de uso de creditos para la clave API proporcionada: {apiKey}. Puede que la cuenta haya sido eliminada o no tenga un plan asignado - verifica en la pestana de claves API en el sitio de ZenScrap.',
    SupportedLanguage.de: 'Kein Kreditnutzungsmodell fur den angegebenen API-Schlussel gefunden: {apiKey}. Moglicherweise wurde das Konto geloscht oder es ist kein Plan zugewiesen - prufen Sie dies im API-Schlussel-Tab auf der ZenScrap-Website.',
    SupportedLanguage.fr: 'Aucun modele d\'utilisation de credits trouve pour la cle API fournie : {apiKey}. Il est possible que le compte ait ete supprime ou qu\'aucun plan ne soit attribue - verifiez dans l\'onglet des cles API sur le site ZenScrap.',
    SupportedLanguage.ptBR: 'Nenhum modelo de uso de creditos encontrado para a chave API fornecida: {apiKey}. Pode ser que a conta tenha sido excluida ou nao tenha um plano atribuido - verifique na aba de chaves API no site do ZenScrap.',
    SupportedLanguage.ja: '指定されたAPIキー: {apiKey} のクレジット使用モデルが見つかりません。アカウントが削除されたか、プランが割り当てられていない可能性があります - ZenScrapサイトのAPIキータブで確認してください。',
  },
  'api_key_not_found_active': {
    SupportedLanguage.en: 'There is no active API key matching the provided value: {apiKey}. It could be that the key was deleted or deactivated - check in your API key tab on ZenScrap site.',
    SupportedLanguage.es: 'No hay ninguna clave API activa que coincida con el valor proporcionado: {apiKey}. Puede que la clave haya sido eliminada o desactivada - verifica en la pestana de claves API en el sitio de ZenScrap.',
    SupportedLanguage.de: 'Es gibt keinen aktiven API-Schlussel, der dem angegebenen Wert entspricht: {apiKey}. Moglicherweise wurde der Schlussel geloscht oder deaktiviert - prufen Sie dies im API-Schlussel-Tab auf der ZenScrap-Website.',
    SupportedLanguage.fr: 'Il n\'y a pas de cle API active correspondant a la valeur fournie : {apiKey}. La cle a peut-etre ete supprimee ou desactivee - verifiez dans l\'onglet des cles API sur le site ZenScrap.',
    SupportedLanguage.ptBR: 'Nao ha chave API ativa correspondente ao valor fornecido: {apiKey}. Pode ser que a chave tenha sido excluida ou desativada - verifique na aba de chaves API no site do ZenScrap.',
    SupportedLanguage.ja: '指定された値: {apiKey} に一致するアクティブなAPIキーがありません。キーが削除または無効化された可能性があります - ZenScrapサイトのAPIキータブで確認してください。',
  },
  'no_active_test_session': {
    SupportedLanguage.en: 'There is no active test session found for the provided scrappable.',
    SupportedLanguage.es: 'No se encontro ninguna sesion de prueba activa para el scrappable proporcionado.',
    SupportedLanguage.de: 'Fur das angegebene Scrappable wurde keine aktive Testsitzung gefunden.',
    SupportedLanguage.fr: 'Aucune session de test active trouvee pour le scrappable fourni.',
    SupportedLanguage.ptBR: 'Nenhuma sessao de teste ativa encontrada para o scrappable fornecido.',
    SupportedLanguage.ja: '指定されたscrappableのアクティブなテストセッションが見つかりません。',
  },
  'test_period_expired': {
    SupportedLanguage.en: 'The test period for this scrappable has expired. You can: Start a new testing session that will start a new test period, or call the production endpoint with a valid API key if you have an account.',
    SupportedLanguage.es: 'El periodo de prueba para este scrappable ha expirado. Puedes: Iniciar una nueva sesion de prueba que comenzara un nuevo periodo de prueba, o llamar al endpoint de produccion con una clave API valida si tienes una cuenta.',
    SupportedLanguage.de: 'Der Testzeitraum fur dieses Scrappable ist abgelaufen. Sie konnen: Eine neue Testsitzung starten, die einen neuen Testzeitraum beginnt, oder den Produktionsendpunkt mit einem gultigen API-Schlussel aufrufen, wenn Sie ein Konto haben.',
    SupportedLanguage.fr: 'La periode de test pour ce scrappable a expire. Vous pouvez : Demarrer une nouvelle session de test qui commencera une nouvelle periode de test, ou appeler l\'endpoint de production avec une cle API valide si vous avez un compte.',
    SupportedLanguage.ptBR: 'O periodo de teste para este scrappable expirou. Voce pode: Iniciar uma nova sessao de teste que iniciara um novo periodo de teste, ou chamar o endpoint de producao com uma chave API valida se voce tiver uma conta.',
    SupportedLanguage.ja: 'このscrappableのテスト期間が終了しました。新しいテスト期間を開始する新しいテストセッションを開始するか、アカウントをお持ちの場合は有効なAPIキーで本番エンドポイントを呼び出すことができます。',
  },
  'api_key_database_not_found': {
    SupportedLanguage.en: 'No account API key matched the provided value (key not found in database).',
    SupportedLanguage.es: 'Ninguna clave API de cuenta coincidio con el valor proporcionado (clave no encontrada en la base de datos).',
    SupportedLanguage.de: 'Kein Konto-API-Schlussel stimmte mit dem angegebenen Wert uberein (Schlussel nicht in der Datenbank gefunden).',
    SupportedLanguage.fr: 'Aucune cle API de compte ne correspond a la valeur fournie (cle non trouvee dans la base de donnees).',
    SupportedLanguage.ptBR: 'Nenhuma chave API de conta correspondeu ao valor fornecido (chave nao encontrada no banco de dados).',
    SupportedLanguage.ja: 'アカウントAPIキーが指定された値と一致しませんでした（データベースにキーが見つかりません）。',
  },
  'insufficient_credits': {
    SupportedLanguage.en: 'Your account has no remaining credits. Purchase or allocate more credits to continue making requests.',
    SupportedLanguage.es: 'Tu cuenta no tiene creditos restantes. Compra o asigna mas creditos para continuar haciendo solicitudes.',
    SupportedLanguage.de: 'Ihr Konto hat keine verbleibenden Guthaben. Kaufen oder weisen Sie mehr Guthaben zu, um weiterhin Anfragen stellen zu konnen.',
    SupportedLanguage.fr: 'Votre compte n\'a plus de credits. Achetez ou allouez plus de credits pour continuer a faire des demandes.',
    SupportedLanguage.ptBR: 'Sua conta nao tem creditos restantes. Compre ou aloque mais creditos para continuar fazendo solicitacoes.',
    SupportedLanguage.ja: 'アカウントにクレジットが残っていません。リクエストを続けるにはクレジットを購入または割り当ててください。',
  },
  'missing_extract_rules': {
    SupportedLanguage.en: 'No extract rules are defined for this scrappable. Please define extraction rules before invoking this endpoint.',
    SupportedLanguage.es: 'No hay reglas de extraccion definidas para este scrappable. Por favor, define las reglas de extraccion antes de invocar este endpoint.',
    SupportedLanguage.de: 'Fur dieses Scrappable sind keine Extraktionsregeln definiert. Bitte definieren Sie Extraktionsregeln, bevor Sie diesen Endpunkt aufrufen.',
    SupportedLanguage.fr: 'Aucune regle d\'extraction n\'est definie pour ce scrappable. Veuillez definir les regles d\'extraction avant d\'invoquer cet endpoint.',
    SupportedLanguage.ptBR: 'Nenhuma regra de extracao esta definida para este scrappable. Por favor, defina as regras de extracao antes de invocar este endpoint.',
    SupportedLanguage.ja: 'このscrappableには抽出ルールが定義されていません。このエンドポイントを呼び出す前に抽出ルールを定義してください。',
  },
  'invalid_api_key_account': {
    SupportedLanguage.en: 'The provided API key does not have a user account.',
    SupportedLanguage.es: 'La clave API proporcionada no tiene una cuenta de usuario.',
    SupportedLanguage.de: 'Der angegebene API-Schlussel hat kein Benutzerkonto.',
    SupportedLanguage.fr: 'La cle API fournie n\'a pas de compte utilisateur.',
    SupportedLanguage.ptBR: 'A chave API fornecida nao possui uma conta de usuario.',
    SupportedLanguage.ja: '指定されたAPIキーにはユーザーアカウントがありません。',
  },
  'concurrency_limit_exceeded': {
    SupportedLanguage.en: 'You have reached the maximum number of concurrent requests allowed for your plan tier. (Max allowed concurrent requests: {maxConcurrentRequests})',
    SupportedLanguage.es: 'Has alcanzado el numero maximo de solicitudes concurrentes permitidas para tu nivel de plan. (Maximo de solicitudes concurrentes permitidas: {maxConcurrentRequests})',
    SupportedLanguage.de: 'Sie haben die maximale Anzahl gleichzeitiger Anfragen fur Ihre Planstufe erreicht. (Maximal erlaubte gleichzeitige Anfragen: {maxConcurrentRequests})',
    SupportedLanguage.fr: 'Vous avez atteint le nombre maximum de requetes simultanees autorisees pour votre niveau de plan. (Requetes simultanees maximum autorisees : {maxConcurrentRequests})',
    SupportedLanguage.ptBR: 'Voce atingiu o numero maximo de solicitacoes simultaneas permitidas para seu nivel de plano. (Maximo de solicitacoes simultaneas permitidas: {maxConcurrentRequests})',
    SupportedLanguage.ja: 'プラン階層で許可されている同時リクエストの最大数に達しました。（最大同時リクエスト数: {maxConcurrentRequests}）',
  },
  'api_scrappable_not_found': {
    SupportedLanguage.en: 'The scrappable resource with id {scrappableId} does not exist or has no target request configured.',
    SupportedLanguage.es: 'El recurso scrappable con id {scrappableId} no existe o no tiene una solicitud de destino configurada.',
    SupportedLanguage.de: 'Die Scrappable-Ressource mit der ID {scrappableId} existiert nicht oder hat keine Zielanfrage konfiguriert.',
    SupportedLanguage.fr: 'La ressource scrappable avec l\'id {scrappableId} n\'existe pas ou n\'a pas de requete cible configuree.',
    SupportedLanguage.ptBR: 'O recurso scrappable com id {scrappableId} nao existe ou nao tem uma solicitacao de destino configurada.',
    SupportedLanguage.ja: 'ID {scrappableId} のscrappableリソースが存在しないか、ターゲットリクエストが設定されていません。',
  },
  'invalid_api_key_format': {
    SupportedLanguage.en: 'API Key must be in the format "nanoId::apiKey".',
    SupportedLanguage.es: 'La clave API debe estar en el formato "nanoId::apiKey".',
    SupportedLanguage.de: 'Der API-Schlussel muss im Format "nanoId::apiKey" sein.',
    SupportedLanguage.fr: 'La cle API doit etre au format "nanoId::apiKey".',
    SupportedLanguage.ptBR: 'A chave API deve estar no formato "nanoId::apiKey".',
    SupportedLanguage.ja: 'APIキーは "nanoId::apiKey" の形式である必要があります。',
  },
  'openai_api_key_invalid': {
    SupportedLanguage.en: 'The OpenAI API key you provided is invalid. Please check your key and try again.',
    SupportedLanguage.es: 'La clave API de OpenAI que proporcionaste es invalida. Por favor, verifica tu clave e intenta de nuevo.',
    SupportedLanguage.de: 'Der von Ihnen angegebene OpenAI API-Schluessel ist ungueltig. Bitte ueberpruefen Sie Ihren Schluessel und versuchen Sie es erneut.',
    SupportedLanguage.fr: 'La cle API OpenAI que vous avez fournie est invalide. Veuillez verifier votre cle et reessayer.',
    SupportedLanguage.ptBR: 'A chave API OpenAI que voce forneceu e invalida. Por favor, verifique sua chave e tente novamente.',
    SupportedLanguage.ja: '入力されたOpenAI APIキーは無効です。キーを確認して再度お試しください。',
  },
  'openai_api_key_validation_failed': {
    SupportedLanguage.en: 'Could not validate the OpenAI API key. Please check your internet connection and try again.',
    SupportedLanguage.es: 'No se pudo validar la clave API de OpenAI. Por favor, verifica tu conexion a internet e intenta de nuevo.',
    SupportedLanguage.de: 'Der OpenAI API-Schluessel konnte nicht validiert werden. Bitte ueberpruefen Sie Ihre Internetverbindung und versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Impossible de valider la cle API OpenAI. Veuillez verifier votre connexion internet et reessayer.',
    SupportedLanguage.ptBR: 'Nao foi possivel validar a chave API OpenAI. Por favor, verifique sua conexao com a internet e tente novamente.',
    SupportedLanguage.ja: 'OpenAI APIキーを検証できませんでした。インターネット接続を確認して再度お試しください。',
  },

  // Deploy endpoint error descriptions
  'no_byte_data_to_deploy': {
    SupportedLanguage.en: 'You cannot deploy reference test data that does not have any byte data yet.',
    SupportedLanguage.es: 'No puedes desplegar datos de prueba de referencia que aun no tienen datos de bytes.',
    SupportedLanguage.de: 'Sie konnen keine Referenztestdaten bereitstellen, die noch keine Byte-Daten haben.',
    SupportedLanguage.fr: 'Vous ne pouvez pas deployer des donnees de test de reference qui n\'ont pas encore de donnees d\'octets.',
    SupportedLanguage.ptBR: 'Voce nao pode implantar dados de teste de referencia que ainda nao possuem dados de bytes.',
    SupportedLanguage.ja: 'バイトデータがないリファレンステストデータはデプロイできません。',
  },
  'authentication_or_reference_data': {
    SupportedLanguage.en: 'You probably must be authenticated to modify this reference test data - or you mistyped the id of it.',
    SupportedLanguage.es: 'Probablemente debes estar autenticado para modificar estos datos de prueba de referencia - o escribiste mal el id.',
    SupportedLanguage.de: 'Sie mussen wahrscheinlich authentifiziert sein, um diese Referenztestdaten zu andern - oder Sie haben die ID falsch eingegeben.',
    SupportedLanguage.fr: 'Vous devez probablement etre authentifie pour modifier ces donnees de test de reference - ou vous avez mal saisi l\'id.',
    SupportedLanguage.ptBR: 'Voce provavelmente deve estar autenticado para modificar estes dados de teste de referencia - ou voce digitou errado o id.',
    SupportedLanguage.ja: 'このリファレンステストデータを変更するには認証が必要か、IDを入力ミスした可能性があります。',
  },

  // Default classes error descriptions
  'internal_scrappable_not_found': {
    SupportedLanguage.en: 'This could be an internal error, please contact support.',
    SupportedLanguage.es: 'Esto podria ser un error interno, por favor contacta con soporte.',
    SupportedLanguage.de: 'Dies konnte ein interner Fehler sein, bitte kontaktieren Sie den Support.',
    SupportedLanguage.fr: 'Cela pourrait etre une erreur interne, veuillez contacter le support.',
    SupportedLanguage.ptBR: 'Isso pode ser um erro interno, por favor entre em contato com o suporte.',
    SupportedLanguage.ja: 'これは内部エラーの可能性があります。サポートにお問い合わせください。',
  },

  // Auto-fix configuration error descriptions
  'auto_fix_threshold_too_low': {
    SupportedLanguage.en: 'Auto-fix error threshold must be at least 25.',
    SupportedLanguage.es: 'El umbral de errores de auto-fix debe ser al menos 25.',
    SupportedLanguage.de: 'Der Auto-Fix-Fehlerschwellenwert muss mindestens 25 sein.',
    SupportedLanguage.fr: 'Le seuil d\'erreurs auto-fix doit etre d\'au moins 25.',
    SupportedLanguage.ptBR: 'O limite de erros do auto-fix deve ser pelo menos 25.',
    SupportedLanguage.ja: '自動修正のエラーしきい値は25以上である必要があります。',
  },
  'auto_fix_threshold_too_high': {
    SupportedLanguage.en: 'Auto-fix error threshold cannot exceed 5000.',
    SupportedLanguage.es: 'El umbral de errores de auto-fix no puede superar 5000.',
    SupportedLanguage.de: 'Der Auto-Fix-Fehlerschwellenwert darf 5000 nicht uberschreiten.',
    SupportedLanguage.fr: 'Le seuil d\'erreurs auto-fix ne peut pas depasser 5000.',
    SupportedLanguage.ptBR: 'O limite de erros do auto-fix nao pode exceder 5000.',
    SupportedLanguage.ja: '自動修正のエラーしきい値は5000を超えることはできません。',
  },
};
