# Gather official OONI Probe versions.
# (1) Get project releases via GitHub API. (2) Filter the tag JSON data to only the tag name. (3) Use RegEx to filter tag names to only the version numbers (no letters) and remove any beta/alpha releases (those end with -alpha/-beta). (4) Return the results of the RegEx as an array. (5) Merge the arrays, source: https://stackoverflow.com/a/63908503. (6) Remove punctuation to enable conversion to bash array, source https://stackoverflow.com/a/61299548.
probe_versions=($(curl -H "Accept: application/vnd.github+json" https://api.github.com/repos/ooni/probe-cli/releases?per_page=100 | jq '.[]."tag_name" | match("([1234567890])+\\.([1234567890])+\\.([1234567890])*$"; "g") | [.string]' | jq -rs 'reduce .[] as $x ([]; . + $x)' | tr -d '[]," '))

# (1) Get container images via the Docker Hub API. (2) Filter the tag JSON data to only the image name. (3) Use RegEx to filter image names to only the version numbers (no letters) and remove any beta/alpha releases (those end with -alpha/-beta). (4) Return the results of the RegEx as an array. (5) Merge the arrays, source: https://stackoverflow.com/a/63908503. (6) Remove punctuation to enable conversion to bash array, source https://stackoverflow.com/a/61299548.
container_versions=($(curl https://hub.docker.com/v2/namespaces/kickball/repositories/ooniprobe/tags?page_size=100 | jq '.results[].name | match("^([1234567890])+\\.([1234567890])+\\.([1234567890])*$"; "g") | [.string]' | jq -rs 'reduce .[] as $x ([]; . + $x)' | tr -d '[]," '))

echo "Probe Versions:"
echo "${probe_versions[@]}"

echo "Container Versions:"
echo "${container_versions[@]}"

# Identify versions of the OONI Probe software that do not have equivilant container image versions. Source: https://stackoverflow.com/a/28161520.
missing_versions=($(echo ${probe_versions[@]} ${container_versions[@]} ${container_versions[@]} | tr ' ' '\n' | sort | uniq -u | sort -V))

echo "Missing Versions:"
echo "${missing_versions[@]}"

# TBC for actual process, will likely involve Git branches/tags and GitHub actions to build the images.
for version in $missing_versions; 
do
    docker build --build-arg OONIPROBE_VERSION=$version --build-arg OONIPROBE_UPLOAD_RESULTS=true -t ooniprobe:$version kickball/ooniprobe:$version . 
    docker push kickball/ooniprobe:$version
done
