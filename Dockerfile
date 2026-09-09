# Hermes Agent Gateway for Render (Web Service)
# Telegram webhook mode + API server for health checks

FROM python:3.13-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git && \
    rm -rf /var/lib/apt/lists/*

# Install Hermes Agent core + telegram-specific deps
# Skip [messaging] extra (pulls discord.py, slack, etc. - not needed)
# Install core hermes-agent + telegram deps explicitly
RUN pip install --no-cache-dir "hermes-agent" && \
    pip install --no-cache-dir "python-telegram-bot[webhooks]==22.8" "aiohttp==3.14.3"

# Verify critical deps
RUN python -c "import aiohttp; print('aiohttp OK:', aiohttp.__version__)" && \
    python -c "import telegram; print('telegram OK')" && \
    python -c "import fastapi; print('fastapi OK')" && \
    python -c "import uvicorn; print('uvicorn OK')"

# Non-root user
RUN useradd -m -u 1000 hermes && \
    mkdir -p /opt/data && chown hermes:hermes /opt/data

# Environment
ENV HERMES_HOME=/opt/data
ENV PYTHONUNBUFFERED=1

# API server for Render health checks
ENV API_SERVER_PORT=8642
ENV API_SERVER_HOST=0.0.0.0
ENV API_SERVER_KEY=hermes-render-key-2026

# Telegram - webhook mode for cloud deployment
# Set TELEGRAM_WEBHOOK_URL in Render dashboard to: https://hermes-render.onrender.com/telegram
# Set TELEGRAM_WEBHOOK_SECRET in Render dashboard (generate with: openssl rand -hex 32)
# Set TELEGRAM_BOT_TOKEN in Render dashboard
ENV TELEGRAM_WEBHOOK_PORT=8443

USER hermes
WORKDIR /home/hermes

# Copy config and skills
COPY --chown=hermes:hermes config.yaml /opt/data/config.yaml
COPY --chown=hermes:hermes skills/ /opt/data/skills/

# Health check against the api_server /health endpoint
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:${API_SERVER_PORT}/health || exit 1

# Run gateway (api_server + telegram platforms)
CMD ["python", "-m", "hermes_cli.main", "gateway", "run"]
