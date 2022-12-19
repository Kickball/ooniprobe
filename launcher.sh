#!/bin/bash

# Handle Linux Signals to allow container to gracefully terminate.
trap 'exit 0' SIGINT SIGQUIT SIGTERM

# Assign variables
mode="$1"
sleep="$2"

# Display debug information is relevant environment variable is set.
if [[ "$OONIPROBE_DEBUG" = "true" ]]; then
    echo "OONIPROBE_DEBUG environment variable is set to: ${OONIPROBE_DEBUG}"
    echo "OONIPROBE_UPLOAD_RESULTS environment variable is set to: ${OONIPROBE_UPLOAD_RESULTS}"
    echo "Mode command line variable is set to: ${mode}"
    echo "Sleep command line variable is set to: ${sleep}"
    ooniprobe --version
    ooniprobe info
fi

# Replace the upload_results variable in the OONI probe config file with the environment variable.
sed "s/\"upload_results\": true/\"upload_results\": ${OONIPROBE_UPLOAD_RESULTS}/" /var/lib/ooniprobe/.ooniprobe/config.json --in-place

# update to exece to handle linux signals: https://stackoverflow.com/a/50536078

if [[ "$mode" == "RunOnce" ]]; then 
  ooniprobe run unattended
elif [ "$mode" == "RunPersist" ]; then
  while true; do ooniprobe run unattended; sleep "$sleep"; done
else
  echo "Error: unknown run mode: $mode"
  exit 5
fi