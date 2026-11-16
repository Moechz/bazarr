# bazarr-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [Bazarr](https://github.com/morpheus65535/bazarr), built for **x86_64 and aarch64**.

## What this is

A four-file TOS Docker application archive that installs Bazarr on TOS 7 through the
App Center. A TOS Docker application declares a single architecture, so the release
carries one archive per architecture:

| Architecture | Archive |
|---|---|
| `x86_64` | `bazarrdocker_x86_64.tar.gz` |
| `aarch64` | `bazarrdocker_aarch64.tar.gz` |

Each archive contains exactly:

- `config.ini` — TOS application metadata (`application_type: docker`, id `bazarrdocker`)
- `bazarrdocker.lang` — 23-language superset (TOS requires 14)
- `bazarrdocker.svg` — application icon
- `docker-compose.yml` — one service, image `linuxserver/bazarr:v1.6.2-ls372`

## How it works

| | |
|---|---|
| Container image | `linuxserver/bazarr:v1.6.2-ls372` (Docker Hub, used unmodified) |
| Open | `http://<NAS-IP>:8006/` (container port 6767) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/config` → `/Volume1/DockerAppData/bazarrdocker/config`, `/media` → `/Volume1/DockerAppData/bazarrdocker/media` |
| Logs | `docker logs bazarrdocker` (stdout/stderr), plus `config/log/` |

`config/` holds everything Bazarr persists: `config/config.yaml` (settings, API keys,
Sonarr/Radarr and provider connections), `db/bazarr.db` (the subtitle database),
`cache/` and `log/`. `media/` is mounted as `/media` inside the container: point
Bazarr's series/movie folders there, or edit `docker-compose.yml` to mount your own
media share after installation.

## Privacy

This application runs entirely on your NAS. **The developer does not collect, receive
or have access to any data processed by the application.** There is no telemetry, no
analytics and no account.

| Topic | Detail |
|---|---|
| Data processed | Settings and API keys (`config/config.yaml`), the subtitle database (`db/bazarr.db`), caches and logs. Subtitles written next to your media stay wherever you point Bazarr. |
| Where it is stored | `/Volume1/DockerAppData/bazarrdocker/` on your NAS. Nothing is uploaded to the developer. |
| Retention period | Until **you** delete it. The application never expires or uploads data on its own. Logs are rotated by Bazarr (default: 10 files); the cache is rebuilt on demand. Uninstalling the app keeps the data unless you tick “delete data”. |
| Your rights | **Access / export**: copy the `bazarrdocker` folder — it is the complete state. **Correct**: change the values in the web UI. **Delete**: uninstall the app with “delete data”, or remove `/Volume1/DockerAppData/bazarrdocker/` after stopping the container. |
| Deletion channel | Delete the folder yourself at any time, or email **moechz@163.com** with the subject “Bazarr data deletion” and the request will be answered within 30 days. |
| Security measures | Container runs as uid 1000 (never root), no `privileged`, no host network, no `cap_add`, no Docker socket, one published port. The image tag is fixed and updated when upstream ships security fixes. Do not expose the port to the internet without a TLS reverse proxy. |
| Children | Not directed at children; the app processes media metadata only. |

**Full privacy policy:** [PRIVACY.md](PRIVACY.md) in this repository —
<https://github.com/Moechz/bazarr/blob/main/PRIVACY.md> — and the website version at
<https://www.moechz.com/privacy.html>, which also covers the other applications by the
same developer.

## Third-party services (API disclosure)

Bazarr itself contacts only the services **you configure**. The developer operates no
server in this path. The table lists what is called, what is sent and where it goes.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| Sonarr / Radarr | the base URL you enter in Settings (normally your LAN, e.g. `http://192.168.1.10:8989`) | library list requests, search triggers, subtitle metadata (titles, season/episode, TVDB/TMDB/IMDb ids, file paths) | your own NAS / LAN |
| Subtitle providers (only the ones you enable) | provider APIs, e.g. `api.opensubtitles.com`, `rest.opensubtitles.org`, `subscene.com`, `podnapisi.net`, `addic7ed.com` | title, year, season/episode, IMDb/TVDB id, language, sometimes a file hash — never your files | the provider's own servers (mostly EU/US; see that provider's policy) |
| Bazarr update check | `github.com/morpheus65535/bazarr` (GitHub API) | current version string | GitHub, US |
| Docker Hub (image pull) | `registry-1.docker.io` via your registry mirror | none (anonymous pull) | Docker Hub, US / your configured mirror |

Disable the update check in Bazarr's settings if you do not want it; providers can be
removed individually in Settings → Subtitles. Sonarr/Radarr traffic never leaves your
network unless you configure a remote address yourself.

## Licence and attributions

| Component | Licence | Notes |
|---|---|---|
| Bazarr | GPL-3.0 | <https://github.com/morpheus65535/bazarr> — upstream application, used unmodified inside the image |
| `linuxserver/bazarr` image | GPL-3.0 | <https://github.com/linuxserver/docker-bazarr> — the official image this package runs |
| Alpine Linux base and bundled Python packages | various free licences | shipped inside the image, listed by the image's own SBOM; not redistributed as source here |
| This packaging (compose file, metadata, translations, icon) | GPL-3.0 | see `LICENSE` |

“Bazarr”, “Sonarr”, “Radarr”, “TerraMaster” and “TOS” are trademarks of their
respective owners. This is an independent community package by Moechz; it is not
affiliated with or endorsed by the Bazarr project, LinuxServer.io or TerraMaster.
The application icon is a generic mark drawn for this package and does not reproduce the
upstream logo.

## Design highlights

- **Non-root.** `user: "1000:1000"`; verified on real hardware (the container reports uid 1000).
- **Entrypoint wrapper** (not a privilege shim): the image's s6 service manager needs root,
  so `src/entrypoint.sh` starts Bazarr directly as the unprivileged container user.
- **Fixed image tag**, Docker Hub only, no `privileged`, no `network_mode: host`,
  no `cap_add`, no Docker socket.
- **Health check** on the UI itself (`GET /` on port 6767) with a 90 s start period.
- **Deterministic build**: GNU tar with uid/gid 0 and zeroed timestamps, gzip without a
  timestamp, plus the review-standards self-check.

## Runtime file manifest

Everything the application writes on the NAS lives inside its own data directory; the
container-internal `/tmp` is discarded with the container.

| Path | Purpose | Created when | Growth bound | Lifecycle |
|---|---|---|---|---|
| `config/config/config.yaml` | all settings - Sonarr/Radarr connections, subtitle providers, languages, path mappings | first start | static, rewritten on settings change | never overwritten by the app |
| `config/db/bazarr.db` | subtitle database (episodes, movies, history, wanted list) | first start | grows with the library | managed by Bazarr; back it up before uninstalling with data removal |
| `config/cache` | cached provider responses and thumbnails | first start | bounded by the cache settings | safe to delete, rebuilt on demand |
| `config/log` | Bazarr log files | first start | rotated by Bazarr (10 files by default) | safe to delete |
| `media` | optional place for media whose subtitles Bazarr should manage | first start (empty) | only what you put there | managed by you |

## Build

```bash
scripts/build-dual.sh              # -> out/bazarrdocker_{x86_64,aarch64}.tar.gz
scripts/build-dual.sh 1.6.2-6      # packaging iteration bump, both architectures
```

Each build stages the four files, substitutes the version/platform placeholders,
embeds `src/entrypoint.sh` into the compose file (escaping `$` as `$$`), removes
CRLF/BOM/AppleDouble, runs `tools/verify.py` and the official
`TOSAppSelfTestingTool -c` check, then writes the archive and its `.sha256`.

## Local verification

```bash
./TOSAppSelfTestingTool -c out/bazarrdocker_x86_64.tar.gz
bash test/install-and-verify.sh out/bazarrdocker_x86_64.tar.gz   # on-device E2E (root)
```

The x86_64 archive is installed on a real TOS 7 NAS and checked end to end (health,
non-root, single published port, volume ownership, write access, HTTP, restart,
uninstall/reinstall data retention). The aarch64 archive differs only in
`config.ini.platform` and is installed on an ARM TOS NAS for the same check.

## Store submission checklist

1. Public GitHub repo (code + README + NOTICE + LICENSE).
2. Release tag `v1.6.2-5` with four assets: `bazarrdocker_{x86_64,aarch64}.tar.gz` and
   their `.sha256` files.
3. Developer platform → Add Application **twice**, same ID `bazarrdocker`:
   architecture `x86_64` and `aarch64`.
4. In each application: Add Version `1.6.2-5` pointing at that architecture's archive.
   Submission remarks: “Rectified per review comments” plus the privacy URL.

## Limitations

- Bazarr only writes subtitles to folders it can see inside the container. TOS Docker
  applications cannot mount shared folders by default: edit
  `/Volume1/@apps/DockerEngine/application/bazarrdocker/docker-compose.yml` to add the
  share, or copy media into the `media/` folder of the application data directory.
- Bazarr needs Sonarr and Radarr (or their API endpoints) plus a subtitle provider before
  it can do anything; none of them are bundled.
- The UI is served over plain HTTP on the LAN. Do not expose the published port to the
  internet without a TLS reverse proxy.

## Support

- Issues and questions: <https://github.com/Moechz/bazarr/issues>
- Email: moechz@163.com
- This package is free. If it saved you time, you can leave a one-time tip at
  <https://www.moechz.com/> — completely optional, and it does not unlock anything.

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.
