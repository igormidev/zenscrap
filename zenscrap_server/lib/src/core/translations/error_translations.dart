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
    SupportedLanguage.es: 'Autenticación Fallida',
    SupportedLanguage.de: 'Authentifizierung fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de l\'authentification',
    SupportedLanguage.ptBR: 'Falha na Autenticação',
    SupportedLanguage.ja: '認証に失敗しました',
  },
  'user_not_authenticated': {
    SupportedLanguage.en: 'User Not Authenticated',
    SupportedLanguage.es: 'Usuario No Autenticado',
    SupportedLanguage.de: 'Benutzer nicht authentifiziert',
    SupportedLanguage.fr: 'Utilisateur non authentifié',
    SupportedLanguage.ptBR: 'Usuário Não Autenticado',
    SupportedLanguage.ja: 'ユーザーが認証されていません',
  },

  // Account errors
  'account_not_found': {
    SupportedLanguage.en: 'Account Not Found',
    SupportedLanguage.es: 'Cuenta No Encontrada',
    SupportedLanguage.de: 'Konto nicht gefunden',
    SupportedLanguage.fr: 'Compte non trouvé',
    SupportedLanguage.ptBR: 'Conta Não Encontrada',
    SupportedLanguage.ja: 'アカウントが見つかりません',
  },
  'account_creation_failed': {
    SupportedLanguage.en: 'Account Creation Failed',
    SupportedLanguage.es: 'Error al Crear Cuenta',
    SupportedLanguage.de: 'Kontoerstellung fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de la création du compte',
    SupportedLanguage.ptBR: 'Falha na Criação da Conta',
    SupportedLanguage.ja: 'アカウントの作成に失敗しました',
  },
  'database_error': {
    SupportedLanguage.en: 'Database Error',
    SupportedLanguage.es: 'Error de Base de Datos',
    SupportedLanguage.de: 'Datenbankfehler',
    SupportedLanguage.fr: 'Erreur de base de données',
    SupportedLanguage.ptBR: 'Erro no Banco de Dados',
    SupportedLanguage.ja: 'データベースエラー',
  },

  // Scrappable errors
  'scrappable_not_found': {
    SupportedLanguage.en: 'Scrappable Not Found',
    SupportedLanguage.es: 'Scrappable No Encontrado',
    SupportedLanguage.de: 'Scrappable nicht gefunden',
    SupportedLanguage.fr: 'Scrappable non trouvé',
    SupportedLanguage.ptBR: 'Scrappable Não Encontrado',
    SupportedLanguage.ja: 'Scrappableが見つかりません',
  },
  'scrappable_already_attached': {
    SupportedLanguage.en: 'Scrappable Already Attached',
    SupportedLanguage.es: 'Scrappable Ya Vinculado',
    SupportedLanguage.de: 'Scrappable bereits angehängt',
    SupportedLanguage.fr: 'Scrappable déjà attaché',
    SupportedLanguage.ptBR: 'Scrappable Já Vinculado',
    SupportedLanguage.ja: 'Scrappableは既に関連付けられています',
  },
  'endpoint_limit_reached': {
    SupportedLanguage.en: 'Endpoint Limit Reached',
    SupportedLanguage.es: 'Límite de Endpoints Alcanzado',
    SupportedLanguage.de: 'Endpunkt-Limit erreicht',
    SupportedLanguage.fr: 'Limite des endpoints atteinte',
    SupportedLanguage.ptBR: 'Límite de Endpoints Atingido',
    SupportedLanguage.ja: 'エンドポイントの制限に達しました',
  },
  'banned_domain': {
    SupportedLanguage.en: 'Domain Not Supported',
    SupportedLanguage.es: 'Dominio No Soportado',
    SupportedLanguage.de: 'Domain nicht unterstützt',
    SupportedLanguage.fr: 'Domaine non pris en charge',
    SupportedLanguage.ptBR: 'Domínio Não Suportado',
    SupportedLanguage.ja: 'サポートされていないドメイン',
  },

  // API Key errors
  'api_key_not_found': {
    SupportedLanguage.en: 'API Key Not Found',
    SupportedLanguage.es: 'Clave API No Encontrada',
    SupportedLanguage.de: 'API-Schlüssel nicht gefunden',
    SupportedLanguage.fr: 'Clé API non trouvée',
    SupportedLanguage.ptBR: 'Chave API Não Encontrada',
    SupportedLanguage.ja: 'APIキーが見つかりません',
  },
  'cannot_deactivate_api_key': {
    SupportedLanguage.en: 'Cannot Deactivate',
    SupportedLanguage.es: 'No Se Puede Desactivar',
    SupportedLanguage.de: 'Kann nicht deaktiviert werden',
    SupportedLanguage.fr: 'Impossible de désactiver',
    SupportedLanguage.ptBR: 'Não é Possível Desativar',
    SupportedLanguage.ja: '無効化できません',
  },

  // Subscription/Plan errors
  'ultra_plan_required': {
    SupportedLanguage.en: 'Ultra Plan Required',
    SupportedLanguage.es: 'Se Requiere Plan Ultra',
    SupportedLanguage.de: 'Ultra-Plan erforderlich',
    SupportedLanguage.fr: 'Plan Ultra requis',
    SupportedLanguage.ptBR: 'Plano Ultra Necessário',
    SupportedLanguage.ja: 'Ultraプランが必要です',
  },
  'upgrade_required': {
    SupportedLanguage.en: 'Upgrade Required',
    SupportedLanguage.es: 'Actualización Requerida',
    SupportedLanguage.de: 'Upgrade erforderlich',
    SupportedLanguage.fr: 'Mise à niveau requise',
    SupportedLanguage.ptBR: 'Atualização Necessária',
    SupportedLanguage.ja: 'アップグレードが必要です',
  },
  'checkout_creation_failed': {
    SupportedLanguage.en: 'Checkout Creation Failed',
    SupportedLanguage.es: 'Error al Crear Checkout',
    SupportedLanguage.de: 'Checkout-Erstellung fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de la création du paiement',
    SupportedLanguage.ptBR: 'Falha na Criação do Checkout',
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
    SupportedLanguage.fr: 'Déjà abonne',
    SupportedLanguage.ptBR: 'Já Inscrito',
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
    SupportedLanguage.fr: 'Email de l\'utilisateur non trouvé',
    SupportedLanguage.ptBR: 'Email do Usuário Não Encontrado',
    SupportedLanguage.ja: 'ユーザーのメールが見つかりません',
  },

  // Access errors
  'access_denied': {
    SupportedLanguage.en: 'Access Denied',
    SupportedLanguage.es: 'Acceso Denegado',
    SupportedLanguage.de: 'Zugriff verweigert',
    SupportedLanguage.fr: 'Accès refusé',
    SupportedLanguage.ptBR: 'Acesso Negado',
    SupportedLanguage.ja: 'アクセスが拒否されました',
  },
  'permission_denied': {
    SupportedLanguage.en: 'Permission Denied',
    SupportedLanguage.es: 'Permiso Denegado',
    SupportedLanguage.de: 'Berechtigung verweigert',
    SupportedLanguage.fr: 'Permission refusée',
    SupportedLanguage.ptBR: 'Permissão Negada',
    SupportedLanguage.ja: '権限がありません',
  },

  // Usage limit errors
  'usage_limit_reached': {
    SupportedLanguage.en: 'Usage Limit Reached',
    SupportedLanguage.es: 'Límite de Uso Alcanzado',
    SupportedLanguage.de: 'Nutzungslimit erreicht',
    SupportedLanguage.fr: 'Limite d\'utilisation atteinte',
    SupportedLanguage.ptBR: 'Límite de Uso Atingido',
    SupportedLanguage.ja: '使用制限に達しました',
  },
  'ai_credits_exhausted': {
    SupportedLanguage.en: 'AI Crédits Exhausted',
    SupportedLanguage.es: 'Créditos de IA Agotados',
    SupportedLanguage.de: 'KI-Guthaben aufgebraucht',
    SupportedLanguage.fr: 'Crédits IA épuisés',
    SupportedLanguage.ptBR: 'Créditos de IA Esgotados',
    SupportedLanguage.ja: 'AIクレジットが不足しています',
  },

  // Delete errors
  'already_deleted': {
    SupportedLanguage.en: 'Already Deleted',
    SupportedLanguage.es: 'Ya Eliminado',
    SupportedLanguage.de: 'Bereits gelöscht',
    SupportedLanguage.fr: 'Déjà supprimé',
    SupportedLanguage.ptBR: 'Já Excluído',
    SupportedLanguage.ja: '既に削除されています',
  },
  'delete_failed': {
    SupportedLanguage.en: 'Delete Failed',
    SupportedLanguage.es: 'Error al Eliminar',
    SupportedLanguage.de: 'Löschen fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de la suppression',
    SupportedLanguage.ptBR: 'Falha ao Excluir',
    SupportedLanguage.ja: '削除に失敗しました',
  },
  'update_failed': {
    SupportedLanguage.en: 'Update Failed',
    SupportedLanguage.es: 'Error al Actualizar',
    SupportedLanguage.de: 'Aktualisierung fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de la mise à jour',
    SupportedLanguage.ptBR: 'Falha ao Atualizar',
    SupportedLanguage.ja: '更新に失敗しました',
  },

  // Validation errors
  'invalid_name': {
    SupportedLanguage.en: 'Invalid Name',
    SupportedLanguage.es: 'Nombre Inválido',
    SupportedLanguage.de: 'Ungültiger Name',
    SupportedLanguage.fr: 'Nom invalide',
    SupportedLanguage.ptBR: 'Nome Inválido',
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
    SupportedLanguage.es: 'Descripción Inválida',
    SupportedLanguage.de: 'Ungültige Beschreibung',
    SupportedLanguage.fr: 'Description invalide',
    SupportedLanguage.ptBR: 'Descrição Inválida',
    SupportedLanguage.ja: '無効な説明',
  },
  'description_too_long': {
    SupportedLanguage.en: 'Description Too Long',
    SupportedLanguage.es: 'Descripción Muy Larga',
    SupportedLanguage.de: 'Beschreibung zu lang',
    SupportedLanguage.fr: 'Description trop longue',
    SupportedLanguage.ptBR: 'Descrição Muito Longa',
    SupportedLanguage.ja: '説明が長すぎます',
  },
  'invalid_api_key': {
    SupportedLanguage.en: 'Invalid API Key',
    SupportedLanguage.es: 'Clave API Inválida',
    SupportedLanguage.de: 'Ungültiger API-Schlüssel',
    SupportedLanguage.fr: 'Clé API invalide',
    SupportedLanguage.ptBR: 'Chave API Inválida',
    SupportedLanguage.ja: '無効なAPIキー',
  },

  // Scrappable availability errors
  'scrappable_not_available': {
    SupportedLanguage.en: 'Scrappable Not Available',
    SupportedLanguage.es: 'Scrappable No Disponible',
    SupportedLanguage.de: 'Scrappable nicht verfügbar',
    SupportedLanguage.fr: 'Scrappable non disponible',
    SupportedLanguage.ptBR: 'Scrappable Não Disponível',
    SupportedLanguage.ja: 'Scrappableは利用できません',
  },

  // Session errors
  'session_not_found': {
    SupportedLanguage.en: 'Session Not Found',
    SupportedLanguage.es: 'Sesión No Encontrada',
    SupportedLanguage.de: 'Sitzung nicht gefunden',
    SupportedLanguage.fr: 'Session non trouvée',
    SupportedLanguage.ptBR: 'Sessão Não Encontrada',
    SupportedLanguage.ja: 'セッションが見つかりません',
  },
  'session_already_opened': {
    SupportedLanguage.en: 'Session Already Opened',
    SupportedLanguage.es: 'Sesión Ya Abierta',
    SupportedLanguage.de: 'Sitzung bereits geöffnet',
    SupportedLanguage.fr: 'Session déjà ouverte',
    SupportedLanguage.ptBR: 'Sessão Já Aberta',
    SupportedLanguage.ja: 'セッションは既に開いています',
  },
  'ai_usage_record_not_found': {
    SupportedLanguage.en: 'AI Usage Record Not Found',
    SupportedLanguage.es: 'Registro de Uso de IA No Encontrado',
    SupportedLanguage.de: 'KI-Nutzungsdatensatz nicht gefunden',
    SupportedLanguage.fr: 'Enregistrement d\'utilisation IA non trouvé',
    SupportedLanguage.ptBR: 'Registro de Uso de IA Não Encontrado',
    SupportedLanguage.ja: 'AI使用記録が見つかりません',
  },
  'failed_to_save_api_key': {
    SupportedLanguage.en: 'Failed to Save API Key',
    SupportedLanguage.es: 'Error al Guardar Clave API',
    SupportedLanguage.de: 'API-Schlüssel speichern fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de l\'enregistrement de la clé API',
    SupportedLanguage.ptBR: 'Falha ao Salvar Chave API',
    SupportedLanguage.ja: 'APIキーの保存に失敗しました',
  },

  // AI génération errors
  'ai_generation_failed': {
    SupportedLanguage.en: 'AI Generation Failed',
    SupportedLanguage.es: 'Error en la Generación de IA',
    SupportedLanguage.de: 'KI-Generierung fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de la génération IA',
    SupportedLanguage.ptBR: 'Falha na Geração de IA',
    SupportedLanguage.ja: 'AI生成に失敗しました',
  },

  // Ultra plan specific
  'ultra_plan_required_marketplace': {
    SupportedLanguage.en: 'Ultra Plan Required',
    SupportedLanguage.es: 'Se Requiere Plan Ultra',
    SupportedLanguage.de: 'Ultra-Plan erforderlich',
    SupportedLanguage.fr: 'Plan Ultra requis',
    SupportedLanguage.ptBR: 'Plano Ultra Necessário',
    SupportedLanguage.ja: 'Ultraプランが必要です',
  },

  // API Helper errors
  'missing_path_parameter': {
    SupportedLanguage.en: 'Missing Path Parameter',
    SupportedLanguage.es: 'Parámetro de Ruta Faltante',
    SupportedLanguage.de: 'Fehlender Pfadparameter',
    SupportedLanguage.fr: 'Paramètre de chemin manquant',
    SupportedLanguage.ptBR: 'Parâmetro de Caminho Faltando',
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
    SupportedLanguage.fr: 'Donnees de test non trouvées',
    SupportedLanguage.ptBR: 'Dados de Teste Não Encontrados',
    SupportedLanguage.ja: 'テストデータが見つかりません',
  },
  'no_credit_usage_model': {
    SupportedLanguage.en: 'No Credit Usage Model Found',
    SupportedLanguage.es: 'Modelo de Uso de Créditos No Encontrado',
    SupportedLanguage.de: 'Kein Kreditnutzungsmodell gefunden',
    SupportedLanguage.fr: 'Modele d\'utilisation des crédits non trouvé',
    SupportedLanguage.ptBR: 'Modelo de Uso de Créditos Não Encontrado',
    SupportedLanguage.ja: 'クレジット使用モデルが見つかりません',
  },
  'api_key_not_found_active': {
    SupportedLanguage.en: 'Valid API Key Not Found',
    SupportedLanguage.es: 'Clave API Valida No Encontrada',
    SupportedLanguage.de: 'Gültiger API-Schlüssel nicht gefunden',
    SupportedLanguage.fr: 'Clé API valide non trouvée',
    SupportedLanguage.ptBR: 'Chave API Válida Não Encontrada',
    SupportedLanguage.ja: '有効なAPIキーが見つかりません',
  },
  'no_active_test_session': {
    SupportedLanguage.en: 'No Active Test Session Found',
    SupportedLanguage.es: 'Sesión de Prueba Activa No Encontrada',
    SupportedLanguage.de: 'Keine aktive Testsitzung gefunden',
    SupportedLanguage.fr: 'Aucune session de test active trouvee',
    SupportedLanguage.ptBR: 'Sessão de Teste Ativa Não Encontrada',
    SupportedLanguage.ja: 'アクティブなテストセッションが見つかりません',
  },
  'test_period_expired': {
    SupportedLanguage.en: 'Test Period Expired',
    SupportedLanguage.es: 'Período de Prueba Expirado',
    SupportedLanguage.de: 'Testzeitraum abgelaufen',
    SupportedLanguage.fr: 'Période de test expirée',
    SupportedLanguage.ptBR: 'Período de Teste Expirado',
    SupportedLanguage.ja: 'テスト期間が終了しました',
  },
  'api_key_database_not_found': {
    SupportedLanguage.en: 'API Key Not Found',
    SupportedLanguage.es: 'Clave API No Encontrada',
    SupportedLanguage.de: 'API-Schlüssel nicht gefunden',
    SupportedLanguage.fr: 'Clé API non trouvée',
    SupportedLanguage.ptBR: 'Chave API Não Encontrada',
    SupportedLanguage.ja: 'APIキーが見つかりません',
  },
  'insufficient_credits': {
    SupportedLanguage.en: 'Insufficient Credits',
    SupportedLanguage.es: 'Créditos Insuficientes',
    SupportedLanguage.de: 'Unzureichendes Guthaben',
    SupportedLanguage.fr: 'Crédits insuffisants',
    SupportedLanguage.ptBR: 'Créditos Insuficientes',
    SupportedLanguage.ja: 'クレジットが不足しています',
  },
  'missing_extract_rules': {
    SupportedLanguage.en: 'Missing Extract Rules',
    SupportedLanguage.es: 'Reglas de Extracción Faltantes',
    SupportedLanguage.de: 'Fehlende Extraktionsregeln',
    SupportedLanguage.fr: 'Règles d\'extraction manquantes',
    SupportedLanguage.ptBR: 'Regras de Extração Faltando',
    SupportedLanguage.ja: '抽出ルールがありません',
  },
  'invalid_api_key_account': {
    SupportedLanguage.en: 'Invalid API Key',
    SupportedLanguage.es: 'Clave API Inválida',
    SupportedLanguage.de: 'Ungültiger API-Schlüssel',
    SupportedLanguage.fr: 'Clé API invalide',
    SupportedLanguage.ptBR: 'Chave API Inválida',
    SupportedLanguage.ja: '無効なAPIキー',
  },
  'concurrency_limit_exceeded': {
    SupportedLanguage.en: 'Concurrency Limit Exceeded',
    SupportedLanguage.es: 'Límite de Concurrencia Excedido',
    SupportedLanguage.de: 'Gleichzeitigkeitslimit überschritten',
    SupportedLanguage.fr: 'Límite de concurrence dépassée',
    SupportedLanguage.ptBR: 'Límite de Concorrência Excedido',
    SupportedLanguage.ja: '同時接続数の制限を超えました',
  },
  'api_scrappable_not_found': {
    SupportedLanguage.en: 'Scrappable Not Found',
    SupportedLanguage.es: 'Scrappable No Encontrado',
    SupportedLanguage.de: 'Scrappable nicht gefunden',
    SupportedLanguage.fr: 'Scrappable non trouvé',
    SupportedLanguage.ptBR: 'Scrappable Não Encontrado',
    SupportedLanguage.ja: 'Scrappableが見つかりません',
  },
  'invalid_api_key_format': {
    SupportedLanguage.en: 'Invalid API Key Format',
    SupportedLanguage.es: 'Formato de Clave API Inválido',
    SupportedLanguage.de: 'Ungültiges API-Schlüssel-Format',
    SupportedLanguage.fr: 'Format de clé API invalide',
    SupportedLanguage.ptBR: 'Formato de Chave API Inválido',
    SupportedLanguage.ja: '無効なAPIキー形式',
  },
  'openai_api_key_invalid': {
    SupportedLanguage.en: 'Invalid OpenAI API Key',
    SupportedLanguage.es: 'Clave API de OpenAI Inválida',
    SupportedLanguage.de: 'Ungueltiger OpenAI API-Schluessel',
    SupportedLanguage.fr: 'Clé API OpenAI invalide',
    SupportedLanguage.ptBR: 'Chave API OpenAI Inválida',
    SupportedLanguage.ja: '無効なOpenAI APIキー',
  },
  'openai_api_key_validation_failed': {
    SupportedLanguage.en: 'API Key Validation Failed',
    SupportedLanguage.es: 'Error en la Validacion de la Clave API',
    SupportedLanguage.de: 'API-Schluessel-Validierung fehlgeschlagen',
    SupportedLanguage.fr: 'Échec de la validation de la clé API',
    SupportedLanguage.ptBR: 'Falha na Validação da Chave API',
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
    SupportedLanguage.es: 'Autenticación Requerida o Datos de Referencia No Encontrados',
    SupportedLanguage.de: 'Authentifizierung erforderlich oder Referenzdaten nicht gefunden',
    SupportedLanguage.fr: 'Authentification requise ou données de reference non trouvées',
    SupportedLanguage.ptBR: 'Autenticação Necessária ou Dados de Referência Não Encontrados',
    SupportedLanguage.ja: '認証が必要またはリファレンスデータが見つかりません',
  },

  // Default classes errors
  'internal_scrappable_not_found': {
    SupportedLanguage.en: 'Scrappable Not Found',
    SupportedLanguage.es: 'Scrappable No Encontrado',
    SupportedLanguage.de: 'Scrappable nicht gefunden',
    SupportedLanguage.fr: 'Scrappable non trouvé',
    SupportedLanguage.ptBR: 'Scrappable Não Encontrado',
    SupportedLanguage.ja: 'Scrappableが見つかりません',
  },

  // Auto-fix configuration errors
  'auto_fix_threshold_too_low': {
    SupportedLanguage.en: 'Invalid Threshold',
    SupportedLanguage.es: 'Umbral Inválido',
    SupportedLanguage.de: 'Ungültiger Schwellenwert',
    SupportedLanguage.fr: 'Seuil invalide',
    SupportedLanguage.ptBR: 'Limite Inválido',
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
    SupportedLanguage.ptBR: 'Conexão Suspeita Detectada',
    SupportedLanguage.ja: '不審な接続が検出されました',
  },

  // Chat session errors
  'cache_scrappable_id_not_found': {
    SupportedLanguage.en: 'Cache Scrappable ID Not Found',
    SupportedLanguage.es: 'ID de Scrappable en Cache No Encontrado',
    SupportedLanguage.de: 'Cache-Scrappable-ID nicht gefunden',
    SupportedLanguage.fr: 'ID de Scrappable en cache non trouvé',
    SupportedLanguage.ptBR: 'ID de Scrappable em Cache Não Encontrado',
    SupportedLanguage.ja: 'キャッシュされたScrappable IDが見つかりません',
  },
  'cache_test_data_not_found': {
    SupportedLanguage.en: 'Cache Test Data Not Found',
    SupportedLanguage.es: 'Datos de Prueba en Cache No Encontrados',
    SupportedLanguage.de: 'Cache-Testdaten nicht gefunden',
    SupportedLanguage.fr: 'Donnees de test en cache non trouvées',
    SupportedLanguage.ptBR: 'Dados de Teste em Cache Não Encontrados',
    SupportedLanguage.ja: 'キャッシュされたテストデータが見つかりません',
  },
  'scrappable_request_not_found': {
    SupportedLanguage.en: 'Scrappable Request Not Found',
    SupportedLanguage.es: 'Solicitud de Scrappable No Encontrada',
    SupportedLanguage.de: 'Scrappable-Anfrage nicht gefunden',
    SupportedLanguage.fr: 'Requete Scrappable non trouvée',
    SupportedLanguage.ptBR: 'Solicitação de Scrappable Não Encontrada',
    SupportedLanguage.ja: 'Scrappableリクエストが見つかりません',
  },
  'reference_test_data_not_found': {
    SupportedLanguage.en: 'Reference Test Data Not Found',
    SupportedLanguage.es: 'Datos de Prueba de Referencia No Encontrados',
    SupportedLanguage.de: 'Referenz-Testdaten nicht gefunden',
    SupportedLanguage.fr: 'Donnees de test de reference non trouvées',
    SupportedLanguage.ptBR: 'Dados de Teste de Referência Não Encontrados',
    SupportedLanguage.ja: 'リファレンステストデータが見つかりません',
  },
  'target_request_not_found': {
    SupportedLanguage.en: 'Target Request Not Found',
    SupportedLanguage.es: 'Solicitud Objetivo No Encontrada',
    SupportedLanguage.de: 'Zielanfrage nicht gefunden',
    SupportedLanguage.fr: 'Requete cible non trouvée',
    SupportedLanguage.ptBR: 'Solicitação Alvo Não Encontrada',
    SupportedLanguage.ja: 'ターゲットリクエストが見つかりません',
  },
  'openai_api_key_missing': {
    SupportedLanguage.en: 'OpenAI API Key Missing',
    SupportedLanguage.es: 'Clave API de OpenAI Faltante',
    SupportedLanguage.de: 'OpenAI API-Schlüssel fehlt',
    SupportedLanguage.fr: 'Clé API OpenAI manquante',
    SupportedLanguage.ptBR: 'Chave API do OpenAI Ausente',
    SupportedLanguage.ja: 'OpenAI APIキーがありません',
  },
  'gemini_api_key_missing': {
    SupportedLanguage.en: 'Gemini API Key Missing',
    SupportedLanguage.es: 'Clave API de Gemini Faltante',
    SupportedLanguage.de: 'Gemini API-Schlüssel fehlt',
    SupportedLanguage.fr: 'Clé API Gemini manquante',
    SupportedLanguage.ptBR: 'Chave API do Gemini Ausente',
    SupportedLanguage.ja: 'Gemini APIキーがありません',
  },

  // Chat message titles (used as keys for chat response messages)
  'chat_session_closed': {
    SupportedLanguage.en: 'Session Closed',
    SupportedLanguage.es: 'Sesión Cerrada',
    SupportedLanguage.de: 'Sitzung geschlossen',
    SupportedLanguage.fr: 'Session fermee',
    SupportedLanguage.ptBR: 'Sessão Encerrada',
    SupportedLanguage.ja: 'セッションが閉じられました',
  },
  'chat_testing_rules': {
    SupportedLanguage.en: 'Testing Rules',
    SupportedLanguage.es: 'Probando Reglas',
    SupportedLanguage.de: 'Regeln testen',
    SupportedLanguage.fr: 'Test des regles',
    SupportedLanguage.ptBR: 'Testando Regras',
    SupportedLanguage.ja: 'ルールをテスト中',
  },
  'chat_rules_success': {
    SupportedLanguage.en: 'Rules Validated',
    SupportedLanguage.es: 'Reglas Validadas',
    SupportedLanguage.de: 'Regeln validiert',
    SupportedLanguage.fr: 'Règles validees',
    SupportedLanguage.ptBR: 'Regras Validadas',
    SupportedLanguage.ja: 'ルールが検証されました',
  },
  'chat_rules_failed': {
    SupportedLanguage.en: 'Validation Failed',
    SupportedLanguage.es: 'Validacion Fallida',
    SupportedLanguage.de: 'Validierung fehlgeschlagen',
    SupportedLanguage.fr: 'Validation echouee',
    SupportedLanguage.ptBR: 'Validação Falhou',
    SupportedLanguage.ja: '検証に失敗しました',
  },
  'chat_request_updated': {
    SupportedLanguage.en: 'Request Updated',
    SupportedLanguage.es: 'Solicitud Actualizada',
    SupportedLanguage.de: 'Anfrage aktualisiert',
    SupportedLanguage.fr: 'Requete mise à jour',
    SupportedLanguage.ptBR: 'Solicitação Atualizada',
    SupportedLanguage.ja: 'リクエストが更新されました',
  },
  'chat_api_key_configured': {
    SupportedLanguage.en: 'API Key Configured',
    SupportedLanguage.es: 'Clave API Configurada',
    SupportedLanguage.de: 'API-Schlüssel konfiguriert',
    SupportedLanguage.fr: 'Clé API configuree',
    SupportedLanguage.ptBR: 'Chave API Configurada',
    SupportedLanguage.ja: 'APIキーが設定されました',
  },
  'chat_ip_limit': {
    SupportedLanguage.en: 'IP Limit Reached',
    SupportedLanguage.es: 'Límite de IP Alcanzado',
    SupportedLanguage.de: 'IP-Limit erreicht',
    SupportedLanguage.fr: 'Limite IP atteinte',
    SupportedLanguage.ptBR: 'Límite de IP Atingido',
    SupportedLanguage.ja: 'IP制限に達しました',
  },
  'chat_credits_exhausted': {
    SupportedLanguage.en: 'Crédits Exhausted',
    SupportedLanguage.es: 'Créditos Agotados',
    SupportedLanguage.de: 'Guthaben aufgebraucht',
    SupportedLanguage.fr: 'Crédits épuisés',
    SupportedLanguage.ptBR: 'Créditos Esgotados',
    SupportedLanguage.ja: 'クレジットが不足しています',
  },
  'chat_quota_exceeded': {
    SupportedLanguage.en: 'Quota Exceeded',
    SupportedLanguage.es: 'Cuota Excedida',
    SupportedLanguage.de: 'Kontingent überschritten',
    SupportedLanguage.fr: 'Quota depasse',
    SupportedLanguage.ptBR: 'Cota Excedida',
    SupportedLanguage.ja: 'クォータを超えました',
  },
  'chat_message_error': {
    SupportedLanguage.en: 'Message Error',
    SupportedLanguage.es: 'Error de Mensaje',
    SupportedLanguage.de: 'Nachrichtenfehler',
    SupportedLanguage.fr: 'Erreur de message',
    SupportedLanguage.ptBR: 'Erro de Mensagem',
    SupportedLanguage.ja: 'メッセージエラー',
  },
  'chat_parse_error': {
    SupportedLanguage.en: 'Response Error',
    SupportedLanguage.es: 'Error de Respuesta',
    SupportedLanguage.de: 'Antwortfehler',
    SupportedLanguage.fr: 'Erreur de reponse',
    SupportedLanguage.ptBR: 'Erro de Resposta',
    SupportedLanguage.ja: 'レスポンスエラー',
  },
  'chat_auth_error': {
    SupportedLanguage.en: 'Authentication Error',
    SupportedLanguage.es: 'Error de Autenticacion',
    SupportedLanguage.de: 'Authentifizierungsfehler',
    SupportedLanguage.fr: 'Erreur d\'authentification',
    SupportedLanguage.ptBR: 'Erro de Autenticação',
    SupportedLanguage.ja: '認証エラー',
  },
  'chat_rate_limit': {
    SupportedLanguage.en: 'Rate Limit',
    SupportedLanguage.es: 'Límite de Velocidad',
    SupportedLanguage.de: 'Ratenlimit',
    SupportedLanguage.fr: 'Límite de debit',
    SupportedLanguage.ptBR: 'Límite de Taxa',
    SupportedLanguage.ja: 'レート制限',
  },

  // Country code errors
  'invalid_country_code': {
    SupportedLanguage.en: 'Invalid Country Code',
    SupportedLanguage.es: 'Código de País Inválido',
    SupportedLanguage.de: 'Ungültiger Ländercode',
    SupportedLanguage.fr: 'Code pays invalide',
    SupportedLanguage.ptBR: 'Código de País Inválido',
    SupportedLanguage.ja: '無効な国コード',
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
    SupportedLanguage.ptBR: 'O usuário deve estar logado para acessar este recurso.',
    SupportedLanguage.ja: 'このリソースにアクセスするにはログインが必要です。',
  },
  'user_not_authenticated': {
    SupportedLanguage.en: 'You must be logged in to access your scrappables.',
    SupportedLanguage.es: 'Debes iniciar sesion para acceder a tus scrappables.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um auf Ihre Scrappables zuzugreifen.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour acceder a vos scrappables.',
    SupportedLanguage.ptBR: 'Você deve estar logado para acessar seus scrappables.',
    SupportedLanguage.ja: 'scrappablesにアクセスするにはログインが必要です。',
  },

  // Account errors
  'account_not_found': {
    SupportedLanguage.en: 'Unable to find account information.',
    SupportedLanguage.es: 'No se pudo encontrar la informacion de la cuenta.',
    SupportedLanguage.de: 'Kontoinformationen konnten nicht gefunden werden.',
    SupportedLanguage.fr: 'Impossible de trouver les informations du compte.',
    SupportedLanguage.ptBR: 'Não foi possível encontrar as informações da conta.',
    SupportedLanguage.ja: 'アカウント情報が見つかりませんでした。',
  },
  'account_not_found_for_user': {
    SupportedLanguage.en: 'No account found for the authenticated user.',
    SupportedLanguage.es: 'No se encontro cuenta para el usuario autenticado.',
    SupportedLanguage.de: 'Kein Konto fur den authentifizierten Benutzer gefunden.',
    SupportedLanguage.fr: 'Aucun compte trouve pour l\'utilisateur authentifie.',
    SupportedLanguage.ptBR: 'Nenhuma conta encontrada para o usuário autenticado.',
    SupportedLanguage.ja: '認証済みユーザーのアカウントが見つかりませんでした。',
  },
  'account_creation_failed': {
    SupportedLanguage.en: 'Unable to create new account. Please try again later.',
    SupportedLanguage.es: 'No se pudo crear la nueva cuenta. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Neues Konto konnte nicht erstellt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Impossible de creer un nouveau compte. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Não foi possível criar uma nova conta. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: '新しいアカウントを作成できませんでした。後でもう一度お試しください。',
  },
  'account_creation_internal_error': {
    SupportedLanguage.en: 'This is an internal error. Please try again later.',
    SupportedLanguage.es: 'Este es un error interno. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Dies ist ein interner Fehler. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Ceci est une erreur interne. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Este é um erro interno. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'これは内部エラーです。後でもう一度お試しください。',
  },
  'database_error': {
    SupportedLanguage.en: 'Failed to retrieve account information. Please try again later.',
    SupportedLanguage.es: 'Error al recuperar la informacion de la cuenta. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Kontoinformationen konnten nicht abgerufen werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Échec de la recuperation des informations du compte. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao recuperar as informações da conta. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'アカウント情報の取得に失敗しました。後でもう一度お試しください。',
  },

  // Scrappable errors
  'scrappable_not_found': {
    SupportedLanguage.en: 'The requested scrappable does not exist.',
    SupportedLanguage.es: 'El scrappable solicitado no existe.',
    SupportedLanguage.de: 'Das angeforderte Scrappable existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable demande n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable solicitado não existe.',
    SupportedLanguage.ja: 'リクエストされたscrappableは存在しません。',
  },
  'scrappable_not_found_attach': {
    SupportedLanguage.en: 'The scrappable you are trying to attach does not exist.',
    SupportedLanguage.es: 'El scrappable que intentas vincular no existe.',
    SupportedLanguage.de: 'Das Scrappable, das Sie anhangen mochten, existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable que vous essayez d\'attacher n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable que você está tentando vincular não existe.',
    SupportedLanguage.ja: '関連付けようとしているscrappableは存在しません。',
  },
  'scrappable_not_found_clone': {
    SupportedLanguage.en: 'The scrappable you are trying to clone does not exist.',
    SupportedLanguage.es: 'El scrappable que intentas clonar no existe.',
    SupportedLanguage.de: 'Das Scrappable, das Sie klonen mochten, existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable que vous essayez de cloner n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable que você está tentando clonar não existe.',
    SupportedLanguage.ja: '複製しようとしているscrappableは存在しません。',
  },
  'scrappable_not_found_or_no_access': {
    SupportedLanguage.en: 'The requested scrappable was not found or you do not have access to it.',
    SupportedLanguage.es: 'El scrappable solicitado no se encontro o no tienes acceso a el.',
    SupportedLanguage.de: 'Das angeforderte Scrappable wurde nicht gefunden oder Sie haben keinen Zugriff darauf.',
    SupportedLanguage.fr: 'Le scrappable demande n\'a pas ete trouve ou vous n\'y avez pas acces.',
    SupportedLanguage.ptBR: 'O scrappable solicitado não foi encontrado ou você não tem acesso a ele.',
    SupportedLanguage.ja: 'リクエストされたscrappableが見つからないか、アクセス権限がありません。',
  },
  'scrappable_already_attached': {
    SupportedLanguage.en: 'The scrappable you are trying to attach is already linked to another account.',
    SupportedLanguage.es: 'El scrappable que intentas vincular ya esta vinculado a otra cuenta.',
    SupportedLanguage.de: 'Das Scrappable, das Sie anhangen mochten, ist bereits mit einem anderen Konto verknupft.',
    SupportedLanguage.fr: 'Le scrappable que vous essayez d\'attacher est deja lie a un autre compte.',
    SupportedLanguage.ptBR: 'O scrappable que você está tentando vincular já está vinculado a outra conta.',
    SupportedLanguage.ja: '関連付けようとしているscrappableは既に別のアカウントにリンクされています。',
  },
  'endpoint_limit_reached': {
    SupportedLanguage.en: 'You have reached the maximum number of endpoints ({maxAllowed}) for your {planName} plan. Please upgrade your plan to attach more endpoints.',
    SupportedLanguage.es: 'Has alcanzado el numero maximo de endpoints ({maxAllowed}) para tu plan {planName}. Por favor, actualiza tu plan para vincular mas endpoints.',
    SupportedLanguage.de: 'Sie haben die maximale Anzahl von Endpunkten ({maxAllowed}) fur Ihren {planName}-Plan erreicht. Bitte aktualisieren Sie Ihren Plan, um weitere Endpunkte anzuhangen.',
    SupportedLanguage.fr: 'Vous avez atteint le nombre maximum d\'endpoints ({maxAllowed}) pour votre plan {planName}. Veuillez mettre a niveau votre plan pour attacher plus d\'endpoints.',
    SupportedLanguage.ptBR: 'Você atingiu o número máximo de endpoints ({maxAllowed}) para seu plano {planName}. Por favor, atualize seu plano para vincular mais endpoints.',
    SupportedLanguage.ja: '{planName}プランのエンドポイント数の上限({maxAllowed})に達しました。より多くのエンドポイントを追加するにはプランをアップグレードしてください。',
  },
  'banned_domain': {
    SupportedLanguage.en: 'The domain "{domain}" is not supported for scraping. This website has strong anti-scraping measures that prevent reliable data extraction.',
    SupportedLanguage.es: 'El dominio "{domain}" no es compatible para scraping. Este sitio web tiene fuertes medidas anti-scraping que impiden la extraccion confiable de datos.',
    SupportedLanguage.de: 'Die Domain "{domain}" wird nicht fur Scraping unterstützt. Diese Website hat starke Anti-Scraping-Massnahmen, die eine zuverlassige Datenextraktion verhindern.',
    SupportedLanguage.fr: 'Le domaine "{domain}" n\'est pas pris en charge pour le scraping. Ce site web a de fortes mesures anti-scraping qui empechent l\'extraction fiable de données.',
    SupportedLanguage.ptBR: 'O domínio "{domain}" não é suportado para scraping. Este site possui fortes medidas anti-scraping que impedem a extração confiável de dados.',
    SupportedLanguage.ja: 'ドメイン「{domain}」はスクレイピングに対応していません。このウェブサイトには強力なアンチスクレイピング対策があり、信頼性の高いデータ抽出ができません。',
  },
  'scrappable_private_cannot_clone': {
    SupportedLanguage.en: 'This scrappable is private and cannot be cloned.',
    SupportedLanguage.es: 'Este scrappable es privado y no se puede clonar.',
    SupportedLanguage.de: 'Dieses Scrappable ist privat und kann nicht geklont werden.',
    SupportedLanguage.fr: 'Ce scrappable est prive et ne peut pas etre clone.',
    SupportedLanguage.ptBR: 'Este scrappable é privado e não pode ser clonado.',
    SupportedLanguage.ja: 'このscrappableはプライベートであり、複製できません。',
  },

  // API Key errors
  'api_key_not_found': {
    SupportedLanguage.en: 'The specified API key was not found or does not belong to your account.',
    SupportedLanguage.es: 'La clave API especificada no se encontro o no pertenece a tu cuenta.',
    SupportedLanguage.de: 'Der angegebene API-Schlüssel wurde nicht gefunden oder gehort nicht zu Ihrem Konto.',
    SupportedLanguage.fr: 'La clé API specifiee n\'a pas ete trouvee ou n\'appartient pas a votre compte.',
    SupportedLanguage.ptBR: 'A chave API especificada não foi encontrada ou não pertence a sua conta.',
    SupportedLanguage.ja: '指定されたAPIキーが見つからないか、アカウントに属していません。',
  },
  'cannot_deactivate_api_key': {
    SupportedLanguage.en: 'You must have at least one active API key.',
    SupportedLanguage.es: 'Debes tener al menos una clave API activa.',
    SupportedLanguage.de: 'Sie mussen mindestens einen aktiven API-Schlüssel haben.',
    SupportedLanguage.fr: 'Vous devez avoir au moins une clé API active.',
    SupportedLanguage.ptBR: 'Você deve ter pelo menos uma chave API ativa.',
    SupportedLanguage.ja: '少なくとも1つのアクティブなAPIキーが必要です。',
  },

  // Subscription/Plan errors
  'ultra_plan_required': {
    SupportedLanguage.en: 'Credit packages are only available for Ultra plan subscribers. Please upgrade to Ultra to purchase additional credits.',
    SupportedLanguage.es: 'Los paquetes de creditos solo estan disponibles para suscriptores del plan Ultra. Por favor, actualiza a Ultra para comprar creditos adicionales.',
    SupportedLanguage.de: 'Kreditpakete sind nur fur Ultra-Plan-Abonnenten verfügbar. Bitte aktualisieren Sie auf Ultra, um zusatzliche Crédits zu erwerben.',
    SupportedLanguage.fr: 'Les packs de crédits sont disponibles uniquement pour les abonnes au plan Ultra. Veuillez passer a Ultra pour acheter des crédits supplementaires.',
    SupportedLanguage.ptBR: 'Os pacotes de créditos estão disponíveis apenas para assinantes do plano Ultra. Por favor, atualize para Ultra para comprar créditos adicionais.',
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
    SupportedLanguage.fr: 'Échec de la création de la session de paiement.',
    SupportedLanguage.ptBR: 'Falha ao criar sessão de checkout.',
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
    SupportedLanguage.ptBR: 'O usuário já possui uma assinatura ativa.',
    SupportedLanguage.ja: 'ユーザーは既にアクティブなサブスクリプションを持っています。',
  },
  'subscription_cancel_failed': {
    SupportedLanguage.en: 'Failed to cancel subscription. Please try again later.',
    SupportedLanguage.es: 'Error al cancelar la suscripcion. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Abonnement konnte nicht gekundigt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Échec de l\'annulation de l\'abonnement. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao cancelar a assinatura. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'サブスクリプションのキャンセルに失敗しました。後でもう一度お試しください。',
  },
  'subscription_checkout_failed': {
    SupportedLanguage.en: 'Failed to create checkout session. Please try again later.',
    SupportedLanguage.es: 'Error al crear la sesion de checkout. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Checkout-Sitzung konnte nicht erstellt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Échec de la création de la session de paiement. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao criar sessão de checkout. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'チェックアウトセッションの作成に失敗しました。後でもう一度お試しください。',
  },
  'customer_portal_failed': {
    SupportedLanguage.en: 'Failed to create customer portal session. Please try again later.',
    SupportedLanguage.es: 'Error al crear la sesion del portal del cliente. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Kundenportalsitzung konnte nicht erstellt werden. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Échec de la création de la session du portail client. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao criar sessão do portal do cliente. Por favor, tente novamente mais tarde.',
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
    SupportedLanguage.ptBR: 'Email do usuário não encontrado.',
    SupportedLanguage.ja: 'ユーザーのメールアドレスが見つかりません。',
  },
  'sync_subscription_failed': {
    SupportedLanguage.en: 'Failed to sync subscription from Stripe. Please try again later.',
    SupportedLanguage.es: 'Error al sincronizar la suscripcion desde Stripe. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Fehler beim Synchronisieren des Abonnements von Stripe. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Échec de la synchronisation de l\'abonnement depuis Stripe. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Falha ao sincronizar assinatura do Stripe. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'Stripeからのサブスクリプションの同期に失敗しました。後でもう一度お試しください。',
  },

  // Access errors
  'access_denied_permission': {
    SupportedLanguage.en: 'You do not have permission to access this scrappable.',
    SupportedLanguage.es: 'No tienes permiso para acceder a este scrappable.',
    SupportedLanguage.de: 'Sie haben keine Berechtigung, auf dieses Scrappable zuzugreifen.',
    SupportedLanguage.fr: 'Vous n\'avez pas la permission d\'acceder a ce scrappable.',
    SupportedLanguage.ptBR: 'Você não tem permissão para acessar este scrappable.',
    SupportedLanguage.ja: 'このscrappableにアクセスする権限がありません。',
  },
  'permission_denied_delete': {
    SupportedLanguage.en: 'You do not have permission to delete this scrappable.',
    SupportedLanguage.es: 'No tienes permiso para eliminar este scrappable.',
    SupportedLanguage.de: 'Sie haben keine Berechtigung, dieses Scrappable zu loschen.',
    SupportedLanguage.fr: 'Vous n\'avez pas la permission de supprimer ce scrappable.',
    SupportedLanguage.ptBR: 'Você não tem permissão para excluir este scrappable.',
    SupportedLanguage.ja: 'このscrappableを削除する権限がありません。',
  },
  'permission_denied_edit': {
    SupportedLanguage.en: 'You do not have permission to edit this scrappable.',
    SupportedLanguage.es: 'No tienes permiso para editar este scrappable.',
    SupportedLanguage.de: 'Sie haben keine Berechtigung, dieses Scrappable zu bearbeiten.',
    SupportedLanguage.fr: 'Vous n\'avez pas la permission de modifier ce scrappable.',
    SupportedLanguage.ptBR: 'Você não tem permissão para editar este scrappable.',
    SupportedLanguage.ja: 'このscrappableを編集する権限がありません。',
  },

  // Usage limit errors
  'usage_limit_reached': {
    SupportedLanguage.en: 'You have reached the spending limit for your IP address (\${limit}). This limit resets in {timeStr}, or you can create an account to get monthly AI credits.',
    SupportedLanguage.es: 'Has alcanzado el limite de gasto para tu direccion IP (\${limit}). Este limite se restablece en {timeStr}, o puedes crear una cuenta para obtener creditos de IA mensuales.',
    SupportedLanguage.de: 'Sie haben das Ausgabenlimit fur Ihre IP-Adresse erreicht (\${limit}). Dieses Limit wird in {timeStr} zuruckgesetzt, oder Sie konnen ein Konto erstellen, um monatliche KI-Guthaben zu erhalten.',
    SupportedLanguage.fr: 'Vous avez atteint la limite de depenses pour votre adresse IP (\${limit}). Cette limite sera reinitialise dans {timeStr}, ou vous pouvez creer un compte pour obtenir des crédits IA mensuels.',
    SupportedLanguage.ptBR: 'Você atingiu o limite de gastos para seu endereço IP (\${limit}). Este limite será redefinido em {timeStr}, ou você pode criar uma conta para obter créditos de IA mensais.',
    SupportedLanguage.ja: 'IPアドレスの使用制限に達しました（\${limit}）。この制限は{timeStr}でリセットされます。月次AIクレジットを取得するにはアカウントを作成してください。',
  },
  'ai_credits_exhausted': {
    SupportedLanguage.en: 'You have used all your AI crédits for this month (\${limit} limit). Crédits will reset next month, or you can add your own OpenAI API key in account settings to continue without limits.',
    SupportedLanguage.es: 'Has usado todos tus creditos de IA para este mes (limite de \${limit}). Los creditos se restablecera el proximo mes, o puedes agregar tu propia clave API de OpenAI en la configuracion de tu cuenta para continuar sin limites.',
    SupportedLanguage.de: 'Sie haben alle Ihre KI-Guthaben fur diesen Monat aufgebraucht (Limit: \${limit}). Die Guthaben werden nachsten Monat zuruckgesetzt, oder Sie konnen Ihren eigenen OpenAI API-Schlüssel in den Kontoeinstellungen hinzufugen, um ohne Limits fortzufahren.',
    SupportedLanguage.fr: 'Vous avez utilise tous vos crédits IA pour ce mois (limite de \${limit}). Les crédits seront reinitialises le mois prochain, ou vous pouvez ajouter votre propre clé API OpenAI dans les parametres du compte pour continuer sans limites.',
    SupportedLanguage.ptBR: 'Você usou todos os seus créditos de IA para este mês (limite de \${limit}). Os créditos serão redefinidos no próximo mês, ou você pode adicionar sua própria chave API do OpenAI nas configurações da conta para continuar sem limites.',
    SupportedLanguage.ja: '今月のAIクレジットをすべて使い切りました（\${limit}の制限）。クレジットは来月リセットされます。制限なく続けるにはアカウント設定でOpenAI APIキーを追加してください。',
  },

  // IP Validation errors
  'suspicious_ip_detected': {
    SupportedLanguage.en: 'Your connection has been flagged as suspicious ({reason}). To protect our service from abuse, we cannot process requests from VPNs, proxies, Tor, or known malicious IPs. Please disable your VPN/proxy or create an account to continue.',
    SupportedLanguage.es: 'Tu conexion ha sido marcada como sospechosa ({reason}). Para proteger nuestro servicio del abuso, no podemos procesar solicitudes de VPNs, proxies, Tor o IPs maliciosas conocidas. Por favor, desactiva tu VPN/proxy o crea una cuenta para continuar.',
    SupportedLanguage.de: 'Ihre Verbindung wurde als verdachtig eingestuft ({reason}). Zum Schutz unseres Dienstes vor Missbrauch konnen wir keine Anfragen von VPNs, Proxys, Tor oder bekannten bosartigen IPs verarbeiten. Bitte deaktivieren Sie Ihr VPN/Proxy oder erstellen Sie ein Konto, um fortzufahren.',
    SupportedLanguage.fr: 'Votre connexion a ete signalee comme suspecte ({reason}). Pour proteger notre service contre les abus, nous ne pouvons pas traiter les requetes provenant de VPN, proxys, Tor ou d\'IPs malveillantes connues. Veuillez désactiver votre VPN/proxy ou creer un compte pour continuer.',
    SupportedLanguage.ptBR: 'Sua conexão foi marcada como suspeita ({reason}). Para proteger nosso serviço contra abusos, não podemos processar solicitações de VPNs, proxies, Tor ou IPs maliciosos conhecidos. Por favor, desative seu VPN/proxy ou crie uma conta para continuar.',
    SupportedLanguage.ja: 'お使いの接続が不審としてフラグ付けされました（{reason}）。サービスの悪用を防ぐため、VPN、プロキシ、Tor、または既知の悪意あるIPからのリクエストは処理できません。VPN/プロキシを無効にするか、アカウントを作成して続行してください。',
  },

  // Delete errors
  'already_deleted': {
    SupportedLanguage.en: 'This scrappable has already been deleted.',
    SupportedLanguage.es: 'Este scrappable ya ha sido eliminado.',
    SupportedLanguage.de: 'Dieses Scrappable wurde bereits gelöscht.',
    SupportedLanguage.fr: 'Ce scrappable a deja ete supprime.',
    SupportedLanguage.ptBR: 'Este scrappable já foi excluído.',
    SupportedLanguage.ja: 'このscrappableは既に削除されています。',
  },
  'delete_failed': {
    SupportedLanguage.en: 'Failed to delete the scrappable. Please try again.',
    SupportedLanguage.es: 'Error al eliminar el scrappable. Por favor, intentelo de nuevo.',
    SupportedLanguage.de: 'Das Scrappable konnte nicht gelöscht werden. Bitte versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Échec de la suppression du scrappable. Veuillez reessayer.',
    SupportedLanguage.ptBR: 'Falha ao excluir o scrappable. Por favor, tente novamente.',
    SupportedLanguage.ja: 'scrappableの削除に失敗しました。もう一度お試しください。',
  },
  'update_failed': {
    SupportedLanguage.en: 'Failed to update the scrappable. Please try again.',
    SupportedLanguage.es: 'Error al actualizar el scrappable. Por favor, intentelo de nuevo.',
    SupportedLanguage.de: 'Das Scrappable konnte nicht aktualisiert werden. Bitte versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Échec de la mise à jour du scrappable. Veuillez reessayer.',
    SupportedLanguage.ptBR: 'Falha ao atualizar o scrappable. Por favor, tente novamente.',
    SupportedLanguage.ja: 'scrappableの更新に失敗しました。もう一度お試しください。',
  },

  // Validation errors
  'invalid_name': {
    SupportedLanguage.en: 'Scrappable name cannot be empty.',
    SupportedLanguage.es: 'El nombre del scrappable no puede estar vacio.',
    SupportedLanguage.de: 'Der Scrappable-Name darf nicht leer sein.',
    SupportedLanguage.fr: 'Le nom du scrappable ne peut pas etre vide.',
    SupportedLanguage.ptBR: 'O nome do scrappable não pode estar vazio.',
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
    SupportedLanguage.ptBR: 'A descrição do scrappable não pode estar vazia.',
    SupportedLanguage.ja: 'scrappableの説明を空にすることはできません。',
  },
  'description_too_long': {
    SupportedLanguage.en: 'Scrappable description must be {maxLength} characters or less.',
    SupportedLanguage.es: 'La descripcion del scrappable debe tener {maxLength} caracteres o menos.',
    SupportedLanguage.de: 'Die Scrappable-Beschreibung darf hochstens {maxLength} Zeichen lang sein.',
    SupportedLanguage.fr: 'La description du scrappable doit contenir {maxLength} caracteres ou moins.',
    SupportedLanguage.ptBR: 'A descrição do scrappable deve ter {maxLength} caracteres ou menos.',
    SupportedLanguage.ja: 'scrappableの説明は{maxLength}文字以下にしてください。',
  },
  'invalid_api_key': {
    SupportedLanguage.en: 'Please provide a valid OpenAI API key.',
    SupportedLanguage.es: 'Por favor, proporciona una clave API de OpenAI valida.',
    SupportedLanguage.de: 'Bitte geben Sie einen gultigen OpenAI API-Schlüssel an.',
    SupportedLanguage.fr: 'Veuillez fournir une clé API OpenAI valide.',
    SupportedLanguage.ptBR: 'Por favor, forneça uma chave API do OpenAI válida.',
    SupportedLanguage.ja: '有効なOpenAI APIキーを入力してください。',
  },

  // Scrappable availability errors
  'scrappable_not_available': {
    SupportedLanguage.en: 'The requested scrappable is not available.',
    SupportedLanguage.es: 'El scrappable solicitado no esta disponible.',
    SupportedLanguage.de: 'Das angeforderte Scrappable ist nicht verfügbar.',
    SupportedLanguage.fr: 'Le scrappable demande n\'est pas disponible.',
    SupportedLanguage.ptBR: 'O scrappable solicitado não está disponível.',
    SupportedLanguage.ja: 'リクエストされたscrappableは利用できません。',
  },
  'scrappable_not_found_by_id': {
    SupportedLanguage.en: 'The scrappable with the provided ID does not exist.',
    SupportedLanguage.es: 'El scrappable con el ID proporcionado no existe.',
    SupportedLanguage.de: 'Das Scrappable mit der angegebenen ID existiert nicht.',
    SupportedLanguage.fr: 'Le scrappable avec l\'ID fourni n\'existe pas.',
    SupportedLanguage.ptBR: 'O scrappable com o ID fornecido não existe.',
    SupportedLanguage.ja: '指定されたIDのscrappableは存在しません。',
  },

  // Session errors
  'session_not_found': {
    SupportedLanguage.en: 'No active session found with the provided ID.',
    SupportedLanguage.es: 'No se encontro ninguna sesion activa con el ID proporcionado.',
    SupportedLanguage.de: 'Keine aktive Sitzung mit der angegebenen ID gefunden.',
    SupportedLanguage.fr: 'Aucune session active trouvee avec l\'ID fourni.',
    SupportedLanguage.ptBR: 'Nenhuma sessão ativa encontrada com o ID fornecido.',
    SupportedLanguage.ja: '指定されたIDのアクティブなセッションが見つかりません。',
  },
  'session_already_opened': {
    SupportedLanguage.en: 'There is already an opened session for this scrappable. Please close the existing session before creating a new one.',
    SupportedLanguage.es: 'Ya hay una sesion abierta para este scrappable. Por favor, cierra la sesion existente antes de crear una nueva.',
    SupportedLanguage.de: 'Es gibt bereits eine geöffnete Sitzung fur dieses Scrappable. Bitte schliessen Sie die bestehende Sitzung, bevor Sie eine neue erstellen.',
    SupportedLanguage.fr: 'Il existe deja une session ouverte pour ce scrappable. Veuillez fermer la session existante avant d\'en creer une nouvelle.',
    SupportedLanguage.ptBR: 'Já existe uma sessão aberta para este scrappable. Por favor, feche a sessão existente antes de criar uma nova.',
    SupportedLanguage.ja: 'このscrappableには既にセッションが開いています。新しいセッションを作成する前に既存のセッションを閉じてください。',
  },
  'ai_usage_record_not_found': {
    SupportedLanguage.en: 'Could not find your AI usage record.',
    SupportedLanguage.es: 'No se pudo encontrar tu registro de uso de IA.',
    SupportedLanguage.de: 'Ihr KI-Nutzungsdatensatz konnte nicht gefunden werden.',
    SupportedLanguage.fr: 'Impossible de trouver votre enregistrement d\'utilisation IA.',
    SupportedLanguage.ptBR: 'Não foi possível encontrar seu registro de uso de IA.',
    SupportedLanguage.ja: 'AI使用記録が見つかりませんでした。',
  },
  'failed_to_save_api_key': {
    SupportedLanguage.en: 'Could not save your API key. Please try again.',
    SupportedLanguage.es: 'No se pudo guardar tu clave API. Por favor, intentelo de nuevo.',
    SupportedLanguage.de: 'Ihr API-Schlüssel konnte nicht gespeichert werden. Bitte versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Impossible d\'enregistrer votre clé API. Veuillez reessayer.',
    SupportedLanguage.ptBR: 'Não foi possível salvar sua chave API. Por favor, tente novamente.',
    SupportedLanguage.ja: 'APIキーを保存できませんでした。もう一度お試しください。',
  },

  // Authentication errors for specific actions
  'authentication_required_delete': {
    SupportedLanguage.en: 'You must be logged in to delete this scrappable.',
    SupportedLanguage.es: 'Debes iniciar sesion para eliminar este scrappable.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um dieses Scrappable zu loschen.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour supprimer ce scrappable.',
    SupportedLanguage.ptBR: 'Você deve estar logado para excluir este scrappable.',
    SupportedLanguage.ja: 'このscrappableを削除するにはログインが必要です。',
  },
  'authentication_required_edit': {
    SupportedLanguage.en: 'You must be logged in to edit this scrappable.',
    SupportedLanguage.es: 'Debes iniciar sesion para editar este scrappable.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um dieses Scrappable zu bearbeiten.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour modifier ce scrappable.',
    SupportedLanguage.ptBR: 'Você deve estar logado para editar este scrappable.',
    SupportedLanguage.ja: 'このscrappableを編集するにはログインが必要です。',
  },
  'authentication_required_marketplace': {
    SupportedLanguage.en: 'You must be logged in to hide scrappables from marketplace.',
    SupportedLanguage.es: 'Debes iniciar sesion para ocultar scrappables del marketplace.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um Scrappables vom Marketplace zu verstecken.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour masquer les scrappables du marketplace.',
    SupportedLanguage.ptBR: 'Você deve estar logado para ocultar scrappables do marketplace.',
    SupportedLanguage.ja: 'マーケットプレイスからscrappableを非表示にするにはログインが必要です。',
  },
  'authentication_required_api_key': {
    SupportedLanguage.en: 'You must be logged in to add an API key.',
    SupportedLanguage.es: 'Debes iniciar sesion para agregar una clave API.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um einen API-Schlüssel hinzuzufugen.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour ajouter une clé API.',
    SupportedLanguage.ptBR: 'Você deve estar logado para adicionar uma chave API.',
    SupportedLanguage.ja: 'APIキーを追加するにはログインが必要です。',
  },
  'authentication_required_session': {
    SupportedLanguage.en: 'You must be the owner of this scrappable to create a session for it.',
    SupportedLanguage.es: 'Debes ser el propietario de este scrappable para crear una sesion para el.',
    SupportedLanguage.de: 'Sie mussen der Besitzer dieses Scrappables sein, um eine Sitzung dafur zu erstellen.',
    SupportedLanguage.fr: 'Vous devez etre le proprietaire de ce scrappable pour creer une session.',
    SupportedLanguage.ptBR: 'Você deve ser o proprietário deste scrappable para criar uma sessão para ele.',
    SupportedLanguage.ja: 'セッションを作成するにはこのscrappableの所有者である必要があります。',
  },
  'authentication_required_ai_model': {
    SupportedLanguage.en: 'You must be logged in to use this AI model.',
    SupportedLanguage.es: 'Debes iniciar sesion para usar este modelo de IA.',
    SupportedLanguage.de: 'Sie mussen angemeldet sein, um dieses KI-Modell zu verwenden.',
    SupportedLanguage.fr: 'Vous devez etre connecte pour utiliser ce modele IA.',
    SupportedLanguage.ptBR: 'Você deve estar logado para usar este modelo de IA.',
    SupportedLanguage.ja: 'このAIモデルを使用するにはログインが必要です。',
  },

  // AI génération errors
  'ai_generation_failed': {
    SupportedLanguage.en: 'An unexpected error occurred while generating the scrappable. Please try again later.',
    SupportedLanguage.es: 'Ocurrio un error inesperado al generar el scrappable. Por favor, intentelo mas tarde.',
    SupportedLanguage.de: 'Beim Generieren des Scrappables ist ein unerwarteter Fehler aufgetreten. Bitte versuchen Sie es spater erneut.',
    SupportedLanguage.fr: 'Une erreur inattendue s\'est produite lors de la génération du scrappable. Veuillez reessayer plus tard.',
    SupportedLanguage.ptBR: 'Ocorreu um erro inesperado ao gerar o scrappable. Por favor, tente novamente mais tarde.',
    SupportedLanguage.ja: 'scrappableの生成中に予期しないエラーが発生しました。後でもう一度お試しください。',
  },

  // Ultra plan specific
  'ultra_plan_required_marketplace': {
    SupportedLanguage.en: 'Hiding scrappables from marketplace is only available for Ultra plan users.',
    SupportedLanguage.es: 'Ocultar scrappables del marketplace solo esta disponible para usuarios del plan Ultra.',
    SupportedLanguage.de: 'Das Verstecken von Scrappables vom Marketplace ist nur fur Ultra-Plan-Benutzer verfügbar.',
    SupportedLanguage.fr: 'Masquer les scrappables du marketplace est disponible uniquement pour les utilisateurs du plan Ultra.',
    SupportedLanguage.ptBR: 'Ocultar scrappables do marketplace está disponível apenas para usuários do plano Ultra.',
    SupportedLanguage.ja: 'マーケットプレイスからscrappableを非表示にするにはUltraプランが必要です。',
  },

  // Upgrade errors
  'upgrade_required_ai_model': {
    SupportedLanguage.en: 'You need at least a Pro plan to use this AI model. Upgrade your plan to access advanced AI models.',
    SupportedLanguage.es: 'Necesitas al menos un plan Pro para usar este modelo de IA. Actualiza tu plan para acceder a modelos de IA avanzados.',
    SupportedLanguage.de: 'Sie benotigen mindestens einen Pro-Plan, um dieses KI-Modell zu verwenden. Aktualisieren Sie Ihren Plan, um auf erweiterte KI-Modelle zuzugreifen.',
    SupportedLanguage.fr: 'Vous avez besoin d\'au moins un plan Pro pour utiliser ce modele IA. Mettez a niveau votre plan pour acceder aux modeles IA avances.',
    SupportedLanguage.ptBR: 'Você precisa de pelo menos um plano Pro para usar este modelo de IA. Atualize seu plano para acessar modelos de IA avançados.',
    SupportedLanguage.ja: 'このAIモデルを使用するにはProプラン以上が必要です。高度なAIモデルにアクセスするにはプランをアップグレードしてください。',
  },

  // API Helper error descriptions
  'missing_path_parameter': {
    SupportedLanguage.en: 'Required path parameter "{pathParam}" was not provided in the payload.',
    SupportedLanguage.es: 'El parametro de ruta requerido "{pathParam}" no fue proporcionado en el payload.',
    SupportedLanguage.de: 'Der erforderliche Pfadparameter "{pathParam}" wurde nicht in der Nutzlast bereitgestellt.',
    SupportedLanguage.fr: 'Le parametre de chemin requis "{pathParam}" n\'a pas ete fourni dans la charge utile.',
    SupportedLanguage.ptBR: 'O parâmetro de caminho obrigatório "{pathParam}" não foi fornecido no payload.',
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
    SupportedLanguage.ptBR: 'Nenhum dado de teste de referência encontrado para esta sessão de scrappable.',
    SupportedLanguage.ja: 'このscrappableセッションのリファレンステストデータが見つかりません。',
  },
  'no_credit_usage_model': {
    SupportedLanguage.en: 'No credit usage model found for the provided API key: {apiKey}. It could be that the account was deleted or has no plan assigned - check in your API key tab on ZenScrap site.',
    SupportedLanguage.es: 'No se encontro modelo de uso de creditos para la clave API proporcionada: {apiKey}. Puede que la cuenta haya sido eliminada o no tenga un plan asignado - verifica en la pestana de claves API en el sitio de ZenScrap.',
    SupportedLanguage.de: 'Kein Kreditnutzungsmodell fur den angegebenen API-Schlüssel gefunden: {apiKey}. Moglicherweise wurde das Konto gelöscht oder es ist kein Plan zugewiesen - prufen Sie dies im API-Schlüssel-Tab auf der ZenScrap-Website.',
    SupportedLanguage.fr: 'Aucun modele d\'utilisation de crédits trouve pour la clé API fournie : {apiKey}. Il est possible que le compte ait ete supprime ou qu\'aucun plan ne soit attribue - verifiez dans l\'onglet des cles API sur le site ZenScrap.',
    SupportedLanguage.ptBR: 'Nenhum modelo de uso de créditos encontrado para a chave API fornecida: {apiKey}. Pode ser que a conta tenha sido excluída ou não tenha um plano atribuído - verifique na aba de chaves API no site do ZenScrap.',
    SupportedLanguage.ja: '指定されたAPIキー: {apiKey} のクレジット使用モデルが見つかりません。アカウントが削除されたか、プランが割り当てられていない可能性があります - ZenScrapサイトのAPIキータブで確認してください。',
  },
  'api_key_not_found_active': {
    SupportedLanguage.en: 'There is no active API key matching the provided value: {apiKey}. It could be that the key was deleted or deactivated - check in your API key tab on ZenScrap site.',
    SupportedLanguage.es: 'No hay ninguna clave API activa que coincida con el valor proporcionado: {apiKey}. Puede que la clave haya sido eliminada o desactivada - verifica en la pestana de claves API en el sitio de ZenScrap.',
    SupportedLanguage.de: 'Es gibt keinen aktiven API-Schlüssel, der dem angegebenen Wert entspricht: {apiKey}. Moglicherweise wurde der Schlüssel gelöscht oder deaktiviert - prufen Sie dies im API-Schlüssel-Tab auf der ZenScrap-Website.',
    SupportedLanguage.fr: 'Il n\'y a pas de clé API active correspondant a la valeur fournie : {apiKey}. La clé a peut-etre ete supprimee ou desactivee - verifiez dans l\'onglet des cles API sur le site ZenScrap.',
    SupportedLanguage.ptBR: 'Não há chave API ativa correspondente ao valor fornecido: {apiKey}. Pode ser que a chave tenha sido excluída ou desativada - verifique na aba de chaves API no site do ZenScrap.',
    SupportedLanguage.ja: '指定された値: {apiKey} に一致するアクティブなAPIキーがありません。キーが削除または無効化された可能性があります - ZenScrapサイトのAPIキータブで確認してください。',
  },
  'no_active_test_session': {
    SupportedLanguage.en: 'There is no active test session found for the provided scrappable.',
    SupportedLanguage.es: 'No se encontro ninguna sesion de prueba activa para el scrappable proporcionado.',
    SupportedLanguage.de: 'Fur das angegebene Scrappable wurde keine aktive Testsitzung gefunden.',
    SupportedLanguage.fr: 'Aucune session de test active trouvee pour le scrappable fourni.',
    SupportedLanguage.ptBR: 'Nenhuma sessão de teste ativa encontrada para o scrappable fornecido.',
    SupportedLanguage.ja: '指定されたscrappableのアクティブなテストセッションが見つかりません。',
  },
  'test_period_expired': {
    SupportedLanguage.en: 'The test period for this scrappable has expired. You can: Start a new testing session that will start a new test period, or call the production endpoint with a valid API key if you have an account.',
    SupportedLanguage.es: 'El periodo de prueba para este scrappable ha expirado. Puedes: Iniciar una nueva sesion de prueba que comenzara un nuevo periodo de prueba, o llamar al endpoint de produccion con una clave API valida si tienes una cuenta.',
    SupportedLanguage.de: 'Der Testzeitraum fur dieses Scrappable ist abgelaufen. Sie konnen: Eine neue Testsitzung starten, die einen neuen Testzeitraum beginnt, oder den Produktionsendpunkt mit einem gultigen API-Schlüssel aufrufen, wenn Sie ein Konto haben.',
    SupportedLanguage.fr: 'La periode de test pour ce scrappable a expire. Vous pouvez : Demarrer une nouvelle session de test qui commencera une nouvelle periode de test, ou appeler l\'endpoint de production avec une clé API valide si vous avez un compte.',
    SupportedLanguage.ptBR: 'O período de teste para este scrappable expirou. Você pode: Iniciar uma nova sessão de teste que iniciará um novo período de teste, ou chamar o endpoint de produção com uma chave API válida se você tiver uma conta.',
    SupportedLanguage.ja: 'このscrappableのテスト期間が終了しました。新しいテスト期間を開始する新しいテストセッションを開始するか、アカウントをお持ちの場合は有効なAPIキーで本番エンドポイントを呼び出すことができます。',
  },
  'api_key_database_not_found': {
    SupportedLanguage.en: 'No account API key matched the provided value (key not found in database).',
    SupportedLanguage.es: 'Ninguna clave API de cuenta coincidio con el valor proporcionado (clave no encontrada en la base de datos).',
    SupportedLanguage.de: 'Kein Konto-API-Schlüssel stimmte mit dem angegebenen Wert uberein (Schlüssel nicht in der Datenbank gefunden).',
    SupportedLanguage.fr: 'Aucune clé API de compte ne correspond a la valeur fournie (cle non trouvée dans la base de données).',
    SupportedLanguage.ptBR: 'Nenhuma chave API de conta correspondeu ao valor fornecido (chave não encontrada no banco de dados).',
    SupportedLanguage.ja: 'アカウントAPIキーが指定された値と一致しませんでした（データベースにキーが見つかりません）。',
  },
  'insufficient_credits': {
    SupportedLanguage.en: 'Your account has no remaining credits. Purchase or allocate more crédits to continue making requests.',
    SupportedLanguage.es: 'Tu cuenta no tiene creditos restantes. Compra o asigna mas creditos para continuar haciendo solicitudes.',
    SupportedLanguage.de: 'Ihr Konto hat keine verbleibenden Guthaben. Kaufen oder weisen Sie mehr Guthaben zu, um weiterhin Anfragen stellen zu konnen.',
    SupportedLanguage.fr: 'Votre compte n\'a plus de credits. Achetez ou allouez plus de crédits pour continuer a faire des demandes.',
    SupportedLanguage.ptBR: 'Sua conta não tem créditos restantes. Compre ou aloque mais créditos para continuar fazendo solicitações.',
    SupportedLanguage.ja: 'アカウントにクレジットが残っていません。リクエストを続けるにはクレジットを購入または割り当ててください。',
  },
  'missing_extract_rules': {
    SupportedLanguage.en: 'No extract rules are defined for this scrappable. Please define extraction rules before invoking this endpoint.',
    SupportedLanguage.es: 'No hay reglas de extraccion definidas para este scrappable. Por favor, define las reglas de extraccion antes de invocar este endpoint.',
    SupportedLanguage.de: 'Fur dieses Scrappable sind keine Extraktionsregeln definiert. Bitte definieren Sie Extraktionsregeln, bevor Sie diesen Endpunkt aufrufen.',
    SupportedLanguage.fr: 'Aucune regle d\'extraction n\'est definie pour ce scrappable. Veuillez definir les regles d\'extraction avant d\'invoquer cet endpoint.',
    SupportedLanguage.ptBR: 'Nenhuma regra de extração está definida para este scrappable. Por favor, defina as regras de extração antes de invocar este endpoint.',
    SupportedLanguage.ja: 'このscrappableには抽出ルールが定義されていません。このエンドポイントを呼び出す前に抽出ルールを定義してください。',
  },
  'invalid_api_key_account': {
    SupportedLanguage.en: 'The provided API key does not have a user account.',
    SupportedLanguage.es: 'La clave API proporcionada no tiene una cuenta de usuario.',
    SupportedLanguage.de: 'Der angegebene API-Schlüssel hat kein Benutzerkonto.',
    SupportedLanguage.fr: 'La clé API fournie n\'a pas de compte utilisateur.',
    SupportedLanguage.ptBR: 'A chave API fornecida não possui uma conta de usuário.',
    SupportedLanguage.ja: '指定されたAPIキーにはユーザーアカウントがありません。',
  },
  'concurrency_limit_exceeded': {
    SupportedLanguage.en: 'You have reached the maximum number of concurrent requests allowed for your plan tier. (Max allowed concurrent requests: {maxConcurrentRequests})',
    SupportedLanguage.es: 'Has alcanzado el numero maximo de solicitudes concurrentes permitidas para tu nivel de plan. (Maximo de solicitudes concurrentes permitidas: {maxConcurrentRequests})',
    SupportedLanguage.de: 'Sie haben die maximale Anzahl gleichzeitiger Anfragen fur Ihre Planstufe erreicht. (Maximal erlaubte gleichzeitige Anfragen: {maxConcurrentRequests})',
    SupportedLanguage.fr: 'Vous avez atteint le nombre maximum de requetes simultanees autorisees pour votre niveau de plan. (Requetes simultanees maximum autorisees : {maxConcurrentRequests})',
    SupportedLanguage.ptBR: 'Você atingiu o número máximo de solicitações simultâneas permitidas para seu nível de plano. (Máximo de solicitações simultâneas permitidas: {maxConcurrentRequests})',
    SupportedLanguage.ja: 'プラン階層で許可されている同時リクエストの最大数に達しました。（最大同時リクエスト数: {maxConcurrentRequests}）',
  },
  'api_scrappable_not_found': {
    SupportedLanguage.en: 'The scrappable resource with id {scrappableId} does not exist or has no target request configured.',
    SupportedLanguage.es: 'El recurso scrappable con id {scrappableId} no existe o no tiene una solicitud de destino configurada.',
    SupportedLanguage.de: 'Die Scrappable-Ressource mit der ID {scrappableId} existiert nicht oder hat keine Zielanfrage konfiguriert.',
    SupportedLanguage.fr: 'La ressource scrappable avec l\'id {scrappableId} n\'existe pas ou n\'a pas de requete cible configuree.',
    SupportedLanguage.ptBR: 'O recurso scrappable com id {scrappableId} não existe ou não tem uma solicitação de destino configurada.',
    SupportedLanguage.ja: 'ID {scrappableId} のscrappableリソースが存在しないか、ターゲットリクエストが設定されていません。',
  },
  'invalid_api_key_format': {
    SupportedLanguage.en: 'API Key must be in the format "nanoId::apiKey".',
    SupportedLanguage.es: 'La clave API debe estar en el formato "nanoId::apiKey".',
    SupportedLanguage.de: 'Der API-Schlüssel muss im Format "nanoId::apiKey" sein.',
    SupportedLanguage.fr: 'La clé API doit etre au format "nanoId::apiKey".',
    SupportedLanguage.ptBR: 'A chave API deve estar no formato "nanoId::apiKey".',
    SupportedLanguage.ja: 'APIキーは "nanoId::apiKey" の形式である必要があります。',
  },
  'openai_api_key_invalid': {
    SupportedLanguage.en: 'The OpenAI API key you provided is invalid. Please check your key and try again.',
    SupportedLanguage.es: 'La clave API de OpenAI que proporcionaste es invalida. Por favor, verifica tu clave e intenta de nuevo.',
    SupportedLanguage.de: 'Der von Ihnen angegebene OpenAI API-Schluessel ist ungueltig. Bitte ueberpruefen Sie Ihren Schluessel und versuchen Sie es erneut.',
    SupportedLanguage.fr: 'La clé API OpenAI que vous avez fournie est invalide. Veuillez verifier votre clé et reessayer.',
    SupportedLanguage.ptBR: 'A chave API OpenAI que você forneceu é inválida. Por favor, verifique sua chave e tente novamente.',
    SupportedLanguage.ja: '入力されたOpenAI APIキーは無効です。キーを確認して再度お試しください。',
  },
  'openai_api_key_validation_failed': {
    SupportedLanguage.en: 'Could not validate the OpenAI API key. Please check your internet connection and try again.',
    SupportedLanguage.es: 'No se pudo validar la clave API de OpenAI. Por favor, verifica tu conexion a internet e intenta de nuevo.',
    SupportedLanguage.de: 'Der OpenAI API-Schluessel konnte nicht validiert werden. Bitte ueberpruefen Sie Ihre Internetverbindung und versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Impossible de valider la clé API OpenAI. Veuillez verifier votre connexion internet et reessayer.',
    SupportedLanguage.ptBR: 'Não foi possível validar a chave API OpenAI. Por favor, verifique sua conexão com a internet e tente novamente.',
    SupportedLanguage.ja: 'OpenAI APIキーを検証できませんでした。インターネット接続を確認して再度お試しください。',
  },

  // Deploy endpoint error descriptions
  'no_byte_data_to_deploy': {
    SupportedLanguage.en: 'You cannot deploy reference test data that does not have any byte data yet.',
    SupportedLanguage.es: 'No puedes desplegar datos de prueba de referencia que aun no tienen datos de bytes.',
    SupportedLanguage.de: 'Sie konnen keine Referenztestdaten bereitstellen, die noch keine Byte-Daten haben.',
    SupportedLanguage.fr: 'Vous ne pouvez pas deployer des données de test de reference qui n\'ont pas encore de données d\'octets.',
    SupportedLanguage.ptBR: 'Você não pode implantar dados de teste de referência que ainda não possuem dados de bytes.',
    SupportedLanguage.ja: 'バイトデータがないリファレンステストデータはデプロイできません。',
  },
  'authentication_or_reference_data': {
    SupportedLanguage.en: 'You probably must be authenticated to modify this reference test data - or you mistyped the id of it.',
    SupportedLanguage.es: 'Probablemente debes estar autenticado para modificar estos datos de prueba de referencia - o escribiste mal el id.',
    SupportedLanguage.de: 'Sie mussen wahrscheinlich authentifiziert sein, um diese Referenztestdaten zu andern - oder Sie haben die ID falsch eingegeben.',
    SupportedLanguage.fr: 'Vous devez probablement etre authentifie pour modifier ces données de test de reference - ou vous avez mal saisi l\'id.',
    SupportedLanguage.ptBR: 'Você provavelmente deve estar autenticado para modificar estes dados de teste de referência - ou você digitou errado o id.',
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
    SupportedLanguage.ptBR: 'O limite de erros do auto-fix não pode exceder 5000.',
    SupportedLanguage.ja: '自動修正のエラーしきい値は5000を超えることはできません。',
  },

  // Chat session error descriptions
  'cache_scrappable_id_not_found': {
    SupportedLanguage.en: 'No cached scrappable ID found for this session. The session may have expired or been closed.',
    SupportedLanguage.es: 'No se encontro ID de scrappable en cache para esta sesion. La sesion puede haber expirado o sido cerrada.',
    SupportedLanguage.de: 'Keine zwischengespeicherte Scrappable-ID fur diese Sitzung gefunden. Die Sitzung ist moglicherweise abgelaufen oder wurde geschlossen.',
    SupportedLanguage.fr: 'Aucun ID de scrappable en cache trouve pour cette session. La session a peut-etre expire ou ete fermee.',
    SupportedLanguage.ptBR: 'Nenhum ID de scrappable em cache encontrado para esta sessão. A sessão pode ter expirado ou sido fechada.',
    SupportedLanguage.ja: 'このセッションのキャッシュされたScrappable IDが見つかりません。セッションが期限切れまたは閉じられた可能性があります。',
  },
  'cache_test_data_not_found': {
    SupportedLanguage.en: 'No cached test data found for this session. The session may have expired or been closed.',
    SupportedLanguage.es: 'No se encontraron datos de prueba en cache para esta sesion. La sesion puede haber expirado o sido cerrada.',
    SupportedLanguage.de: 'Keine zwischengespeicherten Testdaten fur diese Sitzung gefunden. Die Sitzung ist moglicherweise abgelaufen oder wurde geschlossen.',
    SupportedLanguage.fr: 'Aucune donnee de test en cache trouvee pour cette session. La session a peut-etre expire ou ete fermee.',
    SupportedLanguage.ptBR: 'Nenhum dado de teste em cache encontrado para esta sessão. A sessão pode ter expirado ou sido fechada.',
    SupportedLanguage.ja: 'このセッションのキャッシュされたテストデータが見つかりません。セッションが期限切れまたは閉じられた可能性があります。',
  },
  'scrappable_request_not_found': {
    SupportedLanguage.en: 'No scrappable request configuration found for this session.',
    SupportedLanguage.es: 'No se encontro configuracion de solicitud de scrappable para esta sesion.',
    SupportedLanguage.de: 'Keine Scrappable-Anfragekonfiguration fur diese Sitzung gefunden.',
    SupportedLanguage.fr: 'Aucune configuration de requete scrappable trouvee pour cette session.',
    SupportedLanguage.ptBR: 'Nenhuma configuração de solicitação de scrappable encontrada para esta sessão.',
    SupportedLanguage.ja: 'このセッションのScrappableリクエスト設定が見つかりません。',
  },
  'reference_test_data_not_found': {
    SupportedLanguage.en: 'No reference test data found for this scrappable. Please ensure the scrappable has been properly configured.',
    SupportedLanguage.es: 'No se encontraron datos de prueba de referencia para este scrappable. Asegurese de que el scrappable este correctamente configurado.',
    SupportedLanguage.de: 'Keine Referenz-Testdaten fur dieses Scrappable gefunden. Stellen Sie sicher, dass das Scrappable korrekt konfiguriert ist.',
    SupportedLanguage.fr: 'Aucune donnee de test de reference trouvee pour ce scrappable. Assurez-vous que le scrappable est correctement configure.',
    SupportedLanguage.ptBR: 'Nenhum dado de teste de referência encontrado para este scrappable. Certifique-se de que o scrappable esteja configurado corretamente.',
    SupportedLanguage.ja: 'このScrappableのリファレンステストデータが見つかりません。Scrappableが正しく設定されていることを確認してください。',
  },
  'target_request_not_found': {
    SupportedLanguage.en: 'No target request configuration found for this scrappable. Please ensure the scrappable has been properly configured.',
    SupportedLanguage.es: 'No se encontro configuracion de solicitud objetivo para este scrappable. Asegurese de que el scrappable este correctamente configurado.',
    SupportedLanguage.de: 'Keine Zielanfragekonfiguration fur dieses Scrappable gefunden. Stellen Sie sicher, dass das Scrappable korrekt konfiguriert ist.',
    SupportedLanguage.fr: 'Aucune configuration de requete cible trouvee pour ce scrappable. Assurez-vous que le scrappable est correctement configure.',
    SupportedLanguage.ptBR: 'Nenhuma configuração de solicitação alvo encontrada para este scrappable. Certifique-se de que o scrappable esteja configurado corretamente.',
    SupportedLanguage.ja: 'このScrappableのターゲットリクエスト設定が見つかりません。Scrappableが正しく設定されていることを確認してください。',
  },
  'openai_api_key_missing': {
    SupportedLanguage.en: 'The server is not configured with an OpenAI API key. Please contact support.',
    SupportedLanguage.es: 'El servidor no esta configurado con una clave API de OpenAI. Por favor, contacte con soporte.',
    SupportedLanguage.de: 'Der Server ist nicht mit einem OpenAI API-Schlüssel konfiguriert. Bitte kontaktieren Sie den Support.',
    SupportedLanguage.fr: 'Le serveur n\'est pas configure avec une clé API OpenAI. Veuillez contacter le support.',
    SupportedLanguage.ptBR: 'O servidor não está configurado com uma chave API do OpenAI. Por favor, entre em contato com o suporte.',
    SupportedLanguage.ja: 'サーバーにOpenAI APIキーが設定されていません。サポートにお問い合わせください。',
  },
  'gemini_api_key_missing': {
    SupportedLanguage.en: 'The server is not configured with a Gemini API key. Please contact support.',
    SupportedLanguage.es: 'El servidor no esta configurado con una clave API de Gemini. Por favor, contacte con soporte.',
    SupportedLanguage.de: 'Der Server ist nicht mit einem Gemini API-Schlüssel konfiguriert. Bitte kontaktieren Sie den Support.',
    SupportedLanguage.fr: 'Le serveur n\'est pas configure avec une clé API Gemini. Veuillez contacter le support.',
    SupportedLanguage.ptBR: 'O servidor não está configurado com uma chave API do Gemini. Por favor, entre em contato com o suporte.',
    SupportedLanguage.ja: 'サーバーにGemini APIキーが設定されていません。サポートにお問い合わせください。',
  },

  // Chat message descriptions
  'chat_session_closed': {
    SupportedLanguage.en: 'Session not found or has been closed.',
    SupportedLanguage.es: 'Sesión no encontrada o ha sido cerrada.',
    SupportedLanguage.de: 'Sitzung nicht gefunden oder wurde geschlossen.',
    SupportedLanguage.fr: 'Session non trouvée ou a ete fermee.',
    SupportedLanguage.ptBR: 'Sessão não encontrada ou foi encerrada.',
    SupportedLanguage.ja: 'セッションが見つからないか、閉じられました。',
  },
  'chat_session_data_closed': {
    SupportedLanguage.en: 'Session test data not found or has been closed.',
    SupportedLanguage.es: 'Datos de prueba de sesion no encontrados o ha sido cerrada.',
    SupportedLanguage.de: 'Sitzungstestdaten nicht gefunden oder wurde geschlossen.',
    SupportedLanguage.fr: 'Donnees de test de session non trouvées ou a ete fermee.',
    SupportedLanguage.ptBR: 'Dados de teste da sessão não encontrados ou foi encerrada.',
    SupportedLanguage.ja: 'セッションテストデータが見つからないか、閉じられました。',
  },
  'chat_testing_rules': {
    SupportedLanguage.en: 'Great, I will now test the extract rules you created to see if they work with the reference link we are using for testing. Please wait a moment...',
    SupportedLanguage.es: 'Genial, ahora probare las reglas de extraccion que creaste para ver si funcionan con el enlace de referencia que estamos usando para las pruebas. Por favor, espera un momento...',
    SupportedLanguage.de: 'Grossartig, ich werde jetzt die von Ihnen erstellten Extraktionsregeln testen, um zu sehen, ob sie mit dem Referenzlink funktionieren, den wir zum Testen verwenden. Bitte warten Sie einen Moment...',
    SupportedLanguage.fr: 'Super, je vais maintenant tester les regles d\'extraction que vous avez creees pour voir si elles fonctionnent avec le lien de reference que nous utilisons pour les tests. Veuillez patienter un instant...',
    SupportedLanguage.ptBR: 'Ótimo, agora vou testar as regras de extração que você criou para ver se funcionam com o link de referência que estamos usando para testes. Por favor, aguarde um momento...',
    SupportedLanguage.ja: '素晴らしい、作成した抽出ルールがテスト用のリファレンスリンクで機能するかどうかをテストします。少々お待ちください...',
  },
  'chat_rules_success': {
    SupportedLanguage.en: 'New rules were tested and did not present any errors! I\'ll update the test endpoint...',
    SupportedLanguage.es: 'Las nuevas reglas fueron probadas y no presentaron errores! Actualizare el endpoint de prueba...',
    SupportedLanguage.de: 'Neue Regeln wurden getestet und zeigten keine Fehler! Ich werde den Test-Endpunkt aktualisieren...',
    SupportedLanguage.fr: 'Les nouvelles regles ont ete testees et n\'ont presente aucune erreur ! Je vais mettre a jour l\'endpoint de test...',
    SupportedLanguage.ptBR: 'As novas regras foram testadas e não apresentaram erros! Vou atualizar o endpoint de teste...',
    SupportedLanguage.ja: '新しいルールがテストされ、エラーはありませんでした！テストエンドポイントを更新します...',
  },
  'chat_rules_success_final': {
    SupportedLanguage.en: 'New rules were tested and did not present any errors',
    SupportedLanguage.es: 'Las nuevas reglas fueron probadas y no presentaron errores',
    SupportedLanguage.de: 'Neue Regeln wurden getestet und zeigten keine Fehler',
    SupportedLanguage.fr: 'Les nouvelles regles ont ete testees et n\'ont presente aucune erreur',
    SupportedLanguage.ptBR: 'As novas regras foram testadas e não apresentaram erros',
    SupportedLanguage.ja: '新しいルールがテストされ、エラーはありませんでした',
  },
  'chat_rules_failed': {
    SupportedLanguage.en: 'The extraction rules failed in my quality-assurance test validation. I will ask the AI to fix the selectors and try again.',
    SupportedLanguage.es: 'Las reglas de extraccion fallaron en mi validacion de prueba de control de calidad. Le pedire a la IA que corrija los selectores e intente de nuevo.',
    SupportedLanguage.de: 'Die Extraktionsregeln sind bei meiner Qualitatssicherungs-Testvalidierung fehlgeschlagen. Ich werde die KI bitten, die Selektoren zu korrigieren und es erneut zu versuchen.',
    SupportedLanguage.fr: 'Les regles d\'extraction ont echoue lors de ma validation de test d\'assurance qualite. Je vais demander a l\'IA de corriger les selecteurs et de reessayer.',
    SupportedLanguage.ptBR: 'As regras de extração falharam na minha validação de teste de garantia de qualidade. Vou pedir a IA para corrigir os seletores e tentar novamente.',
    SupportedLanguage.ja: '抽出ルールが品質保証テストの検証に失敗しました。AIにセレクターを修正して再試行するよう依頼します。',
  },
  'chat_request_updated': {
    SupportedLanguage.en: 'Request structure updated successfully.',
    SupportedLanguage.es: 'Estructura de solicitud actualizada exitosamente.',
    SupportedLanguage.de: 'Anfragestruktur erfolgreich aktualisiert.',
    SupportedLanguage.fr: 'Structure de requete mise à jour avec succes.',
    SupportedLanguage.ptBR: 'Estrutura de solicitação atualizada com sucesso.',
    SupportedLanguage.ja: 'リクエスト構造が正常に更新されました。',
  },
  'chat_scrappable_request_updated': {
    SupportedLanguage.en: 'Scrappable request configuration updated successfully',
    SupportedLanguage.es: 'Configuracion de solicitud de scrappable actualizada exitosamente',
    SupportedLanguage.de: 'Scrappable-Anfragekonfiguration erfolgreich aktualisiert',
    SupportedLanguage.fr: 'Configuration de requete scrappable mise à jour avec succes',
    SupportedLanguage.ptBR: 'Configuração de solicitação de scrappable atualizada com sucesso',
    SupportedLanguage.ja: 'Scrappableリクエスト設定が正常に更新されました',
  },
  'chat_api_key_configured': {
    SupportedLanguage.en: 'Your OpenAI API key has been successfully configured. You can now continue chatting without using platform credits. Your API key is securely stored and will be used for all future messages.',
    SupportedLanguage.es: 'Tu clave API de OpenAI ha sido configurada exitosamente. Ahora puedes continuar chateando sin usar creditos de la plataforma. Tu clave API esta almacenada de forma segura y se usara para todos los mensajes futuros.',
    SupportedLanguage.de: 'Ihr OpenAI API-Schlüssel wurde erfolgreich konfiguriert. Sie konnen jetzt ohne Plattform-Guthaben weiterchatten. Ihr API-Schlüssel wird sicher gespeichert und fur alle zukunftigen Nachrichten verwendet.',
    SupportedLanguage.fr: 'Votre clé API OpenAI a ete configuree avec succes. Vous pouvez maintenant continuer a discuter sans utiliser les crédits de la plateforme. Votre clé API est stockee en toute securite et sera utilisee pour tous les futurs messages.',
    SupportedLanguage.ptBR: 'Sua chave API do OpenAI foi configurada com sucesso. Agora você pode continuar conversando sem usar créditos da plataforma. Sua chave API está armazenada com segurança e será usada para todas as mensagens futuras.',
    SupportedLanguage.ja: 'OpenAI APIキーが正常に設定されました。プラットフォームのクレジットを使用せずにチャットを続けることができます。APIキーは安全に保存され、今後のすべてのメッセージに使用されます。',
  },
  'chat_ip_limit': {
    SupportedLanguage.en: 'You have reached the spending limit for your IP address ({limit}). This limit resets after 7 days, or you can create an account to get monthly credits.',
    SupportedLanguage.es: 'Has alcanzado el limite de gasto para tu direccion IP ({limit}). Este limite se restablece despues de 7 dias, o puedes crear una cuenta para obtener creditos mensuales.',
    SupportedLanguage.de: 'Sie haben das Ausgabenlimit fur Ihre IP-Adresse erreicht ({limit}). Dieses Limit wird nach 7 Tagen zuruckgesetzt, oder Sie konnen ein Konto erstellen, um monatliche Guthaben zu erhalten.',
    SupportedLanguage.fr: 'Vous avez atteint la limite de depenses pour votre adresse IP ({limit}). Cette limite est reinitialise apres 7 jours, ou vous pouvez creer un compte pour obtenir des crédits mensuels.',
    SupportedLanguage.ptBR: 'Você atingiu o limite de gastos para seu endereço IP ({limit}). Este limite é redefinido após 7 dias, ou você pode criar uma conta para obter créditos mensais.',
    SupportedLanguage.ja: 'IPアドレスの支出制限に達しました（{limit}）。この制限は7日後にリセットされます。月額クレジットを取得するにはアカウントを作成してください。',
  },
  'chat_credits_exhausted_logged_in': {
    SupportedLanguage.en: 'You have exhausted your AI crédits for this month. Your crédits will reset at the beginning of next month, or you can add your own OpenAI API key in account settings to continue without limits.',
    SupportedLanguage.es: 'Has agotado tus creditos de IA para este mes. Tus creditos se restablecera al principio del proximo mes, o puedes agregar tu propia clave API de OpenAI en la configuracion de tu cuenta para continuar sin limites.',
    SupportedLanguage.de: 'Sie haben Ihre KI-Guthaben fur diesen Monat aufgebraucht. Ihre Guthaben werden zu Beginn des nachsten Monats zuruckgesetzt, oder Sie konnen Ihren eigenen OpenAI API-Schlüssel in den Kontoeinstellungen hinzufugen, um ohne Limits fortzufahren.',
    SupportedLanguage.fr: 'Vous avez epuise vos crédits IA pour ce mois. Vos crédits seront reinitialises au debut du mois prochain, ou vous pouvez ajouter votre propre clé API OpenAI dans les parametres du compte pour continuer sans limites.',
    SupportedLanguage.ptBR: 'Você esgotou seus créditos de IA para este mês. Seus créditos serão redefinidos no início do próximo mês, ou você pode adicionar sua própria chave API do OpenAI nas configurações da conta para continuar sem limites.',
    SupportedLanguage.ja: '今月のAIクレジットを使い切りました。クレジットは来月の初めにリセットされます。制限なく続けるにはアカウント設定でOpenAI APIキーを追加してください。',
  },
  'chat_credits_exhausted_anonymous': {
    SupportedLanguage.en: 'You have reached the spending limit for this anonymous session ({limit}). Please create an account to continue using the AI assistant with monthly credits.',
    SupportedLanguage.es: 'Has alcanzado el limite de gasto para esta sesion anonima ({limit}). Por favor, crea una cuenta para continuar usando el asistente de IA con creditos mensuales.',
    SupportedLanguage.de: 'Sie haben das Ausgabenlimit fur diese anonyme Sitzung erreicht ({limit}). Bitte erstellen Sie ein Konto, um den KI-Assistenten mit monatlichem Guthaben weiter zu nutzen.',
    SupportedLanguage.fr: 'Vous avez atteint la limite de depenses pour cette session anonyme ({limit}). Veuillez creer un compte pour continuer a utiliser l\'assistant IA avec des crédits mensuels.',
    SupportedLanguage.ptBR: 'Você atingiu o limite de gastos para esta sessão anônima ({limit}). Por favor, crie uma conta para continuar usando o assistente de IA com créditos mensais.',
    SupportedLanguage.ja: 'この匿名セッションの支出制限に達しました（{limit}）。月額クレジットでAIアシスタントを引き続き使用するにはアカウントを作成してください。',
  },
  'chat_user_api_key_quota': {
    SupportedLanguage.en: 'Your OpenAI API key has run out of credits. Please add crédits to your OpenAI account at platform.openai.com, or remove your API key from account settings to use platform crédits instead.',
    SupportedLanguage.es: 'Tu clave API de OpenAI se ha quedado sin creditos. Por favor, agrega creditos a tu cuenta de OpenAI en platform.openai.com, o elimina tu clave API de la configuracion de tu cuenta para usar los creditos de la plataforma en su lugar.',
    SupportedLanguage.de: 'Ihr OpenAI API-Schlüssel hat keine Guthaben mehr. Bitte fugen Sie Guthaben zu Ihrem OpenAI-Konto auf platform.openai.com hinzu, oder entfernen Sie Ihren API-Schlüssel aus den Kontoeinstellungen, um stattdessen Plattform-Guthaben zu verwenden.',
    SupportedLanguage.fr: 'Votre clé API OpenAI n\'a plus de credits. Veuillez ajouter des crédits a votre compte OpenAI sur platform.openai.com, ou supprimez votre clé API des parametres du compte pour utiliser les crédits de la plateforme a la place.',
    SupportedLanguage.ptBR: 'Sua chave API do OpenAI ficou sem créditos. Por favor, adicione créditos a sua conta OpenAI em platform.openai.com, ou remova sua chave API das configurações da conta para usar os créditos da plataforma.',
    SupportedLanguage.ja: 'OpenAI APIキーのクレジットがなくなりました。platform.openai.comでOpenAIアカウントにクレジットを追加するか、アカウント設定からAPIキーを削除してプラットフォームクレジットを使用してください。',
  },
  'chat_openai_quota_error': {
    SupportedLanguage.en: 'The OpenAI API returned a quota error. Please try again later or contact support if the issue persists.',
    SupportedLanguage.es: 'La API de OpenAI devolvio un error de cuota. Por favor, intenta de nuevo mas tarde o contacta con soporte si el problema persiste.',
    SupportedLanguage.de: 'Die OpenAI API hat einen Kontingentfehler zuruckgegeben. Bitte versuchen Sie es spater erneut oder kontaktieren Sie den Support, wenn das Problem weiterhin besteht.',
    SupportedLanguage.fr: 'L\'API OpenAI a renvoye une erreur de quota. Veuillez reessayer plus tard ou contacter le support si le probleme persiste.',
    SupportedLanguage.ptBR: 'A API do OpenAI retornou um erro de cota. Por favor, tente novamente mais tarde ou entre em contato com o suporte se o problema persistir.',
    SupportedLanguage.ja: 'OpenAI APIがクォータエラーを返しました。後でもう一度お試しください。問題が解決しない場合はサポートにお問い合わせください。',
  },
  'chat_message_error': {
    SupportedLanguage.en: 'An error occurred while sending the message',
    SupportedLanguage.es: 'Ocurrio un error al enviar el mensaje',
    SupportedLanguage.de: 'Beim Senden der Nachricht ist ein Fehler aufgetreten',
    SupportedLanguage.fr: 'Une erreur s\'est produite lors de l\'envoi du message',
    SupportedLanguage.ptBR: 'Ocorreu um erro ao enviar a mensagem',
    SupportedLanguage.ja: 'メッセージの送信中にエラーが発生しました',
  },
  'chat_parse_error': {
    SupportedLanguage.en: 'The AI model returned an unexpected response format. This can happen when the model is processing complex requests with multiple tool calls. Please try again with a simpler request, or contact support if the issue persists.',
    SupportedLanguage.es: 'El modelo de IA devolvio un formato de respuesta inesperado. Esto puede ocurrir cuando el modelo procesa solicitudes complejas con multiples llamadas de herramientas. Por favor, intenta de nuevo con una solicitud mas simple, o contacta con soporte si el problema persiste.',
    SupportedLanguage.de: 'Das KI-Modell hat ein unerwartetes Antwortformat zuruckgegeben. Dies kann passieren, wenn das Modell komplexe Anfragen mit mehreren Tool-Aufrufen verarbeitet. Bitte versuchen Sie es mit einer einfacheren Anfrage erneut, oder kontaktieren Sie den Support, wenn das Problem weiterhin besteht.',
    SupportedLanguage.fr: 'Le modele IA a renvoye un format de reponse inattendu. Cela peut se produire lorsque le modele traite des requetes complexes avec plusieurs appels d\'outils. Veuillez reessayer avec une requete plus simple, ou contactez le support si le probleme persiste.',
    SupportedLanguage.ptBR: 'O modelo de IA retornou um formato de resposta inesperado. Isso pode acontecer quando o modelo processa solicitações complexas com múltiplas chamadas de ferramentas. Por favor, tente novamente com uma solicitação mais simples, ou entre em contato com o suporte se o problema persistir.',
    SupportedLanguage.ja: 'AIモデルが予期しないレスポンス形式を返しました。これは、モデルが複数のツール呼び出しを含む複雑なリクエストを処理しているときに発生することがあります。より簡単なリクエストでもう一度お試しください。問題が解決しない場合はサポートにお問い合わせください。',
  },
  'chat_auth_error': {
    SupportedLanguage.en: 'Authentication error with OpenAI API. Please check the API key configuration.',
    SupportedLanguage.es: 'Error de autenticacion con la API de OpenAI. Por favor, verifica la configuracion de la clave API.',
    SupportedLanguage.de: 'Authentifizierungsfehler mit der OpenAI API. Bitte uberprufen Sie die API-Schlüssel-Konfiguration.',
    SupportedLanguage.fr: 'Erreur d\'authentification avec l\'API OpenAI. Veuillez verifier la configuration de la clé API.',
    SupportedLanguage.ptBR: 'Erro de autenticação com a API do OpenAI. Por favor, verifique a configuração da chave API.',
    SupportedLanguage.ja: 'OpenAI APIの認証エラー。APIキーの設定を確認してください。',
  },
  'chat_rate_limit': {
    SupportedLanguage.en: 'Rate limit exceeded. Please wait a moment and try again.',
    SupportedLanguage.es: 'Límite de velocidad excedido. Por favor, espera un momento e intenta de nuevo.',
    SupportedLanguage.de: 'Ratenlimit überschritten. Bitte warten Sie einen Moment und versuchen Sie es erneut.',
    SupportedLanguage.fr: 'Límite de debit depassee. Veuillez patienter un moment et reessayer.',
    SupportedLanguage.ptBR: 'Límite de taxa excedido. Por favor, aguarde um momento e tente novamente.',
    SupportedLanguage.ja: 'レート制限を超えました。しばらく待ってから再試行してください。',
  },
  'chat_invalid_request': {
    SupportedLanguage.en: 'Invalid request to OpenAI API. This might be a configuration issue. Please try again or contact support.',
    SupportedLanguage.es: 'Solicitud invalida a la API de OpenAI. Esto podria ser un problema de configuracion. Por favor, intenta de nuevo o contacta con soporte.',
    SupportedLanguage.de: 'Ungultige Anfrage an die OpenAI API. Dies konnte ein Konfigurationsproblem sein. Bitte versuchen Sie es erneut oder kontaktieren Sie den Support.',
    SupportedLanguage.fr: 'Requete invalide a l\'API OpenAI. Cela pourrait etre un probleme de configuration. Veuillez reessayer ou contacter le support.',
    SupportedLanguage.ptBR: 'Solicitação inválida para a API do OpenAI. Isso pode ser um problema de configuração. Por favor, tente novamente ou entre em contato com o suporte.',
    SupportedLanguage.ja: 'OpenAI APIへの無効なリクエスト。これは設定の問題かもしれません。再試行するか、サポートにお問い合わせください。',
  },

  // Country code errors
  'invalid_country_code': {
    SupportedLanguage.en: 'The country code "{countryCode}" is not supported. Please use a valid ISO 3166-1 alpha-2 code (e.g., "us", "gb", "de").',
    SupportedLanguage.es: 'El código de país "{countryCode}" no es válido. Por favor, utilice un código ISO 3166-1 alfa-2 válido (ej: "us", "gb", "de").',
    SupportedLanguage.de: 'Der Ländercode "{countryCode}" wird nicht unterstützt. Bitte verwenden Sie einen gültigen ISO 3166-1 Alpha-2 Code (z.B. "us", "gb", "de").',
    SupportedLanguage.fr: 'Le code pays "{countryCode}" n\'est pas pris en charge. Veuillez utiliser un code ISO 3166-1 alpha-2 valide (ex: "us", "gb", "de").',
    SupportedLanguage.ptBR: 'O código de país "{countryCode}" não é suportado. Por favor, use um código ISO 3166-1 alfa-2 válido (ex: "us", "gb", "de").',
    SupportedLanguage.ja: '国コード「{countryCode}」はサポートされていません。有効なISO 3166-1 alpha-2コード（例：「us」、「gb」、「de」）を使用してください。',
  },
};
