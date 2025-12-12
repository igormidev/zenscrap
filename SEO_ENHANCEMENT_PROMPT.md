# SEO Enhancement Master Prompt for Claude Code

> **IMPORTANT**: Use Opus 4.5 model (`--model opus`) and ultrathink (`--ultrathink`) for ALL tasks in this prompt.

## Overview

This prompt orchestrates a comprehensive SEO enhancement for ZenScrap, a SaaS web scraping tool. You will act as a **conductor**, spawning separate Claude Code instances for each major task to ensure focused, high-quality execution without context degradation.

## Architecture

You (the main Claude Code instance) should:
1. Run **ONE task at a time** (sequentially, not in parallel)
2. For each task, spawn a **new Claude Code instance** using the Task tool with `model: "opus"`
3. Wait for each instance to complete before starting the next
4. Verify changes are committed before proceeding to the next task

## Project Structure Reference

Key files and directories:
- **Flutter App**: `@zenscrap_flutter/`
  - Landing Page: `@zenscrap_flutter/lib/src/ui/landing_page/landing_page.dart`
  - Landing Sections: `@zenscrap_flutter/lib/src/ui/landing_page/sections/`
  - Auth View: `@zenscrap_flutter/lib/src/ui/auth/views/auth_view.dart`
  - Router: `@zenscrap_flutter/lib/src/providers/go_router_providers.dart`
  - Web Index: `@zenscrap_flutter/web/index.html`
  - Localization Config: `@zenscrap_flutter/l10n.yaml`
  - Pubspec: `@zenscrap_flutter/pubspec.yaml`
- **Server**: `@zenscrap_server/`
  - Web Routes: `@zenscrap_server/lib/src/web/routes/root.dart`
  - Web App Location: `@zenscrap_server/web/app/`
- **Scripts**: `@scripts/build_flutter_web` (old deploy script - delete after creating new one)

## Routes Overview

From `@zenscrap_flutter/lib/src/providers/go_router_providers.dart`:
- `/splash` - Splash screen (loading)
- `/scrappable-form` - Landing page (public, no auth required)
- `/auth` - Authentication page (public)
- All other routes require authentication

---

## Task 1: robots.txt and sitemap.xml Implementation

**Spawn a new Claude Code instance with this prompt:**

```
You are an SEO expert Claude Code instance. Your task is to implement outstanding robots.txt and sitemap.xml files for a Flutter web SaaS application hosted on Serverpod Cloud.

## CRITICAL: Use ultrathink mode and Opus 4.5 model for maximum quality.

## Your Mission

1. **FIRST: Research Phase** (use WebSearch and WebFetch extensively)
   - Search for "best practices robots.txt 2024 2025"
   - Search for "sitemap.xml best practices SaaS"
   - Search for "robots.txt for single page applications"
   - Search for "sitemap.xml Flutter web app"
   - Search for "Google SEO robots.txt recommendations"
   - Search for "AI crawlers robots.txt GPTBot ClaudeBot"
   - Read at least 5-7 authoritative sources and synthesize the best practices

2. **Understanding the Site Structure**
   - Read `@zenscrap_flutter/lib/src/providers/go_router_providers.dart` to understand all routes
   - The site has these PUBLIC pages (no auth required):
     - `/` or `/scrappable-form` - Landing page
     - `/auth` - Authentication page
   - All other pages require login and should NOT be indexed

3. **Implementation**

   Create `@zenscrap_flutter/web/robots.txt` with:
   - Proper User-agent directives for major search engines
   - AI crawlers handling (GPTBot, ClaudeBot, etc.) - decide based on your research if we should allow or block them
   - Disallow rules for authenticated-only routes
   - Sitemap reference
   - Crawl-delay considerations

   Create `@zenscrap_flutter/web/sitemap.xml` with:
   - XML sitemap format with proper namespace
   - Only include publicly accessible pages:
     - Main landing page (priority 1.0)
     - Auth page (priority 0.5)
   - Proper lastmod, changefreq, and priority attributes
   - Consider using the actual production URL (check if there's a domain configured)

4. **Server Integration**
   - Check `@zenscrap_server/lib/src/web/routes/root.dart` and related files
   - Ensure the server will serve these static files from the web directory
   - You may need to configure Serverpod to serve robots.txt and sitemap.xml at root

5. **Verification**
   - Run `flutter analyze` in `@zenscrap_flutter/` to ensure no analysis errors
   - The files should be valid XML/text format

## Deliverables
- `@zenscrap_flutter/web/robots.txt`
- `@zenscrap_flutter/web/sitemap.xml`
- Any necessary server configuration changes

## After Completion
1. Run `cd zenscrap_flutter && flutter analyze` to ensure no static analysis errors
2. Commit your changes with a descriptive message
3. Report what you implemented and any recommendations
```

---

## Task 2: SEO Package Implementation

**Spawn a new Claude Code instance with this prompt:**

```
You are a Flutter SEO specialist Claude Code instance. Your task is to add and configure the "seo" package (version ^0.0.10) for a Flutter web SaaS application.

## CRITICAL: Use ultrathink mode and Opus 4.5 model for maximum quality.

## Your Mission

1. **FIRST: Extensive Research Phase** (use WebSearch and WebFetch heavily)
   - Search for "Flutter seo package 0.0.10 tutorial"
   - Search for "Flutter seo package examples"
   - Search for "Flutter web SEO meta tags best practices"
   - Search for "seo package Flutter implementation guide"
   - Search for "Flutter web Open Graph meta tags"
   - Search for "Flutter web Twitter card meta tags"
   - Search for "structured data Flutter web SEO"
   - Look for GitHub issues, discussions, and real-world implementations
   - Read the package documentation thoroughly
   - Find at least 5 examples of people using this package

2. **Understanding the Codebase**
   - Read `@zenscrap_flutter/pubspec.yaml` for current dependencies
   - Read `@zenscrap_flutter/lib/src/ui/landing_page/landing_page.dart` - main SEO target
   - Read `@zenscrap_flutter/lib/src/ui/auth/views/auth_view.dart` - secondary SEO target
   - Read `@zenscrap_flutter/web/index.html` for current meta tags setup
   - Understand the app's value proposition from landing page content

3. **Add the Package**
   ```yaml
   # Add to pubspec.yaml dependencies
   seo: ^0.0.10
   ```
   Run `flutter pub get` in zenscrap_flutter directory

4. **Implement SEO on Landing Page** (`@zenscrap_flutter/lib/src/ui/landing_page/landing_page.dart`)
   - Add comprehensive meta tags:
     - Title: Dynamic, keyword-rich title
     - Description: Compelling description with target keywords
     - Keywords: Relevant keywords for web scraping, API, automation
     - Open Graph tags (og:title, og:description, og:image, og:url, og:type)
     - Twitter Card tags (twitter:card, twitter:title, twitter:description, twitter:image)
     - Canonical URL
     - Robots meta (index, follow)
   - Consider structured data (JSON-LD) for:
     - Organization
     - SoftwareApplication
     - WebPage

5. **Implement SEO on Auth Page** (`@zenscrap_flutter/lib/src/ui/auth/views/auth_view.dart`)
   - Add appropriate meta tags for login/signup page
   - Lower priority than landing page but still important

6. **Update index.html** if needed (`@zenscrap_flutter/web/index.html`)
   - Current title is "zenscrap_flutter" - this needs to be updated!
   - Add fallback meta tags
   - Ensure proper charset and viewport
   - Add any missing critical meta tags

7. **Best Practices to Implement**
   - Unique titles and descriptions per page
   - Proper heading hierarchy
   - Alt text for images (if applicable)
   - Canonical URLs to prevent duplicate content

## Key Files to Modify
- `@zenscrap_flutter/pubspec.yaml` - add seo package
- `@zenscrap_flutter/lib/src/ui/landing_page/landing_page.dart` - main SEO implementation
- `@zenscrap_flutter/lib/src/ui/auth/views/auth_view.dart` - auth page SEO
- `@zenscrap_flutter/web/index.html` - fallback meta tags and title

## After Completion
1. Run `cd zenscrap_flutter && flutter pub get`
2. Run `cd zenscrap_flutter && flutter analyze` to ensure no static analysis errors
3. Commit your changes with a descriptive message
4. Report what you implemented and the SEO improvements made
```

---

## Task 3: Minimize Dependencies (Unused Dependency Check)

**Spawn a new Claude Code instance with this prompt:**

```
You are a Flutter optimization specialist Claude Code instance. Your task is to identify and remove unused dependencies to improve build size and SEO performance (faster sites rank better).

## CRITICAL: Use ultrathink mode and Opus 4.5 model for maximum quality.

## Your Mission

1. **Analyze Dependencies**
   - Run: `cd zenscrap_flutter && flutter pub deps --no-dev`
   - Read `@zenscrap_flutter/pubspec.yaml` to see all direct dependencies
   - Document the dependency tree

2. **Check Each Dependency Usage**
   For each dependency in pubspec.yaml, search the codebase:
   - Use Grep to find imports: `import 'package:<dependency_name>`
   - Check if the dependency is actually used in any Dart files
   - Document which dependencies appear unused

3. **Dependencies to Verify** (from pubspec.yaml):
   - flutter_native_splash
   - dio
   - collection
   - dart_debouncer
   - pricing_page
   - package_info_plus
   - shared_preferences
   - simple_platform
   - adaptive_dialog
   - url_launcher
   - result_dart
   - go_router
   - riverpod / flutter_riverpod
   - enchanted_collection
   - form_builder_validators
   - form_validator
   - babel_text
   - lottie
   - flutter_animate
   - synchronized
   - flutter_json_view
   - fl_chart
   - posthog_flutter
   - talker / talker_flutter / talker_riverpod_logger
   - serverpod_flutter and auth packages
   - cupertino_icons
   - enchanted_regex
   - freezed_annotation
   - json_annotation
   - intl

4. **Safety Checks**
   - Do NOT remove any serverpod-related packages
   - Do NOT remove packages that are used in dev_dependencies for code generation (freezed, build_runner, etc.)
   - Be conservative - if unsure, keep the dependency
   - Some packages might be used indirectly

5. **Report Findings**
   - List all potentially unused dependencies
   - For each, explain why you think it's unused
   - Recommend which ones to remove (with caution)

6. **Remove Confirmed Unused Dependencies**
   - Edit `@zenscrap_flutter/pubspec.yaml`
   - Run `flutter pub get`
   - Verify the app still builds: `flutter build web --wasm`

## Key Files
- `@zenscrap_flutter/pubspec.yaml`
- All Dart files in `@zenscrap_flutter/lib/`

## After Completion
1. Run `cd zenscrap_flutter && flutter pub get`
2. Run `cd zenscrap_flutter && flutter analyze`
3. Commit changes if any dependencies were removed
4. Report your findings and actions taken
```

---

## Task 4: Deferred Localization Loading

**Spawn a new Claude Code instance with this prompt:**

```
You are a Flutter performance specialist Claude Code instance. Your task is to implement deferred localization loading to reduce initial bundle size (better performance = better SEO ranking).

## CRITICAL: Use ultrathink mode and Opus 4.5 model for maximum quality.

## Background
Deferring the loading of localization strings can cut the app's initial JavaScript bundle size in half. This improves First Contentful Paint (FCP) and Largest Contentful Paint (LCP), which are Core Web Vitals that affect SEO.

## Your Mission

1. **Research Phase**
   - Search for "Flutter deferred loading localization"
   - Search for "Flutter l10n.yaml use-deferred-loading"
   - Search for "Flutter web performance localization"
   - Understand how deferred loading works in Flutter

2. **Current Configuration**
   - Read `@zenscrap_flutter/l10n.yaml`
   - Read localization files in `@zenscrap_flutter/lib/l10n/`
   - Understand current localization setup

3. **Implementation**
   - Edit `@zenscrap_flutter/l10n.yaml` to add:
     ```yaml
     use-deferred-loading: true
     ```
   - Run `flutter gen-l10n` to regenerate localization files
   - Update any imports if needed

4. **Verify Changes**
   - Ensure generated localization files reflect deferred loading
   - The generated code should use `deferred as` imports
   - Test that the app still works with localization

## Key Files
- `@zenscrap_flutter/l10n.yaml` - add use-deferred-loading: true
- `@zenscrap_flutter/lib/l10n/` - generated files will be updated

## After Completion
1. Run `cd zenscrap_flutter && flutter gen-l10n`
2. Run `cd zenscrap_flutter && flutter analyze`
3. Commit your changes
4. Report the expected performance improvement
```

---

## Task 5: HTML Splash Screen Enhancement

**Spawn a new Claude Code instance with this prompt:**

```
You are a UI/UX and performance specialist Claude Code instance. Your task is to create a beautiful, Material 3-styled HTML splash screen that displays while Flutter loads.

## CRITICAL: Use ultrathink mode and Opus 4.5 model for maximum quality.

## Why This Matters
- Users see the splash screen immediately while Flutter/WASM loads
- A polished splash screen improves perceived performance
- Better UX leads to lower bounce rates = better SEO signals

## Your Mission

1. **EXTENSIVE Research Phase** (DO NOT BE LAZY - look at many examples!)
   - Search for "Flutter web loading screen beautiful examples"
   - Search for "Flutter web splash screen HTML CSS best practices"
   - Search for "Material Design 3 loading animation CSS"
   - Search for "Flutter web index.html splash screen examples github"
   - Search for "best Flutter web loading experiences"
   - Search for "CSS loading animation Material Design"
   - Look at at least 10 different examples and implementations
   - Take inspiration from the best ones

2. **Understand Current Implementation**
   - Read `@zenscrap_flutter/web/index.html` carefully
   - Note the current splash screen implementation
   - Note the color scheme: #607D8B (Blue-grey)
   - Check splash images in `@zenscrap_flutter/web/splash/img/`

3. **Design Requirements**
   - Keep Material 3 design language
   - Use the existing color scheme (#607D8B) or enhance it
   - Create a smooth, professional loading experience
   - Include:
     - Centered logo (use existing splash images)
     - Elegant loading indicator (CSS animation, not JS)
     - Optional: Progress indication
     - Smooth transition when Flutter is ready
   - Must work with both light and dark modes
   - Must be lightweight (no external dependencies)

4. **Implementation in `@zenscrap_flutter/web/index.html`**
   - Enhance the existing splash screen HTML/CSS
   - Add CSS animations for loading indicator
   - Ensure proper removal when Flutter loads (flutter-first-frame event)
   - Consider adding a subtle animation to the logo
   - Add graceful fade-out transition

5. **Testing**
   - Build with WASM: `cd zenscrap_flutter && flutter build web --wasm`
   - Serve locally and test the splash screen experience
   - Verify it works on both Chrome and Firefox
   - Ensure the transition to Flutter app is smooth

## Key File
- `@zenscrap_flutter/web/index.html` - main file to enhance

## After Completion
1. Run `cd zenscrap_flutter && flutter build web --wasm`
2. Run `cd zenscrap_flutter && flutter analyze`
3. Test by running the web app locally
4. Commit your changes
5. Describe the visual improvements you made
```

---

## Task 6: Asset Preloading

**Spawn a new Claude Code instance with this prompt:**

```
You are a web performance specialist Claude Code instance. Your task is to implement asset preloading in index.html to improve loading performance.

## CRITICAL: Use ultrathink mode and Opus 4.5 model for maximum quality.

## Why This Matters
Preloading critical assets allows the browser to fetch them in parallel at the beginning of page load, making them ready immediately when Flutter needs them.

## Your Mission

1. **Research Phase**
   - Search for "HTML preload link best practices"
   - Search for "Flutter web asset preloading"
   - Search for "preload fonts web performance"
   - Search for "preload WASM files"
   - Understand the difference between preload, prefetch, and preconnect

2. **Identify Critical Assets**
   - After building with WASM, check `@zenscrap_flutter/build/web/` for:
     - main.dart.wasm
     - main.dart.mjs (or .js)
     - skwasm.wasm (or skwasm_heavy.wasm)
     - skwasm.js
     - Critical fonts
     - Logo/splash images
   - Also check `@zenscrap_server/web/app/` for currently deployed assets

3. **Implementation in `@zenscrap_flutter/web/index.html`**

   Add preload links in the <head> section:
   ```html
   <!-- WASM files -->
   <link rel="preload" href="main.dart.wasm" as="fetch" crossorigin>
   <link rel="preload" href="canvaskit/skwasm.wasm" as="fetch" crossorigin>

   <!-- JavaScript modules -->
   <link rel="modulepreload" href="main.dart.mjs">

   <!-- Fonts (if custom fonts are used) -->
   <link rel="preload" href="assets/fonts/..." as="font" type="font/ttf" crossorigin>

   <!-- Critical images -->
   <link rel="preload" href="splash/img/light-1x.png" as="image">
   ```

4. **Preconnect to External Domains**
   - Check what external domains are used (Lottie, analytics, etc.)
   - Add preconnect for those domains:
   ```html
   <link rel="preconnect" href="https://lottie.host">
   <link rel="preconnect" href="https://us.i.posthog.com">
   ```

5. **Verification**
   - Build with WASM to see exact file names: `flutter build web --wasm`
   - Check the build/web/ directory for actual filenames
   - Update preload paths to match actual build output

## Important Notes
- File names may vary between builds - use the actual generated names
- Only preload truly critical assets to avoid wasting bandwidth
- Test in Chrome DevTools Network tab to verify preloading works

## Key File
- `@zenscrap_flutter/web/index.html`

## After Completion
1. Run `cd zenscrap_flutter && flutter build web --wasm`
2. Check build/web/ for actual file names and update preloads
3. Run `cd zenscrap_flutter && flutter analyze`
4. Commit your changes
5. Report what assets you're preloading and why
```

---

## Task 7: Deploy with WASM and Tree Shaking

**Spawn a new Claude Code instance with this prompt:**

```
You are a deployment specialist Claude Code instance. Your task is to create a production deployment script and deploy the app to Serverpod Cloud with all optimizations.

## CRITICAL: Use ultrathink mode and Opus 4.5 model for maximum quality.

## MANDATORY: Use Serverpod MCP
Before doing anything, ask the Serverpod MCP tool how to deploy with Serverpod 3. The deployment process changed significantly in Serverpod 3.

Use: `mcp__serverpod__ask-docs` with question: "How do I deploy my Flutter web app with Serverpod Cloud in Serverpod 3?"

Also check the deployment guide:
Use: `mcp__serverpod__get-guide` with the deployment guide URI

And fetch the official documentation:
Use: WebFetch on "https://docs.serverpod.cloud/guides/deployment/deploying-your-application"

## Your Mission

1. **Research Serverpod 3 Deployment**
   - Use Serverpod MCP to understand the NEW deployment process
   - Read official documentation
   - Understand how web apps are served in Serverpod 3

2. **Build Optimizations**
   The build command should include:
   ```bash
   flutter build web --wasm --release --tree-shake-icons
   ```

   This enables:
   - **WASM**: WebAssembly for better performance
   - **Release**: Production optimizations
   - **Tree-shake-icons**: Reduces MaterialIcons from 1.6MB to ~7KB

3. **Tree Shaking Verification**
   - Ensure NO dynamic icons are used in the codebase
   - Search for patterns like `IconData(` which would break tree-shaking
   - All icons should be const: `const Icon(Icons.home)`

4. **Create Deploy Script**
   Create `@scripts/deploy_web.sh`:
   ```bash
   #!/bin/bash
   set -e  # Exit on error

   echo "=== ZenScrap Web Deployment Script ==="

   # Step 1: Navigate to Flutter directory
   cd zenscrap_flutter

   # Step 2: Get dependencies
   echo "Getting dependencies..."
   flutter pub get

   # Step 3: Analyze code
   echo "Running static analysis..."
   flutter analyze

   # Step 4: Build with all optimizations
   echo "Building with WASM and tree-shaking..."
   flutter build web --wasm --release --tree-shake-icons

   # Step 5: Copy build to server web directory
   echo "Copying build to server..."
   cd ..
   rm -rf zenscrap_server/web/app
   cp -r zenscrap_flutter/build/web zenscrap_server/web/app

   # Step 6: Deploy to Serverpod Cloud
   echo "Deploying to Serverpod Cloud..."
   scloud deploy

   echo "=== Deployment initiated! ==="
   echo "Run 'scloud deployment list' to check status"
   ```

5. **Execute Deployment**
   - Run the build steps
   - Deploy using `scloud deploy`
   - Wait for deployment (check every 5 minutes, up to 4 times)
   - Use `scloud deployment list` to verify status

6. **Post-Deploy Verification**
   - Open the deployed site in browser
   - Check browser console for errors
   - If errors exist, note them for a follow-up fix

7. **Cleanup**
   - Delete the old script: `@scripts/build_flutter_web`

## Key Files
- Create: `@scripts/deploy_web.sh`
- Delete: `@scripts/build_flutter_web`
- `@zenscrap_flutter/` - Flutter app to build
- `@zenscrap_server/web/app/` - destination for build files

## After Completion
1. Ensure deployment is successful
2. Make the script executable: `chmod +x scripts/deploy_web.sh`
3. Commit the new deploy script
4. Report deployment status and any issues found
```

---

## Execution Instructions for Main Claude Instance

Execute these tasks **ONE AT A TIME** in order:

```
For each task:

1. Spawn a new Claude Code instance using Task tool:
   - Set model: "opus"
   - Include the full prompt from above
   - Add instruction to "ultrathink" at the start

2. Wait for the instance to complete

3. Verify the instance:
   - Ran static analysis (flutter analyze)
   - Committed changes
   - Reported results

4. Only then proceed to the next task

Example Task tool usage:
{
  "subagent_type": "general-purpose",
  "model": "opus",
  "prompt": "<paste the task prompt here>",
  "description": "Task N: <task name>"
}
```

## Order of Execution

1. **Task 1**: robots.txt and sitemap.xml
2. **Task 2**: SEO Package Implementation
3. **Task 3**: Minimize Dependencies
4. **Task 4**: Deferred Localization Loading
5. **Task 5**: HTML Splash Screen Enhancement
6. **Task 6**: Asset Preloading
7. **Task 7**: Deploy with WASM and Tree Shaking

## Final Checklist

After all tasks complete, verify:
- [ ] robots.txt exists and is valid
- [ ] sitemap.xml exists and is valid
- [ ] SEO package is implemented on landing page
- [ ] No unused dependencies (or documented why kept)
- [ ] Deferred localization loading enabled
- [ ] HTML splash screen is beautiful and functional
- [ ] Asset preloading configured
- [ ] Deploy script created at `@scripts/deploy_web.sh`
- [ ] Old deploy script deleted
- [ ] Site is deployed with WASM
- [ ] No console errors on deployed site

## Notes

- Each task is context-heavy and requires extensive web research
- Spawning separate instances prevents context degradation
- Always use Opus 4.5 and ultrathink for best results
- Commit after each task to preserve progress
- If a task fails, fix it before proceeding
