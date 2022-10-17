FROM debian:stable-slim

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG OONIPROBE_VERSION
ARG OONIPROBE_UPLOAD_RESULTS=true

# OCI Label Specifications (https://github.com/opencontainers/image-spec/blob/main/annotations.md)
LABEL org.opencontainers.image.version=${OONIPROBE_VERSION}
LABEL org.opencontainers.image.authors="Kickball"
LABEL org.opencontainers.image.title="ooniprobe"
LABEL org.opencontainers.image.description="A simple to use image for the OONI Probe software."
LABEL org.opencontainers.image.url=https://github.com/Kickball/ooniprobe
LABEL org.opencontainers.image.source=https://github.com/Kickball/ooniprobe
LABEL org.opencontainers.image.licenses=GPL-3.0

# Install dependencies and ooniprobe.
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg && \
    apt-key adv --verbose --keyserver hkp://keyserver.ubuntu.com --recv-keys 'B5A08F01796E7F521861B449372D1FF271F2DD50' && \
    echo "deb http://deb.ooni.org/ unstable main" | tee /etc/apt/sources.list.d/ooniprobe.list && \
    apt-get update && \
    apt-get install -y ooniprobe-cli=${OONIPROBE_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Agree to onboarding process and risks. Add configuration file
RUN ooniprobe onboard --yes && \ 
    echo '{\n\
  "_": "", \n\
  "_version": 1, \n\
  "_informed_consent": true, \n\
  "sharing": { \n\
    "upload_results": '${OONIPROBE_UPLOAD_RESULTS}' \n\
  }, \n\
  "nettests": { \n\
    "websites_url_limit": 0, \n\
    "websites_enabled_category_codes": null \n\
  }, \n\
  "advanced": { \n\
    "send_crash_reports": true \n\
  } \n\
} \n'\ > ~/.ooniprobe/config.json

# Set entry point
ENTRYPOINT ["ooniprobe"]

# Set default flags for container run
CMD [ "run", "unattended" ]