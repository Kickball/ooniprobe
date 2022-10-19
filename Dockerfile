FROM debian:stable-slim

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG OONIPROBE_VERSION

ENV OONIPROBE_UPLOAD_RESULTS=true
ENV OONIPROBE_DEBUG=false

# OCI Label Specifications (https://github.com/opencontainers/image-spec/blob/main/annotations.md)
LABEL org.opencontainers.image.version=${OONIPROBE_VERSION}
LABEL org.opencontainers.image.authors="Kickball"
LABEL org.opencontainers.image.title="ooniprobe"
LABEL org.opencontainers.image.description="A simple to use image for the OONI Probe software."
LABEL org.opencontainers.image.url=https://github.com/Kickball/ooniprobe
LABEL org.opencontainers.image.source=https://github.com/Kickball/ooniprobe
LABEL org.opencontainers.image.licenses=GPL-3.0

# Install dependencies and ooniprobe. Agree to ooniprobe process and risks.
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg gosu && \
    apt-key adv --verbose --keyserver hkp://keyserver.ubuntu.com --recv-keys 'B5A08F01796E7F521861B449372D1FF271F2DD50' && \
    echo "deb http://deb.ooni.org/ unstable main" | tee /etc/apt/sources.list.d/ooniprobe.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends ooniprobe-cli=${OONIPROBE_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ooniprobe onboard --yes

COPY launcher.sh .
COPY --chown=ooniprobe:ooniprobe config.json /var/lib/ooniprobe/.ooniprobe/config.json

ENTRYPOINT [ "./launcher.sh" ]