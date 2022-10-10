FROM debian:stable-slim

ARG OONIPROBE_VERSION

LABEL maintainer="Kickball"
LABEL org.ooni.ooniprobe.version=${OONIPROBE_VERSION}

# Install dependencies and ooniprobe. Agree to onboarding process and risks.
RUN apt-get update && \
    apt-get install -y gnupg && \
    apt-key adv --verbose --keyserver hkp://keyserver.ubuntu.com --recv-keys 'B5A08F01796E7F521861B449372D1FF271F2DD50' && \
    echo "deb http://deb.ooni.org/ unstable main" | tee /etc/apt/sources.list.d/ooniprobe.list && \
    apt-get update && \
    apt-get install -y ooniprobe-cli=${OONIPROBE_VERSION} && \
    apt-get clean && \
    ooniprobe onboard --yes

# Set entry point
ENTRYPOINT ["ooniprobe"]

# Set default flags for container run
CMD [ "run", "unattended" ]