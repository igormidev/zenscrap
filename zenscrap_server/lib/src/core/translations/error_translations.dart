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
};
