#!/bin/sh

PUSH=$1

# SBT Versions
VERSIONS=(0.13.15 0.13.16)
# Non-version tags
TAGS=(0.13 latest stable)

# Build images for pushing/use.
for VERSION in "${VERSIONS[@]}"; do
  docker build -t aa8y/sbt:"$VERSION" --build-arg SBT_VERSION="$VERSION" .
done
# Images with all datasets and hence non-dataset-specific tags.
for TAG in "${TAGS[@]}"; do
  docker build -t aa8y/sbt:"$TAG" .
done

# Update TAGS to contain all tags.
for TAG in "${VERSIONS[@]}"; do
  TAGS+=($TAG)
done
# If the push flag is set, push all tags.
if [ "$PUSH" == "-p" ]; then
  for TAG in "${TAGS[@]}"; do
    docker push aa8y/sbt:"$TAG"
  done
fi
