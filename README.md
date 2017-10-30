# Docker SBT

[SBT](http://www.scala-sbt.org/) is the de-facto build tool used for Scala. This is a Docker image for SBT based on Alpine to get as small an image as possible.

## Tags

The tags, `1.0.3`, `1.0`, `1`, `latest` and `stable`, all point to the same image. The tags `0.12.2`, `0.12.4`, `0.13.15`, `0.13.16` and `1.0.2` point to the older releases of SBT. `0.12` and `0.13` (along with `1.0`) point to their respective latest minor releases. I am planning to maintain a latest version and a older release for a certain version category. This basically means that for 1.0 minor release, we will keep around 1.0.2 and 1.0.3 patch releases. For people who do not update their SBT versions often, I would recommend you use the minor release tags, rather than the full release tags with the patch version (meaning use `1.0` vs `1.0.3`).

## Usage

You can run Scala through SBT using:
```
docker run --rm -it aa8y/sbt:latest sbt console
```
Or use this as your base image for your Scala code using `FROM aa8y/sbt:stable` in your `Dockerfile`. Even though I've got different tags, the latest version of the image can be used for compiling code with any version of SBT by specifying the SBT version in the `project/build.properties` file where the `project` directory is in the same directory as the `src` directory for your Scala/Java sources. This is what the entry should look like for example,
```
sbt.version=0.13.13
```
See [this link](http://www.scala-sbt.org/0.13/docs/Basic-Def.html) for more details.

When using the image as a base for another image, always cache the SBT jars by running an SBT command (eg. `sbt clean`) in the directory where the `project/build.properties` file resides, if you're using it, or anywhere if you're not. Make sure you run the command as the user you will be using SBT with, as it will download the JARs to the user's home directory.

## FAQs

###### Docker `RUN` commands used to run fine before but now I get a `Permission denied` error.

I recently changed the image to use another base image which has a non-root user called `docker`. So when you use this image as the base for another, you would have to explicitly run it as `root` by running `USER root` before running any commands which would require root access.
