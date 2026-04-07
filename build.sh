#!/bin/bash

set -e

APP_NAME="hex2077-agent"
PKG_ID="cloud.lazycat.app.hex2077"
IMAGE="ghcr.io/justlovemaki/hex2077-agent:latest"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if icon exists
check_icon() {
    if [ ! -f "icon.png" ]; then
        log_warn "icon.png not found!"
        log_info "Please add a 512x512 PNG icon for your application"
        return 1
    fi
    return 0
}

# Show app info
show_info() {
    log_info "Application Information:"
    echo "  Package ID: $PKG_ID"
    echo "  App Name: Hex2077 Agent"
    echo "  Image: $IMAGE"
    echo ""

    if check_icon; then
        log_info "Icon: OK"
    else
        log_warn "Icon: Missing (please add icon.png)"
    fi
}

# Build the app
build_app() {
    log_info "Building application..."

    if ! check_icon; then
        log_error "Cannot build without icon.png"
        exit 1
    fi

    # Generate version from date
    VERSION=$(date +"%Y.%m.%d")

    # Update version in package.yml
    sed -i.bak "s/^version: .*/version: $VERSION/" package.yml && rm -f package.yml.bak

    OUTPUT="${APP_NAME}-${VERSION}.lpk"

    lzc-cli project build -o "$OUTPUT"

    log_info "Build successful: $OUTPUT"
}

# Copy image to Lazycat registry
copy_image() {
    log_info "Copying image to Lazycat registry..."

    # Check login status
    if ! lzc-cli appstore my-images &>/dev/null; then
        log_error "Not logged in to Lazycat AppStore"
        log_info "Please run: lzc-cli appstore login"
        exit 1
    fi

    lzc-cli appstore copy-image "$IMAGE"

    log_info "Image copied successfully"
    log_warn "Remember to update lzc-manifest.yml with the new image URL"
}

# Publish app
publish_app() {
    log_info "Publishing application..."

    # Find latest lpk file
    LPK_FILE=$(ls -t *.lpk 2>/dev/null | head -1)

    if [ -z "$LPK_FILE" ]; then
        log_error "No .lpk file found. Please build first."
        exit 1
    fi

    log_info "Publishing: $LPK_FILE"
    lzc-cli appstore publish "$LPK_FILE"

    log_info "Publish successful!"
}

# One-click build and publish
one_click() {
    log_info "Starting one-click build and publish..."

    # Check login first
    if ! lzc-cli appstore my-images &>/dev/null; then
        log_error "Not logged in to Lazycat AppStore"
        log_info "Please run: lzc-cli appstore login"
        exit 1
    fi

    build_app
    copy_image
    publish_app

    log_info "One-click process completed!"
}

# Main
 case "${1:-info}" in
    info)
        show_info
        ;;
    build)
        build_app
        ;;
    copy)
        copy_image
        ;;
    publish)
        publish_app
        ;;
    one-click)
        one_click
        ;;
    *)
        echo "Usage: $0 {info|build|copy|publish|one-click}"
        echo ""
        echo "Commands:"
        echo "  info       - Show application information"
        echo "  build      - Build the LPK package"
        echo "  copy       - Copy Docker image to Lazycat registry"
        echo "  publish    - Publish app to Lazycat AppStore"
        echo "  one-click  - Run build, copy, and publish in sequence"
        exit 1
        ;;
esac
