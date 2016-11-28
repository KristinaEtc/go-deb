#!/bin/bash
COMMIT_INFO="$(git describe --tags --dirty --always)"
echo "${COMMIT_INFO}"

GIT_BRANCH="$(git symbolic-ref -q --short HEAD)"
echo "${GIT_BRANCH}"

VERSION="$(git describe --tags --dirty --always)-$(git symbolic-ref -q --short HEAD)"
echo "${VERSION}"
