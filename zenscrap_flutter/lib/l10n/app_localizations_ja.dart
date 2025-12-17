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
  String get ai_usage_initial_credit => '初期クレジット';

  @override
  String get ai_usage_welcome_bonus => 'ウェルカムボーナス';

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
  String get ai_usage_api_key_section_title => 'OpenAI APIキー';

  @override
  String get ai_usage_api_key_description =>
      '独自のOpenAI APIキーを使用して、月間クレジット制限を回避できます。キーは安全に保存されます。';

  @override
  String get ai_usage_api_key_configured => 'APIキーが設定されています';

  @override
  String get ai_usage_api_key_not_configured => 'APIキーが設定されていません';

  @override
  String get ai_usage_api_key_add => 'APIキーを追加';

  @override
  String get ai_usage_api_key_edit => '編集';

  @override
  String get ai_usage_api_key_remove => '削除';

  @override
  String get ai_usage_api_key_dialog_title => 'OpenAI APIキー';

  @override
  String get ai_usage_api_key_dialog_hint => 'sk-...';

  @override
  String get ai_usage_api_key_dialog_description =>
      'OpenAI APIキーを入力してください。保存前にキーが検証されます。';

  @override
  String get ai_usage_api_key_show => 'APIキーを表示';

  @override
  String get ai_usage_api_key_hide => 'APIキーを隠す';

  @override
  String get ai_usage_api_key_save => '保存';

  @override
  String get ai_usage_api_key_cancel => 'キャンセル';

  @override
  String get ai_usage_api_key_remove_confirm_title => 'APIキーを削除しますか?';

  @override
  String get ai_usage_api_key_remove_confirm_message =>
      'OpenAI APIキーを削除してもよろしいですか? 代わりにプラットフォームの月間クレジットを使用することになります。';

  @override
  String get ai_usage_api_key_updated => 'APIキーが正常に更新されました';

  @override
  String get ai_usage_api_key_removed => 'APIキーが正常に削除されました';

  @override
  String get ai_usage_api_key_error => 'APIキーの更新に失敗しました';

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
  String get api_usage_page_title => 'APIクレジット＆キー';

  @override
  String get api_usage_refresh => '更新';

  @override
  String get api_usage_retry => '再試行';

  @override
  String get api_usage_overview => '概要';

  @override
  String get api_usage_api_keys => 'APIキー';

  @override
  String get api_usage_history => '履歴';

  @override
  String get api_usage_overview_title => 'API使用状況の概要';

  @override
  String get api_usage_credit_history => 'クレジット履歴';

  @override
  String get api_usage_new_api_key_created => '新しいAPIキーが作成されました';

  @override
  String get api_usage_copy_api_key_warning =>
      'このAPIキーをコピーして保存してください。再度表示することはできません！';

  @override
  String get api_usage_api_key_copied => 'APIキーをクリップボードにコピーしました';

  @override
  String get api_usage_done => '完了';

  @override
  String get api_usage_deactivate_api_key => 'APIキーを無効化';

  @override
  String get api_usage_deactivate_confirmation =>
      'このAPIキーを無効化してもよろしいですか？この操作は元に戻せません。';

  @override
  String get api_usage_cancel => 'キャンセル';

  @override
  String get api_usage_deactivate => '無効化';

  @override
  String get api_usage_create_key => 'キーを作成';

  @override
  String get api_usage_no_api_keys => 'APIキーはまだありません';

  @override
  String get api_usage_purchase_credits => 'APIクレジットを購入';

  @override
  String get api_usage_best_value => 'お得';

  @override
  String get api_usage_bulk_discount => '大量割引';

  @override
  String get api_usage_credits_never_expire => 'クレジットは期限切れになりません • 即時有効化';

  @override
  String api_usage_unit_price(String unitPrice) {
    return '単価: $unitPrice';
  }

  @override
  String get api_usage_ultra_plan_required => 'Ultraプランが必要です';

  @override
  String get api_usage_ultra_exclusive_benefit =>
      'クレジットパッケージはUltraプラン加入者限定の特典です。';

  @override
  String get api_usage_credits_never_expire_benefit => '期限切れのないクレジット';

  @override
  String get api_usage_perfect_for_traffic_spikes => 'トラフィックスパイクに最適';

  @override
  String get api_usage_maybe_later => '後で検討';

  @override
  String get api_usage_upgrade_to_ultra => 'Ultraにアップグレード';

  @override
  String get api_usage_unlock_credits_message =>
      '期限切れのない追加クレジットを購入できるようになります。トラフィックスパイクや季節的な需要に対応するのに最適です。';

  @override
  String get api_usage_get_credits_title => '期限切れのないクレジットを取得';

  @override
  String get api_usage_traffic_spikes_subtitle => 'トラフィックスパイクと長期計画に最適';

  @override
  String get api_usage_credits_never_expire_title => 'クレジットは期限切れになりません';

  @override
  String get api_usage_credits_never_expire_description =>
      '毎月リセットされるサブスクリプションクレジットとは異なり、購入したクレジットはUltraプランがアクティブな限り永久にアカウントに残ります。';

  @override
  String get api_usage_instant_activation_title => '即時有効化';

  @override
  String get api_usage_instant_activation_description =>
      'お支払い後すぐにクレジットがアカウントに追加されます - 待ち時間なし、遅延なし。';

  @override
  String get api_usage_scale_without_limits_title => '無制限にスケール';

  @override
  String get api_usage_scale_without_limits_description =>
      '月額プランをアップグレードせずに、トラフィックスパイク、季節的な需要、特別プロジェクトに対応できます。';

  @override
  String get api_usage_choose_package => 'パッケージを選択';

  @override
  String get api_usage_100k_credits => '100,000クレジット';

  @override
  String get api_usage_1m_credits => '1,000,000クレジット';

  @override
  String get api_usage_2_5m_credits => '2,500,000クレジット';

  @override
  String get api_usage_small_package_description => 'テストや小規模プロジェクトに最適';

  @override
  String get api_usage_medium_package_description => '成長中のアプリケーションに最適な価値';

  @override
  String get api_usage_large_package_description => '企業ニーズに最大の節約';

  @override
  String get api_usage_most_popular => '人気No.1';

  @override
  String get api_usage_best_deal => 'お買い得';

  @override
  String get api_usage_secure_payment_stripe => 'Stripeによる安全なお支払い';

  @override
  String get api_usage_instant_delivery => '即時配信';

  @override
  String get api_usage_not_now => '今はしない';

  @override
  String get api_usage_get_100k_credits => '10万クレジットを取得';

  @override
  String get api_usage_get_1m_credits => '100万クレジットを取得';

  @override
  String get api_usage_get_2_5m_credits => '250万クレジットを取得';

  @override
  String get api_usage_preparing_checkout => '決済を準備中...';

  @override
  String get api_usage_redirect_to_stripe => 'まもなくStripeにリダイレクトされます';

  @override
  String get api_usage_checkout_failed => '決済に失敗しました';

  @override
  String get api_usage_unexpected_error => '予期しないエラーが発生しました';

  @override
  String get api_usage_close => '閉じる';

  @override
  String get api_usage_complete_purchase => '購入を完了';

  @override
  String get api_usage_checkout_opened => '新しいタブで決済が開きました';

  @override
  String get api_usage_complete_in_stripe =>
      'Stripeの決済ページで購入を完了し、このページを更新して新しいクレジットを確認してください。';

  @override
  String get api_usage_secure_payment_powered_by_stripe => 'Stripeによる安全なお支払い';

  @override
  String get api_usage_refresh_and_close => '更新して閉じる';

  @override
  String get api_usage_unable_to_verify_account =>
      'アカウントステータスを確認できませんでした。もう一度お試しください。';

  @override
  String get api_usage_account_refreshed => 'アカウントを更新しました';

  @override
  String get api_usage_credits_overview => 'APIクレジット概要';

  @override
  String get api_usage_total_available => '利用可能合計';

  @override
  String get api_usage_credits_combined_description => '購入とサブスクリプションのクレジットを合算';

  @override
  String get api_usage_subscription => 'サブスクリプション';

  @override
  String get api_usage_subscribe_to_unlock => 'プランをアンロックするには登録してください';

  @override
  String api_usage_will_renew_monthly(int credits) {
    return '毎月更新されます $credits';
  }

  @override
  String get api_usage_purchased => '購入済み';

  @override
  String get api_usage_purchased_description => '期限切れのない一度限りの購入クレジット';

  @override
  String get api_usage_credits_info =>
      '追加クレジットを購入できます • サブスクリプションクレジットは毎月更新されます';

  @override
  String get api_usage_inactive => '無効';

  @override
  String api_usage_created_date(String date) {
    return '$dateに作成';
  }

  @override
  String api_usage_requests_count(int count) {
    return '$count件のリクエスト';
  }

  @override
  String get api_usage_last_30_days => '過去30日間';

  @override
  String get api_usage_api_key_label => 'APIキー';

  @override
  String get api_usage_copy_api_key => 'APIキーをコピー';

  @override
  String get api_usage_account_id => 'アカウントID';

  @override
  String get api_usage_copy_account_id => 'アカウントIDをコピー';

  @override
  String get api_usage_account_id_copied => 'アカウントIDをクリップボードにコピーしました';

  @override
  String get api_usage_create_new_api_key => '新しいAPIキーを作成';

  @override
  String get api_usage_api_key_name_description =>
      '後で識別しやすいように、APIキーに説明的な名前を付けてください。';

  @override
  String get api_usage_api_key_name => 'APIキー名';

  @override
  String get api_usage_api_key_name_hint => '例: 本番サーバー、モバイルアプリ、テスト';

  @override
  String get api_usage_name_required => 'APIキーの名前を入力してください';

  @override
  String get api_usage_name_min_length => '名前は3文字以上である必要があります';

  @override
  String get api_usage_name_max_length => '名前は50文字未満である必要があります';

  @override
  String get api_usage_api_key_security_warning =>
      'このAPIキーにアクセスできる人は、あなたのアカウントと同じ権限を持ちます。安全に保管し、公開しないでください。';

  @override
  String get api_usage_creating => '作成中...';

  @override
  String get api_usage_create_api_key => 'APIキーを作成';

  @override
  String get api_usage_no_credit_history => 'クレジット履歴はまだありません';

  @override
  String get api_usage_credit_transactions_appear_here => 'クレジット取引がここに表示されます';

  @override
  String get api_usage_load_more => 'もっと読み込む';

  @override
  String get api_usage_monthly_subscription => '月額サブスクリプション';

  @override
  String get api_usage_initial_credit => '初期クレジット';

  @override
  String get api_usage_welcome_bonus => 'ウェルカムボーナス';

  @override
  String api_usage_plan_date_subtitle(String planName, String date) {
    return '$planNameプラン • $date';
  }

  @override
  String get api_usage_credit_purchase => 'クレジット購入';

  @override
  String get api_usage_unknown_transaction => '不明な取引';

  @override
  String get api_usage_plan_free => '無料';

  @override
  String get auth_welcome => 'ようこそ';

  @override
  String get auth_login_tab => 'ログイン';

  @override
  String get auth_sign_up_tab => '新規登録';

  @override
  String get auth_password_reset_tab => 'パスワードリセット';

  @override
  String get auth_log_in_button => 'ログイン';

  @override
  String get auth_sign_up_button => '新規登録';

  @override
  String get auth_email_label => 'メールアドレス';

  @override
  String get auth_email_hint => 'メールアドレスを入力';

  @override
  String get auth_email_registered_hint => '登録時のメールアドレス';

  @override
  String get auth_password_label => 'パスワード';

  @override
  String get auth_password_hint => 'パスワードを入力';

  @override
  String get auth_confirm_password_label => 'パスワード確認';

  @override
  String get auth_confirm_password_hint => 'パスワードを再入力';

  @override
  String get auth_user_name_label => '表示名（通常は会社名）';

  @override
  String get auth_user_name_hint => 'ユーザー名（または会社名）';

  @override
  String get auth_new_password_label => '新しいパスワード';

  @override
  String get auth_new_password_hint => '新しいパスワードを設定';

  @override
  String get auth_new_password_confirm_hint => '新しいパスワードを再入力';

  @override
  String get auth_validation_code_label => '認証コード';

  @override
  String get auth_validation_code_hint => 'メールで届いた認証コードを確認してください';

  @override
  String get auth_confirm_email_button => 'メールアドレスを確認';

  @override
  String auth_check_email(String email) {
    return '「$email」を確認してください';
  }

  @override
  String get auth_send_verification_code => '認証コードを送信';

  @override
  String get auth_verification_code_info => '認証コードがメールで送信されます';

  @override
  String get auth_validate_code_button => 'メールで届いたコードを認証';

  @override
  String get auth_password_reset_success_title => 'パスワードのリセットが完了しました！';

  @override
  String get auth_password_reset_success_message => '新しいパスワードでログインできます';

  @override
  String get auth_email_confirmed_title => 'メールアドレスが確認されました！';

  @override
  String get auth_email_confirmed_message => 'メールアドレスとパスワードでログインできます。';

  @override
  String get auth_ok_button => 'OK';

  @override
  String get auth_or_divider => 'または';

  @override
  String get auth_continue_with_google => 'Googleで続ける';

  @override
  String get auth_signing_in => 'ログイン中...';

  @override
  String get auth_google_sign_in_description => 'Googleでログインまたはアカウント作成';

  @override
  String get auth_google_sign_in_failed =>
      'Googleログインに失敗しました。もう一度お試しいただくか、メールをご利用ください。';

  @override
  String get dashboard_app_title => 'Zen scrap';

  @override
  String get dashboard_nav_your_endpoints => 'あなたのエンドポイント';

  @override
  String get dashboard_nav_marketplace => 'マーケットプレイス';

  @override
  String get dashboard_nav_credits_keys => 'クレジット＆キー';

  @override
  String get dashboard_nav_api_analytics => 'API分析';

  @override
  String get dashboard_nav_account => 'アカウント';

  @override
  String get dashboard_nav_log_out => 'ログアウト';

  @override
  String get dashboard_nav_subscription => 'サブスクリプション';

  @override
  String get dashboard_nav_ai_usage => 'AI使用状況';

  @override
  String get dashboard_collapse_tab => 'タブを折りたたむ';

  @override
  String dashboard_app_version(String version) {
    return 'アプリバージョン: $version';
  }

  @override
  String dashboard_version_short(String version) {
    return 'v$version';
  }

  @override
  String get pricing_per_month => '月額';

  @override
  String get pricing_per_year => '年額';

  @override
  String get pricing_subtitle => '個人プロジェクト、スタートアップ、企業まで、\nあらゆるニーズにお応えします。';

  @override
  String get pricing_plan_basic => 'ベーシック';

  @override
  String get pricing_plan_basic_subtitle => '個人プロジェクト向け';

  @override
  String get pricing_plan_pro => 'プロ';

  @override
  String get pricing_plan_pro_subtitle => 'スタートアップ向け';

  @override
  String get pricing_plan_pro_emphasis => '人気No.1';

  @override
  String get pricing_plan_ultra => 'ウルトラ';

  @override
  String get pricing_plan_ultra_subtitle => '企業向け';

  @override
  String pricing_feature_api_credits(String count) {
    return '$count APIクレジット';
  }

  @override
  String pricing_feature_concurrent_requests(String count) {
    return '$count 同時リクエスト';
  }

  @override
  String pricing_feature_active_endpoints(String count) {
    return '$count アクティブエンドポイント';
  }

  @override
  String get pricing_feature_best_ai_model => '最高のAIモデルへのアクセス';

  @override
  String get pricing_feature_priority_support => '優先サポート';

  @override
  String get pricing_feature_hide_endpoints => 'マーケットプレイスからエンドポイントを非表示';

  @override
  String get pricing_feature_copy_endpoints => 'マーケットプレイスからエンドポイントをコピー';

  @override
  String get pricing_feature_addon_credits => '追加APIクレジットの購入が可能';

  @override
  String get pricing_sign_in_required => 'サブスクリプションにはログインが必要です';

  @override
  String get pricing_checkout_error => '決済ページを開けませんでした';

  @override
  String pricing_error_message(String error) {
    return 'エラー: $error';
  }

  @override
  String get marketplace_title => 'マーケットプレイス';

  @override
  String get marketplace_public_scrappables => '公開Scrappables';

  @override
  String get marketplace_refresh_page => 'ページを更新';

  @override
  String get marketplace_search_hint => '名前または説明でScrappablesを検索...';

  @override
  String get marketplace_error_loading => 'マーケットプレイスの読み込みエラー';

  @override
  String get marketplace_no_results_found => '結果が見つかりません';

  @override
  String get marketplace_no_scrappables_available => '利用可能なScrappablesがありません';

  @override
  String marketplace_no_scrappables_match(String searchQuery) {
    return '「$searchQuery」に一致するScrappablesがありません。検索条件を調整してください。';
  }

  @override
  String get marketplace_empty_message =>
      '現在マーケットプレイスは空です。新しいScrappablesが追加されるのをお待ちください。';

  @override
  String get marketplace_clear_search => '検索をクリア';

  @override
  String marketplace_pagination_range(
    int startItem,
    int endItem,
    int totalCount,
  ) {
    return '$totalCount件中$startItem-$endItem件';
  }

  @override
  String get marketplace_usage_metrics_title => '使用状況メトリクス（過去30日間）';

  @override
  String get marketplace_failed_to_load_metrics => 'メトリクスの読み込みに失敗しました';

  @override
  String get marketplace_no_requests_last_30_days => '過去30日間のリクエストはありません';

  @override
  String get marketplace_metrics_success => '成功';

  @override
  String get marketplace_metrics_errors => 'エラー';

  @override
  String get marketplace_metrics_total => '合計';

  @override
  String get marketplace_select_api_key => 'APIキーを選択';

  @override
  String marketplace_api_key_created(String date) {
    return '作成日: $date';
  }

  @override
  String get marketplace_cancel => 'キャンセル';

  @override
  String get marketplace_clone_success_title => 'Scrappableのクローンが完了しました！';

  @override
  String marketplace_clone_success_message(String name) {
    return '「$name」がエンドポイントに追加されました';
  }

  @override
  String get marketplace_clone_private_notice =>
      'クローンされたScrappableはデフォルトで非公開です。編集画面から公開に変更できます。';

  @override
  String get marketplace_go_to_endpoints => 'エンドポイントへ移動';

  @override
  String get marketplace_edit_scrappable => 'Scrappableを編集';

  @override
  String get marketplace_close => '閉じる';

  @override
  String get marketplace_example_response => 'サンプルレスポンス';

  @override
  String get marketplace_tab_result => '結果';

  @override
  String get marketplace_tab_html => 'HTML';

  @override
  String get marketplace_tab_screenshot => 'スクリーンショット';

  @override
  String get marketplace_reference_url => 'サンプルに使用された参照URL:';

  @override
  String get marketplace_open_url => 'URLを開く';

  @override
  String get marketplace_copy_url => 'URLをコピー';

  @override
  String get marketplace_no_example_response => 'サンプルレスポンスがありません';

  @override
  String get marketplace_copy => 'コピー';

  @override
  String get marketplace_increase_font_size => 'フォントサイズを拡大';

  @override
  String get marketplace_decrease_font_size => 'フォントサイズを縮小';

  @override
  String get marketplace_no_html_content => 'HTMLコンテンツがありません';

  @override
  String get marketplace_no_screenshot => 'スクリーンショットがありません';

  @override
  String get marketplace_result_copied => '結果をクリップボードにコピーしました';

  @override
  String get marketplace_html_copied => 'HTMLをクリップボードにコピーしました';

  @override
  String get marketplace_screenshot_info_copied => 'スクリーンショット情報をコピーしました';

  @override
  String get marketplace_target_url => '対象URL:';

  @override
  String get marketplace_change => '変更';

  @override
  String get marketplace_curl_command => 'Curlコマンド';

  @override
  String get marketplace_test_endpoint => 'エンドポイントをテスト';

  @override
  String get marketplace_copy_curl_command => 'テストcURLコマンドをコピー';

  @override
  String get marketplace_api_configuration => 'API設定とコスト';

  @override
  String marketplace_created_date(String date) {
    return '作成日: $date';
  }

  @override
  String marketplace_last_logic_modification(String date) {
    return '最終ロジック変更: $date';
  }

  @override
  String get marketplace_clone_to_my_endpoints => 'マイエンドポイントにクローン';

  @override
  String get marketplace_login_required => 'このScrappableを使用するにはログインしてください。';

  @override
  String get marketplace_no_api_keys =>
      'APIキーが見つかりません。このScrappableを使用するには、まずAPIキーを作成してください。';

  @override
  String get marketplace_upgrade_required_title => 'アップグレードが必要です';

  @override
  String get marketplace_clone_feature_pro =>
      'マーケットプレイスからのScrappableのクローンは、ProおよびUltraプランで利用可能です。';

  @override
  String get marketplace_upgrade_benefits_title => 'アップグレードで解除:';

  @override
  String get marketplace_benefit_clone => 'マーケットプレイスのScrappableをクローン';

  @override
  String get marketplace_benefit_more_credits => 'より多くのAPIクレジット';

  @override
  String get marketplace_benefit_concurrent => 'より多くの同時リクエスト';

  @override
  String get marketplace_benefit_endpoints => 'より多くのアクティブエンドポイント';

  @override
  String get marketplace_maybe_later => '後で検討';

  @override
  String get marketplace_view_plans => 'プランを見る';

  @override
  String get scrap_session_copied_to_clipboard => 'クリップボードにコピーしました';

  @override
  String get scrap_session_tab_result => '結果';

  @override
  String get scrap_session_tab_html => 'HTML';

  @override
  String get scrap_session_tab_screenshot => 'スクリーンショット';

  @override
  String get scrap_session_no_json_response => 'JSONレスポンスがありません';

  @override
  String get scrap_session_no_html_content => 'HTMLコンテンツがありません';

  @override
  String get scrap_session_no_screenshot => 'スクリーンショットがありません';

  @override
  String get scrap_session_copy => 'コピー';

  @override
  String get scrap_session_increase_font_size => 'フォントサイズを拡大';

  @override
  String get scrap_session_decrease_font_size => 'フォントサイズを縮小';

  @override
  String get scrap_session_test_suite => 'テストスイート';

  @override
  String get scrap_session_scrappable_info => 'Scrappable情報';

  @override
  String get scrap_session_powerful_model_upgrade =>
      '高性能AIモデルへのアクセスを解除して、優れた抽出精度と複雑なWebページの理解を実現しましょう。高度なスクレイピングニーズに最適です。';

  @override
  String get scrap_session_sign_in_required => 'ログインが必要です';

  @override
  String get scrap_session_sign_in_unlock_features => 'ログインして強力な機能をアンロック:';

  @override
  String get scrap_session_advanced_ai_models => '高度なAIモデル';

  @override
  String get scrap_session_advanced_ai_models_desc =>
      '高性能AIモデルやその他のプレミアム機能にアクセス';

  @override
  String get scrap_session_no_time_limits => '時間制限なし';

  @override
  String get scrap_session_no_time_limits_desc =>
      'サブスクリプションでエンドポイントは期限切れになりません';

  @override
  String get scrap_session_more_api_credits => 'より多くのAPIクレジット';

  @override
  String get scrap_session_more_api_credits_desc => '毎月数千のAPIクレジットを取得';

  @override
  String get scrap_session_multiple_endpoints => '複数のエンドポイント';

  @override
  String get scrap_session_multiple_endpoints_desc => '複数のスクレイピングエンドポイントを作成・管理';

  @override
  String get scrap_session_maybe_later => '後で検討';

  @override
  String get scrap_session_sign_in => 'ログイン';

  @override
  String scrap_session_model_changed(String modelName) {
    return 'スクラップAIモデルが$modelNameに変更されました';
  }

  @override
  String get scrap_session_current => '現在';

  @override
  String get scrap_session_deploy_tooltip =>
      'このScrappableエンドポイントを\nデプロイして編集/使用を続けましょう!';

  @override
  String get scrap_session_deploy_endpoint => 'エンドポイントをデプロイ';

  @override
  String get scrap_session_discard_changes => '変更を破棄';

  @override
  String get scrap_session_go_back => '戻る';

  @override
  String get scrap_session_edit_request => 'Scrappableリクエストを編集';

  @override
  String get scrap_session_no_test_data => 'テストデータがありません';

  @override
  String get scrap_session_chat_loading => 'チャットを読み込み中...';

  @override
  String get scrap_session_copy_curl => 'テストcURLコマンドをコピー';

  @override
  String get scrap_session_analyzing_url => 'URLを分析中';

  @override
  String scrap_session_thoughts_processed(int count) {
    return '$count個の思考を処理済み';
  }

  @override
  String get scrap_session_ai_thinking => 'AIが思考中...';

  @override
  String get scrap_session_initializing_ai => 'AI分析を初期化中...';

  @override
  String get scrap_session_web_search_grounding => 'ウェブ検索グラウンディング';

  @override
  String scrap_session_sources_referenced(int count) {
    return '$count件のソースを参照';
  }

  @override
  String get scrap_session_ai_analyzing_pattern =>
      'Gemini 3 ProがURLパターンを分析中...';

  @override
  String get scrap_session_test_endpoint => 'エンドポイントをテスト';

  @override
  String get scrap_session_creating_session => 'セッションを作成中...';

  @override
  String get scrap_session_add_api_key => '続行するにはAPIキーを追加してください...';

  @override
  String get scrap_session_ask_modification => '変更をリクエスト...';

  @override
  String get scrap_session_message_min_length => 'メッセージは3文字以上である必要があります';

  @override
  String get scrap_session_message_max_length => 'メッセージは1000文字未満である必要があります';

  @override
  String get scrap_session_edit_request_title => 'Scrappableリクエストを編集';

  @override
  String get scrap_session_edit_request_subtitle =>
      'URLテンプレート、パスパラメータ、クエリパラメータをカスタマイズ';

  @override
  String scrap_session_path_params_hint(Object postId, Object userId) {
    return 'パスパラメータは$userIdや$postIdのように中括弧で囲む必要があります。これらはURLの動的セグメントを表し、実際の値に置き換えられます。';
  }

  @override
  String scrap_session_use_param_name(Object paramName) {
    return 'パスパラメータには$paramNameを使用';
  }

  @override
  String get scrap_session_save_changes => '変更を保存';

  @override
  String get scrap_session_duplicate_param => '重複パラメータ';

  @override
  String get scrap_session_duplicate_path_param => 'このパスパラメータは既に存在します。';

  @override
  String get scrap_session_duplicate_query_param => 'このクエリパラメータは既に存在します。';

  @override
  String get scrap_session_missing_path_params => '不足しているパスパラメータ';

  @override
  String get scrap_session_unused_path_params => '未使用のパスパラメータ';

  @override
  String get scrap_session_request_updated => 'Scrappableリクエストが正常に更新されました!';

  @override
  String get scrap_session_close => '閉じる';

  @override
  String get scrappables_empty_title => 'まだスクラッパブルを作成していません。';

  @override
  String get scrappables_create_first => '最初のスクラッパブルを作成';

  @override
  String get scrappables_search_hint => '名前または説明でエンドポイントを検索...';

  @override
  String get scrappables_error_loading => 'エンドポイントの読み込みエラー';

  @override
  String get scrappables_no_results => 'エンドポイントが見つかりません';

  @override
  String get scrappables_try_different_keywords =>
      '別のキーワードで検索するか、フィルターを調整してください。';

  @override
  String get scrappables_try_different_categories =>
      '別のカテゴリを選択するか、フィルターをクリアしてください。';

  @override
  String get scrappables_selected_category => '選択したカテゴリ';

  @override
  String get scrappables_selected_categories => '選択したカテゴリ';

  @override
  String get scrappables_your_endpoints => 'あなたのエンドポイント';

  @override
  String get scrappables_create_new => '新しいエンドポイントを作成';

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
}
