# Frequently Asked Questions #

This page contains answers to some frequently asked questions.

## Why are there not images for all releases of the OONI Probe software? ##

It is expected that there will not be container images for each release of the OONI Probe software.

The process of releases looks as follows: software release (OONI) -> debian package release (OONI) -> docker container image (Kickball). This project uses automated build processes (see [release.sh](release.sh)) to stay up to date with releases of the OONI Probe software, but is dependant on the middle step, the creation of a debian package by OONI.

OONI have provided the following explaining why a debian package may not exist for every software release.
1) They started releasing for debian after a given moment in time
2) They skip creating debian packages when it does not make sense to do so (e.g. the update only contains improvements for mobile devices)