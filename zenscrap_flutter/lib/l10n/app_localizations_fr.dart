// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get landing_nav_create_scrappable => 'Créer un Scrappable';

  @override
  String get landing_nav_how_it_works => 'Comment ça marche';

  @override
  String get landing_nav_auto_fix => 'Auto-Réparation';

  @override
  String get landing_nav_features => 'Fonctionnalités';

  @override
  String get landing_nav_marketplace => 'Marketplace';

  @override
  String get landing_nav_pricing => 'Tarifs';

  @override
  String get landing_sign_in => 'Se connecter';

  @override
  String get landing_app_name => 'ZenScrap';

  @override
  String get landing_learn_more => 'En savoir plus';

  @override
  String get landing_drawer_language => 'Langue';

  @override
  String get landing_hero_title =>
      'Des Web Scrapers qui se\nréparent tout seuls';

  @override
  String get landing_hero_subtitle =>
      'Décrivez ce que vous voulez extraire. Notre IA construit, teste et maintient votre scraper automatiquement. Sans code. Sans sélecteurs CSS. Sans endpoints cassés.';

  @override
  String get landing_hero_target_url_label => 'URL cible';

  @override
  String get landing_hero_target_url_hint => 'https://exemple.fr/produit/12345';

  @override
  String get landing_hero_url_validation_invalid =>
      'Veuillez entrer une URL valide';

  @override
  String get landing_hero_url_validation_min_length =>
      'L\'URL doit contenir au moins 10 caractères';

  @override
  String get landing_hero_url_validation_max_length =>
      'L\'URL doit contenir moins de 500 caractères';

  @override
  String landing_hero_url_validation_banned_domain(String domain) {
    return 'Ce site web ($domain) n\'est pas pris en charge pour le scraping';
  }

  @override
  String get landing_hero_prompt_label => 'Que voulez-vous extraire ?';

  @override
  String get landing_hero_prompt_hint =>
      'Ex. Extraire le nom du produit, le prix et les images';

  @override
  String get landing_hero_prompt_validation_min_length =>
      'Le prompt doit contenir au moins 10 caractères';

  @override
  String get landing_hero_prompt_validation_max_length =>
      'Le prompt doit contenir moins de 2200 caractères';

  @override
  String get landing_hero_cta_button => 'Créez votre premier Scraper';

  @override
  String get landing_hero_free_label => 'Gratuit';

  @override
  String get landing_trust_no_credit_card => 'Pas de carte bancaire requise';

  @override
  String get landing_trust_no_signup => 'Pas d\'inscription pour tester';

  @override
  String get landing_trust_ready_in_minutes => 'Prêt en moins de 2 minutes';

  @override
  String get landing_problem_title => 'Le Web Scraping traditionnel est cassé';

  @override
  String get landing_problem_subtitle =>
      'Des heures perdues sur les sélecteurs CSS. Des scrapers qui cassent chaque semaine. Des systèmes anti-bot qui bloquent vos requêtes. Ça vous dit quelque chose ?';

  @override
  String get landing_problem_css_title => 'L\'enfer des sélecteurs CSS';

  @override
  String get landing_problem_css_description =>
      'Fouiller le HTML pour trouver les bons sélecteurs, pour qu\'ils cassent dès que le site se met à jour.';

  @override
  String get landing_problem_maintenance_title => 'Maintenance constante';

  @override
  String get landing_problem_maintenance_description =>
      'Les sites web changent constamment leur structure. Votre scraper fonctionnait hier, aujourd\'hui il renvoie des données vides.';

  @override
  String get landing_problem_antibot_title => 'Cauchemars anti-bot';

  @override
  String get landing_problem_antibot_description =>
      'CAPTCHAs, limites de débit, blocages IP. Combattre les systèmes anti-bot est un travail à plein temps.';

  @override
  String get landing_problem_productivity_title => 'Productivité perdue';

  @override
  String get landing_problem_productivity_description =>
      'Chaque heure à debugger des scrapers est une heure non consacrée à votre véritable activité.';

  @override
  String get landing_how_title => 'Trois étapes vers des données automatisées';

  @override
  String get landing_how_subtitle =>
      'Sans code. Sans configuration. Décrivez simplement ce dont vous avez besoin.';

  @override
  String get landing_how_step1_title => 'Collez votre URL';

  @override
  String get landing_how_step1_description =>
      'Déposez le lien vers la page dont vous voulez extraire les données. N\'importe quel site, n\'importe quelle complexité.';

  @override
  String get landing_how_step2_title => 'Décrivez ce que vous voulez';

  @override
  String get landing_how_step2_description =>
      'Dites à notre IA en langage simple quelles données vous avez besoin. Prix des produits, contenu d\'articles, profils utilisateurs, tout.';

  @override
  String get landing_how_step3_title => 'Obtenez votre API auto-réparatrice';

  @override
  String get landing_how_step3_description =>
      'Recevez un endpoint API prêt à l\'emploi qui s\'adapte automatiquement quand le site cible change.';

  @override
  String get landing_how_ai_note =>
      'L\'IA génère automatiquement le nom, la description, la catégorie et les patterns d\'URL';

  @override
  String get landing_autofix_badge => 'PREMIÈRE MONDIALE';

  @override
  String get landing_autofix_title => 'Le Web Scraper auto-réparateur';

  @override
  String get landing_autofix_subtitle =>
      'Les sites web changent. Vos scrapers n\'ont pas à casser. Notre IA détecte automatiquement quand un site cible se met à jour et corrige vos règles d\'extraction, avant même que vous ne le remarquiez.';

  @override
  String get landing_autofix_step1_title => 'Changements détectés';

  @override
  String get landing_autofix_step1_description =>
      'Notre système surveille vos scrapers et détecte quand les règles d\'extraction commencent à échouer.';

  @override
  String get landing_autofix_step2_title => 'L\'IA analyse et s\'adapte';

  @override
  String get landing_autofix_step2_description =>
      'L\'IA examine la nouvelle structure de la page et génère des règles d\'extraction mises à jour.';

  @override
  String get landing_autofix_step3_title => 'Scraper réparé';

  @override
  String get landing_autofix_step3_description =>
      'Votre endpoint continue de fonctionner parfaitement. Vous recevez une notification par email.';

  @override
  String get landing_autofix_notifications_title => 'Notifications proactives';

  @override
  String get landing_autofix_notifications_description =>
      'Soyez notifié quand un site change et que votre scraper est en cours de réparation automatique.';

  @override
  String get landing_autofix_without_title => 'Sans ZenScrap';

  @override
  String get landing_autofix_without_item1 =>
      'Le scraper casse de manière inattendue';

  @override
  String get landing_autofix_without_item2 => 'Des heures passées à debugger';

  @override
  String get landing_autofix_without_item3 => 'Données et revenus perdus';

  @override
  String get landing_autofix_without_item4 => 'Charge de maintenance constante';

  @override
  String get landing_autofix_with_title => 'Avec ZenScrap';

  @override
  String get landing_autofix_with_item1 =>
      'L\'IA détecte les problèmes instantanément';

  @override
  String get landing_autofix_with_item2 =>
      'Corrections automatiques en minutes';

  @override
  String get landing_autofix_with_item3 => 'Zéro perte de données';

  @override
  String get landing_autofix_with_item4 => 'Configurez et oubliez';

  @override
  String get landing_features_title => 'Conçu pour le web moderne';

  @override
  String get landing_features_subtitle =>
      'Infrastructure niveau entreprise dans une interface simple.';

  @override
  String get landing_features_cost_title =>
      'Optimisation intelligente des coûts';

  @override
  String get landing_features_cost_description =>
      'L\'IA teste automatiquement les configurations et trouve l\'option la moins chère qui fonctionne. Pas de crédits gaspillés.';

  @override
  String get landing_features_antibot_title => 'Anti-bot géré';

  @override
  String get landing_features_antibot_description =>
      'CAPTCHAs, limites de débit, fingerprinting, nous gérons tout pour que vous n\'ayez pas à le faire.';

  @override
  String get landing_features_geo_title => 'Géo-ciblage mondial';

  @override
  String get landing_features_geo_description =>
      'Accédez au contenu bloqué par région avec sélection automatique de proxy basée sur l\'emplacement cible.';

  @override
  String get landing_features_testing_title => 'Tests intégrés à la plateforme';

  @override
  String get landing_features_testing_description =>
      'Testez n\'importe quel scraper instantanément sans quitter la plateforme. Pas besoin de Postman.';

  @override
  String get landing_features_analytics_title => 'Analytiques approfondies';

  @override
  String get landing_features_analytics_description =>
      'Suivez chaque requête, identifiez les problèmes instantanément et surveillez l\'utilisation sur différentes périodes.';

  @override
  String get landing_features_js_title => 'Rendu JavaScript';

  @override
  String get landing_features_js_description =>
      'Support complet du navigateur headless pour les SPAs, le contenu dynamique et les pages à défilement infini.';

  @override
  String get landing_marketplace_badge => 'COMMUNAUTÉ';

  @override
  String get landing_marketplace_title =>
      'Ne construisez pas ce qui existe déjà';

  @override
  String get landing_marketplace_subtitle =>
      'Parcourez notre marketplace de scrapers pré-construits pour les sites populaires. Utilisez-les instantanément ou apprenez comment d\'autres ont résolu des défis similaires.';

  @override
  String get landing_marketplace_prebuilt_title => 'Scrapers pré-construits';

  @override
  String get landing_marketplace_prebuilt_description =>
      'Amazon, eBay, LinkedIn, sites d\'actualités, les sites populaires ont déjà des scrapers fonctionnels prêts à l\'emploi.';

  @override
  String get landing_marketplace_stats_title => 'Statistiques d\'utilisation';

  @override
  String get landing_marketplace_stats_description =>
      'Voyez quels scrapers sont les plus populaires et fiables basés sur les données réelles d\'utilisation de la communauté.';

  @override
  String get landing_marketplace_testing_title => 'Tests instantanés';

  @override
  String get landing_marketplace_testing_description =>
      'Testez n\'importe quel scraper du marketplace avant de l\'utiliser. Testez avec vos propres paramètres pour vérifier les résultats.';

  @override
  String get landing_marketplace_category_ecommerce => 'E-Commerce';

  @override
  String get landing_marketplace_category_news => 'Actualités et Médias';

  @override
  String get landing_marketplace_category_jobs => 'Offres d\'emploi';

  @override
  String get landing_marketplace_category_social => 'Réseaux sociaux';

  @override
  String get landing_marketplace_category_realestate => 'Immobilier';

  @override
  String get landing_marketplace_category_finance => 'Finance';

  @override
  String get landing_marketplace_category_sports => 'Sports';

  @override
  String get landing_marketplace_category_more => '+ 25 autres';

  @override
  String get landing_pricing_title => 'Tarification simple et transparente';

  @override
  String get landing_pricing_subtitle =>
      'Choisissez le forfait qui correspond à vos besoins. Évoluez au fur et à mesure de votre croissance.';

  @override
  String get landing_cta_title =>
      'Prêt à arrêter de surveiller\nvos Scrapers ?';

  @override
  String get landing_cta_subtitle =>
      'Rejoignez les développeurs qui ont récupéré leur temps. Construisez une fois, laissez l\'IA maintenir pour toujours.';

  @override
  String get landing_cta_create_button => 'Créez votre premier Scraper';

  @override
  String get landing_cta_marketplace_button => 'Parcourir le Marketplace';

  @override
  String get landing_marketplace_login_title => 'Connexion requise';

  @override
  String get landing_marketplace_login_message =>
      'Vous devez vous connecter pour voir les endpoints du marketplace.';

  @override
  String get landing_marketplace_login_ok => 'OK';

  @override
  String get landing_footer_tagline => 'Web Scraping propulsé par l\'IA';

  @override
  String get account_title => 'Compte';

  @override
  String get account_information_title => 'Informations du compte';

  @override
  String get account_user_name_label => 'Nom d\'utilisateur';

  @override
  String get account_email_label => 'E-mail';

  @override
  String get account_subscription_plan_label => 'Votre abonnement';

  @override
  String get account_subscription_sync => 'Synchroniser';

  @override
  String get account_subscription_syncing => 'Synchronisation...';

  @override
  String get account_subscription_sync_success =>
      'Abonnement synchronisé avec succès';

  @override
  String get account_appearance_title => 'Apparence';

  @override
  String get account_display_mode_title => 'Mode d\'affichage';

  @override
  String get account_display_mode_subtitle =>
      'Choisissez entre le thème clair et sombre';

  @override
  String get account_accent_color_title => 'Couleur d\'accent';

  @override
  String get account_accent_color_subtitle =>
      'Personnalisez l\'application avec votre couleur préférée';

  @override
  String get account_loading => 'Chargement...';

  @override
  String get account_change_image_tooltip => 'Changer l\'image';

  @override
  String get account_brightness_light => 'Clair';

  @override
  String get account_brightness_dark => 'Sombre';

  @override
  String get account_beta_badge => 'BETA';

  @override
  String get account_dark_mode_title => 'Mode Sombre';

  @override
  String get account_dark_mode_beta_warning =>
      'Certains éléments de l\'interface peuvent ne pas s\'afficher parfaitement. Nous améliorons activement.';

  @override
  String get ai_usage_title => 'Utilisation de l\'IA';

  @override
  String get ai_usage_refresh => 'Actualiser';

  @override
  String get ai_usage_retry => 'Réessayer';

  @override
  String get ai_usage_credit_history => 'Historique des Crédits';

  @override
  String get ai_usage_no_credit_history =>
      'Pas encore d\'historique de crédits';

  @override
  String get ai_usage_credit_history_empty_description =>
      'Vos transactions de crédits IA apparaîtront ici';

  @override
  String get ai_usage_monthly_ai_credits => 'Crédits IA Mensuels';

  @override
  String get ai_usage_initial_credit => 'Crédit Initial';

  @override
  String get ai_usage_welcome_bonus => 'Bonus de bienvenue';

  @override
  String get ai_usage_plan_name_free => 'Gratuit';

  @override
  String ai_usage_plan_subtitle(String planName) {
    return 'Forfait $planName';
  }

  @override
  String get ai_usage_unknown_transaction => 'Transaction Inconnue';

  @override
  String get ai_usage_credits_overview => 'Aperçu des Crédits IA';

  @override
  String get ai_usage_remaining_credits => 'Crédits Restants';

  @override
  String get ai_usage_monthly_limit => 'Limite Mensuelle';

  @override
  String ai_usage_percentage_used(String percentage) {
    return '$percentage% utilisé ce mois';
  }

  @override
  String get ai_usage_using_own_api_key =>
      'Utilisation de votre propre clé API OpenAI';

  @override
  String get ai_usage_autofix_sessions => 'Sessions d\'Auto-Réparation';

  @override
  String get ai_usage_no_autofix_sessions =>
      'Pas encore de sessions d\'auto-réparation';

  @override
  String get ai_usage_autofix_empty_description =>
      'Lorsque vos scrappables cessent de fonctionner, notre IA tentera automatiquement de les réparer. Ces sessions apparaîtront ici.';

  @override
  String get ai_usage_powerful_model => 'Modèle Puissant';

  @override
  String get ai_usage_normal_model => 'Modèle Normal';

  @override
  String ai_usage_tokens_count(String count) {
    return '$count tokens';
  }

  @override
  String ai_usage_scrappable_id(int id) {
    return 'Scrappable #$id';
  }

  @override
  String get ai_usage_status_pending => 'En attente';

  @override
  String get ai_usage_status_in_progress => 'En cours';

  @override
  String get ai_usage_status_success => 'Réussi';

  @override
  String get ai_usage_status_failed => 'Échoué';

  @override
  String get ai_usage_status_exhausted => 'Épuisé';

  @override
  String get ai_usage_status_cancelled => 'Annulé';

  @override
  String get ai_usage_triggered_at => 'Déclenché à';

  @override
  String ai_usage_consecutive_errors(int count, int threshold) {
    return '$count erreurs consécutives (seuil: $threshold)';
  }

  @override
  String get ai_usage_api_key_label => 'Clé API';

  @override
  String get ai_usage_your_own_key => 'Votre propre clé';

  @override
  String get ai_usage_platform_key => 'Clé de la plateforme';

  @override
  String get ai_usage_tokens_used => 'Tokens utilisés';

  @override
  String get ai_usage_cost => 'Coût';

  @override
  String get ai_usage_fix_summary => 'Résumé de la Réparation';

  @override
  String get ai_usage_failure_reason => 'Raison de l\'Échec';

  @override
  String ai_usage_attempts_count(int count) {
    return 'Tentatives ($count)';
  }

  @override
  String get ai_usage_attempt_status_in_progress => 'En cours';

  @override
  String get ai_usage_attempt_status_success => 'Réussi';

  @override
  String get ai_usage_attempt_status_ai_error => 'Erreur IA';

  @override
  String get ai_usage_attempt_status_api_error => 'Erreur API';

  @override
  String get ai_usage_attempt_status_validation_failed => 'Validation échouée';

  @override
  String get ai_usage_tokens_short => 'tok';

  @override
  String get ai_usage_load_more => 'Charger plus';

  @override
  String get ai_usage_api_key_section_title => 'Clé API OpenAI';

  @override
  String get ai_usage_api_key_description =>
      'Utilisez votre propre clé API OpenAI pour contourner les limites de crédits mensuels. Votre clé est stockée en toute sécurité.';

  @override
  String get ai_usage_api_key_configured => 'Clé API configurée';

  @override
  String get ai_usage_api_key_not_configured => 'Aucune clé API configurée';

  @override
  String get ai_usage_api_key_add => 'Ajouter une Clé API';

  @override
  String get ai_usage_api_key_edit => 'Modifier';

  @override
  String get ai_usage_api_key_remove => 'Supprimer';

  @override
  String get ai_usage_api_key_dialog_title => 'Clé API OpenAI';

  @override
  String get ai_usage_api_key_dialog_hint => 'sk-...';

  @override
  String get ai_usage_api_key_dialog_description =>
      'Entrez votre clé API OpenAI. La clé sera validée avant l\'enregistrement.';

  @override
  String get ai_usage_api_key_show => 'Afficher la clé API';

  @override
  String get ai_usage_api_key_hide => 'Masquer la clé API';

  @override
  String get ai_usage_api_key_save => 'Enregistrer';

  @override
  String get ai_usage_api_key_cancel => 'Annuler';

  @override
  String get ai_usage_api_key_remove_confirm_title => 'Supprimer la Clé API?';

  @override
  String get ai_usage_api_key_remove_confirm_message =>
      'Êtes-vous sûr de vouloir supprimer votre clé API OpenAI? Vous utiliserez les crédits mensuels de la plateforme à la place.';

  @override
  String get ai_usage_api_key_updated => 'Clé API mise à jour avec succès';

  @override
  String get ai_usage_api_key_removed => 'Clé API supprimée avec succès';

  @override
  String get ai_usage_api_key_error => 'Échec de la mise à jour de la clé API';

  @override
  String get api_analytics_title => 'Analytiques API';

  @override
  String get api_analytics_retry => 'Réessayer';

  @override
  String get api_analytics_refresh => 'Actualiser';

  @override
  String get api_analytics_load_more => 'Charger plus';

  @override
  String get api_analytics_no_scrappable_selected =>
      'Aucun Scrappable sélectionné';

  @override
  String get api_analytics_select_scrappable_hint =>
      'Sélectionnez un scrappable dans la liste pour voir les analytiques détaillées';

  @override
  String get api_analytics_no_more_to_load => 'Plus d\'analytiques à charger';

  @override
  String get api_analytics_error_loading =>
      'Erreur de chargement des analytiques';

  @override
  String api_analytics_showing_count(int current, int total) {
    return 'Affichage de $current sur $total';
  }

  @override
  String api_analytics_items_count(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get api_analytics_status_success => 'Réussi';

  @override
  String get api_analytics_status_client_error => 'Erreur Client';

  @override
  String get api_analytics_status_server_error => 'Erreur Serveur';

  @override
  String get api_analytics_status_insufficient_credits =>
      'Crédits Insuffisants';

  @override
  String get api_analytics_status_max_concurrency => 'Concurrence Max';

  @override
  String get api_analytics_status_extract_rules_error =>
      'Erreur Règles d\'Extraction';

  @override
  String get api_analytics_status_4xx => '4xx';

  @override
  String get api_analytics_status_5xx => '5xx';

  @override
  String get api_analytics_status_2xx => '2xx';

  @override
  String get api_analytics_stat_no_credits => 'Pas de Crédits';

  @override
  String get api_analytics_stat_extract_rules_errors =>
      'Erreurs de règles d\'extraction';

  @override
  String get api_analytics_tooltip_success => 'Requêtes complétées avec succès';

  @override
  String get api_analytics_tooltip_client_error =>
      'Erreurs client - paramètres de requête invalides ou données manquantes';

  @override
  String get api_analytics_tooltip_server_error =>
      'Erreurs serveur - problèmes avec le site web cible';

  @override
  String get api_analytics_tooltip_extract_rules_error =>
      'Les règles d\'extraction générées par l\'IA n\'ont pas pu analyser la réponse';

  @override
  String get api_analytics_tooltip_insufficient_credits =>
      'Requêtes échouées en raison de crédits insuffisants';

  @override
  String get api_analytics_tooltip_max_concurrency =>
      'Requêtes rejetées en raison de la limite de concurrence';

  @override
  String get api_analytics_scope_last_hour => 'Dernière heure';

  @override
  String get api_analytics_scope_last_12_hours => '12 dernières heures';

  @override
  String get api_analytics_scope_last_24_hours => '24 dernières heures';

  @override
  String get api_analytics_scope_last_7_days => '7 derniers jours';

  @override
  String get api_analytics_scope_last_30_days => '30 derniers jours';

  @override
  String get api_analytics_column_5_minutes =>
      'Chaque colonne représente 5 minutes';

  @override
  String get api_analytics_column_1_hour => 'Chaque colonne représente 1 heure';

  @override
  String get api_analytics_column_2_hours =>
      'Chaque colonne représente 2 heures';

  @override
  String get api_analytics_column_1_day => 'Chaque colonne représente 1 jour';

  @override
  String get api_analytics_request_delay_warning =>
      'Une requête peut prendre jusqu\'à 10 minutes pour apparaître ici';

  @override
  String get api_analytics_no_requests => 'Aucune requête';

  @override
  String get api_analytics_max_concurrency_exceeded =>
      'Concurrence maximale dépassée';

  @override
  String get api_analytics_insufficient_credits_chip => 'Crédits insuffisants';

  @override
  String get api_analytics_last_12_hours => '12 dernières heures';

  @override
  String api_analytics_total_requests(int count) {
    return 'Total: $count requêtes';
  }

  @override
  String api_analytics_tooltip_success_count(int count, String percentage) {
    return 'Réussi: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_4xx_count(int count, String percentage) {
    return '4xx: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_5xx_count(int count, String percentage) {
    return '5xx: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_scraping_bee_error(
    int count,
    String percentage,
  ) {
    return 'Erreur ScrapingBee: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_no_credits_count(int count, String percentage) {
    return 'Pas de Crédits: $count ($percentage%)';
  }

  @override
  String api_analytics_tooltip_max_concurrency_count(
    int count,
    String percentage,
  ) {
    return 'Concurrence Max: $count ($percentage%)';
  }

  @override
  String get api_analytics_show_less => 'Afficher moins';

  @override
  String get api_analytics_show_details => 'Afficher les détails';

  @override
  String get api_analytics_detail_title => 'Titre';

  @override
  String get api_analytics_detail_description => 'Description';

  @override
  String get api_analytics_detail_error_object => 'Objet d\'Erreur';

  @override
  String get api_analytics_detail_stack_trace => 'Trace de Pile';

  @override
  String get api_analytics_detail_request_payload => 'Charge de Requête';

  @override
  String get api_analytics_detail_response_data => 'Données de Réponse';

  @override
  String get api_analytics_success_badge => 'RÉUSSI';

  @override
  String get api_analytics_collapse => 'Réduire';

  @override
  String get api_analytics_expand => 'Développer';

  @override
  String api_analytics_copied_to_clipboard(String label) {
    return '$label copié dans le presse-papiers';
  }

  @override
  String api_analytics_copy_label(String label) {
    return 'Copier $label';
  }

  @override
  String api_analytics_expand_more_lines(int count) {
    return 'Cliquez sur développer pour voir $count+ lignes supplémentaires';
  }

  @override
  String get api_analytics_subtitle =>
      'Endpoints you\'ve called in the selected time period';

  @override
  String get api_analytics_scope_tooltip =>
      'Shows endpoints you\'ve interacted with during this time period';

  @override
  String get api_analytics_badge_yours => 'Yours';

  @override
  String get api_analytics_badge_marketplace => 'Marketplace';

  @override
  String get api_analytics_api_key_label => 'API Key:';

  @override
  String get api_analytics_api_key_deleted => 'API Key (deleted)';

  @override
  String get api_analytics_api_key_copied => 'API key copied to clipboard';

  @override
  String get api_analytics_copy_button => 'Copy';

  @override
  String get api_analytics_average_duration_prefix => 'Avg: ';

  @override
  String get scrappable_card_average_duration_tooltip =>
      'Average request duration';

  @override
  String get api_analytics_duration_label => 'Duration';

  @override
  String get api_analytics_load_more_failed =>
      'Échec du chargement de plus de données. Appuyez pour réessayer.';

  @override
  String get api_usage_page_title => 'Crédits et Clés API';

  @override
  String get api_usage_refresh => 'Actualiser';

  @override
  String get api_usage_retry => 'Réessayer';

  @override
  String get api_usage_overview => 'Aperçu';

  @override
  String get api_usage_api_keys => 'Clés API';

  @override
  String get api_usage_history => 'Historique';

  @override
  String get api_usage_overview_title => 'Aperçu de l\'utilisation API';

  @override
  String get api_usage_credit_history => 'Historique des Crédits';

  @override
  String get api_usage_new_api_key_created => 'Nouvelle Clé API Créée';

  @override
  String get api_usage_copy_api_key_warning =>
      'Veuillez copier et sauvegarder cette clé API. Vous ne pourrez plus la voir!';

  @override
  String get api_usage_api_key_copied =>
      'Clé API copiée dans le presse-papiers';

  @override
  String get api_usage_done => 'Terminé';

  @override
  String get api_usage_deactivate_api_key => 'Désactiver la Clé API';

  @override
  String get api_usage_deactivate_confirmation =>
      'Êtes-vous sûr de vouloir désactiver cette clé API? Cette action est irréversible.';

  @override
  String get api_usage_cancel => 'Annuler';

  @override
  String get api_usage_deactivate => 'Désactiver';

  @override
  String get api_usage_create_key => 'Créer une Clé';

  @override
  String get api_usage_no_api_keys => 'Pas encore de clés API';

  @override
  String get api_usage_purchase_credits => 'Acheter des Crédits API';

  @override
  String get api_usage_best_value => 'MEILLEURE VALEUR';

  @override
  String get api_usage_bulk_discount => 'REMISE VOLUME';

  @override
  String get api_usage_credits_never_expire =>
      'Les crédits n\'expirent jamais - Activation instantanée';

  @override
  String api_usage_unit_price(String unitPrice) {
    return 'Prix unitaire: $unitPrice';
  }

  @override
  String get api_usage_ultra_plan_required => 'Plan Ultra Requis';

  @override
  String get api_usage_ultra_exclusive_benefit =>
      'Les paquets de crédits sont un avantage exclusif pour les abonnés au plan Ultra.';

  @override
  String get api_usage_credits_never_expire_benefit =>
      'Des crédits qui n\'expirent jamais';

  @override
  String get api_usage_perfect_for_traffic_spikes =>
      'Parfait pour les pics de trafic';

  @override
  String get api_usage_maybe_later => 'Peut-être Plus Tard';

  @override
  String get api_usage_upgrade_to_ultra => 'Passer à Ultra';

  @override
  String get api_usage_unlock_credits_message =>
      'Débloquez la possibilité d\'acheter des crédits supplémentaires qui n\'expirent jamais. Parfait pour gérer les pics de trafic et les demandes saisonnières.';

  @override
  String get api_usage_get_credits_title =>
      'Obtenez des Crédits Qui N\'expirent Jamais';

  @override
  String get api_usage_traffic_spikes_subtitle =>
      'Parfait pour les pics de trafic et la planification à long terme';

  @override
  String get api_usage_credits_never_expire_title =>
      'Les Crédits N\'expirent Jamais';

  @override
  String get api_usage_credits_never_expire_description =>
      'Contrairement aux crédits d\'abonnement qui se réinitialisent mensuellement, les crédits achetés restent dans votre compte pour toujours tant que votre plan Ultra est actif.';

  @override
  String get api_usage_instant_activation_title => 'Activation Instantanée';

  @override
  String get api_usage_instant_activation_description =>
      'Les crédits sont ajoutés à votre compte immédiatement après le paiement - sans attente, sans délai.';

  @override
  String get api_usage_scale_without_limits_title => 'Évoluez Sans Limites';

  @override
  String get api_usage_scale_without_limits_description =>
      'Gérez les pics de trafic, les demandes saisonnières ou les projets spéciaux sans mettre à niveau votre plan mensuel.';

  @override
  String get api_usage_choose_package => 'Choisissez Votre Forfait';

  @override
  String get api_usage_100k_credits => '100 000 crédits';

  @override
  String get api_usage_1m_credits => '1 000 000 crédits';

  @override
  String get api_usage_2_5m_credits => '2 500 000 crédits';

  @override
  String get api_usage_small_package_description =>
      'Idéal pour les tests et les petits projets';

  @override
  String get api_usage_medium_package_description =>
      'Meilleure valeur pour les applications en croissance';

  @override
  String get api_usage_large_package_description =>
      'Économies maximales pour les besoins d\'entreprise';

  @override
  String get api_usage_most_popular => 'LE PLUS POPULAIRE';

  @override
  String get api_usage_best_deal => 'MEILLEURE OFFRE';

  @override
  String get api_usage_secure_payment_stripe => 'Paiement sécurisé via Stripe';

  @override
  String get api_usage_instant_delivery => 'Livraison instantanée';

  @override
  String get api_usage_not_now => 'Pas Maintenant';

  @override
  String get api_usage_get_100k_credits => 'Obtenir 100K Crédits';

  @override
  String get api_usage_get_1m_credits => 'Obtenir 1M Crédits';

  @override
  String get api_usage_get_2_5m_credits => 'Obtenir 2,5M Crédits';

  @override
  String get api_usage_preparing_checkout => 'Préparation du paiement...';

  @override
  String get api_usage_redirect_to_stripe =>
      'Vous serez redirigé vers Stripe dans un instant';

  @override
  String get api_usage_checkout_failed => 'Échec du Paiement';

  @override
  String get api_usage_unexpected_error =>
      'Une erreur inattendue s\'est produite';

  @override
  String get api_usage_close => 'Fermer';

  @override
  String get api_usage_complete_purchase => 'Finalisez Votre Achat';

  @override
  String get api_usage_checkout_opened =>
      'Paiement ouvert dans un nouvel onglet';

  @override
  String get api_usage_complete_in_stripe =>
      'Finalisez votre achat sur la page de paiement Stripe, puis actualisez cette page pour voir vos nouveaux crédits.';

  @override
  String get api_usage_secure_payment_powered_by_stripe =>
      'Paiement sécurisé propulsé par Stripe';

  @override
  String get api_usage_refresh_and_close => 'Actualiser et Fermer';

  @override
  String get api_usage_unable_to_verify_account =>
      'Impossible de vérifier le statut du compte. Veuillez réessayer.';

  @override
  String get api_usage_account_refreshed => 'Compte actualisé';

  @override
  String get api_usage_credits_overview => 'Aperçu des Crédits API';

  @override
  String get api_usage_total_available => 'Total Disponible';

  @override
  String get api_usage_credits_combined_description =>
      'Crédits d\'achat et d\'abonnement combinés';

  @override
  String get api_usage_subscription => 'Abonnement';

  @override
  String get api_usage_subscribe_to_unlock =>
      'Abonnez-vous pour débloquer un forfait';

  @override
  String api_usage_will_renew_monthly(int credits) {
    return 'Se renouvellera mensuellement $credits';
  }

  @override
  String get api_usage_purchased => 'Achetés';

  @override
  String get api_usage_purchased_description =>
      'Crédits d\'achat unique qui n\'expirent jamais';

  @override
  String get api_usage_credits_info =>
      'Vous pouvez acheter des crédits supplémentaires - Les crédits d\'abonnement se renouvellent mensuellement';

  @override
  String get api_usage_inactive => 'INACTIF';

  @override
  String api_usage_created_date(String date) {
    return 'Créé le $date';
  }

  @override
  String api_usage_requests_count(int count) {
    return '$count requêtes';
  }

  @override
  String get api_usage_last_30_days => '30 derniers jours';

  @override
  String get api_usage_api_key_label => 'Clé API';

  @override
  String get api_usage_copy_api_key => 'Copier la Clé API';

  @override
  String get api_usage_account_id => 'ID du Compte';

  @override
  String get api_usage_copy_account_id => 'Copier l\'ID du Compte';

  @override
  String get api_usage_account_id_copied =>
      'ID du compte copié dans le presse-papiers';

  @override
  String get api_usage_create_new_api_key => 'Créer une Nouvelle Clé API';

  @override
  String get api_usage_api_key_name_description =>
      'Donnez à votre clé API un nom descriptif pour vous aider à l\'identifier plus tard.';

  @override
  String get api_usage_api_key_name => 'Nom de la Clé API';

  @override
  String get api_usage_api_key_name_hint =>
      'ex., Serveur de Production, App Mobile, Tests';

  @override
  String get api_usage_name_required =>
      'Veuillez entrer un nom pour la clé API';

  @override
  String get api_usage_name_min_length =>
      'Le nom doit contenir au moins 3 caractères';

  @override
  String get api_usage_name_max_length =>
      'Le nom doit contenir moins de 50 caractères';

  @override
  String get api_usage_api_key_security_warning =>
      'Quiconque a accès à cette clé API aura les mêmes permissions que votre compte. Gardez-la sécurisée et ne la partagez pas publiquement.';

  @override
  String get api_usage_creating => 'Création...';

  @override
  String get api_usage_create_api_key => 'Créer une Clé API';

  @override
  String get api_usage_no_credit_history =>
      'Pas encore d\'historique de crédits';

  @override
  String get api_usage_credit_transactions_appear_here =>
      'Vos transactions de crédits apparaîtront ici';

  @override
  String get api_usage_load_more => 'Charger Plus';

  @override
  String get api_usage_monthly_subscription => 'Abonnement Mensuel';

  @override
  String get api_usage_initial_credit => 'Crédit Initial';

  @override
  String get api_usage_welcome_bonus => 'Bonus de bienvenue';

  @override
  String api_usage_plan_date_subtitle(String planName, String date) {
    return 'Forfait $planName - $date';
  }

  @override
  String get api_usage_credit_purchase => 'Achat de Crédits';

  @override
  String get api_usage_unknown_transaction => 'Transaction Inconnue';

  @override
  String get api_usage_plan_free => 'Gratuit';

  @override
  String get auth_welcome => 'Bienvenue';

  @override
  String get auth_login_tab => 'Connexion';

  @override
  String get auth_sign_up_tab => 'S\'inscrire';

  @override
  String get auth_password_reset_tab => 'Réinitialiser le mot de passe';

  @override
  String get auth_log_in_button => 'Se connecter';

  @override
  String get auth_sign_up_button => 'S\'inscrire';

  @override
  String get auth_email_label => 'E-mail';

  @override
  String get auth_email_hint => 'Entrez votre e-mail';

  @override
  String get auth_email_registered_hint =>
      'L\'e-mail avec lequel vous vous êtes inscrit';

  @override
  String get auth_password_label => 'Mot de passe';

  @override
  String get auth_password_hint => 'Entrez votre mot de passe';

  @override
  String get auth_confirm_password_label => 'Confirmer le mot de passe';

  @override
  String get auth_confirm_password_hint => 'Retapez votre mot de passe';

  @override
  String get auth_user_name_label =>
      'Nom d\'affichage (Généralement le nom de l\'entreprise)';

  @override
  String get auth_user_name_hint => 'Nom d\'utilisateur (ou nom d\'entreprise)';

  @override
  String get auth_new_password_label => 'Nouveau mot de passe';

  @override
  String get auth_new_password_hint => 'Définissez votre nouveau mot de passe';

  @override
  String get auth_new_password_confirm_hint =>
      'Retapez votre nouveau mot de passe';

  @override
  String get auth_validation_code_label => 'Code de validation';

  @override
  String get auth_validation_code_hint =>
      'Vérifiez votre e-mail pour le code de validation';

  @override
  String get auth_confirm_email_button => 'Confirmer votre e-mail';

  @override
  String auth_check_email(String email) {
    return 'Vérifiez votre \"$email\"';
  }

  @override
  String get auth_send_verification_code => 'Envoyer le code de vérification';

  @override
  String get auth_verification_code_info =>
      'Un code de vérification sera envoyé à votre e-mail';

  @override
  String get auth_validate_code_button => 'Valider le code envoyé par e-mail';

  @override
  String get auth_password_reset_success_title =>
      'Mot de passe réinitialisé avec succès!';

  @override
  String get auth_password_reset_success_message =>
      'Vous pouvez maintenant vous connecter avec votre nouveau mot de passe';

  @override
  String get auth_email_confirmed_title => 'E-mail confirmé!';

  @override
  String get auth_email_confirmed_message =>
      'Vous pouvez maintenant vous connecter avec votre e-mail et mot de passe.';

  @override
  String get auth_ok_button => 'OK';

  @override
  String get auth_or_divider => 'ou';

  @override
  String get auth_continue_with_google => 'Continuer avec Google';

  @override
  String get auth_signing_in => 'Connexion en cours...';

  @override
  String get auth_google_sign_in_description =>
      'Connectez-vous ou créez un compte avec Google';

  @override
  String get auth_google_sign_in_failed =>
      'Échec de la connexion Google. Veuillez réessayer ou utiliser l\'e-mail.';

  @override
  String get email_typo_dialog_header => 'Did you mean?';

  @override
  String get email_typo_dialog_title =>
      'We noticed a possible typo in your email address';

  @override
  String get email_typo_you_typed => 'You typed';

  @override
  String get email_typo_did_you_mean => 'Did you mean';

  @override
  String get email_typo_use_suggestion => 'Yes, use corrected email';

  @override
  String get email_typo_keep_original => 'No, I typed it correctly';

  @override
  String get auth_go_back => 'Go back';

  @override
  String get auth_change_email => 'Change email';

  @override
  String get auth_incomplete_scrappable_warning_title => 'Endpoint not ready';

  @override
  String get auth_incomplete_scrappable_warning_message =>
      'This endpoint is still being configured. It won\'t be attached to your account until you finish the AI chat session and deploy it.';

  @override
  String get dashboard_app_title => 'Zen scrap';

  @override
  String get dashboard_nav_your_endpoints => 'Vos endpoints';

  @override
  String get dashboard_nav_marketplace => 'Marketplace';

  @override
  String get dashboard_nav_credits_keys => 'Crédits et Clés';

  @override
  String get dashboard_nav_api_analytics => 'Analytiques API';

  @override
  String get dashboard_nav_account => 'Compte';

  @override
  String get dashboard_nav_log_out => 'Déconnexion';

  @override
  String get dashboard_nav_subscription => 'Abonnement';

  @override
  String get dashboard_nav_ai_usage => 'Utilisation de l\'IA';

  @override
  String get dashboard_collapse_tab => 'Réduire l\'onglet';

  @override
  String dashboard_app_version(String version) {
    return 'Version de l\'app: $version';
  }

  @override
  String dashboard_version_short(String version) {
    return 'v$version';
  }

  @override
  String get pricing_per_month => 'Par mois';

  @override
  String get pricing_per_year => 'Par an';

  @override
  String get pricing_subtitle =>
      'Nous vous couvrons, que vous soyez une personne unique gérant\nun projet personnel, une startup ou même une entreprise.';

  @override
  String get pricing_plan_basic => 'BASIC';

  @override
  String get pricing_plan_basic_subtitle => 'POUR PROJETS PERSONNELS';

  @override
  String get pricing_plan_pro => 'PRO';

  @override
  String get pricing_plan_pro_subtitle => 'POUR STARTUPS';

  @override
  String get pricing_plan_pro_emphasis => 'LE PLUS POPULAIRE';

  @override
  String get pricing_plan_ultra => 'ULTRA';

  @override
  String get pricing_plan_ultra_subtitle => 'USAGE ENTREPRISE';

  @override
  String pricing_feature_api_credits(String count) {
    return '$count crédits API';
  }

  @override
  String pricing_feature_concurrent_requests(String count) {
    return '$count requêtes simultanées';
  }

  @override
  String pricing_feature_active_endpoints(String count) {
    return '$count endpoints actifs';
  }

  @override
  String get pricing_feature_best_ai_model => 'Accès au meilleur modèle IA';

  @override
  String get pricing_feature_priority_support => 'Support Prioritaire';

  @override
  String get pricing_feature_hide_endpoints =>
      'Masquer vos endpoints du marketplace';

  @override
  String get pricing_feature_copy_endpoints =>
      'Copier les endpoints du marketplace';

  @override
  String get pricing_feature_addon_credits =>
      'Possibilité d\'acheter des crédits API supplémentaires';

  @override
  String get pricing_sign_in_required =>
      'Veuillez vous connecter pour vous abonner';

  @override
  String get pricing_checkout_error =>
      'Impossible d\'ouvrir la page de paiement';

  @override
  String pricing_error_message(String error) {
    return 'Erreur: $error';
  }

  @override
  String get marketplace_title => 'Marketplace';

  @override
  String get marketplace_public_scrappables => 'Scrappables Publics';

  @override
  String get marketplace_refresh_page => 'Actualiser la page';

  @override
  String get marketplace_search_hint =>
      'Rechercher des scrappables par nom ou description...';

  @override
  String get marketplace_error_loading =>
      'Erreur lors du chargement du marketplace';

  @override
  String get marketplace_no_results_found => 'Aucun résultat trouvé';

  @override
  String get marketplace_no_scrappables_available =>
      'Aucun scrappable disponible';

  @override
  String marketplace_no_scrappables_match(String searchQuery) {
    return 'Aucun scrappable ne correspond à \"$searchQuery\". Essayez d\'ajuster votre recherche.';
  }

  @override
  String get marketplace_empty_message =>
      'Le marketplace est actuellement vide. Revenez plus tard pour de nouveaux scrappables.';

  @override
  String get marketplace_clear_search => 'Effacer la recherche';

  @override
  String marketplace_pagination_range(
    int startItem,
    int endItem,
    int totalCount,
  ) {
    return '$startItem-$endItem sur $totalCount';
  }

  @override
  String get marketplace_usage_metrics_title =>
      'Métriques d\'utilisation (30 derniers jours)';

  @override
  String get marketplace_failed_to_load_metrics =>
      'Échec du chargement des métriques';

  @override
  String get marketplace_no_requests_last_30_days =>
      'Aucune requête dans les 30 derniers jours';

  @override
  String get marketplace_metrics_success => 'Succès';

  @override
  String get marketplace_metrics_errors => 'Erreurs';

  @override
  String get marketplace_metrics_total => 'Total';

  @override
  String get marketplace_select_api_key => 'Sélectionner une clé API';

  @override
  String marketplace_api_key_created(String date) {
    return 'Créée: $date';
  }

  @override
  String get marketplace_cancel => 'Annuler';

  @override
  String get marketplace_clone_success_title => 'Scrappable cloné avec succès!';

  @override
  String marketplace_clone_success_message(String name) {
    return '\"$name\" a été ajouté à vos endpoints';
  }

  @override
  String get marketplace_clone_private_notice =>
      'Le scrappable cloné est privé par défaut. Vous pouvez le rendre public depuis l\'écran de modification.';

  @override
  String get marketplace_go_to_endpoints => 'Aller aux Endpoints';

  @override
  String get marketplace_edit_scrappable => 'Modifier le Scrappable';

  @override
  String get marketplace_close => 'Fermer';

  @override
  String get marketplace_example_response => 'Réponse d\'exemple';

  @override
  String get marketplace_tab_result => 'RÉSULTAT';

  @override
  String get marketplace_tab_html => 'HTML';

  @override
  String get marketplace_tab_screenshot => 'Capture d\'écran';

  @override
  String get marketplace_reference_url =>
      'URL de référence utilisée pour l\'exemple:';

  @override
  String get marketplace_open_url => 'Ouvrir l\'URL';

  @override
  String get marketplace_copy_url => 'Copier l\'URL';

  @override
  String get marketplace_no_example_response =>
      'Aucune réponse d\'exemple disponible';

  @override
  String get marketplace_copy => 'Copier';

  @override
  String get marketplace_increase_font_size => 'Augmenter la taille de police';

  @override
  String get marketplace_decrease_font_size => 'Réduire la taille de police';

  @override
  String get marketplace_no_html_content => 'Aucun contenu HTML disponible';

  @override
  String get marketplace_no_screenshot => 'Aucune capture d\'écran disponible';

  @override
  String get marketplace_result_copied =>
      'Résultat copié dans le presse-papiers';

  @override
  String get marketplace_html_copied => 'HTML copié dans le presse-papiers';

  @override
  String get marketplace_screenshot_info_copied => 'Info de capture copiée';

  @override
  String get marketplace_screenshot_copy_error =>
      'Could not copy screenshot. Try right-click and save image instead.';

  @override
  String get marketplace_target_url => 'URL cible:';

  @override
  String get marketplace_change => 'Modifier';

  @override
  String get marketplace_curl_command => 'Commande Curl';

  @override
  String get marketplace_test_endpoint => 'Tester l\'endpoint';

  @override
  String get marketplace_copy_curl_command => 'Copier la commande cURL de test';

  @override
  String get marketplace_api_configuration => 'Configuration API et Coûts';

  @override
  String marketplace_created_date(String date) {
    return 'Créé: $date';
  }

  @override
  String marketplace_last_logic_modification(String date) {
    return 'Dernière modification de logique: $date';
  }

  @override
  String get marketplace_clone_to_my_endpoints => 'Cloner vers mes Endpoints';

  @override
  String get marketplace_login_required =>
      'Veuillez vous connecter pour utiliser ce scrappable.';

  @override
  String get marketplace_no_api_keys =>
      'Aucune clé API trouvée. Veuillez d\'abord créer une clé API pour utiliser ce scrappable.';

  @override
  String get marketplace_upgrade_required_title => 'Mise à niveau requise';

  @override
  String get marketplace_clone_feature_pro =>
      'Le clonage de scrappables depuis le marketplace est disponible sur les forfaits Pro et Ultra.';

  @override
  String get marketplace_upgrade_benefits_title =>
      'Mettez à niveau pour débloquer:';

  @override
  String get marketplace_benefit_clone =>
      'Cloner n\'importe quel scrappable du marketplace';

  @override
  String get marketplace_benefit_more_credits => 'Plus de crédits API';

  @override
  String get marketplace_benefit_concurrent => 'Plus de requêtes simultanées';

  @override
  String get marketplace_benefit_endpoints => 'Plus d\'endpoints actifs';

  @override
  String get marketplace_maybe_later => 'Peut-être plus tard';

  @override
  String get marketplace_view_plans => 'Voir les forfaits';

  @override
  String get scrap_session_copied_to_clipboard =>
      'Copié dans le presse-papiers';

  @override
  String get scrap_session_tab_result => 'RÉSULTAT';

  @override
  String get scrap_session_tab_html => 'HTML';

  @override
  String get scrap_session_tab_screenshot => 'Capture d\'écran';

  @override
  String get scrap_session_no_json_response => 'Aucune réponse JSON disponible';

  @override
  String get scrap_session_no_html_content => 'Aucun contenu HTML disponible';

  @override
  String get scrap_session_no_screenshot =>
      'Aucune capture d\'écran disponible';

  @override
  String get scrap_session_copy => 'Copier';

  @override
  String get scrap_session_increase_font_size =>
      'Augmenter la taille de police';

  @override
  String get scrap_session_decrease_font_size => 'Réduire la taille de police';

  @override
  String get scrap_session_test_suite => 'Suite de tests';

  @override
  String get scrap_session_scrappable_info => 'Info du Scrappable';

  @override
  String get scrap_session_powerful_model_upgrade =>
      'Débloquez l\'accès au modèle IA Puissant pour une précision d\'extraction supérieure et une meilleure compréhension des pages web complexes. Parfait pour les besoins de scraping avancés.';

  @override
  String get scrap_session_sign_in_required => 'Connexion Requise';

  @override
  String get scrap_session_sign_in_unlock_features =>
      'Connectez-vous pour débloquer des fonctionnalités puissantes:';

  @override
  String get scrap_session_advanced_ai_models => 'Modèles IA Avancés';

  @override
  String get scrap_session_advanced_ai_models_desc =>
      'Accès aux modèles IA puissants et autres fonctionnalités premium';

  @override
  String get scrap_session_no_time_limits => 'Sans Limite de Temps';

  @override
  String get scrap_session_no_time_limits_desc =>
      'Les endpoints n\'expirent jamais avec un abonnement';

  @override
  String get scrap_session_more_api_credits => 'Plus de Crédits API';

  @override
  String get scrap_session_more_api_credits_desc =>
      'Obtenez des milliers de crédits API par mois';

  @override
  String get scrap_session_multiple_endpoints => 'Endpoints Multiples';

  @override
  String get scrap_session_multiple_endpoints_desc =>
      'Créez et gérez plusieurs endpoints de scraping';

  @override
  String get scrap_session_maybe_later => 'Peut-être Plus Tard';

  @override
  String get scrap_session_sign_in => 'Se Connecter';

  @override
  String scrap_session_model_changed(String modelName) {
    return 'Modèle IA de Scrap changé en $modelName';
  }

  @override
  String get scrap_session_current => 'Actuel';

  @override
  String get scrap_session_deploy_tooltip =>
      'Continuez à éditer/utiliser cet endpoint\nscrappable en le déployant!';

  @override
  String get scrap_session_deploy_endpoint => 'DÉPLOYER L\'ENDPOINT';

  @override
  String get scrap_session_discard_changes => 'Annuler les modifications';

  @override
  String get scrap_session_go_back => 'Retour';

  @override
  String get scrap_session_edit_request => 'Modifier la requête scrappable';

  @override
  String get scrap_session_no_test_data => 'Aucune donnée de test disponible';

  @override
  String get scrap_session_chat_loading => 'Chargement du chat...';

  @override
  String get scrap_session_copy_curl => 'Copier la commande cURL de test';

  @override
  String get scrap_session_analyzing_url => 'Analyse de l\'URL';

  @override
  String scrap_session_thoughts_processed(int count) {
    return '$count pensées traitées';
  }

  @override
  String get scrap_session_ai_thinking => 'L\'IA réfléchit...';

  @override
  String get scrap_session_initializing_ai =>
      'Initialisation de l\'analyse IA...';

  @override
  String get scrap_session_web_search_grounding => 'Ancrage de Recherche Web';

  @override
  String scrap_session_sources_referenced(int count) {
    return '$count sources référencées';
  }

  @override
  String get scrap_session_ai_analyzing_pattern =>
      'Gemini 3 Pro analyse votre modèle d\'URL...';

  @override
  String get scrap_session_test_endpoint => 'Tester l\'endpoint';

  @override
  String get scrap_session_creating_session => 'Création de la session...';

  @override
  String get scrap_session_add_api_key =>
      'Ajoutez une clé API pour continuer...';

  @override
  String get scrap_session_ask_modification => 'Demandez une modification...';

  @override
  String get scrap_session_message_min_length =>
      'Le message doit contenir au moins 3 caractères';

  @override
  String get scrap_session_message_max_length =>
      'Le message doit contenir moins de 1000 caractères';

  @override
  String get scrap_session_edit_request_title =>
      'Modifier la Requête Scrappable';

  @override
  String get scrap_session_edit_request_subtitle =>
      'Personnalisez le modèle d\'URL, les paramètres de chemin et les paramètres de requête';

  @override
  String scrap_session_path_params_hint(Object postId, Object userId) {
    return 'Les paramètres de chemin doivent être entourés d\'accolades comme $userId ou $postId. Ils représentent des segments dynamiques dans l\'URL qui seront remplacés par des valeurs réelles.';
  }

  @override
  String scrap_session_use_param_name(Object paramName) {
    return 'Utilisez $paramName pour les paramètres de chemin';
  }

  @override
  String get scrap_session_save_changes => 'Enregistrer les Modifications';

  @override
  String get scrap_session_duplicate_param => 'Paramètre en Double';

  @override
  String get scrap_session_duplicate_path_param =>
      'Ce paramètre de chemin existe déjà.';

  @override
  String get scrap_session_duplicate_query_param =>
      'Ce paramètre de requête existe déjà.';

  @override
  String get scrap_session_missing_path_params =>
      'Paramètres de Chemin Manquants';

  @override
  String get scrap_session_unused_path_params =>
      'Paramètres de Chemin Non Utilisés';

  @override
  String get scrap_session_request_updated =>
      'Requête scrappable mise à jour avec succès!';

  @override
  String get scrap_session_close => 'Fermer';

  @override
  String get scrap_session_chat_loading_disabled_tooltip =>
      'Désactivé pendant le traitement de l\'IA';

  @override
  String get scrap_session_chat_loading_test_notice =>
      'L\'IA traite une requête. Veuillez patienter avant d\'exécuter les tests.';

  @override
  String get scrap_session_session_expired_tooltip =>
      'Session expirée - déployez pour continuer';

  @override
  String get scrap_session_session_expired_test_notice =>
      'Votre session de test a expiré. Déployez le point de terminaison pour continuer à l\'utiliser.';

  @override
  String get scrappables_empty_title =>
      'Vous n\'avez pas encore créé de scrappables.';

  @override
  String get scrappables_create_first => 'Créez votre premier scrappable';

  @override
  String get scrappables_search_hint =>
      'Recherchez vos endpoints par nom ou description...';

  @override
  String get scrappables_error_loading =>
      'Erreur lors du chargement des endpoints';

  @override
  String get scrappables_no_results => 'Aucun endpoint trouvé';

  @override
  String get scrappables_try_different_keywords =>
      'Essayez de rechercher avec d\'autres mots-clés ou ajustez vos filtres.';

  @override
  String get scrappables_try_different_categories =>
      'Essayez de sélectionner d\'autres catégories ou effacez vos filtres.';

  @override
  String get scrappables_selected_category => 'la catégorie sélectionnée';

  @override
  String get scrappables_selected_categories => 'les catégories sélectionnées';

  @override
  String get scrappables_your_endpoints => 'Vos endpoints';

  @override
  String get scrappables_create_new => 'Créer un nouvel endpoint';

  @override
  String get scrappables_create_dialog_title => 'Create New Scraper';

  @override
  String get scrappables_create_dialog_subtitle => 'AI-powered data extraction';

  @override
  String get scrappables_create_dialog_description =>
      'Enter the URL you want to scrape and describe what data you want to extract. Our AI will analyze the page and create a custom scraper for you.';

  @override
  String get scrappables_create_dialog_hint =>
      'Be specific about the data you need';

  @override
  String get scrappables_create_dialog_cancel => 'Cancel';

  @override
  String get scrappables_create_dialog_create => 'Create Scraper';

  @override
  String get scrappables_create_dialog_creating => 'Creating...';

  @override
  String get common_show_original => 'Afficher l\'original';

  @override
  String get common_show_translated => 'Afficher la traduction';

  @override
  String common_auto_translated(String language) {
    return 'Traduit automatiquement depuis $language';
  }

  @override
  String get authErrorInvalidCredentialsTitle => 'Login Failed';

  @override
  String get authErrorInvalidCredentialsDescription =>
      'The email or password you entered is incorrect. Please check your credentials and try again.';

  @override
  String get authErrorAccountNotFoundDescription =>
      'We couldn\'t find an account with this email address. Please check the email or create a new account.';

  @override
  String get authErrorAccountLockedTitle => 'Account Locked';

  @override
  String get authErrorAccountDisabledDescription =>
      'Your account has been disabled. Please contact support for assistance.';

  @override
  String get authErrorAccountLockedDescription =>
      'Your account has been temporarily locked due to security concerns. Please try again later or contact support.';

  @override
  String get authErrorEmailExistsTitle => 'Email Already Registered';

  @override
  String get authErrorEmailExistsDescription =>
      'An account with this email address already exists. Please try logging in instead, or use a different email.';

  @override
  String get authErrorInvalidCodeTitle => 'Invalid Code';

  @override
  String get authErrorInvalidCodeDescription =>
      'The verification code you entered is incorrect. Please check the code in your email and try again.';

  @override
  String get authErrorExpiredCodeTitle => 'Code Expired';

  @override
  String get authErrorExpiredCodeDescription =>
      'This verification code has expired. Please request a new code and try again.';

  @override
  String get authErrorWeakPasswordTitle => 'Password Too Weak';

  @override
  String get authErrorWeakPasswordDescription =>
      'Please choose a stronger password. Use at least 8 characters with a mix of letters, numbers, and symbols.';

  @override
  String get authErrorInvalidEmailTitle => 'Invalid Email';

  @override
  String get authErrorInvalidEmailDescription =>
      'Please enter a valid email address.';

  @override
  String get authErrorRateLimitedTitle => 'Too Many Attempts';

  @override
  String get authErrorTooManyAttemptsDescription =>
      'You\'ve made too many attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorLoginRateLimitedDescription =>
      'Too many login attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorVerificationRateLimitedDescription =>
      'Too many verification attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorPasswordResetCodeInvalidDescription =>
      'The password reset code you entered is incorrect. Please check the code in your email and try again.';

  @override
  String get authErrorPasswordResetCodeExpiredDescription =>
      'This password reset code has expired. Please request a new password reset and try again.';

  @override
  String get authErrorPasswordResetRateLimitedDescription =>
      'Too many password reset attempts. Please wait a few minutes before trying again.';

  @override
  String get authErrorGoogleCancelledTitle => 'Sign-In Cancelled';

  @override
  String get authErrorGoogleCancelledDescription =>
      'Google sign-in was cancelled. You can try again or use email sign-in instead.';

  @override
  String get authErrorGoogleFailedTitle => 'Google Sign-In Failed';

  @override
  String get authErrorGoogleFailedDescription =>
      'We couldn\'t complete Google sign-in. Please try again or use email sign-in.';

  @override
  String get authErrorGoogleNotVerifiedTitle => 'Account Not Verified';

  @override
  String get authErrorGoogleNotVerifiedDescription =>
      'Your Google account email is not verified. Please verify your Google account and try again.';

  @override
  String get authErrorGoogleDomainRestrictedTitle => 'Domain Not Allowed';

  @override
  String get authErrorGoogleDomainRestrictedDescription =>
      'Sign-in is restricted to specific email domains. Please use an allowed email address.';

  @override
  String get authErrorNetworkTitle => 'Connection Error';

  @override
  String get authErrorNetworkDescription =>
      'Unable to connect to the server. Please check your internet connection and try again.';

  @override
  String get authErrorConnectionRefusedDescription =>
      'Could not reach the server. Please check your internet connection and try again.';

  @override
  String get authErrorServerTitle => 'Server Error';

  @override
  String get authErrorServerDescription =>
      'Something went wrong on our end. Please try again later. If the problem persists, contact support.';

  @override
  String get authErrorTimeoutTitle => 'Request Timeout';

  @override
  String get authErrorTimeoutDescription =>
      'The request took too long. Please check your connection and try again.';

  @override
  String get authErrorUnknownTitle => 'Something Went Wrong';

  @override
  String get authErrorUnknownDescription =>
      'An unexpected error occurred. Please try again. If the problem continues, contact support.';

  @override
  String get authErrorButtonTryAgain => 'Try Again';

  @override
  String get authErrorButtonTryLater => 'Try Later';

  @override
  String get authErrorButtonOk => 'OK';

  @override
  String get ip_block_reason_unknown => 'Raison inconnue';

  @override
  String get ip_block_reason_tor_detected => 'Noeud de sortie Tor détecté';

  @override
  String get ip_block_reason_datacenter_abuser =>
      'IP de datacenter avec historique d\'abus';

  @override
  String get ip_block_reason_known_abuser => 'Adresse IP abusive connue';

  @override
  String get ip_block_reason_crawler_detected =>
      'Bot ou robot automatisé détecté';

  @override
  String get ip_block_reason_bogon_ip => 'Plage d\'adresses IP invalide';
}
