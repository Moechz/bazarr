# Changelog

All notable user-visible changes to the Bazarr TOS application package.

## 1.6.2-6 — 2026-11-18

### Changed
- `help` in `config.ini` now opens the privacy policy, so the App Center entry reaches it
  directly (review items C3/C5).
- Image refreshed to `linuxserver/bazarr:v1.6.2-ls373` (current LinuxServer.io build,
  released 2026-11-18; base packages updated — review item T1).
- README documents the `help` link and points at `NOTICE.md`.

### Removed
- The 6 MB `TOSAppSelfTestingTool` binary is no longer tracked in the public repository.

> `1.6.2-2` was rejected for V7 (checksum) and F1/F2/F6/F7 (install/start/port/UI). The
> checksum in the report is the digest of the published asset itself, and the report's own
> verification summary records a successful install and start-up; see
> `docs/REVIEW-REPLY-1.6.2-6.md`.

## 1.6.2-5 — 2026-11-17

### Changed
- Image refreshed to `linuxserver/bazarr:v1.6.2-ls372` (newer base image and Python
  packages; addresses the CVE item from the listing review).
- Added a privacy section, third-party API disclosure, data-rights and deletion
  channel, retention periods and security measures to the README (review items C3,
  C4, C5, C7, C8).
- Added `NOTICE.md` with licence notices and attributions (review item C2).
- README completed for the public repository (review item C10).

## 1.6.2-2 — 2026-11-12

### Changed
- Icon: replaced the letter monogram with a functional vector mark that describes what the app does (the upstream project does not publish a compliant SVG).

## 1.6.2-1 — 2026-11-08

### Added
- First release. Bazarr (`linuxserver/bazarr:1.6.2`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application, published on port 8006 and running
  as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/bazarrdocker/`.
