FROM debian:stable-slim

ARG OONIPROBE_VERSION
ARG OONIPROBE_UPLOAD_RESULTS=true

LABEL maintainer="Kickball"
LABEL org.ooni.ooniprobe.version=${OONIPROBE_VERSION}

# Install dependencies and ooniprobe.
RUN apt-get update && \
    apt-get install -y gnupg && \
    apt-key adv --verbose --keyserver hkp://keyserver.ubuntu.com --recv-keys 'B5A08F01796E7F521861B449372D1FF271F2DD50' && \
    echo "deb http://deb.ooni.org/ unstable main" | tee /etc/apt/sources.list.d/ooniprobe.list && \
    apt-get update && \
    apt-get install -y ooniprobe-cli=${OONIPROBE_VERSION} && \
    apt-get clean

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