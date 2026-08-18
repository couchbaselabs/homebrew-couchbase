# Maintainer & CI/CD Guide

This document covers repository maintenance, CI/CD workflow architecture, and GitHub repository configuration for `couchbaselabs/homebrew-couchbase`.

## Automated CI/CD Workflows

The repository uses GitHub Actions to automate formula testing, bottle compilation, and publishing:

### 1. `Brew Test & Build Bottles` (`.github/workflows/tests.yml`)
- **Triggers**: Pushes to `master`/`main`, pull requests, and manual triggers (`workflow_dispatch`).
- **Runners**: `macos-14` (macOS 14 Sonoma, Apple Silicon) and `macos-15` (macOS 15 Sequoia, Apple Silicon).
- **Behavior**:
  - Runs `brew test-bot` across all supported macOS platforms.
  - Validates formula syntax (`--only-tap-syntax`).
  - Compiles the formula into binary bottles (`--only-formulae`).
  - Uploads compiled bottle archives as workflow artifacts (`bottles_*`).

### 2. `Publish Bottles` (`.github/workflows/publish.yml`)
- **Triggers**:
  - Pull Requests labeled with `pr-pull`.
  - Automatically via `workflow_run` when `Brew Test & Build Bottles` completes on `master`/`main`.
  - Manual triggers (`workflow_dispatch`).
- **Behavior**:
  - Downloads built bottle artifacts from the test run.
  - Publishes binary bottle layers to GHCR (`ghcr.io/v2/couchbaselabs/couchbase`) via `brew pr-upload --warn-on-upload-failure`.
  - Automatically updates `Formula/couchbase-cxx-client.rb` with the new `bottle do ... end` checksum block and pushes to `master`.

---

## GitHub Repository Setup Checklist

To ensure automated bottle building and publishing functions correctly:

1. **Actions Permissions**:
   - Navigate to **Settings -> Actions -> General -> Workflow permissions**.
   - Select **Read and write permissions**.
   - Check **Allow GitHub Actions to create and approve pull requests**.

2. **Package Visibility**:
   - Navigate to Organization **Packages -> couchbase -> Package Settings** ([Packages Page](https://github.com/orgs/couchbaselabs/packages)).
   - Ensure the package visibility is set to **Public** so Homebrew users can download bottles without authentication.

---

## Security & Token Scoping

- Workflows use GitHub Actions standard short-lived OIDC tokens (`GITHUB_TOKEN`) with strictly scoped permissions (`contents: write`, `packages: write`, `pull-requests: write`).
- No long-lived credentials, personal access tokens, or filesystem secret files are used.
