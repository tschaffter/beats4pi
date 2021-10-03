# Build elastic/beats for Raspberry Pi

[![GitHub Release](https://img.shields.io/github/release/tschaffter/beats4pi.svg?include_prereleases&color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/beats4pi/releases)
[![GitHub CI](https://img.shields.io/github/workflow/status/tschaffter/beats4pi/CI.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/beats4pi/actions)
[![GitHub License](https://img.shields.io/github/license/tschaffter/beats4pi.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/tschaffter/beats4pi/blob/main/LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/tschaffter/beats4pi.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/repository/docker/tschaffter/beats4pi)

## Introduction

This repository provides a Docker image to cross compile [elastic/beats]
components for Raspberry Pi (ARMv7 architecture).

## Requirements

- [Docker Engine] >=19.03.0

## Usage

### Customizing

The image has a couple of ENV vars that can be used for customizing what and how
to build:

- `GOARCH=arm` - the target architecture, arm for RaspberryPi
- `GOARM=7` - ARM architecture version - 7 for RasperryPi 3
- `BEATS=filebeat,metricbeat` - comma-separated list of beats to compile
- `BEATS_VERSION=7.15.0` - version to compile

### Building the image

    docker build -t tschaffter/beats4pi:latest .

### Building elastic beats

These commands will clone the repository of elastic/beats, build the selected
beats components and output the build result in the current folder:

    git clone https://github.com/elastic/beats.git
    docker run --rm \
        -v $(pwd)/beats:/go/src/github.com/elastic/beats \
        -v $(pwd):/build \
        -e BEATS_VERSION=7.15.0 \
        tschaffter/beats4pi:latest

    docker run --rm \
        -v $(pwd)/beats:/go/src/github.com/elastic/beats \
        -v $(pwd):/build \
        -e GOARCH=amd64 \
        -e BEATS_VERSION=7.15.0 \
        tschaffter/beats4pi:latest

## Acknowledgments

This project has been forked from [andig/beats4pi].

<!-- Links -->

[elastic/beats]: https://github.com/elastic/beats
[Docker Engine]: https://docs.docker.com/engine/install/
[andig/beats4pi]: https://github.com/andig/beats4pi