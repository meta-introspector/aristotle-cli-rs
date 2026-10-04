// mathlib-split-oleans worker — serves per-decl oleans from Workers KV/R2.
// Deployed by .github/workflows/gokujo-deploy.yml (cloudflare-publish job).
// Gokujo: the oleans are compiled once in CI and published here; the
// edge serves them — no local disk IO at all.

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    // GET /oleans/manifest.json — the sha256 manifest from publish-artifacts
    // GET /oleans/<Decl>.olean — per-decl olean bytes
    const key = url.pathname.replace(/^\/oleans\//, "");
    if (url.pathname === "/manifest.json") {
      const manifest = await env.OLEANS.get("manifest.json");
      if (manifest === null) return new Response("manifest not published yet", { status: 404 });
      return new Response(manifest, {
        headers: { "content-type": "application/json", "cache-control": "no-cache" },
      });
    }
    if (!key || key.includes("..")) {
      return new Response("mathlib-split-oleans: GET /manifest.json or /oleans/<Decl>.olean", { status: 200 });
    }
    const value = await env.OLEANS.get(key);
    if (value === null) {
      return new Response(`olean not found: ${key}`, { status: 404 });
    }
    return new Response(value, {
      headers: {
        "content-type": "application/octet-stream",
        "cache-control": "public, max-age=31536000, immutable",
      },
    });
  },
};
