# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# The name of the host tool archive.
# Must be set as an env variable before make is invoked.
HOST_TOOL_ARCHIVE_NAME := ""

DISK := ""

CONTAINER_NAME := "mame-docker:latest"

CONTAINER_INSTALL_TARGET_DIR := /opt/Xilinx

NCPU := 10

SHELL := /bin/bash

all:
	@echo "SHELL                        : ${SHELL}"
	@echo
	@echo "build container by using"
	@echo "		make build"
.PHONY: all

build: build.stamp
.PHONY: build

build.stamp: docker/Dockerfile Makefile
	env DOCKER_BUILDKIT=1 docker build \
		--build-arg NCPU=${NCPU} \
		-t ${CONTAINER_NAME} \
		-f $< .
	touch $@

run:
	env DISK=${DISK} ./run.tim011.sh
.PHONY: run

clean:
	rm *.stamp

