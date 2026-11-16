# Privacy Policy — Bazarr for TerraMaster TOS (`bazarrdocker`)

**Last updated:** 17 November 2026
**Data controller / contact:** Moechz — moechz@163.com

This policy covers the TOS application `bazarrdocker` (the “app”) and the packaging work
around it. It explains what data the app processes, where it stays, how long it is kept,
what rights you have and how to exercise them.

## 1. Summary

- The app runs **entirely on your NAS**. The developer does not receive, collect or have
  access to your data.
- There is **no telemetry, no analytics, no account and no cloud service** operated by the
  developer.
- The app contacts only the services **you configure** (Sonarr/Radarr, subtitle providers)
  plus an update check and the Docker image registry.

## 2. What data is processed

| Data | Where it lives | Why |
|---|---|---|
| Settings, API keys for Sonarr/Radarr and providers | `config/config/config.yaml` | to operate the app |
| Subtitle database (series, movies, history, wanted list) | `config/db/bazarr.db` | to track subtitles |
| Caches (provider responses, thumbnails) | `config/cache/` | performance |
| Logs | `config/log/`, container stdout | troubleshooting |
| Subtitle files | wherever you point Bazarr (usually next to your media) | the purpose of the app |

All of it is stored under `/Volume1/DockerAppData/bazarrdocker/` (or the media paths you
choose). None of it is transmitted to the developer.

## 3. Retention period

- **Application data:** kept until **you** delete it. There is no automatic expiry and no
  upload. Uninstalling the app keeps the data unless you tick “delete data”.
- **Logs:** rotated by Bazarr (10 files by default); older entries are discarded by the app.
- **Cache:** rebuilt on demand; safe to delete at any time.
- **Website/server logs (moechz.com):** short-lived operational logs, not used for profiling.

## 4. Your rights and the deletion channel

You have the right to access, correct, export and delete the data the app holds.

| Right | How |
|---|---|
| Access / export | Copy the folder `/Volume1/DockerAppData/bazarrdocker/` — it is the complete state. |
| Correct | Change the values in the app's web UI (Settings). |
| Delete | Uninstall the app and tick “delete data”, or stop the container and remove `/Volume1/DockerAppData/bazarrdocker/`. |
| Assistance | Email **moechz@163.com** with the subject “Bazarr data request”; a reply follows within 30 days. |

Because the developer holds no copy of your data, a deletion request is normally completed
by deleting the folder on your own NAS — the email channel exists for questions and for
requests about the website or the publishing records (e.g. store listing).

## 5. Security measures

- The container runs as **uid 1000**, never root; no `privileged`, no `cap_add`, no host
  network, no Docker socket.
- Only **one port** is published (host 8006 → container 6767).
- The image tag is **pinned**; the package is rebuilt when upstream ships security fixes.
- Data stays inside the application data folder, owned by the app user.
- Recommendation: if you expose the UI outside the LAN, put it behind a TLS reverse proxy
  and keep the app updated.

## 6. Third-party sharing and API disclosure

The developer shares nothing. The app itself contacts only the endpoints below, and only
when you configure or enable them.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| Sonarr / Radarr | the URL you enter (usually LAN, e.g. `http://192.168.1.10:8989`) | library queries, subtitle metadata (titles, season/episode, TVDB/TMDB/IMDb ids, paths) | your LAN |
| Subtitle providers you enable | e.g. `api.opensubtitles.com`, `rest.opensubtitles.org`, `subscene.com`, `podnapisi.net`, `addic7ed.com` | title, year, season/episode, IMDb/TVDB id, language, sometimes a file hash — never your media files | the provider's servers (mostly EU/US, per that provider's policy) |
| Bazarr update check | `github.com/morpheus65535/bazarr` | current version string | GitHub, US |
| Docker Hub | `registry-1.docker.io` (or your registry mirror) | anonymous image pull | Docker Hub, US / your mirror |

No data is sold or shared with advertisers. There is no third-party analytics SDK.

## 7. Children

The app is a media utility and is not directed at children.

## 8. Changes

Material changes to this policy are published in this file and reflected in the “Last
updated” date above.

## 9. Contact

Moechz — **moechz@163.com** — <https://www.moechz.com/privacy.html>
