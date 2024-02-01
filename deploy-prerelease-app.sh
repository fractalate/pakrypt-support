#!/bin/bash

set -eo pipefail

if [ "$#" -eq 1 ]; then
    TAG="${1}"
else
    echo "Expected a single argument, the git tag to build and deploy." 2>&1
    exit 1
fi

WEB_HOST=tulip
CODE_DIR=checkout-prerelease-app

if [ -d "${CODE_DIR}" ]; then
    pushd "${CODE_DIR}"
    git clean -xdf .
    git checkout main
    git pull
    git checkout "${TAG}"
    git pull || true # TODO: Not great, but okay for now.
else
    git clone https://github.com/fractalate/pakrypt.git "${CODE_DIR}"
    pushd "${CODE_DIR}"
    git checkout "${TAG}"
fi

TIMESTAMP=$( date )
COMMIT=$( git rev-parse HEAD )

npm ci .
npm run build

echo "deploy time: ${TIMESTAMP}" > ./dist/deployment_metadata.txt
echo "git commit hash: ${COMMIT}" >> ./dist/deployment_metadata.txt

# -p so there is no error if it exists already.
ssh "${WEB_HOST}" mkdir -p "/var/www/app.pakrypt.com/pakrypt.version:prerelease/"
rsync -av --delete ./dist/ "${WEB_HOST}:/var/www/app.pakrypt.com/pakrypt.version:prerelease/"

popd
