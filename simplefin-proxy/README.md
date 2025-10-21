# SimpleFIN Proxy (Render-ready)

## Endpoints
- `GET /health`
- `GET /api/accounts`
- `GET /api/accounts/:id/transactions?since=YYYY-MM-DD`

### Auth
Send header `x-api-key: <API_KEY>`

### Env Vars (Render)
- `SIMPLEFIN_TOKEN` (required) — from SimpleFIN Bridge
- `API_KEY` (required) — shared secret for callers
- `SIMPLEFIN_BASE` (optional) — default `https://beta-bridge.simplefin.org`

### Deploy on Render
1. Push this repo to GitHub.
2. In Render → **New → Web Service → From repo**
3. Build: `npm install` • Start: `npm start`
4. Add environment variables in Render dashboard:
   - `SIMPLEFIN_TOKEN=...`
   - `API_KEY=...`
5. Test:  
   - `GET https://<your-app>.onrender.com/health`  
   - `curl -H "x-api-key: <API_KEY>" https://<your-app>.onrender.com/api/accounts`
