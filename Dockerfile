# Hermes Agent Gateway for Render
# Simplified from official Dockerfile — gateway only, no s6-overlay

# ── Stage 1: Build environment ──────────────────────────────────────────
FROM python:3.13-slim AS builder

WORKDIR /build

# Install system deps for building
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl git && \
    rm -rf /var/lib/apt/lists/*

# Copy hermes-agent source
COPY hermes-agent/ ./

# Install uv and Python deps
COPY --from=ghcr.io/astral-sh/uv:0.11.6 /uv /usr/local/bin/uv
RUN uv sync --frozen --no-install-project --extra all --extra messaging --extra anthropic

# ── Stage 2: Runtime ────────────────────────────────────────────────────
FROM python:3.13-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git ripgrep && \
    rm -rf /var/lib/apt/lists/*

# Copy Python environment from builder
COPY --from=builder /build/.venv /opt/hermes/.venv
COPY --from=builder /build /opt/hermes

# Node.js for TUI and tools
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd -m -u 1000 hermes && \
    mkdir -p /opt/data && chown hermes:hermes /opt/data

# Environment
ENV HERMES_HOME=/opt/data
ENV PATH="/opt/hermes/.venv/bin:${PATH}"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Config volume
VOLUME ["/opt/data"]

USER hermes
WORKDIR /opt/hermes

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Default: run gateway
CMD ["python", "-m", "hermes_cli.main", "gateway", "run"]
