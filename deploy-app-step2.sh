#!/bin/bash

set -eo pipefail

if [ "$#" -eq 1 ]; then
    TAG="${1}"
else
    echo "Expected a single argument, the git tag to build and deploy." 2>&1
    exit 1
fi

WEB_HOST=tulip
CODE_DIR=checkout-app

pushd "${CODE_DIR}"

rsync -av --delete "--exclude=pakrypt.version:prerelease" "./pakrypt-${TAG}/" "${WEB_HOST}:/var/www/app.pakrypt.com/"

popd
