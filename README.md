# Codity CLI Releases

Pre-built binaries for the Codity CLI. Download the appropriate archive for your platform from the [Releases](https://github.com/codity-ai/codity-cli/releases) page.

## Platforms

| OS | Architecture | File |
|----|-------------|------|
| macOS | Apple Silicon (arm64) | `codity_*_darwin_arm64.tar.gz` |
| macOS | Intel (amd64) | `codity_*_darwin_amd64.tar.gz` |
| Linux | amd64 | `codity_*_linux_amd64.tar.gz` |
| Linux | arm64 | `codity_*_linux_arm64.tar.gz` |
| Windows | amd64 | `codity_*_windows_amd64.zip` |
| Windows | arm64 | `codity_*_windows_arm64.zip` |

## Install

```bash
# macOS / Linux
curl -fsSL https://github.com/codity-ai/codity-cli/releases/latest/download/codity_<version>_<os>_<arch>.tar.gz | tar -xz
sudo mv codity /usr/local/bin/
```
