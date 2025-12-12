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

  @override
  String get ai_usage_title => 'AI使用状況';

  @override
  String get ai_usage_refresh => '更新';

  @override
  String get ai_usage_retry => '再試行';

  @override
  String get ai_usage_credit_history => 'クレジット履歴';

  @override
  String get ai_usage_no_credit_history => 'クレジット履歴はまだありません';

  @override
  String get ai_usage_credit_history_empty_description =>
      'AIクレジットの取引履歴がここに表示されます';

  @override
  String get ai_usage_monthly_ai_credits => '月間AIクレジット';

  @override
  String get ai_usage_plan_name_free => '無料';

  @override
  String ai_usage_plan_subtitle(String planName) {
    return '$planNameプラン';
  }

  @override
  String get ai_usage_unknown_transaction => '不明な取引';

  @override
  String get ai_usage_credits_overview => 'AIクレジット概要';

  @override
  String get ai_usage_remaining_credits => '残りクレジット';

  @override
  String get ai_usage_monthly_limit => '月間上限';

  @override
  String ai_usage_percentage_used(String percentage) {
    return '今月$percentage%使用済み';
  }

  @override
  String get ai_usage_using_own_api_key => '独自のOpenAI APIキーを使用中';

  @override
  String get ai_usage_autofix_sessions => '自動修復セッション';

  @override
  String get ai_usage_no_autofix_sessions => '自動修復セッションはまだありません';

  @override
  String get ai_usage_autofix_empty_description =>
      'スクラッパブルが壊れた際、AIが自動的に修復を試みます。そのセッションがここに表示されます。';

  @override
  String get ai_usage_powerful_model => '高性能モデル';

  @override
  String get ai_usage_normal_model => '通常モデル';

  @override
  String ai_usage_tokens_count(String count) {
    return '$countトークン';
  }

  @override
  String ai_usage_scrappable_id(int id) {
    return 'Scrappable #$id';
  }

  @override
  String get ai_usage_status_pending => '保留中';

  @override
  String get ai_usage_status_in_progress => '処理中';

  @override
  String get ai_usage_status_success => '成功';

  @override
  String get ai_usage_status_failed => '失敗';

  @override
  String get ai_usage_status_exhausted => '使い果たし';

  @override
  String get ai_usage_status_cancelled => 'キャンセル';

  @override
  String get ai_usage_triggered_at => 'トリガー時点';

  @override
  String ai_usage_consecutive_errors(int count, int threshold) {
    return '連続エラー$count回（閾値: $threshold）';
  }

  @override
  String get ai_usage_api_key_label => 'APIキー';

  @override
  String get ai_usage_your_own_key => '独自のキー';

  @override
  String get ai_usage_platform_key => 'プラットフォームキー';

  @override
  String get ai_usage_tokens_used => '使用トークン';

  @override
  String get ai_usage_cost => 'コスト';

  @override
  String get ai_usage_fix_summary => '修復サマリー';

  @override
  String get ai_usage_failure_reason => '失敗理由';

  @override
  String ai_usage_attempts_count(int count) {
    return '試行回数（$count）';
  }

  @override
  String get ai_usage_attempt_status_in_progress => '処理中';

  @override
  String get ai_usage_attempt_status_success => '成功';

  @override
  String get ai_usage_attempt_status_ai_error => 'AIエラー';

  @override
  String get ai_usage_attempt_status_api_error => 'APIエラー';

  @override
  String get ai_usage_attempt_status_validation_failed => '検証失敗';

  @override
  String get ai_usage_tokens_short => 'トークン';

  @override
  String get ai_usage_load_more => 'もっと読み込む';

  @override
  String get api_analytics_title => 'API分析';

  @override
  String get api_analytics_retry => '再試行';

  @override
  String get api_analytics_refresh => '更新';

  @override
  String get api_analytics_load_more => 'もっと読み込む';

  @override
  String get api_analytics_no_scrappable_selected => 'Scrappableが選択されていません';

  @override
  String get api_analytics_select_scrappable_hint =>
      'リストからScrappableを選択して詳細な分析を表示してください';

  @override
  String get api_analytics_no_more_to_load => 'これ以上の分析データはありません';

  @override
  String get api_analytics_error_loading => '分析の読み込みエラー';

  @override
  String api_analytics_showing_count(int current, int total) {
    return '$total件中$current件を表示';
  }

  @override
  String api_analytics_items_count(int current, int total) {
    return '$total件中$current件';
  }

  @override
  String get api_analytics_status_success => '成功';

  @override
  String get api_analytics_status_client_error => 'クライアントエラー';

  @override
  String get api_analytics_status_server_error => 'サーバーエラー';

  @override
  String get api_analytics_status_insufficient_credits => 'クレジット不足';

  @override
  String get api_analytics_status_max_concurrency => '最大同時実行数';

  @override
  String get api_analytics_status_extract_rules_error => '抽出ルールエラー';

  @override
  String get api_analytics_status_4xx => '4xx';

  @override
  String get api_analytics_status_5xx => '5xx';

  @override
  String get api_analytics_status_2xx => '2xx';

  @override
  String get api_analytics_stat_no_credits => 'クレジットなし';

  @override
  String get api_analytics_stat_extract_rules_errors => '抽出ルールエラー';

  @override
  String get api_analytics_tooltip_success => '正常に完了したリクエスト';

  @override
  String get api_analytics_tooltip_client_error =>
      'クライアントエラー - 無効なリクエストパラメータまたはデータ不足';

  @override
  String get api_analytics_tooltip_server_error => 'サーバーエラー - 対象ウェブサイトの問題';

  @override
  String get api_analytics_tooltip_extract_rules_error =>
      'AI生成の抽出ルールがレスポンスを解析できませんでした';

  @override
  String get api_analytics_tooltip_insufficient_credits =>
      'クレジット不足によりリクエストが失敗しました';

  @override
  String get api_analytics_tooltip_max_concurrency => '同時実行数制限によりリクエストが拒否されました';

  @override
  String get api_analytics_scope_last_hour => '過去1時間';

  @override
  String get api_analytics_scope_last_12_hours => '過去12時間';

  @override
  String get api_analytics_scope_last_24_hours => '過去24時間';

  @override
  String get api_analytics_scope_last_7_days => '過去7日間';

  @override
  String get api_analytics_scope_last_30_days => '過去30日間';

  @override
  String get api_analytics_column_5_minutes => '各列は5分を表します';

  @override
  String get api_analytics_column_1_hour => '各列は1時間を表します';

  @override
  String get api_analytics_column_2_hours => '各列は2時間を表します';

  @override
  String get api_analytics_column_1_day => '各列は1日を表します';

  @override
  String get api_analytics_request_delay_warning =>
      'リクエストがここに表示されるまで最大10分かかる場合があります';

  @override
  String get api_analytics_no_requests => 'リクエストなし';

  @override
  String get api_analytics_max_concurrency_exceeded => '最大同時実行数超過';

  @override
  String get api_analytics_insufficient_credits_chip => 'クレジット不足';

  @override
  String get api_analytics_last_12_hours => '過去12時間';

  @override
  String api_analytics_total_requests(int count) {
    return '合計: $count件のリクエスト';
  }

  @override
  String api_analytics_tooltip_success_count(int count, String percentage) {
    return '成功: $count件 ($percentage%)';
  }

  @override
  String api_analytics_tooltip_4xx_count(int count, String percentage) {
    return '4xx: $count件 ($percentage%)';
  }

  @override
  String api_analytics_tooltip_5xx_count(int count, String percentage) {
    return '5xx: $count件 ($percentage%)';
  }

  @override
  String api_analytics_tooltip_scraping_bee_error(
    int count,
    String percentage,
  ) {
    return 'ScrapingBeeエラー: $count件 ($percentage%)';
  }

  @override
  String api_analytics_tooltip_no_credits_count(int count, String percentage) {
    return 'クレジットなし: $count件 ($percentage%)';
  }

  @override
  String api_analytics_tooltip_max_concurrency_count(
    int count,
    String percentage,
  ) {
    return '最大同時実行数: $count件 ($percentage%)';
  }

  @override
  String get api_analytics_show_less => '閉じる';

  @override
  String get api_analytics_show_details => '詳細を表示';

  @override
  String get api_analytics_detail_title => 'タイトル';

  @override
  String get api_analytics_detail_description => '説明';

  @override
  String get api_analytics_detail_error_object => 'エラーオブジェクト';

  @override
  String get api_analytics_detail_stack_trace => 'スタックトレース';

  @override
  String get api_analytics_detail_request_payload => 'リクエストペイロード';

  @override
  String get api_analytics_detail_response_data => 'レスポンスデータ';

  @override
  String get api_analytics_success_badge => '成功';

  @override
  String get api_analytics_collapse => '折りたたむ';

  @override
  String get api_analytics_expand => '展開';

  @override
  String api_analytics_copied_to_clipboard(String label) {
    return '$labelをクリップボードにコピーしました';
  }

  @override
  String api_analytics_copy_label(String label) {
    return '$labelをコピー';
  }

  @override
  String api_analytics_expand_more_lines(int count) {
    return '展開をクリックして残り$count行以上を表示';
  }
}
