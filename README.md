# Docker SBT

[SBT](http://www.scala-sbt.org/) is the de-facto build tool used for Scala. This is a Docker image for SBT based on Alpine to get as small an image as possible.

## Tags 

The tags, `1.0.0`, `1`, `latest` and `stable`, all point to the same image. The tags `0.12.2`, `0.12.4`, `0.13.15` and `0.13.16` point to the older releases of SBT. `0.13` is a legacy tag I am not planning to build anymore.

## Usage

You can run Scala through SBT using:
```
docker run --rm -it aa8y/sbt:latest sbt console
```
Or use this as your base image for your Scala code using `FROM aa8y/sbt:stable` in your `Dockerfile`. Even though I've got different tags, the latest version of the image can be used for compiling code with any version of SBT by specifying the SBT version in the `project/build.properties` file where the `project` directory is in the same directory as the `src` directory for your Scala/Java sources. This is what the entry should look like for example,
```
sbt.version=0.13.13
```
