#!/bin/bash

# Display debug information is relevant environment variable is set.
if [[ "$OONIPROBE_DEBUG" = "true" ]]; then
    echo "OONIPROBE_DEBUG environment variable is set to: ${OONIPROBE_DEBUG}"
    echo "OONIPROBE_UPLOAD_RESULTS environment variable is set to: ${OONIPROBE_UPLOAD_RESULTS}"
    ooniprobe --version
    ooniprobe info
fi

# Replace the upload_results variable in the OONI probe config file with the environment variable.
sed "s/\"upload_results\": true/\"upload_results\": ${OONIPROBE_UPLOAD_RESULTS}/" /var/lib/ooniprobe/.ooniprobe/config.json --in-place

# Run the OONI Probe as the non-root ooniprobe user.
gosu "ooniprobe:ooniprobe" ooniprobe run unattended