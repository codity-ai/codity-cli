#!/bin/sh
set -e

DOWNLOAD_BASE_URL="${CODITY_RELEASES_URL:-https://github.com/codity-ai/codity-cli/releases/download}"
LATEST_URL="${CODITY_LATEST_URL:-https://github.com/codity-ai/codity-cli/releases/latest}"
INSTALL_DIR="${CODITY_INSTALL_DIR:-/usr/local/bin}"
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
if [ -n "${1:-}" ]; then
    VERSION="$1"
else
    LATEST_EFFECTIVE_URL=$(curl -fsSL -o /dev/null -w '%{url_effective}' "$LATEST_URL")
    case "$LATEST_EFFECTIVE_URL" in
        */releases/tag/v*) VERSION=${LATEST_EFFECTIVE_URL##*/tag/} ;;
        *) echo "Error: could not determine latest release tag"; exit 1 ;;
    esac
    if [ -z "$VERSION" ]; then
        echo "Error: could not determine latest version"
        exit 1
    fi
fi
VERSION=${VERSION#v}
case "$VERSION" in
    ''|*[!0-9A-Za-z.+-]*) echo "Error: invalid release version"; exit 1 ;;
esac
DOWNLOAD_BASE_URL=${DOWNLOAD_BASE_URL%/}

ARCHIVE="codity_${VERSION}_${OS}_${ARCH}.tar.gz"
URL="${DOWNLOAD_BASE_URL}/v${VERSION}/${ARCHIVE}"

echo "Installing codity v${VERSION} (${OS}/${ARCH})..."

# Download and extract
INSTALL_TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$INSTALL_TEMP_DIR"' EXIT

curl -fsSL "$URL" -o "${INSTALL_TEMP_DIR}/${ARCHIVE}"
curl -fsSL "${DOWNLOAD_BASE_URL}/v${VERSION}/checksums.txt" -o "${INSTALL_TEMP_DIR}/checksums.txt"
EXPECTED=$(awk -v archive="$ARCHIVE" '$2 == archive {print $1}' "${INSTALL_TEMP_DIR}/checksums.txt")
if [ "${#EXPECTED}" -ne 64 ]; then
    echo "Error: release checksum is missing or invalid"
    exit 1
fi
if command -v sha256sum >/dev/null 2>&1; then
    ACTUAL=$(sha256sum "${INSTALL_TEMP_DIR}/${ARCHIVE}" | awk '{print $1}')
else
    ACTUAL=$(shasum -a 256 "${INSTALL_TEMP_DIR}/${ARCHIVE}" | awk '{print $1}')
fi
if [ "$ACTUAL" != "$EXPECTED" ]; then
    echo "Error: release checksum verification failed"
    exit 1
fi
tar -xzf "${INSTALL_TEMP_DIR}/${ARCHIVE}" -C "$INSTALL_TEMP_DIR" "$BINARY_NAME"
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi

# Install binary
if [ -w "$INSTALL_DIR" ]; then
    mv "${INSTALL_TEMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
    echo "Installing to ${INSTALL_DIR} (requires sudo)..."
    sudo mv "${INSTALL_TEMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi

chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

echo "codity v${VERSION} installed to ${INSTALL_DIR}/${BINARY_NAME}"
echo ""
echo "Run 'codity login' to get started."
