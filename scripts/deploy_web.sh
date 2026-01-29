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

# Cleanup function to restore original state after deployment
cleanup() {
    echo ""
    echo "Cleaning up deployment files..."
    # Remove the copied zenscrap_core from server directory
    rm -rf "$PROJECT_ROOT/zenscrap_server/packages/zenscrap_core"
    # Restore original pubspec.yaml
    if [ -f "$PROJECT_ROOT/zenscrap_server/pubspec.yaml.bak" ]; then
        mv "$PROJECT_ROOT/zenscrap_server/pubspec.yaml.bak" "$PROJECT_ROOT/zenscrap_server/pubspec.yaml"
    fi
    echo "Cleanup complete."
}

# Set up trap to ensure cleanup runs on exit (success or failure)
trap cleanup EXIT

# Step 1: Generate Serverpod code
echo "[1/10] Generating Serverpod code..."
cd "$PROJECT_ROOT/zenscrap_server"
serverpod generate

# Step 2: Prepare zenscrap_core for deployment
# Serverpod Cloud only uploads the server directory, so we need to include
# the shared package inside the server directory for the Docker build
echo ""
echo "[2/10] Preparing zenscrap_core for deployment..."
mkdir -p "$PROJECT_ROOT/zenscrap_server/packages"
rm -rf "$PROJECT_ROOT/zenscrap_server/packages/zenscrap_core"
cp -r "$PROJECT_ROOT/zenscrap_core" "$PROJECT_ROOT/zenscrap_server/packages/zenscrap_core"
echo "      Copied zenscrap_core to: zenscrap_server/packages/zenscrap_core"

# Step 3: Update pubspec.yaml to use local path for deployment
echo ""
echo "[3/10] Updating pubspec.yaml for deployment..."
cp "$PROJECT_ROOT/zenscrap_server/pubspec.yaml" "$PROJECT_ROOT/zenscrap_server/pubspec.yaml.bak"
sed -i '' 's|path: \.\./zenscrap_core|path: packages/zenscrap_core|g' "$PROJECT_ROOT/zenscrap_server/pubspec.yaml"
echo "      Updated path dependency for zenscrap_core"

# Step 4: Navigate to Flutter directory
echo ""
cd "$PROJECT_ROOT/zenscrap_flutter"
echo "[4/10] Working in: $(pwd)"

# Step 5: Get dependencies
echo ""
echo "[5/10] Getting dependencies..."
flutter pub get

# Step 6: Analyze code
echo ""
echo "[6/10] Running static analysis..."
flutter analyze --no-fatal-infos || {
    echo "WARNING: Static analysis found issues (non-fatal)"
}

# Step 7: Build with all optimizations
echo ""
echo "[7/10] Building with WASM, release mode, and tree-shaking..."
echo "      This may take a few minutes..."
echo "      Google Client ID: $GOOGLE_SERVER_CLIENT_ID"
flutter build web --wasm --release --tree-shake-icons \
  --dart-define=GOOGLE_SERVER_CLIENT_ID="$GOOGLE_SERVER_CLIENT_ID"

# Check build size
echo ""
echo "Build size summary:"
du -sh "$PROJECT_ROOT/zenscrap_flutter/build/web" 2>/dev/null || true

# Step 8: Copy build to server web directory
echo ""
echo "[8/10] Copying build to server..."
cd "$PROJECT_ROOT"
rm -rf zenscrap_server/web/app
cp -r zenscrap_flutter/build/web zenscrap_server/web/app
echo "      Copied to: zenscrap_server/web/app"

# Step 9: Create migrations
echo ""
echo "[9/10] Creating migrations..."
cd "$PROJECT_ROOT/zenscrap_server"
serverpod create-migration --force

# Step 10: Deploy to Serverpod Cloud
echo ""
echo "[10/10] Deploying to Serverpod Cloud..."
scloud deploy

echo ""
echo "=== Deployment initiated! ==="
echo ""
echo "Monitor your deployment:"
echo "  scloud deployment list    - List all deployments"
echo "  scloud deployment show    - Show latest deployment details"
echo "  scloud deployment build-log - View build logs"
echo ""
