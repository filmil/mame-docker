#! /bin/bash
# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -euo pipefail
set -x

CONTAINER_NAME="${CONTAINER_NAME:-mame-docker:latest}"
IMAGE="${IMAGE:-}"

INTERACTIVE=""
if sh -c ": >/dev/tty" >/dev/null 2>/dev/null; then
	# Only add these if running on actual terminal.
	INTERACTIVE="--interactive --tty"
fi

docker run \
  ${INTERACTIVE} \
  -u $(id -u):$(id -g) \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v "${PWD}:/work:rw" \
  -e DISPLAY="${DISPLAY}" \
  -e HOME="/work" \
  -e IMAGE="${IMAGE}" \
  --net=host \
  "${CONTAINER_NAME}" \
  /bin/bash -c "ls -ld / && /run.sh"

