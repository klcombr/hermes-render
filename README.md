# Hermes Agent Gateway for Render

Telegram bot gateway deployed on Render, connected to VansRouter.

## Architecture

```
Telegram → Render (Hermes Gateway) → Render (VansRouter) → AI Providers
```

## Environment Variables

Set these in Render dashboard:

- `TELEGRAM_BOT_TOKEN` - Your Telegram bot token
- `TELEGRAM_ALLOWED_USERS` - Comma-separated user IDs (default: 5789631016)
- `VANSROUTER_URL` - URL of your VansRouter service (e.g., https://vansrouter.onrender.com)
- `VANSROUTER_API_KEY` - VansRouter API key

## Deploy

1. Deploy vansrouter-render first
2. Set VANSROUTER_URL to the vansrouter service URL
3. Deploy this service
4. Test by sending a message to your Telegram bot

## Health Check

- `GET /health` - Returns service status
