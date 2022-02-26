#!/bin/sh
set -e

EXPLORER_VERSION=9.12.3


echo "Fetching explorer $EXPLORER_VERSION source"
curl -L https://github.com/ergoplatform/explorer-backend/archive/refs/tags/$EXPLORER_VERSION.tar.gz > explorer-backend-$EXPLORER_VERSION.tar.gz

echo "Extracting explorer source"
rm -rf explorer-backend/$EXPLORER_VERSION
tar -xf explorer-backend-$EXPLORER_VERSION.tar.gz
rm explorer-backend-$EXPLORER_VERSION.tar.gz

echo "Preparing grabber Dockerfile"
cp explorer-backend-$EXPLORER_VERSION/modules/chain-grabber/Dockerfile explorer-backend-$EXPLORER_VERSION/chain-grabber.Dockerfile

echo "Preparing api Dockerfile"
cp explorer-backend-$EXPLORER_VERSION/modules/explorer-api/Dockerfile explorer-backend-$EXPLORER_VERSION/explorer-api.Dockerfile

echo "Done."
