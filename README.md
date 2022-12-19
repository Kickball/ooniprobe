# ooniprobe #

![GitHub](https://img.shields.io/github/license/kickball/ooniprobe)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/kickball/ooniprobe?label=release)

Using this container you can have [The Open Observatory of Network Interference (OONI)'s Probe](https://github.com/ooni/probe-cli) up and running in minutes. The probe is an open source tool designed to collect information about network censorship and surveillance, which is published for use in research.

A full list of tests ran by the tool can be found on [OONI's website](https://ooni.org/nettest/).

## Risks ##

The OONI probe is designed to measure censorship and surveillance of networks. As part of its tests, it will attempt to connect to websites which could be provocative, objectionable or illegal in some countries.

By default, results of the test are published publically, including to those who may view its usage as a threat/issue (see #Optional variables for disabling this publication). Though anyone monitoring your internet activity will be able to see that you are running OONI Probe even the data is not published.

Please review OONI's [disclaimer](https://ooni.org/support/ooni-probe-cli#disclaimer) and [risks](https://ooni.org/about/risks/) pages for more information, particularly if operating in a high risk environment.

## Usage ##

This docker image can be run in one of two modes (see [Optional variables](https://github.com/Kickball/ooniprobe#optional-variables) for technical info):
* RunPersist - This is the default mode and will run the OONIProbe's test on a regular basis, with the same container running multiple jobs. This is suitable for normal Docker usage, Docker Compose, Nomad Services and Kubernetes Deployments.
* RunOnce - This is an optional mode which will only run the OONIProbe's tests a single time before the container exits. This is suitable for Nomad Batch, Kubernetes CronJobs or other similar systems where an orchestrator handles scheduling the container.

## Image tags ##

The images of this container are tagged with [semantic versions](https://semver.org) that align with the [version and build of OONI Probe](https://github.com/ooni/probe-cli/releases) that will be ran.

It is recommended that most users use the `:release` tag.

| Image:tag | Description |
|-----------|-------------|
|`kickball/ooniprobe:release` | The most recent image from the `stable` channel.  Most users will use this tag.  The `latest` tag always points to the same version as `release`.|
|`kickball/ooniprobe:3.16.3`| An exact image version. |
|`kickball/ooniprobe:3.16`| The most recent image matching the major and minor version numbers. |
|`kickball/ooniprobe:3`| The most recent image matching the major version number. |
|`kickball/ooniprobe:latest`| See the `release` tag.  [Why does `latest` == `release`?](https://vsupalov.com/docker-latest-tag/) |

See the [tags tab](https://hub.docker.com/r/kickball/ooniprobe/tags) on Docker Hub for a list of all the supported tags.

## Optional variables ##

The below are a list of customisations which can be specified a run-time (so they do not require rebuilding the container image) to alter the container's behaviour.

They are a mix of:
* Environment Variables - these must be specific with the syntax of `--env VARIABLE_NAME='$variable_value'` in the docker run command and must be anywhere in the command between the `run` and the container name (e.g. `kickball/ooniprobe:release`).
* Positional Arguments - as suggested by the name, these variables are retrieved from specific positions of command. They must be listed after the container name (e.g. `kickball/ooniprobe:release`) without the need for prefixes, such as `--env VARIABLE_NAME=`.

They can be used as follows: `docker run --rm -d --env VARIABLE_NAME='$variable_value' kickball/ooniprobe:3.16.3 $mode_value $sleep_value`.

As an example; `docker run --rm -d --env OONIPROBE_UPLOAD_RESULTS='false' --env OONIPROBE_DEBUG='true' kickball/ooniprobe:3.16.3 RunPersist 1800`, would disable the public upload of the scan results, enable debug information, configure the container to run in persistent/repeat mode at an interval of 30 minutes instead of the default 60 minutes.

| Name  | Type |Purpose | Default |
|-------|---------|---------|---------|
| `OONIPROBE_UPLOAD_RESULTS` | Environment Variable | This is a boolean (true or false) option which determines if the measurement results should be automatically uploaded to the OONI collectors. | `true` |
| `OONIPROBE_DEBUG` | Environment Variable | This is a boolean (true or false) option which determines whether additional debug information should be logged during container runtime. | `false` |
| `mode` | Positional Argument (1) | This variable will determine whether the container will run the test once and exit (if in `RunOnce` mode) or will run the tests at a regular interval (if in `RunPersist` mode, with the interval determined by the `sleep` argument) | `RunPersist` |
| `sleep` | Positional Argument (2) | This variable will determine how often the automated tests will run if the container is executed in `RunPersist` mode. | `3600` |

## FAQ ##

You can find answers to frequently asked questions on our [FAQ](FAQ.md).

## Contributing ##

All contributions and feedback is welcome! Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for details.

## License ##

This project is released as open source under the [GNU General Public License v3.0](LICENSE), the same license as the [OONI Probe Software](https://github.com/ooni/probe-cli/blob/master/LICENSE).

All contributions to this project will be released under the same GNU General Public License v3.0. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.