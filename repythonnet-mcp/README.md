# RePythonNET-MCP container

This directory is the build source for the prebuilt RePythonNET-MCP image
published in this repository's releases. Users do not need to build it.

## Download and run

Download `repythonnet-mcp-bundle-amd64.tar.gz` from the
[latest release](https://github.com/kvmc/docker-containers/releases/tag/repythonnet-mcp-latest),
then run:

```bash
tar -xzf repythonnet-mcp-bundle-amd64.tar.gz
chmod +x run.sh
./run.sh
```

The bundle contains:

- `repythonnet-mcp-image-amd64.tar` — the complete Docker image
- `run.sh` — imports the image and starts the container

The MCP endpoint is available at `http://localhost:8001/mcp`. Uploads and
analysis results are stored in the Docker-managed `repythonnet-data` volume.

Use another host port:

```bash
REPYTHONNET_PORT=9001 ./run.sh
```

## Upload a binary

```bash
curl -F file=@sample.dll http://localhost:8001/upload
```

## Manage the container

```bash
docker logs -f repythonnet-mcp
docker stop repythonnet-mcp
docker start repythonnet-mcp
```

The image contains Python, Mono, dnlib, ILSpy/dnSpy, the MCP server, and all
runtime dependencies. It is pinned to upstream commit
`1056cfd480ab3ff344bee2bf023b2e7a9ae4e3fa`.
