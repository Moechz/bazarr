# bazarr-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [Bazarr](https://github.com/morpheus65535/bazarr).

## What this is

A four-file TOS Docker application archive (`bazarrdocker.tar.gz`) that installs
Bazarr on TOS 7 through the App Center:

- `config.ini` — TOS application metadata (`application_type: docker`, id `bazarrdocker`)
- `bazarrdocker.lang` — 23-language superset (TOS requires 14)
- `bazarrdocker.svg` — application icon (326 bytes, 2 SVG elements)
- `docker-compose.yml` — one service, image `linuxserver/bazarr:1.6.2`

## How it works

| | |
|---|---|
| Container image | `linuxserver/bazarr:1.6.2` (Docker Hub, used unmodified) |
| Open | `http://<NAS-IP>:8006/` (container port 6767) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/config` → `/Volume1/DockerAppData/bazarrdocker/config`, `/media` → `/Volume1/DockerAppData/bazarrdocker/media` |
| Logs | `docker logs bazarrdocker` (stdout/stderr) |

`config/` holds everything Bazarr persists: `config/config.yaml` (settings, API keys, Sonarr/Radarr and provider connections), `db/bazarr.db` (the subtitle database), `cache/` and `log/`. `media/` is the place mounted as `/media` inside the container: point Bazarr's series/movie folders there, or edit docker-compose.yml to mount your own media share after installation.

## Design highlights

- **Non-root.** `user: "1000:1000"`; verified on real hardware (the container reports uid 1000).
- **Entrypoint wrapper** (not a privilege shim): the image's s6 service manager needs root, so `src/entrypoint.sh` starts Bazarr directly as the unprivileged container user.
- **Deterministic build**: GNU tar with uid/gid 0 and zeroed timestamps, gzip without a timestamp, plus the review-standards self-check above.
- **Non-root by construction.** The s6 service manager of the image needs root, so the wrapper starts Bazarr directly as `1000:1000`; verified on real hardware with `id` inside the container.
- **Fixed image tag `1.6.2`**, Docker Hub only, no `privileged`, no `network_mode: host`, no `cap_add`, no Docker socket.
- **Health check** on the UI itself (`GET /` on port 6767) with a 90 s start period for the first start.

## Runtime file manifest

Everything the application writes on the NAS lives inside its own data
directory; the container-internal `/tmp` is discarded with the container. The
table lists what is created and how it behaves. Nothing else is written.

| Path | Purpose | Created when | Growth bound | Lifecycle |
|---|---|---|---|---|
| `config/config/config.yaml` | all settings - Sonarr/Radarr connections, subtitle providers, languages, path mappings | first start | static, rewritten on every settings change | never overwritten by the app; it is the whole configuration |
| `config/db/bazarr.db` | subtitle database (episodes, movies, history, wanted list) | first start | grows with the size of the library | managed by Bazarr; back it up before uninstalling with data removal |
| `config/cache` | cached provider responses and thumbnails | first start | bounded by the cache settings | safe to delete, rebuilt on demand |
| `config/log` | Bazarr log files | first start | rotated by Bazarr | safe to delete |
| `media` | optional place for media whose subtitles Bazarr should manage | first start (empty) | only what you put there | managed by you |
| `/Volume1/DockerAppData/bazarrdocker/config` | Bazarr application data (everything the container writes outside /tmp) | on first start / on demand | bounded by your own data | persistent; kept on uninstall unless you ask to delete it |
| `/Volume1/DockerAppData/bazarrdocker/media` | Bazarr application data (everything the container writes outside /tmp) | on first start / on demand | bounded by your own data | persistent; kept on uninstall unless you ask to delete it |

## Build

```bash
scripts/build.sh                  # -> out/bazarrdocker.tar.gz + .sha256
scripts/build.sh 1.6.2-2   # packaging iteration bump
scripts/build.sh 1.6.2-1 aarch64
```

The build stages the four files, substitutes the version/platform placeholders,
embeds `src/entrypoint.sh` into the compose file (escaping every `$` as `$$`), removes CRLF/BOM/AppleDouble, then runs
`tools/verify.py`, a review-standards self-check (archive layout, JSON validity,
required fields, 14+ language coverage, version consistency, Docker-Hub-only
images, fixed tag, reserved/recommended host ports, non-root user, per-service
healthcheck/TZ/restart, data path below the application data root, never the
`/Volume*` wildcard, comment-free sequence blocks, `x-app-meta` position, no
literal secrets and the SVG size/element limits).

## Local verification

```bash
./TOSAppSelfTestingTool -c out/bazarrdocker.tar.gz   # official spec check
bash test/install-and-verify.sh                  # on-device E2E (needs root)
```

> Docker applications cannot be side-loaded through the App Center's manual
> install page (it accepts `.deb` only); the official self-testing tool's `-i`
> mode or `docker compose` are the only ways to install one for testing.

## Store submission checklist

1. Public GitHub repo (code + README only).
2. Release **tag `v1.6.2-1`**, assets `bazarrdocker.tar.gz` +
   `bazarrdocker.tar.gz.sha256` (Docker asset naming: `<app_id>.tar.gz`, **no
   platform suffix**).
3. Developer platform → Add Application: ID `bazarrdocker`, package type Docker,
   repository URL, architecture `x86_64`.
4. Version Management → Add Version `1.6.2-1` → automated validation → review.

## License / branding

Bazarr is distributed by its upstream authors under **GPL-3.0**. The container image is the official image from Docker Hub (`linuxserver/bazarr:1.6.2`) and is used unmodified; no upstream source code is redistributed here. This packaging is an independent community submission by Moechz and is not affiliated with the upstream project or TerraMaster.

## Limitations

Bazarr only writes subtitles to folders it can see inside the container. TOS Docker applications cannot mount shared folders by default: to use your real library, edit `/Volume1/@apps/DockerEngine/application/bazarrdocker/docker-compose.yml` and add the share, or copy media into the `media/` folder of the application data directory.
Bazarr needs Sonarr and Radarr (or their API endpoints) plus a subtitle provider before it can do anything; none of them are bundled.
The UI is served over plain HTTP on the LAN. Do not expose the published port to the internet without a TLS reverse proxy.

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.
