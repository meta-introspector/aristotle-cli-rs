/**
 * Error telemetry for Cloudflare Pages deployment.
 * Logs 404 errors, runtime errors, and deployment status.
 */
import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';

const LOG_DIR = '/mnt/data1/kant/pastebin/logs';
const TELEMETRY_FILE = path.join(LOG_DIR, 'telemetry.jsonl');

fs.mkdirSync(LOG_DIR, { recursive: true });

export function logTelemetry(event, data = {}) {
  const entry = {
    timestamp: new Date().toISOString(),
    event,
    ...data
  };
  fs.appendFileSync(TELEMETRY_FILE, JSON.stringify(entry) + '\n');
  console.error(`[TELEMETRY] ${event}:`, JSON.stringify(data));
}

export async function checkPageHealth(url) {
  try {
    const res = await fetch(url, { headers: { accept: 'text/html' } });
    const html = await res.text();
    const has404 = html.includes('This page could not be found');
    const hasError = html.includes('error') || html.includes('Error');
    const statusCode = res.status;
    
    logTelemetry('page_health_check', {
      url,
      status: statusCode,
      has404,
      hasError,
      htmlSize: html.length,
      healthy: !has404 && statusCode === 200
    });
    
    return { status: statusCode, has404, hasError, healthy: !has404 && statusCode === 200 };
  } catch (err) {
    logTelemetry('page_health_error', { url, error: err.message });
    return { status: 0, has404: true, hasError: true, healthy: false, error: err.message };
  }
}

export function logDeployment(project, url, bytes, error = null) {
  logTelemetry('deployment', {
    project,
    url,
    bytes,
    error: error?.message || null,
    timestamp: new Date().toISOString()
  });
}

export function logRuntimeError(pageUrl, errorType, details) {
  logTelemetry('runtime_error', {
    pageUrl,
    errorType,
    details,
    userAgent: 'Cloudflare-Pages'
  });
}

// CLI usage: node scripts/error-telemetry.mjs check <url>
if (process.argv[2] === 'check') {
  const url = process.argv[3] || 'https://gui2proof-aristo-test.pages.dev/';
  checkPageHealth(url).then(r => {
    console.log(`Health: ${r.healthy ? '✅ OK' : '❌ ERROR'}`);
    console.log(`Status: ${r.status}`);
    console.log(`404: ${r.has404}`);
    process.exit(r.healthy ? 0 : 1);
  });
}
