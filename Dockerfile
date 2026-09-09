# Hermes Agent Gateway for Render (Web Service)
# Installs via pip from PyPI

FROM python:3.13-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git && \
    rm -rf /var/lib/apt/lists/*

# Install Hermes Agent via pip
RUN pip install --no-cache-dir hermes-agent

# Non-root user
RUN useradd -m -u 1000 hermes && \
    mkdir -p /opt/data && chown hermes:hermes /opt/data

# Environment
ENV HERMES_HOME=/opt/data
ENV PATH="/home/hermes/.local/bin:${PATH}"
ENV PYTHONUNBUFFERED=1
ENV API_SERVER_PORT=8642
ENV API_SERVER_HOST=0.0.0.0

USER hermes
WORKDIR /home/hermes

# Copy config
COPY --chown=hermes:hermes config.yaml /opt/data/config.yaml

# Health check against the api_server /health endpoint
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:${API_SERVER_PORT}/health || exit 1

# Run gateway (api_server platform auto-starts with /health)
CMD ["python", "-m", "hermes_cli.main", "gateway", "run"]
