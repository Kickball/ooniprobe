# Frequently Asked Questions #

This page contains answers to some frequently asked questions. You can also find the FAQ for OONI Probe itself on [their website](https://ooni.org/support/faq).

## Why are there not images for all releases of the OONI Probe software? ##

It is expected that there will not be container images for each release of the OONI Probe software.

The process of releases looks as follows: software release (OONI) -> debian package release (OONI) -> docker container image (Kickball). This project uses automated build processes (see [release.sh](release.sh)) to stay up to date with releases of the OONI Probe software, but is dependant on the middle step, the creation of a debian package by OONI.

OONI have provided the following explaining why a debian package may not exist for every software release.
1) They started releasing for debian after a given moment in time
2) They skip creating debian packages when it does not make sense to do so (e.g. the update only contains improvements for mobile devices)

## How can I access the results of a scan? ##

The results of a scan are available at the following path in the container: `/var/lib/ooniprobe/.ooniprobe/msmts/`. Options for retrieving or accessing this data are provided below.

If you do not upload the results of the OONI Probe scan (see [Optional Variables](https://github.com/Kickball/ooniprobe#optional-variables) for instructions on disabling uploads), then you will likely want to review them locally.

There are a few options available to you:
1) For longer-lasting access to the results, you can mount the path within the container where the results of the probe are stored, onto your host system, using a Docker volume. Add the following argument when running the container (replacing the first path with your desired destination for the data): `-v /YOUR/PATH/HERE:/var/lib/ooniprobe/.ooniprobe/msmts:rw`. 
2) For quick, irregular access, you can enter into the container. This can be accomplished with the following steps:
A) Find your container's ID by running `docker ps`.
B) Create a shell inside your container by running `docker exec -it CONTAINERIDHERE bash`.
C) Now that you have a shell within the container you can access the test results as desired, e.g. `ls -l /var/lib/ooniprobe/.ooniprobe/msmts/` or `ooniprobe list`.

Note that these options will still work if you upload the results of the scan.