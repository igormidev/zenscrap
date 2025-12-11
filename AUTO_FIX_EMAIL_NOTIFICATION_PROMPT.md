# Auto-Fix Email Notification System Implementation

## Task Overview

Implement an email notification system to inform users when their web scrapers break and when AI auto-fix is working to repair them. The system should send contextually appropriate emails based on the scraper's auto-fix configuration and the current status of any repair attempts.

## Key Files to Reference

### Email Infrastructure
- @zenscrap_server/lib/src/auth/send_email.dart - Existing email sending utility using `mailer` package with Hostinger SMTP

### Auto-Fix Entity Models (READ ALL OF THESE)
- @zenscrap_server/lib/src/entities/scrappable/auto_fix/auto_fix_config.spy.yaml - Configuration for auto-fix (enabled, thresholds, in-progress state)
- @zenscrap_server/lib/src/entities/scrappable/auto_fix/auto_fix_session.spy.yaml - Parent model grouping repair attempts
- @zenscrap_server/lib/src/entities/scrappable/auto_fix/auto_fix_session_status.spy.yaml - Session status enum (pending, in_progress, success, failed, exhausted, cancelled)
- @zenscrap_server/lib/src/entities/scrappable/auto_fix/auto_fix_attempt.spy.yaml - Individual repair attempt details
- @zenscrap_server/lib/src/entities/scrappable/auto_fix/auto_fix_attempt_status.spy.yaml - Attempt status enum

### Related Entities
- @zenscrap_server/lib/src/entities/scrappable/scrappable.spy.yaml - Main scrappable entity (has `accountId` relationship)
- @zenscrap_server/lib/src/entities/account/account.spy.yaml - AccountInfo has `userInfo` (from serverpod_auth module which contains user email)

## Critical Business Logic

### AutoFixConfig.enabled
- **If `enabled = true`**: User wants AI to automatically fix broken scrapers. Send emails about repair progress.
- **If `enabled = false`**: User disabled auto-fix. Send a different email type alerting them that their scraper is broken and they need to fix it manually.

### AutoFixConfig Fields to Consider
- `consecutiveErrorThreshold`: Number of errors before auto-fix triggers
- `currentConsecutiveErrors`: Current error count
- `inProgress`: Whether a repair is currently running
- `attemptCount`: Number of failed repair attempts (max 5 before giving up)

## Email Archetypes to Implement

Create a new file `@zenscrap_server/lib/src/notifications/auto_fix_email_templates.dart` with HTML email templates and a service file `@zenscrap_server/lib/src/notifications/auto_fix_notification_service.dart` to orchestrate sending.

---

### EMAIL 1: Scraper Broken - Auto-Fix IN PROGRESS

**Trigger:** When `AutoFixSession` is created with `status = in_progress` and `AutoFixConfig.enabled = true`

**Subject:** Your scraper "{scraperName}" needs attention - AI repair in progress

**HTML Body:**
```html
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
                ⚡ AI Repair In Progress
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
                Your scraper <strong style="color: #18181b;">"{scraperName}"</strong> has encountered <strong>{errorCount} consecutive errors</strong>. Our AI is already analyzing the issue and working on a fix.
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
              <a href="{dashboardUrl}" style="display: inline-block; background-color: #18181b; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">
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
```

---

### EMAIL 2: Scraper SUCCESSFULLY Fixed by AI

**Trigger:** When `AutoFixSession.status` changes to `success`

**Subject:** Great news! "{scraperName}" has been automatically repaired

**HTML Body:**
```html
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
                ✓ Successfully Repaired
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
                Our AI successfully diagnosed and repaired <strong style="color: #18181b;">"{scraperName}"</strong>. Your data extraction is now working again with updated rules.
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
                      {successSummary}
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
                      <div style="font-size: 24px; font-weight: 700; color: #18181b;">{attemptCount}</div>
                      <div style="font-size: 13px; color: #71717a;">Attempts needed</div>
                    </div>
                  </td>
                  <td width="50%" style="padding-left: 8px;">
                    <div style="background-color: #f4f4f5; border-radius: 8px; padding: 16px; text-align: center;">
                      <div style="font-size: 24px; font-weight: 700; color: #18181b;">{totalTime}</div>
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
              <a href="{dashboardUrl}" style="display: inline-block; background-color: #18181b; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">
                View Scraper Details
              </a>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f4f4f5; border-radius: 0 0 12px 12px; text-align: center;">
              <p style="margin: 0; font-size: 13px; color: #71717a;">
                Zero downtime, zero effort. That's the power of AI auto-fix.<br>
                <a href="{settingsUrl}" style="color: #18181b; text-decoration: underline;">Manage notification settings</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

---

### EMAIL 3: Auto-Fix FAILED (Exhausted All Attempts)

**Trigger:** When `AutoFixSession.status` changes to `exhausted` (all 5 attempts failed)

**Subject:** Action required: "{scraperName}" needs manual attention

**HTML Body:**
```html
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
                ⚠ Manual Attention Required
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
                After <strong>{attemptCount} attempts</strong>, our AI was unable to automatically repair <strong style="color: #18181b;">"{scraperName}"</strong>. The target website may have undergone significant structural changes.
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
                    <p style="margin: 0; color: #b91c1c; font-size: 14px; line-height: 1.6; font-family: monospace;">
                      {failureReason}
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
              <a href="{editorUrl}" style="display: inline-block; background-color: #dc2626; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px;">
                Fix Manually
              </a>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f4f4f5; border-radius: 0 0 12px 12px; text-align: center;">
              <p style="margin: 0; font-size: 13px; color: #71717a;">
                Auto-fix will remain paused for this scraper until you manually repair it.<br>
                <a href="{supportUrl}" style="color: #18181b; text-decoration: underline;">Need help? Contact support</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

---

### EMAIL 4: Scraper Broken - AUTO-FIX DISABLED (User must fix manually)

**Trigger:** When scraper breaks (`currentConsecutiveErrors >= consecutiveErrorThreshold`) AND `AutoFixConfig.enabled = false`

**Subject:** Alert: "{scraperName}" is failing - Manual fix required

**HTML Body:**
```html
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
                ⚠ Scraper Down
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
                <strong style="color: #18181b;">"{scraperName}"</strong> has failed <strong>{errorCount} times in a row</strong>. Since auto-fix is disabled for this scraper, it requires your attention to get back online.
              </p>
            </td>
          </tr>

          <!-- Error Stats -->
          <tr>
            <td style="padding: 0 40px 24px;">
              <table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="background-color: #fef3c7; border-radius: 8px; border: 1px solid #fde68a;">
                <tr>
                  <td style="padding: 20px; text-align: center;">
                    <div style="font-size: 36px; font-weight: 700; color: #92400e;">{errorCount}</div>
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
                    <p style="margin: 0 0 12px; font-size: 14px; font-weight: 600; color: #1e40af;">💡 Tip: Enable Auto-Fix</p>
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
              <a href="{editorUrl}" style="display: inline-block; background-color: #18181b; color: #ffffff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px; margin-right: 12px;">
                Fix Now
              </a>
              <a href="{enableAutoFixUrl}" style="display: inline-block; background-color: #ffffff; color: #18181b; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 16px; border: 2px solid #e4e4e7;">
                Enable Auto-Fix
              </a>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f4f4f5; border-radius: 0 0 12px 12px; text-align: center;">
              <p style="margin: 0; font-size: 13px; color: #71717a;">
                You're receiving this because auto-fix is disabled for this scraper.<br>
                <a href="{settingsUrl}" style="color: #18181b; text-decoration: underline;">Manage notification settings</a>
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>
```

---

## Implementation Guide

### Step 1: Create Email Templates File

Create `@zenscrap_server/lib/src/notifications/auto_fix_email_templates.dart`:

```dart
// Contains all HTML email templates as functions that accept parameters
// and return formatted HTML strings.
//
// Functions to implement:
// - buildAutoFixInProgressEmail({scraperName, errorCount, dashboardUrl})
// - buildAutoFixSuccessEmail({scraperName, successSummary, attemptCount, totalTime, dashboardUrl, settingsUrl})
// - buildAutoFixExhaustedEmail({scraperName, attemptCount, failureReason, editorUrl, supportUrl})
// - buildScraperBrokenNoAutoFixEmail({scraperName, errorCount, editorUrl, enableAutoFixUrl, settingsUrl})
```

### Step 2: Create Notification Service

Create `@zenscrap_server/lib/src/notifications/auto_fix_notification_service.dart`:

```dart
// Service class that:
// 1. Gets the user's email from Scrappable -> AccountInfo -> UserInfo
// 2. Determines which email template to use based on AutoFixConfig.enabled and session status
// 3. Calls sendEmail() from send_email.dart
//
// Key methods:
// - notifyAutoFixStarted(Session session, Scrappable scrappable, AutoFixSession autoFixSession)
// - notifyAutoFixCompleted(Session session, Scrappable scrappable, AutoFixSession autoFixSession)
// - notifyScraperBroken(Session session, Scrappable scrappable) // When auto-fix is disabled
```

### Step 3: Integration Points

Call the notification service at these points:

1. **When AutoFixSession is created** (status = in_progress):
   - Check `AutoFixConfig.enabled`
   - If true: Send "AI Repair In Progress" email
   - If false: Send "Scraper Broken - Manual Fix Required" email

2. **When AutoFixSession completes** (status changes):
   - `success`: Send "Successfully Repaired" email
   - `exhausted`: Send "Manual Attention Required" email

### Step 4: Getting User Email

```dart
// To get the user's email:
// 1. Load Scrappable with accountId
// 2. Load AccountInfo with userInfoId
// 3. UserInfo (from serverpod_auth module) has the email field

final accountInfo = await AccountInfo.db.findById(session, scrappable.accountId!);
final userInfo = await UserInfo.db.findById(session, accountInfo!.userInfoId!);
final email = userInfo!.email;
```

### Step 5: URL Generation

Create helper functions to generate dashboard URLs:

```dart
// Base URL should come from environment/config
const baseUrl = 'https://app.zenscrap.com';

String getDashboardUrl(int scrappableId) => '$baseUrl/dashboard/scrapers/$scrappableId';
String getEditorUrl(int scrappableId) => '$baseUrl/editor/$scrappableId';
String getSettingsUrl() => '$baseUrl/settings/notifications';
String getEnableAutoFixUrl(int scrappableId) => '$baseUrl/dashboard/scrapers/$scrappableId/settings';
String getSupportUrl() => '$baseUrl/support';
```

## Template Variables Reference

| Variable | Description | Used In |
|----------|-------------|---------|
| `{scraperName}` | Name of the Scrappable | All emails |
| `{errorCount}` | Number of consecutive errors | Email 1, 4 |
| `{dashboardUrl}` | URL to scraper dashboard | Email 1, 2 |
| `{successSummary}` | AI's description of what was fixed | Email 2 |
| `{attemptCount}` | Number of repair attempts | Email 2, 3 |
| `{totalTime}` | Duration of repair session | Email 2 |
| `{settingsUrl}` | URL to notification settings | Email 2, 4 |
| `{failureReason}` | Last error message from failed attempt | Email 3 |
| `{editorUrl}` | URL to scraper editor for manual fix | Email 3, 4 |
| `{supportUrl}` | URL to support page | Email 3 |
| `{enableAutoFixUrl}` | URL to enable auto-fix | Email 4 |

## Email Subject Lines Summary

1. **In Progress**: `Your scraper "{name}" needs attention - AI repair in progress`
2. **Success**: `Great news! "{name}" has been automatically repaired`
3. **Exhausted**: `Action required: "{name}" needs manual attention`
4. **Disabled**: `Alert: "{name}" is failing - Manual fix required`

## Testing Checklist

- [ ] Verify email renders correctly in Gmail, Outlook, Apple Mail
- [ ] Test with long scraper names (truncation/wrapping)
- [ ] Verify all URLs are correct and clickable
- [ ] Test dark mode email rendering
- [ ] Confirm emails don't land in spam (check SPF/DKIM for zenscrap.com domain)
- [ ] Test with very long error messages in {failureReason}

## Future Enhancements (Out of Scope)

- Email notification preferences per user (opt-out for certain email types)
- Digest emails (batch multiple scraper issues into one email)
- Slack/Discord integration
- SMS for critical failures
