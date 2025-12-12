// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get landing_nav_create_scrappable => 'Scrappableを作成';

  @override
  String get landing_nav_how_it_works => '使い方';

  @override
  String get landing_nav_auto_fix => '自動修復';

  @override
  String get landing_nav_features => '機能';

  @override
  String get landing_nav_marketplace => 'マーケットプレイス';

  @override
  String get landing_nav_pricing => '料金';

  @override
  String get landing_sign_in => 'ログイン';

  @override
  String get landing_app_name => 'ZenScrap';

  @override
  String get landing_learn_more => '詳しく見る';

  @override
  String get landing_hero_title => '自己修復する\nWebスクレイパー';

  @override
  String get landing_hero_subtitle =>
      '抽出したい内容を説明するだけ。AIがスクレイパーを自動で構築、テスト、メンテナンスします。コード不要。CSSセレクター不要。壊れたエンドポイントはもう心配いりません。';

  @override
  String get landing_hero_target_url_label => '対象URL';

  @override
  String get landing_hero_target_url_hint => 'https://example.jp/product/12345';

  @override
  String get landing_hero_url_validation_invalid => '有効なURLを入力してください';

  @override
  String get landing_hero_url_validation_min_length => 'URLは10文字以上である必要があります';

  @override
  String get landing_hero_url_validation_max_length => 'URLは500文字以下である必要があります';

  @override
  String get landing_hero_prompt_label => '何を抽出しますか？';

  @override
  String get landing_hero_prompt_hint => '例：商品名、価格、画像を抽出';

  @override
  String get landing_hero_prompt_validation_min_length =>
      'プロンプトは10文字以上である必要があります';

  @override
  String get landing_hero_prompt_validation_max_length =>
      'プロンプトは2200文字以下である必要があります';

  @override
  String get landing_hero_cta_button => '最初のスクレイパーを作成';

  @override
  String get landing_hero_free_label => '無料';

  @override
  String get landing_trust_no_credit_card => 'クレジットカード不要';

  @override
  String get landing_trust_no_signup => '登録なしでテスト可能';

  @override
  String get landing_trust_ready_in_minutes => '2分以内に完了';

  @override
  String get landing_problem_title => '従来のWebスクレイピングは限界です';

  @override
  String get landing_problem_subtitle =>
      'CSSセレクターに費やす時間。毎週壊れるスクレイパー。リクエストをブロックするアンチボットシステム。心当たりはありませんか？';

  @override
  String get landing_problem_css_title => 'CSSセレクター地獄';

  @override
  String get landing_problem_css_description =>
      '正しいセレクターを見つけるためにHTMLを調べても、サイトが更新されると壊れてしまいます。';

  @override
  String get landing_problem_maintenance_title => '絶え間ないメンテナンス';

  @override
  String get landing_problem_maintenance_description =>
      'Webサイトは常に構造を変更します。昨日動いていたスクレイパーが、今日は空のデータを返します。';

  @override
  String get landing_problem_antibot_title => 'アンチボットの悪夢';

  @override
  String get landing_problem_antibot_description =>
      'CAPTCHA、レート制限、IPブロック。アンチボットシステムとの戦いはフルタイムの仕事です。';

  @override
  String get landing_problem_productivity_title => '生産性の損失';

  @override
  String get landing_problem_productivity_description =>
      'スクレイパーのデバッグに費やす時間は、本業に使えない時間です。';

  @override
  String get landing_how_title => '3ステップで自動データ取得';

  @override
  String get landing_how_subtitle => 'コード不要。設定不要。必要なものを説明するだけ。';

  @override
  String get landing_how_step1_title => 'URLを貼り付け';

  @override
  String get landing_how_step1_description =>
      'データを抽出したいページのリンクを貼り付けてください。どんなサイトでも、どんな複雑さでも対応します。';

  @override
  String get landing_how_step2_title => '欲しいものを説明';

  @override
  String get landing_how_step2_description =>
      '必要なデータをAIに自然な言葉で伝えてください。商品価格、記事内容、ユーザープロフィール、何でも可能です。';

  @override
  String get landing_how_step3_title => '自己修復APIを取得';

  @override
  String get landing_how_step3_description =>
      '対象サイトが変更されても自動的に適応する、すぐに使えるAPIエンドポイントを受け取れます。';

  @override
  String get landing_how_ai_note => 'AIが名前、説明、カテゴリ、URLパターンを自動生成します';

  @override
  String get landing_autofix_badge => '業界初';

  @override
  String get landing_autofix_title => '自己修復Webスクレイパー';

  @override
  String get landing_autofix_subtitle =>
      'Webサイトは変わります。でもスクレイパーが壊れる必要はありません。AIが対象サイトの更新を自動検出し、お気づきになる前に抽出ルールを修正します。';

  @override
  String get landing_autofix_step1_title => '変更を検出';

  @override
  String get landing_autofix_step1_description =>
      'システムがスクレイパーを監視し、抽出ルールが失敗し始めたことを検出します。';

  @override
  String get landing_autofix_step2_title => 'AIが分析・適応';

  @override
  String get landing_autofix_step2_description =>
      'AIが新しいページ構造を分析し、更新された抽出ルールを生成します。';

  @override
  String get landing_autofix_step3_title => 'スクレイパー修復完了';

  @override
  String get landing_autofix_step3_description =>
      'エンドポイントはシームレスに動作し続けます。メール通知でお知らせします。';

  @override
  String get landing_autofix_notifications_title => 'プロアクティブ通知';

  @override
  String get landing_autofix_notifications_description =>
      'サイトが変更され、スクレイパーが自動修復されている際に通知を受け取れます。';

  @override
  String get landing_autofix_without_title => 'ZenScrapなしの場合';

  @override
  String get landing_autofix_without_item1 => 'スクレイパーが予期せず壊れる';

  @override
  String get landing_autofix_without_item2 => 'デバッグに何時間も費やす';

  @override
  String get landing_autofix_without_item3 => 'データと収益の損失';

  @override
  String get landing_autofix_without_item4 => '絶え間ないメンテナンス負担';

  @override
  String get landing_autofix_with_title => 'ZenScrapありの場合';

  @override
  String get landing_autofix_with_item1 => 'AIが問題を即座に検出';

  @override
  String get landing_autofix_with_item2 => '数分で自動修復';

  @override
  String get landing_autofix_with_item3 => 'データ損失ゼロ';

  @override
  String get landing_autofix_with_item4 => '設定したら放置でOK';

  @override
  String get landing_features_title => '現代のWebのために構築';

  @override
  String get landing_features_subtitle => 'エンタープライズグレードのインフラをシンプルなインターフェースで。';

  @override
  String get landing_features_cost_title => 'スマートなコスト最適化';

  @override
  String get landing_features_cost_description =>
      'AIが自動的に設定をテストし、動作する最も安価なオプションを見つけます。クレジットの無駄遣いはありません。';

  @override
  String get landing_features_antibot_title => 'アンチボット対策済み';

  @override
  String get landing_features_antibot_description =>
      'CAPTCHA、レート制限、フィンガープリンティング、すべて私たちが対応しますので、お客様は心配不要です。';

  @override
  String get landing_features_geo_title => 'グローバルジオターゲティング';

  @override
  String get landing_features_geo_description =>
      '対象地域に基づいた自動プロキシ選択で、地域制限コンテンツにアクセスできます。';

  @override
  String get landing_features_testing_title => 'プラットフォーム内テスト';

  @override
  String get landing_features_testing_description =>
      'プラットフォームを離れることなく、どんなスクレイパーも即座にテストできます。Postmanは不要です。';

  @override
  String get landing_features_analytics_title => '詳細な分析';

  @override
  String get landing_features_analytics_description =>
      'すべてのリクエストを追跡し、問題を即座に特定し、様々な期間の使用状況を監視できます。';

  @override
  String get landing_features_js_title => 'JavaScript レンダリング';

  @override
  String get landing_features_js_description =>
      'SPA、動的コンテンツ、無限スクロールページに対応したヘッドレスブラウザを完全サポート。';

  @override
  String get landing_marketplace_badge => 'コミュニティ';

  @override
  String get landing_marketplace_title => '既存のものを作り直す必要はありません';

  @override
  String get landing_marketplace_subtitle =>
      '人気サイト向けの構築済みスクレイパーのマーケットプレイスをご覧ください。すぐに使用するか、他の人がどのように同様の課題を解決したかを学べます。';

  @override
  String get landing_marketplace_prebuilt_title => '構築済みスクレイパー';

  @override
  String get landing_marketplace_prebuilt_description =>
      'Amazon、eBay、LinkedIn、ニュースサイトなど、人気サイトには既に動作するスクレイパーが用意されています。';

  @override
  String get landing_marketplace_stats_title => '使用統計';

  @override
  String get landing_marketplace_stats_description =>
      '実際のコミュニティ使用データに基づいて、どのスクレイパーが最も人気があり信頼性が高いかを確認できます。';

  @override
  String get landing_marketplace_testing_title => '即座にテスト';

  @override
  String get landing_marketplace_testing_description =>
      'マーケットプレイスのスクレイパーを使用前にテストできます。独自のパラメータでテストして結果を確認してください。';

  @override
  String get landing_marketplace_category_ecommerce => 'Eコマース';

  @override
  String get landing_marketplace_category_news => 'ニュース・メディア';

  @override
  String get landing_marketplace_category_jobs => '求人情報';

  @override
  String get landing_marketplace_category_social => 'ソーシャルメディア';

  @override
  String get landing_marketplace_category_realestate => '不動産';

  @override
  String get landing_marketplace_category_finance => '金融';

  @override
  String get landing_marketplace_category_sports => 'スポーツ';

  @override
  String get landing_marketplace_category_more => '+ 25以上';

  @override
  String get landing_pricing_title => 'シンプルで透明な料金';

  @override
  String get landing_pricing_subtitle => 'ニーズに合ったプランをお選びください。成長に合わせてスケールできます。';

  @override
  String get landing_cta_title => 'スクレイパーの監視から\n解放されませんか？';

  @override
  String get landing_cta_subtitle =>
      '時間を取り戻した開発者の仲間入りをしましょう。一度構築すれば、AIが永遠にメンテナンスします。';

  @override
  String get landing_cta_create_button => '最初のスクレイパーを作成';

  @override
  String get landing_cta_marketplace_button => 'マーケットプレイスを見る';

  @override
  String get landing_footer_tagline => 'AI駆動のWebスクレイピング';

  @override
  String get account_title => 'アカウント';

  @override
  String get account_information_title => 'アカウント情報';

  @override
  String get account_user_name_label => 'ユーザー名';

  @override
  String get account_email_label => 'メールアドレス';

  @override
  String get account_subscription_plan_label => 'ご契約プラン';

  @override
  String get account_appearance_title => '外観';

  @override
  String get account_display_mode_title => '表示モード';

  @override
  String get account_display_mode_subtitle => 'ライトテーマとダークテーマから選択';

  @override
  String get account_accent_color_title => 'アクセントカラー';

  @override
  String get account_accent_color_subtitle => 'お好みの色でアプリをカスタマイズ';

  @override
  String get account_loading => '読み込み中...';

  @override
  String get account_change_image_tooltip => '画像を変更';

  @override
  String get account_brightness_light => 'ライト';

  @override
  String get account_brightness_dark => 'ダーク';

  @override
  String get account_beta_badge => 'ベータ版';

  @override
  String get account_dark_mode_title => 'ダークモード';

  @override
  String get account_dark_mode_beta_warning =>
      '一部のUI要素が正しく表示されない場合があります。現在改善中です。';
}
