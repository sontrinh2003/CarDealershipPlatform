// ─── main.jsx ─────────────────────────────────────────────────────────────────
// Place this in your Vite project's src/ folder.
// It wraps App with the AuthProvider so the auth context is available everywhere.

import React from "react";
import ReactDOM from "react-dom/client";
import { Root } from "./App";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <Root />
  </React.StrictMode>
);

// ─── package.json ─────────────────────────────────────────────────────────────
// Run: npm create vite@latest carstockapi-frontend -- --template react
// Then replace package.json with this (or just run: npm install react react-dom)
// No extra dependencies needed — the frontend uses only React + fetch.

/*
{
  "name": "carstockapi-frontend",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev":   "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react":     "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1",
    "vite": "^5.4.0"
  }
}
*/

// ─── vite.config.js ───────────────────────────────────────────────────────────
// Proxy API calls to the C# backend so you avoid CORS issues in dev.
// Place in project root.

/*
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true,
      }
    }
  }
})
*/

// With this proxy in place, change API_BASE in App.jsx from:
//   const API_BASE = "http://localhost:5000";
// to:
//   const API_BASE = "";
// ...and all /api/* calls will be proxied automatically — no CORS needed in dev.
