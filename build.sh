#!/bin/bash

podman build --build-arg OONIPROBE_VERSION=3.16.3 --build-arg OONIPROBE_UPLOAD_RESULTS=true -t ooniprobe .