#! /bin/bash
# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -x

PROGRAM="${PROGRAM:-r}"
PROGRAM="$(echo ${PROGRAM} | grep -o .)"

function sendKey () {
    #sleep 1
    echo "Sending to ID $ID: $@"
    xdotool windowactivate --sync $ID key --window $ID --delay 400 $*
}

function waitID() {
  local name="${1}"
  id=""
  while [[ "${id}" == "" ]]; do
    id=$(xdotool search --name "${name}" getwindowpid)
    if [[ "${id}" == "" ]]; then
      sleep 1
    fi
  done
  echo "${id}"
}

ID=$(xdotool search --name "\[tim011\] - MAME" getwindowpid)
if [ "$ID" != "" ]; then
    echo "Killing existing MAME instance..."
    kill -9 $ID
fi

/prg/tim011 tim011 \
  -flop1 /work/${IMAGE} \
  -window \
  -v -r 720x512 -switchres \
  -sound none \
  -rompath /work &
readonly _emu_pid="$!"

DEBUG=""

ID=0
echo "FOUND: $img"

#./tim011 tim011 -window -v -r 720x512 -switchres $DEBUG -flop1 "$img" 1>run1.log 2>run2.log &

# speed up emulator unitl code is executed
sleep 1
ID=$(xdotool search --name "\[tim011\] - MAME")
#ID=$(waitID "\[tim011\] - MAME")
sendKey space space Scroll_Lock F11 F10
#sendKey space space Scroll_Lock F11

# How long to wait here?
sleep 15 

# Run the program.
sendKey F10 ${PROGRAM} Return F10
#sendKey F10 r Return

sleep 0.5
sendKey F10 F11 Scroll_Lock

wait "${_emu_pid}"

