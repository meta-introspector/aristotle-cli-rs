// ─────────────────────────────────────────────────────────────────────
// Aristotle Alias Editor — Cloudflare Worker
// Serves the static HTML editor and proxies API calls to the origin.
// ─────────────────────────────────────────────────────────────────────

const HTML = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Aristotle Alias Editor</title>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #e2e8f0; padding: 2rem; }
h1 { font-size: 1.5rem; margin-bottom: 1rem; color: #38bdf8; }
.controls { display: flex; gap: 1rem; margin-bottom: 1rem; flex-wrap: wrap; align-items: center; }
.controls input, .controls select { background: #1e293b; border: 1px solid #334155; color: #e2e8f0; padding: 0.5rem; border-radius: 0.375rem; }
.controls button { background: #0ea5e9; color: white; border: none; padding: 0.5rem 1rem; border-radius: 0.375rem; cursor: pointer; font-weight: 500; }
.controls button:hover { background: #0284c7; }
.controls button.danger { background: #ef4444; }
.controls button.danger:hover { background: #dc2626; }
.controls .stats { color: #94a3b8; font-size: 0.875rem; }
table { width: 100%; border-collapse: collapse; background: #1e293b; border-radius: 0.5rem; overflow: hidden; }
th, td { padding: 0.75rem 1rem; text-align: left; border-bottom: 1px solid #334155; }
th { background: #0f172a; font-weight: 600; color: #38bdf8; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; }
tr:hover { background: #334155; }
td input { width: 100%; background: #0f172a; border: 1px solid #334155; color: #e2e8f0; padding: 0.375rem 0.5rem; border-radius: 0.25rem; font-family: monospace; }
td input:focus { outline: none; border-color: #0ea5e9; }
td .uuid { font-family: monospace; font-size: 0.8rem; color: #94a3b8; }
.actions { display: flex; gap: 0.5rem; }
.actions button { padding: 0.25rem 0.5rem; font-size: 0.75rem; border-radius: 0.25rem; border: none; cursor: pointer; }
.btn-save { background: #22c55e; color: white; }
.btn-save:hover { background: #16a34a; }
.btn-delete { background: #ef4444; color: white; }
.btn-delete:hover { background: #dc2626; }
.toast { position: fixed; bottom: 2rem; right: 2rem; background: #22c55e; color: white; padding: 1rem 1.5rem; border-radius: 0.5rem; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.3); transform: translateY(100px); transition: transform 0.3s ease; }
.toast.show { transform: translateY(0); }
.toast.error { background: #ef4444; }
#empty { text-align: center; padding: 3rem; color: #64748b; }
</style>
</head>
<body>
<h1>🏛️ Aristotle Alias Editor</h1>
<div class="controls">
  <input type="text" id="search" placeholder="Search aliases..." oninput="render()">
  <select id="filter" onchange="render()">
    <option value="all">All</option>
    <option value="untagged">Untagged only</option>
    <option value="tagged">Tagged only</option>
  </select>
  <input type="text" id="tagFilter" placeholder="Filter by tag..." oninput="render()">
  <button onclick="saveAll()">Save All Changes</button>
  <button class="danger" onclick="if(confirm('Delete ALL aliases?'))deleteAll()">Delete All</button>
  <span class="stats" id="stats"></span>
</div>
<table>
  <thead>
    <tr>
      <th style="width: 25%">Alias Name</th>
      <th style="width: 40%">Description</th>
      <th style="width: 25%">UUID</th>
      <th style="width: 10%">Actions</th>
    </tr>
  </thead>
  <tbody id="table"></tbody>
</table>
<div id="empty"></div>
<div class="toast" id="toast"></div>

<script>
const API = '';
let aliases = {};
let dirty = false;

async function load() {
  try {
    const res = await fetch('/api/v3/aliases');
    const data = await res.json();
    aliases = data.mappings || {};
    dirty = false;
    render();
  } catch (e) {
    showToast('Failed to load aliases: ' + e.message, true);
  }
}

function render() {
  const search = document.getElementById('search').value.toLowerCase();
  const filter = document.getElementById('filter').value;
  const tagFilter = document.getElementById('tagFilter').value.toLowerCase();
  const tbody = document.getElementById('table');
  const empty = document.getElementById('empty');
  tbody.innerHTML = '';

  const entries = Object.entries(aliases).filter(([name, uuid]) => {
    if (search && !name.includes(search) && !uuid.includes(search)) return false;
    if (filter === 'untagged' && (data.tags && data.tags[uuid])) return false;
    if (filter === 'tagged' && !(data.tags && data.tags[uuid])) return false;
    if (tagFilter && !(data.tags && data.tags[uuid] && data.tags[uuid].includes(tagFilter))) return false;
    return true;
  });

  document.getElementById('stats').textContent = entries.length + ' aliases' + (dirty ? ' (unsaved changes)' : '');

  if (entries.length === 0) {
    empty.style.display = 'block';
    empty.textContent = 'No aliases found.';
    return;
  }
  empty.style.display = 'none';

  entries.sort((a, b) => a[0].localeCompare(b[0]));

  for (const [name, uuid] of entries) {
    const tr = document.createElement('tr');
    tr.innerHTML = '<td><input type="text" value="' + escapeHtml(name) + '" data-uuid="' + escapeHtml(uuid) + '"></td>' +
      '<td><div class="uuid">' + escapeHtml(uuid) + '</div></td>' +
      '<td><div class="uuid">' + escapeHtml(uuid) + '</div></td>' +
      '<td class="actions">' +
      '<button class="btn-save" onclick="saveOne(\'' + escapeHtml(uuid) + '\')">Save</button>' +
      '<button class="btn-delete" onclick="deleteOne(\'' + escapeHtml(uuid) + '\')">Del</button>' +
      '</td>';
    tbody.appendChild(tr);
  }
}

async function saveAll() {
  const inputs = document.querySelectorAll('input[data-uuid]');
  const updates = {};
  for (const input of inputs) {
    const newName = input.value.trim();
    const uuid = input.dataset.uuid;
    if (newName && aliases[input.dataset.uuid] && newName !== Object.keys(aliases).find(k => aliases[k] === uuid)) {
      updates[uuid] = newName;
    }
  }
  try {
    const res = await fetch('/api/v3/aliases/batch', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({updates})
    });
    if (res.ok) {
      dirty = false;
      showToast('Saved!');
      load();
    } else {
      showToast('Save failed', true);
    }
  } catch (e) {
    showToast('Save failed: ' + e.message, true);
  }
}

async function saveOne(uuid) {
  const input = document.querySelector('input[data-uuid="' + uuid + '"]');
  const newName = input.value.trim();
  if (!newName) return;
  try {
    const res = await fetch('/api/v3/aliases/set', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({name: newName, uuid})
    });
    if (res.ok) {
      dirty = false;
      showToast('Saved!');
      load();
    } else {
      showToast('Save failed', true);
    }
  } catch (e) {
    showToast('Save failed: ' + e.message, true);
  }
}

async function deleteOne(uuid) {
  if (!confirm('Delete alias for ' + uuid + '?')) return;
  try {
    const res = await fetch('/api/v3/aliases/remove', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({uuid})
    });
    if (res.ok) {
      showToast('Deleted!');
      load();
    } else {
      showToast('Delete failed', true);
    }
  } catch (e) {
    showToast('Delete failed: ' + e.message, true);
  }
}

async function deleteAll() {
  try {
    const res = await fetch('/api/v3/aliases/clear', {method: 'POST'});
    if (res.ok) {
      showToast('All aliases deleted!');
      load();
    } else {
      showToast('Delete all failed', true);
    }
  } catch (e) {
    showToast('Delete all failed: ' + e.message, true);
  }
}

function escapeHtml(s) {
  return s.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

function showToast(msg, isError) {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.className = 'toast show' + (isError ? ' error' : '');
  setTimeout(() => t.className = 'toast', 3000);
}

load();
</script>
</body>
</html>`;

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);

    // CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      });
    }

    // API proxy — forward to origin
    if (url.pathname.startsWith('/api/v3/aliases')) {
      const origin = 'https://solana.solfunmeme.com';
      const resp = await fetch(origin + url.pathname + url.search, {
        method: request.method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: request.method !== 'GET' ? await request.text() : undefined,
      });
      return new Response(resp.body, {
        status: resp.status,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      });
    }

    // Serve the HTML editor
    return new Response(HTML, {
      headers: {
        'Content-Type': 'text/html;charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    });
  },
};
