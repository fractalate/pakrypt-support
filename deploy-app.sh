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

if [ -d "${CODE_DIR}" ]; then
    pushd "${CODE_DIR}"
    git clean -xdf .
    git checkout main
    git pull
    git checkout "${TAG}"
else
    git clone https://github.com/fractalate/pakrypt.git "${CODE_DIR}"
    pushd "${CODE_DIR}"
    git checkout "${TAG}"
fi

TIMESTAMP=$( date )
COMMIT=$( git rev-parse HEAD )

npm install .
npm run build

echo "deploy time: ${TIMESTAMP}" > ./dist/deployment_metadata.txt
echo "git commit hash: ${COMMIT}" >> ./dist/deployment_metadata.txt

rsync -av --delete ./dist/ "${WEB_HOST}:/var/www/app.pakrypt.com/"

popd
