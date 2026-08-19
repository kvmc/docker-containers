# RePythonNET-MCP

Self-contained Docker packaging for
[SEKOIA-IO/RePythonNET-MCP](https://github.com/SEKOIA-IO/RePythonNET-MCP).

The image includes Python, Mono, dnlib, ILSpy/dnSpy assemblies, the MCP server,
and all Python dependencies. The upstream source is pinned to commit
`1056cfd480ab3ff344bee2bf023b2e7a9ae4e3fa` for reproducible builds.

## Run

Docker Compose is the only prerequisite:

```bash
docker compose -f compose.yml up --build -d
```

The MCP endpoint is available at `http://localhost:8001/mcp`. Docker creates
the `repythonnet-data` volume automatically, and analysis data survives
container replacement.

Use another host port when necessary:

```bash
REPYTHONNET_PORT=9001 docker compose -f compose.yml up --build -d
```

## Upload a binary

```bash
curl -F file=@sample.dll http://localhost:8001/upload
```

The response contains the container path to pass to the
`pythonnet_load_binary` MCP tool.

## Operations

```bash
docker compose -f compose.yml logs -f
docker compose -f compose.yml ps
docker compose -f compose.yml down
```

To also delete all persisted uploads and analysis results:

```bash
docker compose -f compose.yml down --volumes
```

## Build an importable image

```bash
docker compose -f compose.yml build
docker save repythonnet-mcp:latest | gzip > repythonnet-mcp.tar.gz
```

On another Docker host:

```bash
gzip -dc repythonnet-mcp.tar.gz | docker load
docker run -d --name repythonnet-mcp \
  --restart unless-stopped \
  -p 8001:8001 \
  -v repythonnet-data:/data \
  repythonnet-mcp:latest
```

## Update upstream

Change `REPYTHONNET_COMMIT` in `compose.yml`, or override it for one build:

```bash
REPYTHONNET_COMMIT=<full-commit-sha> docker compose -f compose.yml build
```
