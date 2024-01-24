#!/bin/bash

set -eo pipefail

if [ "$#" -eq 1 ]; then
    TAG="${1}"
else
    echo "Expected a single argument, the git tag to build and deploy." 2>&1
    exit 1
fi

CODE_DIR=checkout-app

if [ -d "${CODE_DIR}" ]; then
    pushd "${CODE_DIR}"
    git clean -xdf .
    git fetch
    git checkout "${TAG}"
    git pull
else
    git clone https://github.com/fractalate/pakrypt.git "${CODE_DIR}"
    pushd "${CODE_DIR}"
    git checkout "${TAG}"
fi

npm install .
npm run build

rsync -av --delete ./dist/ tulip:/var/www/app.pakrypt.com/

popd
