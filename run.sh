#! /bin/bash
# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

PROGRAM="${PROGRAM:-r}"
PROGRAM="$(echo ${PROGRAM} | grep -o .)"

# How long to sleep until system boots.
# It would have been nicer to have a better signal than time, but we don't.
SLEEP=${SLEEP:-5}

# Set to `-debug` to activate the MAME internal debugger.
DEBUG=${DEBUG:-}

# If set to `true`, the machine is slowed down to its actual speed once
# boot completes. For unit tests you may want to set this to `false`.
SLOWDOWN=${SLOWDOWN:-true}

function sendKey () {
    #sleep 1
    echo "Sending to ID $ID: $@"
    xdotool windowactivate --sync $ID key --window $ID --delay 400 $*
}

ID=$(xdotool search --name "\[tim011\] - MAME" getwindowpid)
if [ "$ID" != "" ]; then
    echo "Killing existing MAME instance..."
    kill -9 $ID
fi

/prg/tim011 tim011 \
  -flop1 /work/${IMAGE} \
  ${IMAGE_2_ARGS} \
  ${DEBUG} \
  -window \
  -v -r 720x512 \
  -switchres \
  -sound none \
  -rompath /work \
  &
readonly _emu_pid="$!"

ID=0
echo "FOUND: $img"

# speed up emulator unitl boot ends.
sleep 1
ID=$(xdotool search --name "\[tim011\] - MAME")

# Go past 2 "press any key" -- space
# Scroll_Lock -- turn on menus
# On screen display - F11
# F10 - start skipping frames
# F8 F8 - skip at maximum speed
sendKey space space Scroll_Lock F11 F10 F8 F8

# Wait for system to boot.
sleep ${SLEEP}

# Run the program.
sendKey F10 ${PROGRAM} Return F10

if [[ "${SLOWDOWN}" == "true" ]]; then
  # Slow the system down to real speed. 
  sleep 0.5
  sendKey F10 F11 Scroll_Lock
fi

# Wait until emulator exits.
wait "${_emu_pid}"

