import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Shows the Terms of Service dialog.
void showTermsOfServiceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const TermsOfServiceDialog(),
  );
}

/// Dialog displaying the full Terms of Service for ZenScrap.
class TermsOfServiceDialog extends StatelessWidget {
  const TermsOfServiceDialog({super.key});

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
                    Icons.gavel_rounded,
                    color: context.c.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms of Service',
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
                    children: _buildTermsContent(context),
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

  List<TextSpan> _buildTermsContent(BuildContext context) {
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
        text: 'Welcome to ZenScrap\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'These Terms of Service ("Terms") govern your access to and use of ZenScrap\'s AI-powered web scraping platform, including our website, APIs, and related services (collectively, the "Service"). By accessing or using our Service, you agree to be bound by these Terms. If you do not agree to these Terms, you may not use the Service.\n\n',
        style: bodyStyle,
      ),

      // 1. Service Description
      TextSpan(
        text: '1. Service Description\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'ZenScrap provides an AI-powered platform that enables users to create, deploy, and manage automated web scrapers ("Scrappables"). Our Service includes:\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '• ',
        style: bodyStyle,
      ),
      TextSpan(
        text: 'AI-Assisted Scraper Creation: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Natural language interface to describe data extraction requirements, with AI generating the appropriate scraping logic.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '• ',
        style: bodyStyle,
      ),
      TextSpan(
        text: 'Self-Healing Technology: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Automatic detection and repair of scrapers when target websites change their structure.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '• ',
        style: bodyStyle,
      ),
      TextSpan(
        text: 'API Access: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'RESTful API endpoints for programmatic access to your deployed scrapers.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '• ',
        style: bodyStyle,
      ),
      TextSpan(
        text: 'Marketplace: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Community-driven repository of pre-built scrapers that users can browse, test, and clone.\n\n',
        style: bodyStyle,
      ),

      // 2. Account Registration
      TextSpan(
        text: '2. Account Registration and Eligibility\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '2.1 Eligibility: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You must be at least 18 years old and capable of forming a binding contract to use the Service. By registering, you represent that you meet these requirements.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '2.2 Account Security: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You are responsible for maintaining the confidentiality of your account credentials and API keys. You must immediately notify us of any unauthorized access or security breach. ZenScrap is not liable for any loss arising from unauthorized use of your account.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '2.3 Accurate Information: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You agree to provide accurate, current, and complete information during registration and to update such information as necessary.\n\n',
        style: bodyStyle,
      ),

      // 3. Acceptable Use Policy
      TextSpan(
        text: '3. Acceptable Use Policy\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'You agree to use the Service only for lawful purposes and in accordance with these Terms. Specifically, you agree NOT to:\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '3.1 Prohibited Data Collection:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Scrape personal data or personally identifiable information (PII) including names, email addresses, phone numbers, physical addresses, social security numbers, or any data that could identify a specific individual, without explicit consent from the data subjects.\n'
            '• Access or extract data that is protected behind login walls, paywalls, or other access controls without proper authorization.\n'
            '• Collect sensitive personal data including health information, financial data, biometric data, or data revealing racial/ethnic origin, political opinions, religious beliefs, or sexual orientation.\n'
            '• Scrape content that is protected by copyright, trademark, or other intellectual property rights without proper authorization.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '3.2 Prohibited Activities:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            '• Use the Service to violate any applicable laws, regulations, or third-party rights, including but not limited to GDPR, CCPA, CFAA, or similar data protection and computer access laws.\n'
            '• Circumvent, disable, or interfere with security-related features of target websites, including CAPTCHA systems, rate limiting, or access controls.\n'
            '• Use the Service in a manner that could damage, disable, overburden, or impair target websites or their servers.\n'
            '• Attempt to gain unauthorized access to any computer system, network, or data.\n'
            '• Use the Service for competitive intelligence gathering on ZenScrap or its affiliates.\n'
            '• Redistribute, resell, or sublicense the Service without prior written consent.\n'
            '• Use the Service to engage in any form of harassment, spam, or fraudulent activity.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '3.3 Your Responsibility:\n',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You are solely responsible for ensuring that your use of the Service complies with:\n'
            '• The terms of service, robots.txt directives, and any other published policies of the websites you scrape.\n'
            '• All applicable laws and regulations in your jurisdiction and the jurisdiction of the target websites.\n'
            '• Any consent requirements for data collection under applicable privacy laws.\n\n',
        style: bodyStyle,
      ),

      // 4. User Data and Responsibility
      TextSpan(
        text: '4. User Data and Responsibility\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '4.1 Your Data: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You retain ownership of any data you extract using the Service ("User Data"). ZenScrap does not claim ownership over User Data.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '4.2 Authorization Warranty: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'By using the Service to access third-party websites, you represent and warrant that you have the necessary rights, permissions, and authority to access such websites and extract the data you request. You acknowledge that you are using ZenScrap as a tool to facilitate your own data extraction activities.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '4.3 Data Handling: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'ZenScrap processes your scraping requests and temporarily handles extracted data to deliver it to you. We do not permanently store the content you scrape unless required for service functionality (such as caching for performance optimization).\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '4.4 Compliance: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You are solely responsible for how you use, store, process, and distribute User Data. You must comply with all applicable data protection laws and regulations.\n\n',
        style: bodyStyle,
      ),

      // 5. Intellectual Property
      TextSpan(
        text: '5. Intellectual Property\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '5.1 ZenScrap IP: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'The Service, including its original content, features, functionality, and underlying technology, is owned by ZenScrap and protected by copyright, trademark, and other intellectual property laws.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '5.2 Your Scrappables: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Scrappables you create remain your property. By publishing a Scrappable to the Marketplace, you grant ZenScrap and other users a non-exclusive license to use, clone, and modify that Scrappable within the platform.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '5.3 Feedback: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Any feedback, suggestions, or ideas you provide regarding the Service may be used by ZenScrap without any obligation to compensate you.\n\n',
        style: bodyStyle,
      ),

      // 6. Payment and Billing
      TextSpan(
        text: '6. Payment and Billing\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '6.1 Subscription Plans: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Access to certain features requires a paid subscription. Plan details, pricing, and included credits are described on our pricing page.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '6.2 Billing Cycle: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Subscriptions are billed in advance on a monthly or annual basis, depending on your selected plan. Your subscription will automatically renew unless cancelled before the renewal date.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '6.3 Credits: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'API usage and AI features are metered using credits. Credit usage depends on the complexity of scraping operations, including factors like JavaScript rendering, proxy usage, and geo-targeting.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '6.4 Refunds: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Subscription fees are generally non-refundable except as required by applicable law. Unused credits do not roll over to the next billing period unless specified in your plan.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '6.5 Price Changes: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'ZenScrap reserves the right to modify pricing with 30 days\' advance notice. Continued use after the effective date constitutes acceptance of the new pricing.\n\n',
        style: bodyStyle,
      ),

      // 7. Service Availability
      TextSpan(
        text: '7. Service Availability and Modifications\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '7.1 Availability: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'We strive to maintain high availability but do not guarantee uninterrupted access. The Service may be temporarily unavailable for maintenance, updates, or due to factors beyond our control.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '7.2 Modifications: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'ZenScrap reserves the right to modify, suspend, or discontinue any aspect of the Service at any time. We will provide reasonable notice for material changes that affect your use.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '7.3 Third-Party Dependencies: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'The Service depends on third-party websites remaining accessible and maintaining consistent structures. We cannot guarantee that scrapers will work indefinitely, as target websites may change or block access.\n\n',
        style: bodyStyle,
      ),

      // 8. Disclaimer of Warranties
      TextSpan(
        text: '8. Disclaimer of Warranties\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'THE SERVICE IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, AND ACCURACY OF DATA.\n\n'
            'ZENSCRAP DOES NOT WARRANT THAT:\n'
            '• The Service will meet your specific requirements.\n'
            '• The Service will be uninterrupted, timely, secure, or error-free.\n'
            '• Scrapers will function correctly with all target websites.\n'
            '• Data extracted will be accurate, complete, or suitable for any particular purpose.\n'
            '• The auto-fix feature will successfully repair all broken scrapers.\n\n',
        style: bodyStyle,
      ),

      // 9. Limitation of Liability
      TextSpan(
        text: '9. Limitation of Liability\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'TO THE MAXIMUM EXTENT PERMITTED BY LAW, ZENSCRAP AND ITS OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS SHALL NOT BE LIABLE FOR:\n\n'
            '• Any indirect, incidental, special, consequential, or punitive damages.\n'
            '• Loss of profits, data, business opportunities, or goodwill.\n'
            '• Any damages arising from your use of scraped data.\n'
            '• Any claims by third parties related to your use of the Service.\n'
            '• Actions taken by target websites, including blocking, legal action, or terms of service enforcement.\n\n'
            'IN NO EVENT SHALL ZENSCRAP\'S TOTAL LIABILITY EXCEED THE AMOUNT YOU PAID TO ZENSCRAP IN THE TWELVE (12) MONTHS PRECEDING THE CLAIM.\n\n',
        style: bodyStyle,
      ),

      // 10. Indemnification
      TextSpan(
        text: '10. Indemnification\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'You agree to indemnify, defend, and hold harmless ZenScrap and its officers, directors, employees, contractors, and agents from and against any claims, liabilities, damages, losses, costs, and expenses (including reasonable attorneys\' fees) arising out of or related to:\n\n'
            '• Your use of the Service.\n'
            '• Your violation of these Terms.\n'
            '• Your violation of any rights of third parties.\n'
            '• Your violation of any applicable laws or regulations.\n'
            '• Data you collect, process, or distribute using the Service.\n'
            '• Any content you submit to the Marketplace.\n\n',
        style: bodyStyle,
      ),

      // 11. Termination
      TextSpan(
        text: '11. Termination\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '11.1 By You: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You may terminate your account at any time through your account settings or by contacting support. Termination does not entitle you to refunds of prepaid fees.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '11.2 By ZenScrap: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'We may suspend or terminate your access immediately, without notice, if we believe you have violated these Terms, engaged in fraudulent activity, or posed a risk to other users or our Service.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '11.3 Effect of Termination: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Upon termination, your right to use the Service ceases immediately. We may delete your account data, including Scrappables and API keys, after a reasonable retention period.\n\n',
        style: bodyStyle,
      ),

      // 12. Privacy
      TextSpan(
        text: '12. Privacy\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'Your privacy is important to us. Our collection and use of personal information is described in our Privacy Policy, which is incorporated into these Terms by reference. By using the Service, you consent to our data practices as described in the Privacy Policy.\n\n',
        style: bodyStyle,
      ),

      // 13. Governing Law
      TextSpan(
        text: '13. Governing Law and Dispute Resolution\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '13.1 Governing Law: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction where ZenScrap is incorporated, without regard to conflict of law principles.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '13.2 Dispute Resolution: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Any disputes arising from these Terms or your use of the Service shall first be attempted to be resolved through good-faith negotiation. If negotiation fails, disputes shall be resolved through binding arbitration in accordance with applicable arbitration rules.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '13.3 Class Action Waiver: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You agree to resolve any disputes on an individual basis and waive any right to participate in class action lawsuits or class-wide arbitration.\n\n',
        style: bodyStyle,
      ),

      // 14. Changes to Terms
      TextSpan(
        text: '14. Changes to Terms\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'ZenScrap reserves the right to modify these Terms at any time. We will notify you of material changes by posting the updated Terms on our website and/or sending you an email notification. Your continued use of the Service after such modifications constitutes acceptance of the updated Terms.\n\n',
        style: bodyStyle,
      ),

      // 15. General Provisions
      TextSpan(
        text: '15. General Provisions\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text: '15.1 Entire Agreement: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'These Terms, together with our Privacy Policy, constitute the entire agreement between you and ZenScrap regarding the Service.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '15.2 Severability: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'If any provision of these Terms is found unenforceable, the remaining provisions shall continue in full force and effect.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '15.3 Waiver: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'Failure to enforce any provision of these Terms shall not constitute a waiver of that provision or any other provision.\n\n',
        style: bodyStyle,
      ),
      TextSpan(
        text: '15.4 Assignment: ',
        style: subHeaderStyle,
      ),
      TextSpan(
        text:
            'You may not assign or transfer your rights under these Terms without our prior written consent. ZenScrap may assign its rights and obligations without restriction.\n\n',
        style: bodyStyle,
      ),

      // 16. Contact Information
      TextSpan(
        text: '16. Contact Information\n\n',
        style: headerStyle,
      ),
      TextSpan(
        text:
            'If you have questions about these Terms or need to report a violation, please contact us through our support channels available in the application.\n\n'
            'By using ZenScrap, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.\n',
        style: bodyStyle,
      ),
    ];
  }
}

/// A clickable text widget that opens the Terms of Service dialog.
class TermsOfServiceLink extends StatelessWidget {
  /// Optional custom text for the link.
  final String? text;

  /// Optional custom text style.
  final TextStyle? style;

  const TermsOfServiceLink({
    super.key,
    this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => showTermsOfServiceDialog(context),
        child: Text(
          text ?? 'Terms of Service',
          style: style ??
              context.t.bodySmall?.copyWith(
                color: context.c.onSurfaceVariant,
                decoration: TextDecoration.underline,
                decorationColor: context.c.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
