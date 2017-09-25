#!/bin/sh
set -eu

: ${1?"Must provide version"}
version="$1"

#remove node_modules for safety
echo "deleting node_modules"
rm -rf node_modules

#build the javascript assets
echo "compiling static assets"
docker run -v $PWD:/usr/src/app -w /usr/src/app node:7.7-alpine /bin/sh -c "npm i && npm run build"

#create the final image
echo "building elixir image"
docker build -t gcr.io/corsada-157602/media-sites:"$version" -f ./Dockerfile ../..
