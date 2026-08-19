#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
IMAGE_ARCHIVE="$SCRIPT_DIR/repythonnet-mcp-image-amd64.tar"
IMAGE="${REPYTHONNET_IMAGE:-repythonnet-mcp:latest}"
NAME="${REPYTHONNET_NAME:-repythonnet-mcp}"
PORT="${REPYTHONNET_PORT:-8001}"
VOLUME="${REPYTHONNET_VOLUME:-repythonnet-data}"

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required but was not found." >&2
    exit 1
fi

if [ ! -f "$IMAGE_ARCHIVE" ]; then
    echo "Image archive not found: $IMAGE_ARCHIVE" >&2
    exit 1
fi

echo "Importing RePythonNET-MCP image..."
docker load --input "$IMAGE_ARCHIVE"

if docker container inspect "$NAME" >/dev/null 2>&1; then
    echo "Replacing existing container: $NAME"
    docker rm --force "$NAME" >/dev/null
fi

docker volume create "$VOLUME" >/dev/null

docker run --detach \
    --name "$NAME" \
    --restart unless-stopped \
    --publish "$PORT:8001" \
    --volume "$VOLUME:/data" \
    "$IMAGE" >/dev/null

echo "RePythonNET-MCP is starting."
echo "MCP endpoint: http://localhost:$PORT/mcp"
echo "Logs: docker logs -f $NAME"
