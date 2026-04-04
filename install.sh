#!/bin/sh
set -e

GITHUB_REPO="codity-ai/codity-cli"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="codity"

# Detect OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    arm64)   ARCH="arm64" ;;
    *)
        echo "Error: unsupported architecture: $ARCH"
        exit 1
        ;;
esac

case "$OS" in
    linux|darwin) ;;
    *)
        echo "Error: unsupported OS: $OS"
        exit 1
        ;;
esac

# Determine version to install
if [ -n "$1" ]; then
    VERSION="$1"
else
    VERSION=$(curl -fsSL -o /dev/null -w '%{redirect_url}' "https://github.com/${GITHUB_REPO}/releases/latest" | grep -oE '[^/]+$' | sed 's/^v//')
    if [ -z "$VERSION" ]; then
        echo "Error: could not determine latest version"
        exit 1
    fi
fi

ARCHIVE="codity_${VERSION}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/${ARCHIVE}"

echo "Installing codity v${VERSION} (${OS}/${ARCH})..."

# Download and extract
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

curl -fsSL "$URL" -o "${TMPDIR}/${ARCHIVE}"
tar -xzf "${TMPDIR}/${ARCHIVE}" -C "$TMPDIR"

# Install binary
if [ -w "$INSTALL_DIR" ]; then
    mv "${TMPDIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
    echo "Installing to ${INSTALL_DIR} (requires sudo)..."
    sudo mv "${TMPDIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi

chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

echo "codity v${VERSION} installed to ${INSTALL_DIR}/${BINARY_NAME}"
echo ""
echo "Run 'codity login' to get started."
