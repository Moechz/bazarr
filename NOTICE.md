# NOTICE — third-party components and attributions

This package (`bazarrdocker`, TOS 7 Docker application) is an independent packaging by
Moechz of the upstream **Bazarr** project, distributed under the terms below.

## 1. Upstream application — Bazarr

- Project: Bazarr — <https://github.com/morpheus65535/bazarr>
- Copyright: the Bazarr contributors
- Licence: **GNU General Public License v3.0** (GPL-3.0)
- Licence text: <https://github.com/morpheus65535/bazarr/blob/development/LICENSE>
- Relationship: the upstream application is used **unmodified**, inside the container
  image. No Bazarr source code is redistributed in this package.

## 2. Container image — linuxserver/bazarr

- Image: `linuxserver/bazarr:v1.6.2-ls372` (Docker Hub)
- Build repository: <https://github.com/linuxserver/docker-bazarr>
- Copyright: LinuxServer.io and the Bazarr contributors
- Licence: **GPL-3.0**

The image is pulled from Docker Hub at install time and is not redistributed here.

## 3. Components inside the image

The image is based on Alpine Linux and bundles Python 3, lsiopy packages and s6-overlay.
Their licences (MIT, BSD, Apache-2.0, GPL/LGPL and others) are documented in the image's
own package metadata and SBOM. They are shipped inside the image only; this package does
not redistribute them as separate files.

## 4. This packaging

The files authored for this package — `docker-compose.yml`, `config.ini`,
`bazarrdocker.lang`, `bazarrdocker.svg`, `entrypoint.sh`, build scripts and this
documentation — are released under **GPL-3.0** (see `LICENSE`).

## 5. Trademarks

“Bazarr”, “Sonarr”, “Radarr”, “LinuxServer.io”, “TerraMaster” and “TOS” are trademarks or
registered trademarks of their respective owners. Their use here is descriptive only.
This package is **not affiliated with, sponsored or endorsed by** the Bazarr project,
LinuxServer.io or TerraMaster.

## 6. Icon

The application icon in `src/bazarrdocker.svg` is a generic mark drawn for this package.
It does not reproduce the upstream Bazarr logo or any third-party trademark.

## 7. Contact

Moechz — moechz@163.com — <https://www.moechz.com/>
