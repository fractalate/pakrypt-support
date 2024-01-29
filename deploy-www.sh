#!/bin/bash

set -eo pipefail

if [ "$#" -eq 1 ]; then
    TAG="${1}"
else
    echo "Expected a single argument, the git tag to build and deploy." 2>&1
    exit 1
fi

WEB_HOST=tulip
CODE_DIR=checkout-www

if [ -d "${CODE_DIR}" ]; then
    pushd "${CODE_DIR}"
    git clean -xdf .
    git checkout main
    git pull
    git checkout "${TAG}"
else
    git clone https://github.com/fractalate/www.pakrypt.com.git "${CODE_DIR}"
    pushd "${CODE_DIR}"
    git checkout "${TAG}"
fi

TIMESTAMP=$( date )
COMMIT=$( git rev-parse HEAD )

echo "deploy time: ${TIMESTAMP}" > deployment_metadata.txt
echo "git commit hash: ${COMMIT}" >> deployment_metadata.txt

rsync -av --delete --exclude=.git/ ./ "${WEB_HOST}:/var/www/www.pakrypt.com/"

popd
