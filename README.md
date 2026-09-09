# Hermes Agent Gateway for Render

Telegram bot gateway deployed on Render free tier, connected to VansRouter.

## Architecture

```
Telegram → Render (Hermes Gateway) → Render (VansRouter) → AI Providers
```

## Environment Variables

Set these in Render dashboard:

### Required
- `TELEGRAM_BOT_TOKEN` - Your Telegram bot token
- `VANSROUTER_URL` - URL of your VansRouter service (e.g., https://vansrouter.onrender.com)
- `VANSROUTER_API_KEY` - VansRouter API key

### Telegram Webhook (required for cloud deployment)
- `TELEGRAM_WEBHOOK_URL` - Set to: `https://hermes-render.onrender.com/telegram`
- `TELEGRAM_WEBHOOK_SECRET` - Generate with: `openssl rand -hex 32`

### Optional
- `TELEGRAM_ALLOWED_USERS` - Comma-separated user IDs (default: 5789631016)
- `API_SERVER_KEY` - API server authentication key

## Deploy

1. Deploy vansrouter-render first
2. Set `VANSROUTER_URL` to the vansrouter service URL
3. Deploy this service
4. Set webhook env vars in Render dashboard
5. Test by sending a message to your Telegram bot

## Health Check

- `GET /health` - Returns service status (used by Render for health checks)
