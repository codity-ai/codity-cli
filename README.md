# Codity CLI

Pre-built binaries for the Codity CLI. Download the appropriate archive for your platform from the [Releases](https://github.com/codity-ai/codity-cli/releases) page.

## Quick Install (macOS / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/codity-ai/codity-cli/main/install.sh | sh
```

To install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/codity-ai/codity-cli/main/install.sh | sh -s 0.1.0
```

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
