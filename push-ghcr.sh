#!/bin/bash

if ! grep -q ghcr\.io ~/.docker/config.json && [ -f ".pat" ]; then
    cat .pat | docker login ghcr.io -u Rocka84 --password-stdin
fi

docker tag rocka84/shairport-sync-blue:latest ghcr.io/rocka84/shairport-sync-blue:latest
docker push ghcr.io/rocka84/shairport-sync-blue:latest

