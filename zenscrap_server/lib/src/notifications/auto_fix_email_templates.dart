/// HTML email templates for auto-fix notifications.
///
/// This file contains all the email templates used to notify users about
/// their scraper's auto-fix status, including:
/// - Repair in progress notifications
/// - Successful repair notifications
/// - Failed repair (exhausted attempts) notifications
/// - Scraper broken with auto-fix disabled notifications
library;

/// Builds the HTML email for when AI auto-fix repair is in progress.
///
/// Parameters:
/// - [scraperName]: Name of the scrappable being repaired
/// - [errorCount]: Number of consecutive errors that triggered the repair
/// - [dashboardUrl]: URL to the scraper dashboard
String buildAutoFixInProgressEmail({
  required String scraperName,
  required int errorCount,
  required String dashboardUrl,
}) {
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Scraper Repair In Progress</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f4f4f5; color: #18181b;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f4f4f5;">
    <tr>
      <td align="center" style="padding: 40px 20px;">
        <table role="presentation" width="600" cellspacing="0" cellpadding="0" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

          <!-- Header -->
          <tr>
            <td style="padding: 32px 40px 24px; text-align: center; border-bottom: 1px solid #e4e4e7;">
              <div style="font-size: 28px; font-weight: 700; color: #18181b;">Zen Scrap</div>
            </td>
          </tr>

          <!-- Status Badge -->
          <tr>
            <td style="padding: 32px 40px 16px; text-align: center;">
              <span style="display: inline-block; background-color: #fef3c7; color: #92400e; padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 600;">
                AI Repair In Progress
              </span>
            </td>
          </tr>

          <!-- Main Content -->
          <tr>
            <td style="padding: 16px 40px 24px;">
              <h1 style="margin: 0 0 16px; font-size: 24px; font-weight: 600; color: #18181b; text-align: center;">
                We detected an issue with your scraper
              </h1>
              <p style="margin: 0 0 24px; font-size: 16px; line-height: 1.6; color: #52525b; text-align: center;">
                Your scraper <strong style="color: #18181b;">"$scraperName"</strong> has encountered <strong>$errorCount consecutive errors</strong>. Our AI is already analyzing the issue and working on a fix.
              </p>
            </td>
          </tr>

          <!-- Info Box -->
          <tr>
            <td style="padding: 0 40px 32px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f4f4f5; border-radius: 8px;">
                <tr>
                  <td style="padding: 20px;">
                    <p style="margin: 0 0 8px; font-size: 14px; font-weight: 600; color: #18181b;">What's happening:</p>
                    <ul style="margin: 0; padding-left: 20px; color: #52525b; font-size: 14px; line-height: 1.8;">
                      <li>The AI is browsing the target website to diagnose changes</li>
                      <li>New extraction rules are being generated and tested</li>
                      <li>You'll receive another email once the repair completes</li>
                    </ul>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- CTA -->
          <tr>
            <td style="padding: 0 40px 32px; text-align: center;">
              <a href="$dashboardUrl" style="display: inline-block; background-color: #18181b; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">
                View Repair Status
              </a>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f4f4f5; border-radius: 0 0 12px 12px; text-align: center;">
              <p style="margin: 0; font-size: 13px; color: #71717a;">
                This is an automated notification from Zen Scrap.<br>
                You're receiving this because auto-fix is enabled for this scraper.
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
}

/// Builds the HTML email for when AI auto-fix successfully repairs the scraper.
///
/// Parameters:
/// - [scraperName]: Name of the scrappable that was repaired
/// - [successSummary]: Description of what was fixed
/// - [attemptCount]: Number of attempts it took to fix
/// - [totalTime]: Duration of the repair session (e.g., "2m 34s")
/// - [dashboardUrl]: URL to the scraper dashboard
/// - [settingsUrl]: URL to notification settings
String buildAutoFixSuccessEmail({
  required String scraperName,
  required String successSummary,
  required int attemptCount,
  required String totalTime,
  required String dashboardUrl,
  required String settingsUrl,
}) {
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Scraper Repaired Successfully</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f4f4f5; color: #18181b;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f4f4f5;">
    <tr>
      <td align="center" style="padding: 40px 20px;">
        <table role="presentation" width="600" cellspacing="0" cellpadding="0" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

          <!-- Header -->
          <tr>
            <td style="padding: 32px 40px 24px; text-align: center; border-bottom: 1px solid #e4e4e7;">
              <div style="font-size: 28px; font-weight: 700; color: #18181b;">Zen Scrap</div>
            </td>
          </tr>

          <!-- Status Badge -->
          <tr>
            <td style="padding: 32px 40px 16px; text-align: center;">
              <span style="display: inline-block; background-color: #dcfce7; color: #166534; padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 600;">
                Successfully Repaired
              </span>
            </td>
          </tr>

          <!-- Main Content -->
          <tr>
            <td style="padding: 16px 40px 24px;">
              <h1 style="margin: 0 0 16px; font-size: 24px; font-weight: 600; color: #18181b; text-align: center;">
                Your scraper is back online
              </h1>
              <p style="margin: 0 0 24px; font-size: 16px; line-height: 1.6; color: #52525b; text-align: center;">
                Our AI successfully diagnosed and repaired <strong style="color: #18181b;">"$scraperName"</strong>. Your data extraction is now working again with updated rules.
              </p>
            </td>
          </tr>

          <!-- Success Details Box -->
          <tr>
            <td style="padding: 0 40px 32px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f0fdf4; border-radius: 8px; border: 1px solid #bbf7d0;">
                <tr>
                  <td style="padding: 20px;">
                    <p style="margin: 0 0 8px; font-size: 14px; font-weight: 600; color: #166534;">What was fixed:</p>
                    <p style="margin: 0; color: #15803d; font-size: 14px; line-height: 1.6;">
                      $successSummary
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Stats Row -->
          <tr>
            <td style="padding: 0 40px 32px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="50%" style="padding-right: 8px;">
                    <div style="background-color: #f4f4f5; border-radius: 8px; padding: 16px; text-align: center;">
                      <div style="font-size: 24px; font-weight: 700; color: #18181b;">$attemptCount</div>
                      <div style="font-size: 13px; color: #71717a;">Attempts needed</div>
                    </div>
                  </td>
                  <td width="50%" style="padding-left: 8px;">
                    <div style="background-color: #f4f4f5; border-radius: 8px; padding: 16px; text-align: center;">
                      <div style="font-size: 24px; font-weight: 700; color: #18181b;">$totalTime</div>
                      <div style="font-size: 13px; color: #71717a;">Repair time</div>
                    </div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- CTA -->
          <tr>
            <td style="padding: 0 40px 32px; text-align: center;">
              <a href="$dashboardUrl" style="display: inline-block; background-color: #18181b; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">
                View Scraper Details
              </a>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f4f4f5; border-radius: 0 0 12px 12px; text-align: center;">
              <p style="margin: 0; font-size: 13px; color: #71717a;">
                Zero downtime, zero effort. That's the power of AI auto-fix.<br>
                <a href="$settingsUrl" style="color: #18181b; text-decoration: underline;">Manage notification settings</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
}

/// Builds the HTML email for when AI auto-fix exhausted all attempts.
///
/// Parameters:
/// - [scraperName]: Name of the scrappable that failed to repair
/// - [attemptCount]: Number of attempts made
/// - [failureReason]: The last error message from the failed attempt
/// - [editorUrl]: URL to the scraper editor for manual fix
/// - [supportUrl]: URL to support page
String buildAutoFixExhaustedEmail({
  required String scraperName,
  required int attemptCount,
  required String failureReason,
  required String editorUrl,
  required String supportUrl,
}) {
  // Escape HTML characters in failure reason to prevent XSS
  final escapedFailureReason = _escapeHtml(failureReason);

  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manual Repair Required</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f4f4f5; color: #18181b;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f4f4f5;">
    <tr>
      <td align="center" style="padding: 40px 20px;">
        <table role="presentation" width="600" cellspacing="0" cellpadding="0" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

          <!-- Header -->
          <tr>
            <td style="padding: 32px 40px 24px; text-align: center; border-bottom: 1px solid #e4e4e7;">
              <div style="font-size: 28px; font-weight: 700; color: #18181b;">Zen Scrap</div>
            </td>
          </tr>

          <!-- Status Badge -->
          <tr>
            <td style="padding: 32px 40px 16px; text-align: center;">
              <span style="display: inline-block; background-color: #fee2e2; color: #991b1b; padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 600;">
                Manual Attention Required
              </span>
            </td>
          </tr>

          <!-- Main Content -->
          <tr>
            <td style="padding: 16px 40px 24px;">
              <h1 style="margin: 0 0 16px; font-size: 24px; font-weight: 600; color: #18181b; text-align: center;">
                AI couldn't fix this one automatically
              </h1>
              <p style="margin: 0 0 24px; font-size: 16px; line-height: 1.6; color: #52525b; text-align: center;">
                After <strong>$attemptCount attempts</strong>, our AI was unable to automatically repair <strong style="color: #18181b;">"$scraperName"</strong>. The target website may have undergone significant structural changes.
              </p>
            </td>
          </tr>

          <!-- Error Details Box -->
          <tr>
            <td style="padding: 0 40px 24px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #fef2f2; border-radius: 8px; border: 1px solid #fecaca;">
                <tr>
                  <td style="padding: 20px;">
                    <p style="margin: 0 0 8px; font-size: 14px; font-weight: 600; color: #991b1b;">Last error:</p>
                    <p style="margin: 0; color: #b91c1c; font-size: 14px; line-height: 1.6; font-family: monospace; word-break: break-word;">
                      $escapedFailureReason
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- What to do -->
          <tr>
            <td style="padding: 0 40px 32px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f4f4f5; border-radius: 8px;">
                <tr>
                  <td style="padding: 20px;">
                    <p style="margin: 0 0 8px; font-size: 14px; font-weight: 600; color: #18181b;">What you can do:</p>
                    <ul style="margin: 0; padding-left: 20px; color: #52525b; font-size: 14px; line-height: 1.8;">
                      <li>Open the scraper editor and chat with AI to manually adjust rules</li>
                      <li>Check if the target website structure has fundamentally changed</li>
                      <li>Try creating a new scraper from scratch if the site is very different</li>
                    </ul>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- CTA -->
          <tr>
            <td style="padding: 0 40px 32px; text-align: center;">
              <a href="$editorUrl" style="display: inline-block; background-color: #dc2626; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">
                Fix Manually
              </a>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f4f4f5; border-radius: 0 0 12px 12px; text-align: center;">
              <p style="margin: 0; font-size: 13px; color: #71717a;">
                Auto-fix will remain paused for this scraper until you manually repair it.<br>
                <a href="$supportUrl" style="color: #18181b; text-decoration: underline;">Need help? Contact support</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
}

/// Builds the HTML email for when a scraper is broken but auto-fix is disabled.
///
/// Parameters:
/// - [scraperName]: Name of the broken scrappable
/// - [errorCount]: Number of consecutive errors
/// - [editorUrl]: URL to the scraper editor
/// - [enableAutoFixUrl]: URL to enable auto-fix for this scraper
/// - [settingsUrl]: URL to notification settings
String buildScraperBrokenNoAutoFixEmail({
  required String scraperName,
  required int errorCount,
  required String editorUrl,
  required String enableAutoFixUrl,
  required String settingsUrl,
}) {
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Scraper Failing - Manual Fix Required</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f4f4f5; color: #18181b;">
  <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #f4f4f5;">
    <tr>
      <td align="center" style="padding: 40px 20px;">
        <table role="presentation" width="600" cellspacing="0" cellpadding="0" style="background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

          <!-- Header -->
          <tr>
            <td style="padding: 32px 40px 24px; text-align: center; border-bottom: 1px solid #e4e4e7;">
              <div style="font-size: 28px; font-weight: 700; color: #18181b;">Zen Scrap</div>
            </td>
          </tr>

          <!-- Status Badge -->
          <tr>
            <td style="padding: 32px 40px 16px; text-align: center;">
              <span style="display: inline-block; background-color: #fef3c7; color: #92400e; padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 600;">
                Scraper Down
              </span>
            </td>
          </tr>

          <!-- Main Content -->
          <tr>
            <td style="padding: 16px 40px 24px;">
              <h1 style="margin: 0 0 16px; font-size: 24px; font-weight: 600; color: #18181b; text-align: center;">
                Your scraper needs manual repair
              </h1>
              <p style="margin: 0 0 24px; font-size: 16px; line-height: 1.6; color: #52525b; text-align: center;">
                <strong style="color: #18181b;">"$scraperName"</strong> has failed <strong>$errorCount times in a row</strong>. Since auto-fix is disabled for this scraper, it requires your attention to get back online.
              </p>
            </td>
          </tr>

          <!-- Error Stats -->
          <tr>
            <td style="padding: 0 40px 24px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #fef3c7; border-radius: 8px; border: 1px solid #fde68a;">
                <tr>
                  <td style="padding: 20px; text-align: center;">
                    <div style="font-size: 36px; font-weight: 700; color: #92400e;">$errorCount</div>
                    <div style="font-size: 14px; color: #a16207;">Consecutive failures</div>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Enable Auto-Fix CTA -->
          <tr>
            <td style="padding: 0 40px 16px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #eff6ff; border-radius: 8px; border: 1px solid #bfdbfe;">
                <tr>
                  <td style="padding: 20px;">
                    <p style="margin: 0 0 12px; font-size: 14px; font-weight: 600; color: #1e40af;">Tip: Enable Auto-Fix</p>
                    <p style="margin: 0; color: #1d4ed8; font-size: 14px; line-height: 1.6;">
                      With auto-fix enabled, our AI automatically detects and repairs broken scrapers before you even notice. No more manual maintenance.
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- CTAs -->
          <tr>
            <td style="padding: 24px 40px 32px; text-align: center;">
              <a href="$editorUrl" style="display: inline-block; background-color: #18181b; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px; margin-right: 12px;">
                Fix Now
              </a>
              <a href="$enableAutoFixUrl" style="display: inline-block; background-color: #ffffff; color: #18181b; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px; border: 2px solid #e4e4e7;">
                Enable Auto-Fix
              </a>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f4f4f5; border-radius: 0 0 12px 12px; text-align: center;">
              <p style="margin: 0; font-size: 13px; color: #71717a;">
                You're receiving this because auto-fix is disabled for this scraper.<br>
                <a href="$settingsUrl" style="color: #18181b; text-decoration: underline;">Manage notification settings</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
}

/// Escapes HTML special characters to prevent XSS attacks.
String _escapeHtml(String text) {
  return text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}

/// Email subject line templates.
class AutoFixEmailSubjects {
  /// Subject for when auto-fix repair is in progress.
  static String inProgress(String scraperName) =>
      'Your scraper "$scraperName" needs attention - AI repair in progress';

  /// Subject for when auto-fix successfully repairs the scraper.
  static String success(String scraperName) =>
      'Great news! "$scraperName" has been automatically repaired';

  /// Subject for when auto-fix exhausted all attempts.
  static String exhausted(String scraperName) =>
      'Action required: "$scraperName" needs manual attention';

  /// Subject for when scraper is broken but auto-fix is disabled.
  static String brokenNoAutoFix(String scraperName) =>
      'Alert: "$scraperName" is failing - Manual fix required';
}
