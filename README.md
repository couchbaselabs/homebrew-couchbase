# Couchbase C++ Client Homebrew Tap

This is the official Homebrew tap for [`couchbase-cxx-client`](https://github.com/couchbase/couchbase-cxx-client).

## Installation

```bash
brew tap couchbaselabs/homebrew-couchbase
brew install couchbase-cxx-client
```

## Precompiled Binary Bottles

This tap automatically builds and publishes precompiled binary bottles hosted on [GitHub Container Registry (GHCR)](https://ghcr.io) for fast installation without local compilation.

### Supported Platforms

| OS Version | Architecture | GitHub Runner |
| :--- | :--- | :--- |
| **macOS 14 (Sonoma)** | Apple Silicon (`arm64`) | `macos-14` |
| **macOS 15 (Sequoia)** | Apple Silicon (`arm64`) | `macos-15` |

## Automated CI/CD Workflows

The repository uses GitHub Actions to automate formula testing and bottle generation:

1. **`Brew Test & Build Bottles` (`.github/workflows/tests.yml`)**:
   - Triggers on pushes, pull requests, and manual triggers.
   - Runs `brew test-bot` across all supported macOS platforms (`macos-14`, `macos-15`).
   - Validates formula syntax, compiles the formula, and uploads bottle artifacts.

2. **`Publish Bottles` (`.github/workflows/publish.yml`)**:
   - Triggers when a Pull Request is labeled with `pr-pull` or when tests complete on the default branch.
   - Pushes compiled bottle images to GHCR (`ghcr.io/couchbaselabs/couchbase/couchbase-cxx-client`).
   - Automatically commits the updated formula with the new `bottle do ... end` SHA256 checksum block.

### GitHub Repository Setup Checklist

To enable automated bottle publishing:

1. **Actions Permissions**: Go to **Settings -> Actions -> General -> Workflow permissions**, select **Read and write permissions**, and check **Allow GitHub Actions to create and approve pull requests**.
2. **Package Visibility**: Under Organization/User **Packages -> couchbase -> Package Settings**, ensure the package visibility is set to **Public**.
