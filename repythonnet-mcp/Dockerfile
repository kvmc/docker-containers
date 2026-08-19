FROM python:3.11-slim

ARG REPYTHONNET_COMMIT=1056cfd480ab3ff344bee2bf023b2e7a9ae4e3fa

LABEL org.opencontainers.image.title="RePythonNET-MCP" \
      org.opencontainers.image.description="MCP server for .NET reverse engineering" \
      org.opencontainers.image.source="https://github.com/SEKOIA-IO/RePythonNET-MCP" \
      org.opencontainers.image.revision="${REPYTHONNET_COMMIT}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        mono-complete \
        tini \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN curl --fail --location --silent --show-error \
        "https://github.com/SEKOIA-IO/RePythonNET-MCP/archive/${REPYTHONNET_COMMIT}.tar.gz" \
        | tar --extract --gzip --strip-components=1

RUN pip install --no-cache-dir -r requirements.txt \
    && mkdir -p /data/pythonnet_projects /data/samples

ENV PYTHONUNBUFFERED=1 \
    PYTHONNET_PROJECTS_DIR=/data/pythonnet_projects \
    SAMPLES_DIR=/data/samples

EXPOSE 8001
VOLUME ["/data"]

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=3 \
    CMD python -c "import socket; s=socket.create_connection(('127.0.0.1', 8001), 3); s.close()"

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["python", "server.py", "--host", "0.0.0.0", "--port", "8001"]
