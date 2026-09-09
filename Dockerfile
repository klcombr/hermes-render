# Hermes Agent Gateway for Render (Web Service)
# Installs via pip from PyPI with Telegram + API server support

FROM python:3.13-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git && \
    rm -rf /var/lib/apt/lists/*

# Install Hermes Agent with Telegram and messaging extras
# Install aiohttp separately to avoid version conflicts
RUN pip install --no-cache-dir "hermes-agent[telegram,messaging]" && \
    pip install --no-cache-dir aiohttp python-telegram-bot

# Verify installations
RUN python -c "import aiohttp; print('aiohttp OK')" && \
    python -c "import telegram; print('telegram OK')"

# Non-root user
RUN useradd -m -u 1000 hermes && \
    mkdir -p /opt/data && chown hermes:hermes /opt/data

# Environment
ENV HERMES_HOME=/opt/data
ENV PATH="/home/hermes/.local/bin:${PATH}"
ENV PYTHONUNBUFFERED=1
ENV API_SERVER_PORT=8642
ENV API_SERVER_HOST=0.0.0.0
# API server requires a key for authentication
ENV API_SERVER_KEY=hermes-render-key-2026

USER hermes
WORKDIR /home/hermes

# Copy config
COPY --chown=hermes:hermes config.yaml /opt/data/config.yaml

# Health check against the api_server /health endpoint
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:${API_SERVER_PORT}/health || exit 1

# Run gateway (api_server platform auto-starts with /health)
CMD ["python", "-m", "hermes_cli.main", "gateway", "run"]
