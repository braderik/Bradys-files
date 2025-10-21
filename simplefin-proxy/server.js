import express from "express";
import fetch from "node-fetch";
import dotenv from "dotenv";
dotenv.config();

const app = express();
app.use(express.json());

const SIMPLEFIN_BASE = process.env.SIMPLEFIN_BASE || "https://beta-bridge.simplefin.org";
const SIMPLEFIN_TOKEN = process.env.SIMPLEFIN_TOKEN;
const API_KEY = process.env.API_KEY;

// Require x-api-key on every request
app.use((req, res, next) => {
  const k = req.header("x-api-key");
  if (!API_KEY || k === API_KEY) return next();
  return res.status(401).json({ error: "unauthorized" });
});

app.get("/health", (_, res) => res.json({ ok: true }));

app.get("/api/accounts", async (_, res) => {
  try {
    const r = await fetch(`${SIMPLEFIN_BASE}/accounts`, {
      headers: { Authorization: `Bearer ${SIMPLEFIN_TOKEN}`, Accept: "application/json" }
    });
    if (!r.ok) return res.status(r.status).send(await r.text());
    return res.json(await r.json());
  } catch (err) {
    return res.status(500).json({ error: String(err?.message || err) });
  }
});

app.get("/api/accounts/:id/transactions", async (req, res) => {
  const { id } = req.params;
  const since = req.query.since || "2025-09-01";
  try {
    const r = await fetch(
      `${SIMPLEFIN_BASE}/accounts/${encodeURIComponent(id)}/transactions?since=${since}`,
      { headers: { Authorization: `Bearer ${SIMPLEFIN_TOKEN}`, Accept: "application/json" } }
    );
    if (!r.ok) return res.status(r.status).send(await r.text());
    return res.json(await r.json());
  } catch (err) {
    return res.status(500).json({ error: String(err?.message || err) });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`simplefin-proxy listening on :${port}`));
