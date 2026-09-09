# Hermes Agent Gateway for Render (Web Service)
# Uses official Hermes Agent Docker image

FROM ghcr.io/nousresearch/hermes-agent:latest

# Environment for Render
ENV HERMES_HOME=/opt/data
ENV API_SERVER_PORT=8642
ENV API_SERVER_HOST=0.0.0.0

# Copy config
COPY --chown=hermes:hermes config.yaml /opt/data/config.yaml

# Health check against the api_server /health endpoint
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:${API_SERVER_PORT}/health || exit 1

# Run gateway (api_server platform auto-starts with /health)
CMD ["python", "-m", "hermes_cli.main", "gateway", "run"]
