#!/bin/bash

# Gather official OONI Probe versions.
# (1) Get project releases via GitHub API. (2) Filter the tag JSON data to only the tag name. (3) Use RegEx to filter tag names to only the version numbers (no letters) and remove any beta/alpha releases (those end with -alpha/-beta). (4) Return the results of the RegEx as an array. (5) Merge the arrays, source: https://stackoverflow.com/a/63908503. (6) Remove punctuation to enable conversion to bash array, source https://stackoverflow.com/a/61299548.
probe_versions=($(curl -H "Accept: application/vnd.github+json" https://api.github.com/repos/ooni/probe-cli/releases?per_page=100 | jq '.[]."tag_name" | match("([1234567890])+\\.([1234567890])+\\.([1234567890])*$"; "g") | [.string]' | jq -rs 'reduce .[] as $x ([]; . + $x)' | tr -d '[]," '))

# (1) Get container images via the Docker Hub API. (2) Filter the tag JSON data to only the image name. (3) Use RegEx to filter image names to only the version numbers (no letters) and remove any beta/alpha releases (those end with -alpha/-beta). (4) Return the results of the RegEx as an array. (5) Merge the arrays, source: https://stackoverflow.com/a/63908503. (6) Remove punctuation to enable conversion to bash array, source https://stackoverflow.com/a/61299548.
container_versions=($(curl https://hub.docker.com/v2/namespaces/kickball/repositories/ooniprobe/tags?page_size=100 | jq '.results[].name | match("^([1234567890])+\\.([1234567890])+\\.([1234567890])*$"; "g") | [.string]' | jq -rs 'reduce .[] as $x ([]; . + $x)' | tr -d '[]," '))

# (1) Get debian packages for OONI Probe from official repo. (2) Filter to only ooniprobe-cli, removing any other packages in the repo. (3) Use RegEx to filter to only full, non-beta/alpha/rc, releases. (4) Remove the "Version: " prefix, leaving only the semantic version number.
package_versions=($(curl http://deb.ooni.org/dists/unstable/main/binary-amd64/Packages | grep -Pazo "(Package: ooniprobe-cli).*\n.*(Version:\s)([0-9]+.[0-9]+.[0-9]+).*\n" | grep -aE "(Version:\s)([0-9]+.[0-9]+.[0-9]+$)" | cut -d ' ' -f 2))

echo "Probe Versions:"
echo "${probe_versions[@]}"

echo "Container Versions:"
echo "${container_versions[@]}"

echo "Package Versions:"
echo "${package_versions[@]}"

# Identify versions of the OONI Probe software that do not have equivilant container image versions (results in the probe versions array but not the container versions array). Source: https://stackoverflow.com/a/28161520.
missing_versions=($(echo "${probe_versions[@]}" "${container_versions[@]}" "${container_versions[@]}" | tr ' ' '\n' | sort | uniq -u | sort -V))

echo "Missing Versions:"
echo "${missing_versions[@]}"

# Check which missing image versions there exists a package for (results in both arrays). Source: https://unix.stackexchange.com/a/293254.
available_missing_versions=($(echo "${missing_versions[@]}" "${package_versions[@]}" | tr ' ' '\n' | sort | uniq -d | sort -V))

echo "Available Missing Versions:"
echo "${available_missing_versions[@]}"

# Create a Git tag for each available missing version, triggering the build and push of a container image running that version of software.
for version in "${available_missing_versions[@]}"
do
    echo "Would tag: $version"
    #git tag "$version"
done