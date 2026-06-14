# Docker SBT

[![CI](https://github.com/aa8y/docker-sbt/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/aa8y/docker-sbt/actions/workflows/ci.yml)

[SBT](https://www.scala-sbt.org/) is the de-facto build tool used for Scala. This is a Docker image for SBT based on Alpine to get as small an image footprint as possible.

## Tags

Only the latest patch release of each supported minor line is published.
`latest` tracks the newest stable 1.x; `2` tracks the latest 2.x release
candidate.

| Tag      | SBT version  | JDK |
|----------|--------------|-----|
| `1.10`   | 1.10.11      | 21  |
| `1.11`   | 1.11.7       | 21  |
| `1.12`   | 1.12.11      | 21  |
| `1`      | 1.12.11      | 21  |
| `2`      | 2.0.0-RC16   | 21  |
| `latest` | 1.12.11      | 21  |

All previously published 0.x and pre-1.10 1.x tags have been deprecated;
those SBT lines are no longer maintained upstream. See `manifest.yml`
for the full build matrix.

## Usage

You can run SBT against an existing project by mounting it:
```
docker run --rm -it -v "$PWD":/usr/src/app aa8y/sbt:latest sbt console
```
The image is more often used as a base image for testing or packaging
Scala code. While any of the tags could be used, prefer `latest` or a
minor/major version tag (`1.12`, `1`, `2`) — full patch tags may be
pruned as new versions are released. From 1.0.0 onwards, SBT pulls the
required SBT JARs based on the `sbt.version` declared in
`project/build.properties`, so the image's bundled SBT only needs to be
new enough to bootstrap.

## Testing

Image tests are defined as [container-structure-test][cst] configs under
`test/config/`. `common.yaml` asserts the install layout and
`version.yaml` runs `sbt sbtVersion`. The configs to apply per tag are
declared in `manifest.yml` under `structureTest:` and run natively by
`dave structure-test`:

```sh
brew install container-structure-test     # one-time

dave build
dave structure-test
```

CI runs the same commands; see `.github/workflows/ci.yml`.

[cst]: https://github.com/GoogleContainerTools/container-structure-test
