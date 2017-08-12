#!/bin/sh

PUSH=$1

# SBT Versions
VERSIONS=(0.12.2 0.12.4 0.13.15 0.13.16 1.0.0)
# Non-version tags
TAGS=(1 latest stable)

# Images with all datasets and hence non-dataset-specific tags.
for TAG in "${TAGS[@]}"; do
  docker build -t aa8y/sbt:"$TAG" .
done
# Build images for tags named by version.
for VERSION in "${VERSIONS[@]}"; do
  TAG="$(echo $VERSION | sed -E s/-[A-Z]+[0-9]//g)" # Remove RC2 from the tag.
  TAGS+=($TAG)
  docker build -t aa8y/sbt:"$TAG" --build-arg SBT_VERSION="$VERSION" .
done

# If the push flag is set, push all tags.
if [ "$PUSH" == "-p" ]; then
  for TAG in "${TAGS[@]}"; do
    docker push aa8y/sbt:"$TAG"
  done
fi
