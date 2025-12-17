#!/bin/bash
# ZenScrap Web Deployment Script
# Builds Flutter web with optimizations and deploys to Serverpod Cloud
#
# Usage: ./scripts/deploy_web.sh
#
# Build optimizations:
#   --wasm              WebAssembly for better performance
#   --release           Production optimizations
#   --tree-shake-icons  Reduces MaterialIcons from ~1.6MB to ~7KB

set -e  # Exit on any error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Google OAuth Client ID for web authentication
# This is the Web application client ID from Google Cloud Console
GOOGLE_SERVER_CLIENT_ID="602145347765-dafncgl6jkbmnc3mf62qk1o0oeic5861.apps.googleusercontent.com"

echo "=== ZenScrap Web Deployment Script ==="
echo "Project root: $PROJECT_ROOT"
echo ""

# Step 1: Navigate to Flutter directory
cd "$PROJECT_ROOT/zenscrap_flutter"
echo "[1/6] Working in: $(pwd)"

# Step 2: Get dependencies
echo ""
echo "[2/6] Getting dependencies..."
flutter pub get

# Step 3: Analyze code
echo ""
echo "[3/6] Running static analysis..."
flutter analyze --no-fatal-infos || {
    echo "WARNING: Static analysis found issues (non-fatal)"
}

# Step 4: Build with all optimizations
echo ""
echo "[4/6] Building with WASM, release mode, and tree-shaking..."
echo "      This may take a few minutes..."
echo "      Google Client ID: $GOOGLE_SERVER_CLIENT_ID"
flutter build web --wasm --release --tree-shake-icons \
  --dart-define=GOOGLE_SERVER_CLIENT_ID="$GOOGLE_SERVER_CLIENT_ID"

# Check build size
echo ""
echo "Build size summary:"
du -sh "$PROJECT_ROOT/zenscrap_flutter/build/web" 2>/dev/null || true

# Step 5: Copy build to server web directory
echo ""
echo "[5/6] Copying build to server..."
cd "$PROJECT_ROOT"
rm -rf zenscrap_server/web/app
cp -r zenscrap_flutter/build/web zenscrap_server/web/app
echo "      Copied to: zenscrap_server/web/app"

# Step 6: Deploy to Serverpod Cloud
echo ""
echo "[6/6] Deploying to Serverpod Cloud..."
cd "$PROJECT_ROOT/zenscrap_server"
scloud deploy

echo ""
echo "=== Deployment initiated! ==="
echo ""
echo "Monitor your deployment:"
echo "  scloud deployment list    - List all deployments"
echo "  scloud deployment show    - Show latest deployment details"
echo "  scloud deployment build-log - View build logs"
echo ""
