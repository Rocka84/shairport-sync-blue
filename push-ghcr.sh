#!/bin/bash

tag="${1:-latest}"

if ! grep -q ghcr\.io ~/.docker/config.json && [ -f ".pat" ]; then
    cat .pat | docker login ghcr.io -u Rocka84 --password-stdin
fi

echo "Pushing to ghcr.io/rocka84/shairport-sync-blue:$tag"

docker tag rocka84/shairport-sync-blue:"$tag" ghcr.io/rocka84/shairport-sync-blue:"$tag"
docker push ghcr.io/rocka84/shairport-sync-blue:"$tag"

