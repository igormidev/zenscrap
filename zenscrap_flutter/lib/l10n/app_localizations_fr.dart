// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get landing_nav_create_scrappable => 'Creer un Scrappable';

  @override
  String get landing_nav_how_it_works => 'Comment ca marche';

  @override
  String get landing_nav_auto_fix => 'Auto-Reparation';

  @override
  String get landing_nav_features => 'Fonctionnalites';

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
  String get landing_hero_title =>
      'Des Web Scrapers qui se\nreparent tout seuls';

  @override
  String get landing_hero_subtitle =>
      'Decrivez ce que vous voulez extraire. Notre IA construit, teste et maintient votre scraper automatiquement. Sans code. Sans selecteurs CSS. Sans endpoints casses.';

  @override
  String get landing_hero_target_url_label => 'URL cible';

  @override
  String get landing_hero_target_url_hint => 'https://exemple.fr/produit/12345';

  @override
  String get landing_hero_url_validation_invalid =>
      'Veuillez entrer une URL valide';

  @override
  String get landing_hero_url_validation_min_length =>
      'L\'URL doit contenir au moins 10 caracteres';

  @override
  String get landing_hero_url_validation_max_length =>
      'L\'URL doit contenir moins de 500 caracteres';

  @override
  String get landing_hero_prompt_label => 'Que voulez-vous extraire ?';

  @override
  String get landing_hero_prompt_hint =>
      'Ex. Extraire le nom du produit, le prix et les images';

  @override
  String get landing_hero_prompt_validation_min_length =>
      'Le prompt doit contenir au moins 10 caracteres';

  @override
  String get landing_hero_prompt_validation_max_length =>
      'Le prompt doit contenir moins de 2200 caracteres';

  @override
  String get landing_hero_cta_button => 'Creez votre premier Scraper';

  @override
  String get landing_hero_free_label => 'Gratuit';

  @override
  String get landing_trust_no_credit_card => 'Pas de carte bancaire requise';

  @override
  String get landing_trust_no_signup => 'Pas d\'inscription pour tester';

  @override
  String get landing_trust_ready_in_minutes => 'Pret en moins de 2 minutes';

  @override
  String get landing_problem_title => 'Le Web Scraping traditionnel est casse';

  @override
  String get landing_problem_subtitle =>
      'Des heures perdues sur les selecteurs CSS. Des scrapers qui cassent chaque semaine. Des systemes anti-bot qui bloquent vos requetes. Ca vous dit quelque chose ?';

  @override
  String get landing_problem_css_title => 'L\'enfer des selecteurs CSS';

  @override
  String get landing_problem_css_description =>
      'Fouiller le HTML pour trouver les bons selecteurs, pour qu\'ils cassent des que le site se met a jour.';

  @override
  String get landing_problem_maintenance_title => 'Maintenance constante';

  @override
  String get landing_problem_maintenance_description =>
      'Les sites web changent constamment leur structure. Votre scraper fonctionnait hier, aujourd\'hui il renvoie des donnees vides.';

  @override
  String get landing_problem_antibot_title => 'Cauchemars anti-bot';

  @override
  String get landing_problem_antibot_description =>
      'CAPTCHAs, limites de debit, blocages IP. Combattre les systemes anti-bot est un travail a plein temps.';

  @override
  String get landing_problem_productivity_title => 'Productivite perdue';

  @override
  String get landing_problem_productivity_description =>
      'Chaque heure a debugger des scrapers est une heure non consacree a votre veritable activite.';

  @override
  String get landing_how_title => 'Trois etapes vers des donnees automatisees';

  @override
  String get landing_how_subtitle =>
      'Sans code. Sans configuration. Decrivez simplement ce dont vous avez besoin.';

  @override
  String get landing_how_step1_title => 'Collez votre URL';

  @override
  String get landing_how_step1_description =>
      'Deposez le lien vers la page dont vous voulez extraire les donnees. N\'importe quel site, n\'importe quelle complexite.';

  @override
  String get landing_how_step2_title => 'Decrivez ce que vous voulez';

  @override
  String get landing_how_step2_description =>
      'Dites a notre IA en langage simple quelles donnees vous avez besoin. Prix des produits, contenu d\'articles, profils utilisateurs, tout.';

  @override
  String get landing_how_step3_title => 'Obtenez votre API auto-reparatrice';

  @override
  String get landing_how_step3_description =>
      'Recevez un endpoint API pret a l\'emploi qui s\'adapte automatiquement quand le site cible change.';

  @override
  String get landing_how_ai_note =>
      'L\'IA genere automatiquement le nom, la description, la categorie et les patterns d\'URL';

  @override
  String get landing_autofix_badge => 'PREMIERE MONDIALE';

  @override
  String get landing_autofix_title => 'Le Web Scraper auto-reparateur';

  @override
  String get landing_autofix_subtitle =>
      'Les sites web changent. Vos scrapers n\'ont pas a casser. Notre IA detecte automatiquement quand un site cible se met a jour et corrige vos regles d\'extraction, avant meme que vous ne le remarquiez.';

  @override
  String get landing_autofix_step1_title => 'Changements detectes';

  @override
  String get landing_autofix_step1_description =>
      'Notre systeme surveille vos scrapers et detecte quand les regles d\'extraction commencent a echouer.';

  @override
  String get landing_autofix_step2_title => 'L\'IA analyse et s\'adapte';

  @override
  String get landing_autofix_step2_description =>
      'L\'IA examine la nouvelle structure de la page et genere des regles d\'extraction mises a jour.';

  @override
  String get landing_autofix_step3_title => 'Scraper repare';

  @override
  String get landing_autofix_step3_description =>
      'Votre endpoint continue de fonctionner parfaitement. Vous recevez une notification par email.';

  @override
  String get landing_autofix_notifications_title => 'Notifications proactives';

  @override
  String get landing_autofix_notifications_description =>
      'Soyez notifie quand un site change et que votre scraper est en cours de reparation automatique.';

  @override
  String get landing_autofix_without_title => 'Sans ZenScrap';

  @override
  String get landing_autofix_without_item1 =>
      'Le scraper casse de maniere inattendue';

  @override
  String get landing_autofix_without_item2 => 'Des heures passees a debugger';

  @override
  String get landing_autofix_without_item3 => 'Donnees et revenus perdus';

  @override
  String get landing_autofix_without_item4 => 'Charge de maintenance constante';

  @override
  String get landing_autofix_with_title => 'Avec ZenScrap';

  @override
  String get landing_autofix_with_item1 =>
      'L\'IA detecte les problemes instantanement';

  @override
  String get landing_autofix_with_item2 =>
      'Corrections automatiques en minutes';

  @override
  String get landing_autofix_with_item3 => 'Zero perte de donnees';

  @override
  String get landing_autofix_with_item4 => 'Configurez et oubliez';

  @override
  String get landing_features_title => 'Concu pour le web moderne';

  @override
  String get landing_features_subtitle =>
      'Infrastructure niveau entreprise dans une interface simple.';

  @override
  String get landing_features_cost_title =>
      'Optimisation intelligente des couts';

  @override
  String get landing_features_cost_description =>
      'L\'IA teste automatiquement les configurations et trouve l\'option la moins chere qui fonctionne. Pas de credits gaspilles.';

  @override
  String get landing_features_antibot_title => 'Anti-bot gere';

  @override
  String get landing_features_antibot_description =>
      'CAPTCHAs, limites de debit, fingerprinting, nous gerons tout pour que vous n\'ayez pas a le faire.';

  @override
  String get landing_features_geo_title => 'Geo-ciblage mondial';

  @override
  String get landing_features_geo_description =>
      'Accedez au contenu bloque par region avec selection automatique de proxy basee sur l\'emplacement cible.';

  @override
  String get landing_features_testing_title => 'Tests integres a la plateforme';

  @override
  String get landing_features_testing_description =>
      'Testez n\'importe quel scraper instantanement sans quitter la plateforme. Pas besoin de Postman.';

  @override
  String get landing_features_analytics_title => 'Analytiques approfondies';

  @override
  String get landing_features_analytics_description =>
      'Suivez chaque requete, identifiez les problemes instantanement et surveillez l\'utilisation sur differentes periodes.';

  @override
  String get landing_features_js_title => 'Rendu JavaScript';

  @override
  String get landing_features_js_description =>
      'Support complet du navigateur headless pour les SPAs, le contenu dynamique et les pages a defilement infini.';

  @override
  String get landing_marketplace_badge => 'COMMUNAUTE';

  @override
  String get landing_marketplace_title =>
      'Ne construisez pas ce qui existe deja';

  @override
  String get landing_marketplace_subtitle =>
      'Parcourez notre marketplace de scrapers pre-construits pour les sites populaires. Utilisez-les instantanement ou apprenez comment d\'autres ont resolu des defis similaires.';

  @override
  String get landing_marketplace_prebuilt_title => 'Scrapers pre-construits';

  @override
  String get landing_marketplace_prebuilt_description =>
      'Amazon, eBay, LinkedIn, sites d\'actualites, les sites populaires ont deja des scrapers fonctionnels prets a l\'emploi.';

  @override
  String get landing_marketplace_stats_title => 'Statistiques d\'utilisation';

  @override
  String get landing_marketplace_stats_description =>
      'Voyez quels scrapers sont les plus populaires et fiables bases sur les donnees reelles d\'utilisation de la communaute.';

  @override
  String get landing_marketplace_testing_title => 'Tests instantanes';

  @override
  String get landing_marketplace_testing_description =>
      'Testez n\'importe quel scraper du marketplace avant de l\'utiliser. Testez avec vos propres parametres pour verifier les resultats.';

  @override
  String get landing_marketplace_category_ecommerce => 'E-Commerce';

  @override
  String get landing_marketplace_category_news => 'Actualites et Medias';

  @override
  String get landing_marketplace_category_jobs => 'Offres d\'emploi';

  @override
  String get landing_marketplace_category_social => 'Reseaux sociaux';

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
      'Choisissez le forfait qui correspond a vos besoins. Evoluez au fur et a mesure de votre croissance.';

  @override
  String get landing_cta_title =>
      'Pret a arreter de surveiller\nvos Scrapers ?';

  @override
  String get landing_cta_subtitle =>
      'Rejoignez les developpeurs qui ont recupere leur temps. Construisez une fois, laissez l\'IA maintenir pour toujours.';

  @override
  String get landing_cta_create_button => 'Creez votre premier Scraper';

  @override
  String get landing_cta_marketplace_button => 'Parcourir le Marketplace';

  @override
  String get landing_footer_tagline => 'Web Scraping propulse par l\'IA';

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
  String get account_appearance_title => 'Apparence';

  @override
  String get account_display_mode_title => 'Mode d\'affichage';

  @override
  String get account_display_mode_subtitle =>
      'Choisissez entre le theme clair et sombre';

  @override
  String get account_accent_color_title => 'Couleur d\'accent';

  @override
  String get account_accent_color_subtitle =>
      'Personnalisez l\'application avec votre couleur preferee';

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
      'Certains elements de l\'interface peuvent ne pas s\'afficher parfaitement. Nous ameliorons activement.';

  @override
  String get ai_usage_title => 'Utilisation de l\'IA';

  @override
  String get ai_usage_refresh => 'Actualiser';

  @override
  String get ai_usage_retry => 'Reessayer';

  @override
  String get ai_usage_credit_history => 'Historique des Credits';

  @override
  String get ai_usage_no_credit_history =>
      'Pas encore d\'historique de credits';

  @override
  String get ai_usage_credit_history_empty_description =>
      'Vos transactions de credits IA apparaitront ici';

  @override
  String get ai_usage_monthly_ai_credits => 'Credits IA Mensuels';

  @override
  String get ai_usage_plan_name_free => 'Gratuit';

  @override
  String ai_usage_plan_subtitle(String planName) {
    return 'Forfait $planName';
  }

  @override
  String get ai_usage_unknown_transaction => 'Transaction Inconnue';

  @override
  String get ai_usage_credits_overview => 'Apercu des Credits IA';

  @override
  String get ai_usage_remaining_credits => 'Credits Restants';

  @override
  String get ai_usage_monthly_limit => 'Limite Mensuelle';

  @override
  String ai_usage_percentage_used(String percentage) {
    return '$percentage% utilise ce mois';
  }

  @override
  String get ai_usage_using_own_api_key =>
      'Utilisation de votre propre cle API OpenAI';

  @override
  String get ai_usage_autofix_sessions => 'Sessions d\'Auto-Reparation';

  @override
  String get ai_usage_no_autofix_sessions =>
      'Pas encore de sessions d\'auto-reparation';

  @override
  String get ai_usage_autofix_empty_description =>
      'Lorsque vos scrappables cessent de fonctionner, notre IA tentera automatiquement de les reparer. Ces sessions apparaitront ici.';

  @override
  String get ai_usage_powerful_model => 'Modele Puissant';

  @override
  String get ai_usage_normal_model => 'Modele Normal';

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
  String get ai_usage_status_success => 'Reussi';

  @override
  String get ai_usage_status_failed => 'Echoue';

  @override
  String get ai_usage_status_exhausted => 'Epuise';

  @override
  String get ai_usage_status_cancelled => 'Annule';

  @override
  String get ai_usage_triggered_at => 'Declenche a';

  @override
  String ai_usage_consecutive_errors(int count, int threshold) {
    return '$count erreurs consecutives (seuil: $threshold)';
  }

  @override
  String get ai_usage_api_key_label => 'Cle API';

  @override
  String get ai_usage_your_own_key => 'Votre propre cle';

  @override
  String get ai_usage_platform_key => 'Cle de la plateforme';

  @override
  String get ai_usage_tokens_used => 'Tokens utilises';

  @override
  String get ai_usage_cost => 'Cout';

  @override
  String get ai_usage_fix_summary => 'Resume de la Reparation';

  @override
  String get ai_usage_failure_reason => 'Raison de l\'Echec';

  @override
  String ai_usage_attempts_count(int count) {
    return 'Tentatives ($count)';
  }

  @override
  String get ai_usage_attempt_status_in_progress => 'En cours';

  @override
  String get ai_usage_attempt_status_success => 'Reussi';

  @override
  String get ai_usage_attempt_status_ai_error => 'Erreur IA';

  @override
  String get ai_usage_attempt_status_api_error => 'Erreur API';

  @override
  String get ai_usage_attempt_status_validation_failed => 'Validation echouee';

  @override
  String get ai_usage_tokens_short => 'tok';

  @override
  String get ai_usage_load_more => 'Charger plus';
}
