# Codity CLI

Pre-built binaries for the Codity CLI. Download the appropriate archive for your platform from the [Releases](https://github.com/codity-ai/codity-cli/releases) page.

## Quick Install (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/codity-ai/codity-cli/main/install.sh | sh
```

To install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/codity-ai/codity-cli/main/install.sh | sh -s -- v2.5.0
```

The installer verifies the archive against the release's `checksums.txt` before installation.
For an installation without sudo, download the script and select a writable directory:

```bash
curl -fsSL https://raw.githubusercontent.com/codity-ai/codity-cli/main/install.sh -o /tmp/codity-install.sh
CODITY_INSTALL_DIR="$HOME/.local/bin" sh /tmp/codity-install.sh
```

Ensure the selected directory is on your `PATH`. Existing installations can use `codity update`.
Explicit versions accept either `2.5.0` or `v2.5.0`. Prereleases require an explicit version.

## Manual Install

1. Download the archive for your platform from [Releases](https://github.com/codity-ai/codity-cli/releases)
2. Extract and move to your PATH:

```bash
# macOS / Linux
tar -xzf codity_*_*.tar.gz
sudo mv codity /usr/local/bin/
```

```powershell
# Windows
Expand-Archive codity_*_windows_*.zip -DestinationPath .
Move-Item codity.exe C:\Windows\System32\
```

3. Verify:

```bash
codity --version
```

## Platforms

| OS | Architecture | File |
|----|-------------|------|
| macOS | Apple Silicon (arm64) | `codity_*_darwin_arm64.tar.gz` |
| macOS | Intel (amd64) | `codity_*_darwin_amd64.tar.gz` |
| Linux | amd64 | `codity_*_linux_amd64.tar.gz` |
| Linux | arm64 | `codity_*_linux_arm64.tar.gz` |
| Windows | amd64 | `codity_*_windows_amd64.zip` |
| Windows | arm64 | `codity_*_windows_arm64.zip` |

## Getting Started

```bash
codity login
codity review --staged
```


## Source and releases

CLI source lives in [codity-forge](https://github.com/codity-ai/codity-forge).
This repository distributes the installer and release archives. Forge's `v*` tag workflow
builds all six platforms and publishes here using the `CLI_RELEASE_TOKEN` repository secret
with Contents write access to `codity-ai/codity-cli`. Its automatic `GITHUB_TOKEN` is scoped
to Forge and cannot publish this repository's releases. S3 upload also requires the
workflow's AWS credentials and `CLI_RELEASES_S3_BUCKET` variable.

A GitHub Release tag in this repository identifies the distribution repository, not the
Forge source tree. Record the exact Forge source commit in every release's notes.
Prerelease binaries remain versioned and do not replace the stable S3 `latest` pointer.
The separately hosted ingress managed CLI is built from Forge using its own manifest;
publishing a GitHub release here does not update that manifest.
