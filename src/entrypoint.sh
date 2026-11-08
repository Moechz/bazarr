#!/bin/sh
# ===========================================================================
# Bazarr entrypoint wrapper for the TerraMaster TOS 7 package.
#
# The upstream image boots with the s6-overlay v3 init, whose service manager
# needs root; with user "1000:1000" it cannot start the service and the
# container stays up with nothing listening on 6767. TOS forbids root
# containers, so this wrapper runs exactly the command the s6 service runs,
# directly as the unprivileged container user:
#
#   cd /app/bazarr/bin && python3 bazarr.py --no-update --config /config
#
# Nothing in the image is modified; only the process identity differs.
# ===========================================================================
set -u

CONFIG_DIR=/config
MEDIA_DIR=/media

mkdir -p "$CONFIG_DIR" "$MEDIA_DIR"

# Bazarr keeps its cache below $HOME; point it at the persistent volume.
export HOME=$CONFIG_DIR
export TZ="${TZ:-Asia/Shanghai}"
export PYTHONIOENCODING=UTF-8

cd /app/bazarr/bin || exit 1
exec python3 -u /app/bazarr/bin/bazarr.py --no-update --config "$CONFIG_DIR"
