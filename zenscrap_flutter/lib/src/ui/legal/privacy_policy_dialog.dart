import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Shows the Privacy Policy dialog.
void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const PrivacyPolicyDialog(),
  );
}

/// Dialog displaying the full Privacy Policy for ZenScrap.
class PrivacyPolicyDialog extends StatelessWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.c.primaryContainer.withAlpha(50),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_rounded,
                    color: context.c.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: context.t.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.c.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last updated: December 2025',
                          style: context.t.bodySmall?.copyWith(
                            color: context.c.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: SelectableText.rich(
                  TextSpan(
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.onSurface,
                      height: 1.7,
                    ),
                    children: _buildPrivacyContent(context),
                  ),
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: context.c.outline.withAlpha(30)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('I Understand'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildPrivacyContent(BuildContext context) {
    final headerStyle = context.t.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: context.c.onSurface,
      height: 2.5,
    );

    final subHeaderStyle = context.t.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: context.c.onSurface,
      height: 2.2,
    );

    final bodyStyle = context.t.bodyMedium?.copyWith(
      color: context.c.onSurface,
      height: 1.7,
    );

    return [
      TextSpan(
        text: 'Your Privacy Matters\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'At ZenScrap, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our AI-powered web scraping platform.\n\n',
        style: bodyStyle,
      ),

      // 1. Information We Collect
      TextSpan(
        text: '1. Information We Collect\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '1.1 Information You Provide:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Account Information: Name, email address, and password when you create an account.\n'
            '• Profile Information: Any additional information you choose to add to your profile.\n'
            '• Payment Information: Billing address and payment details (processed securely through Stripe).\n'
            '• Communications: Messages, feedback, and support requests you send to us.\n'
            '• Scrappable Configurations: The scraping rules and configurations you create using our platform.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '1.2 Information Collected Automatically:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Device Information: Browser type, operating system, device identifiers, and screen resolution.\n'
            '• Usage Data: Pages visited, features used, API calls made, and time spent on the platform.\n'
            '• Log Data: IP address, access times, referring URLs, and error logs.\n'
            '• Cookies: We use cookies to maintain sessions and remember your preferences.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '1.3 Information We Do NOT Collect:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Scraped Content: We do not permanently store the data you extract using our scrapers.\n'
            '• Target Website Credentials: We never ask for or store login credentials for the websites you scrape.\n'
            '• Sensitive Personal Data: We do not intentionally collect sensitive categories of personal data.\n\n',
        style: bodyStyle,
      ),

      // 2. How We Use Your Information
      TextSpan(
        text: '2. How We Use Your Information\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '2.1 Service Delivery:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Provide, maintain, and improve our web scraping platform.\n'
            '• Process your scraping requests and deliver extracted data.\n'
            '• Manage your account and subscription.\n'
            '• Process payments and prevent fraud.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '2.2 Communication:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Send you important service updates and security alerts.\n'
            '• Respond to your inquiries and provide customer support.\n'
            '• Send promotional communications (with your consent).\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '2.3 Service Improvement:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Analyze usage patterns to improve our AI algorithms and features.\n'
            '• Monitor and optimize platform performance.\n'
            '• Develop new features and services.\n\n',
        style: bodyStyle,
      ),

      // 3. Information Sharing
      TextSpan(
        text: '3. Information Sharing and Disclosure\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'We do not sell your personal information. We may share your information with:\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '3.1 Service Providers:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Stripe: Payment processing and billing management.\n'
            '• Cloud Infrastructure: Hosting and data storage services.\n'
            '• Analytics Providers: Usage analytics and performance monitoring.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '3.2 Legal Requirements:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'We may disclose your information if required by law, court order, or government request, or to protect the rights, property, or safety of ZenScrap, our users, or others.\n\n',
        style: bodyStyle,
      ),

      // 4. Data Security
      TextSpan(
        text: '4. Data Security\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'We implement appropriate technical and organizational measures to protect your personal information:\n\n'
            '• Encryption: All data is encrypted in transit using TLS/SSL and at rest.\n'
            '• Access Controls: Strict access controls limit who can access your data.\n'
            '• Secure Infrastructure: Our servers are hosted in secure, SOC 2 compliant data centers.\n'
            '• API Key Security: Your API keys are hashed and stored securely.\n\n'
            'While we strive to protect your information, no method of transmission or storage is 100% secure.\n\n',
        style: bodyStyle,
      ),

      // 5. Data Retention
      TextSpan(
        text: '5. Data Retention\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            '• Account Data: Retained while your account is active and for a reasonable period thereafter.\n'
            '• Usage Data: Retained for up to 24 months for analytics and service improvement.\n'
            '• Payment Records: Retained as required by tax and accounting laws.\n'
            '• Scraped Data: Not retained beyond the immediate delivery to you.\n\n'
            'Upon account deletion, we will delete or anonymize your personal information within 30 days.\n\n',
        style: bodyStyle,
      ),

      // 6. Your Rights
      TextSpan(
        text: '6. Your Rights and Choices\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '6.1 Access and Portability: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You can request a copy of the personal information we hold about you.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '6.2 Correction: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You can update or correct your account information through your account settings.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '6.3 Deletion: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You can request deletion of your account and associated personal information.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '6.4 Opt-Out: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You can opt out of promotional communications by clicking the unsubscribe link in our emails.\n\n',
        style: bodyStyle,
      ),

      // 7. International Transfers
      TextSpan(
        text: '7. International Data Transfers\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'Your information may be transferred to and processed in countries other than your country of residence. We ensure appropriate safeguards are in place for such transfers, including Standard Contractual Clauses.\n\n',
        style: bodyStyle,
      ),

      // 8. Children's Privacy
      TextSpan(
        text: '8. Children\'s Privacy\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'Our Service is not intended for individuals under 18 years of age. We do not knowingly collect personal information from children.\n\n',
        style: bodyStyle,
      ),

      // 9. Changes
      TextSpan(
        text: '9. Changes to This Policy\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'We may update this Privacy Policy from time to time. We will notify you of material changes by posting the updated policy on our website and/or sending you an email notification.\n\n',
        style: bodyStyle,
      ),

      // 10. GDPR and CCPA
      TextSpan(
        text: '10. Additional Rights for Specific Jurisdictions\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: 'European Union (GDPR):\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Right to object to processing based on legitimate interests.\n'
            '• Right to restrict processing in certain circumstances.\n'
            '• Right to lodge a complaint with a supervisory authority.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: 'California (CCPA):\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Right to know what personal information is collected, used, and disclosed.\n'
            '• Right to delete personal information (subject to exceptions).\n'
            '• Right to opt-out of the sale of personal information (we do not sell personal information).\n'
            '• Right to non-discrimination for exercising your privacy rights.\n\n',
        style: bodyStyle,
      ),

      // 11. Contact
      TextSpan(
        text: '11. Contact Us\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'If you have any questions about this Privacy Policy or our data practices, please contact us through our in-app support channels.\n\n'
            'By using ZenScrap, you acknowledge that you have read and understood this Privacy Policy and agree to our collection, use, and disclosure of your information as described herein.\n',
        style: bodyStyle,
      ),
    ];
  }
}

