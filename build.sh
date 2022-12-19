#!/bin/bash

podman build --build-arg OONIPROBE_VERSION=3.16.3 --env OONIPROBE_UPLOAD_RESULTS=false --env OONIPROBE_DEBUG=true -t ooniprobe .
