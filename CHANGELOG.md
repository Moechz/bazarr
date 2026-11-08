# Changelog

All notable user-visible changes to the Bazarr TOS application package.

## 1.6.2-1 — 2026-11-08

### Added
- First release. Bazarr (`linuxserver/bazarr:1.6.2`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application, published on port 8006 and running
  as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/bazarrdocker/`.
