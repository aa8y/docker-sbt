# Docker SBT

[![Build Status](https://travis-ci.org/aa8y/docker-scala.svg?branch=master)](https://travis-ci.org/aa8y/docker-scala)

[SBT](http://www.scala-sbt.org/) is the de-facto build tool used for Scala. This is a Docker image for SBT based on Alpine to get as small an image as possible.

## Tags

The tags, `1.2.8`, `1.2`, `1` and `latest`, all point to the same image. The full version tags like `0.12.4`, `0.13.18` and `1.0.4` point to the older releases of SBT. `0.12`, `0.13`, `1.0` and `1.1` (along with `1.2`) point to their respective latest minor releases. I am planning to maintain a latest version and a older release for a certain version category. This basically means that for 1.0 minor release, we will keep around 1.0.3 and 1.0.4 patch releases. For people who do not update their SBT versions often, I would recommend you use the minor release tags, rather than the full release tags with the patch version (meaning use `1.0` vs `1.0.4`), because those would always be available.

## Usage

You can run Scala through SBT using:
```
docker run --rm -it aa8y/sbt:latest sbt console
```
But the image is expected to be used more often as a base image for testing or packaging Scala code. While any of the tags could be used, I would recommend using `latest`, `stable` or the minor/major version tags. Using full version tags is not recommended because, such older tags maybe removed as new versions are released. Also, post version 1.0.0, SBT pulls the required SBT JARs based on the the SBT version specified in the `project/build.properties` file where the `project` directory is in the same directory as your based `build.sbt` file. This is what the entry should look like for example,
```
sbt.version=0.13.13
```
See [this link](http://www.scala-sbt.org/0.13/docs/Basic-Def.html) for more details.

Also, Docker builds an image by building layers which are cached. So if the image is built the correct way, every little change won't rebuild the complete image. See the [examples](#examples).

## Examples

* [better-files](https://github.com/pathikrit/better-files): The `.circleci/config.yml` is an [example](https://github.com/pathikrit/better-files/blob/master/.circleci/config.yml) on how these images could be used with [CircleCI](https://circleci.com) 2.0 as it inherently supports Docker.
* [scrypto](https://github.com/input-output-hk/scrypto/): The `Dockerfile` is a [good example](https://github.com/input-output-hk/scrypto/blob/master/Dockerfile) of how to cache certain image layers to avoid rebuilding the image every time. Also, the `.travis.yml` file describes [how to use](https://github.com/input-output-hk/scrypto/blob/master/.travis.yml) the Docker image for running tests.

## FAQs

###### Docker `RUN` commands used to run fine before but now I get a `Permission denied` error.

I recently changed the image to use another base image which has a non-root user called `docker`. So when you use this image as the base for another, you would have to explicitly run it as `root` by running `USER root` before running any commands which would require root access.

###### Why can't I use the `ci` tag anymore?

`git` and `openssh` have been added to all based images negating the need to have a special `ci` tag. Due to this the `ci` tag which was _deprecated_ on Jan 13, 2019 has been _removed_ on Apr 14, 2019.

###### Why is the `stable` tag no longer available?

Initially when I added the `stable` tag I was expecting to have Docker images for unstable/nightly SBT builds. Since I don't see that happening, the `stable` tag which was _deprecated_ on Jab 13, 2019 was _removed_ on Apr 14, 2019.

###### The `Dockerfile` did not have a version before. What does the new v1.0.0 release mean?

Since [labels are now supported](https://docs.docker.com/engine/reference/builder/#label) in `Dockerfile`s, the idea is to use [Semantic Versioning](https://semver.org/) for all changes. Also, I believe the image is stable enough to warrant a `v1` release.
