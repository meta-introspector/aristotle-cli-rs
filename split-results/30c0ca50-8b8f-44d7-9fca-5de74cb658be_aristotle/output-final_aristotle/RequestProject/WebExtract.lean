import RequestProject.GodelBrainrot
import RequestProject.GameDSL

/-!
# Gödel Brainrot — extracting a Rust + Web playable app *from Lean*

This module turns the machine-verified Lean game core (`GodelBrainrot`) into a
runnable **Rust/Web application**. Lean is the single source of truth: it

1. recomputes the Gödel codes of a brainrot corpus with the verified
   `encodeBrainrot`, and emits them as a Rust **oracle test suite**, so the
   extracted Rust core is checked against Lean's own numbers (`cargo test`);
2. writes a self-contained, dependency-free **Rust crate** (`webapp/`) — a tiny
   `std`-only HTTP server that serves the game and exposes a `/api/encode`
   endpoint backed by a Rust re-implementation of `encodeBrainrot`;
3. writes the **browser frontend** (`index.html` + `app.js` + `style.css`): a
   playable single-page "steal my brainrot" game using JS `BigInt` for the Gödel
   numbers, mirroring the Lean semantics for `steal` / `fight` / Gödel-slap.

Run the extractor with `#eval GodelBrainrot.Web.writeWebapp` (at the bottom),
then in the generated folder run `cargo run` and open `http://127.0.0.1:8080`.

Nothing here is axiomatic; the generated Rust is validated against Lean-computed
values via `encodeBrainrot`.
-/

namespace GodelBrainrot.Web

open GodelBrainrot

/-! ## The brainrot corpus that seeds the app (and the oracle tests) -/

/-- Named brainrot used both to seed the game and to generate Rust oracle tests. -/
def corpus : List (String × Brainrot) :=
  [ ("sigma",     ⟨["sigma", "looks", "maxing"]⟩),
    ("fanum",     ⟨["fanum", "tax", "rizzler"]⟩),
    ("skibidi",   ⟨["skibidi", "toilet", "incompleteness"]⟩),
    ("ohio",      ⟨["ohio", "rizz"]⟩),
    ("gyatt",     ⟨["gyatt"]⟩),
    ("principia", ⟨["principia", "mathematica", "brainrot"]⟩),
    ("ramanujan", ⟨["ramanujan"]⟩) ]

/-- Render one token list as a Rust `&[&str]` argument. -/
private def rustTokens (b : Brainrot) : String :=
  "&[" ++ String.intercalate ", " (b.tokens.map (fun t => "\"" ++ t ++ "\"")) ++ "]"

/-- Render the corpus as a JS array literal of `{name, tokens}` records. -/
private def jsCorpus : String :=
  let row := fun (nm : String) (b : Brainrot) =>
    let toks := String.intercalate ", " (b.tokens.map (fun t => "\"" ++ t ++ "\""))
    "  {name: \"" ++ nm ++ "\", tokens: [" ++ toks ++ "]}"
  "[\n" ++ String.intercalate ",\n" (corpus.map (fun p => row p.1 p.2)) ++ "\n]"

/-! ## Generated artifacts -/

/-- `Cargo.toml` for the extracted crate. -/
def cargoToml : String := r#"[package]
name = "godel_brainrot_webapp"
version = "0.1.0"
edition = "2021"
description = "Gödel Brainrot Stealer — extracted from a verified Lean 4 core"

[[bin]]
name = "godel_brainrot_webapp"
path = "src/main.rs"

[profile.release]
opt-level = 2
"#

/-- The Rust core + HTTP server (everything except the Lean-generated oracle tests,
which are appended by `rustMain`). -/
private def rustCore : String := r#"// ============================================================================
//  Gödel Brainrot Stealer — Rust core extracted from the verified Lean module
//  `RequestProject/GodelBrainrot.lean`.  Do not edit by hand: regenerate by
//  running `#eval GodelBrainrot.Web.writeWebapp` in Lean.
//
//  std-only: no external crates, no network access required to build.
// ============================================================================

use std::io::{Read, Write};
use std::net::TcpListener;

// ---- Verified game core (mirrors GodelBrainrot.lean) -----------------------

/// Prime table; we fall back to 2 past the end, exactly like the Lean `primes`.
const PRIMES: [u64; 12] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

fn prime_at(i: usize) -> u64 {
    if i < PRIMES.len() { PRIMES[i] } else { 2 }
}

// A tiny base-1e9 big natural number (little-endian limbs).
const BASE: u64 = 1_000_000_000;

fn mul_small(n: &mut Vec<u64>, m: u64) {
    let mut carry: u64 = 0;
    for limb in n.iter_mut() {
        let prod = *limb * m + carry;
        *limb = prod % BASE;
        carry = prod / BASE;
    }
    while carry > 0 {
        n.push(carry % BASE);
        carry /= BASE;
    }
}

fn bignum_to_string(n: &Vec<u64>) -> String {
    if n.is_empty() {
        return "0".to_string();
    }
    let mut s = String::new();
    let mut first = true;
    for limb in n.iter().rev() {
        if first {
            s.push_str(&format!("{}", limb));
            first = false;
        } else {
            s.push_str(&format!("{:09}", limb));
        }
    }
    s
}

/// Gödel numbering: product of prime_at(i) ^ (char-length of i-th token).
/// This is the verified `encodeBrainrot` re-expressed in Rust.
pub fn encode(tokens: &[&str]) -> String {
    let mut n: Vec<u64> = vec![1];
    for (i, t) in tokens.iter().enumerate() {
        let p = prime_at(i);
        let len = t.chars().count();
        for _ in 0..len {
            mul_small(&mut n, p);
        }
    }
    bignum_to_string(&n)
}

// ---- Minimal HTTP plumbing -------------------------------------------------

const INDEX_HTML: &str = include_str!("../static/index.html");
const APP_JS: &str = include_str!("../static/app.js");
const STYLE_CSS: &str = include_str!("../static/style.css");

fn percent_decode(s: &str) -> String {
    let bytes = s.as_bytes();
    let mut out = Vec::with_capacity(bytes.len());
    let mut i = 0;
    while i < bytes.len() {
        match bytes[i] {
            b'+' => {
                out.push(b' ');
                i += 1;
            }
            b'%' if i + 2 < bytes.len() => {
                let hi = (bytes[i + 1] as char).to_digit(16);
                let lo = (bytes[i + 2] as char).to_digit(16);
                if let (Some(h), Some(l)) = (hi, lo) {
                    out.push((h * 16 + l) as u8);
                    i += 3;
                } else {
                    out.push(bytes[i]);
                    i += 1;
                }
            }
            b => {
                out.push(b);
                i += 1;
            }
        }
    }
    String::from_utf8_lossy(&out).to_string()
}

fn query_param(query: &str, key: &str) -> Option<String> {
    for pair in query.split('&') {
        let mut it = pair.splitn(2, '=');
        let k = it.next().unwrap_or("");
        let v = it.next().unwrap_or("");
        if k == key {
            return Some(percent_decode(v));
        }
    }
    None
}

fn http_response(status: &str, content_type: &str, body: &str) -> String {
    format!(
        "HTTP/1.1 {}\r\nContent-Type: {}\r\nContent-Length: {}\r\nAccess-Control-Allow-Origin: *\r\nConnection: close\r\n\r\n{}",
        status,
        content_type,
        body.as_bytes().len(),
        body
    )
}

fn route(method: &str, path: &str, query: &str) -> String {
    match (method, path) {
        ("GET", "/") | ("GET", "/index.html") => {
            http_response("200 OK", "text/html; charset=utf-8", INDEX_HTML)
        }
        ("GET", "/app.js") => {
            http_response("200 OK", "application/javascript; charset=utf-8", APP_JS)
        }
        ("GET", "/style.css") => {
            http_response("200 OK", "text/css; charset=utf-8", STYLE_CSS)
        }
        ("GET", "/api/health") => {
            http_response("200 OK", "application/json", "{\"ok\":true}")
        }
        ("GET", "/api/encode") => {
            // tokens=a,b,c  -> verified Rust core (mirrors Lean encodeBrainrot)
            let raw = query_param(query, "tokens").unwrap_or_default();
            let toks: Vec<&str> = if raw.is_empty() {
                vec![]
            } else {
                raw.split(',').collect()
            };
            let code = encode(&toks);
            let body = format!("{{\"code\":\"{}\"}}", code);
            http_response("200 OK", "application/json", &body)
        }
        _ => http_response("404 Not Found", "text/plain; charset=utf-8", "not found"),
    }
}

fn handle(stream: &mut std::net::TcpStream) {
    let mut buf = [0u8; 8192];
    let n = match stream.read(&mut buf) {
        Ok(n) => n,
        Err(_) => return,
    };
    let req = String::from_utf8_lossy(&buf[..n]);
    let first = req.lines().next().unwrap_or("");
    let mut parts = first.split_whitespace();
    let method = parts.next().unwrap_or("GET");
    let target = parts.next().unwrap_or("/");
    let (path, query) = match target.split_once('?') {
        Some((p, q)) => (p, q),
        None => (target, ""),
    };
    let resp = route(method, path, query);
    let _ = stream.write_all(resp.as_bytes());
    let _ = stream.flush();
}

fn main() {
    let addr = "127.0.0.1:8080";
    let listener = match TcpListener::bind(addr) {
        Ok(l) => l,
        Err(e) => {
            eprintln!("could not bind {}: {}", addr, e);
            return;
        }
    };
    println!("Gödel Brainrot Stealer running on http://{}", addr);
    println!("(extracted from the verified Lean core; Ctrl-C to stop)");
    for stream in listener.incoming() {
        if let Ok(mut s) = stream {
            handle(&mut s);
        }
    }
}
"#

/-- The Lean-generated Rust oracle test module: the verified `encodeBrainrot`
values are baked in as `assert_eq!`s, so `cargo test` checks the Rust core
against Lean. -/
private def rustOracleTests : String :=
  let line := fun (nm : String) (b : Brainrot) =>
    s!"    assert_eq!(encode({rustTokens b}), \"{encodeBrainrot b}\", \"{nm}\");"
  let body := String.intercalate "\n" (corpus.map (fun p => line p.1 p.2))
  "\n#[cfg(test)]\nmod oracle_tests {\n    use super::*;\n    // Oracle values computed by the verified Lean `encodeBrainrot`.\n    #[test]\n    fn matches_lean_oracle() {\n"
    ++ body ++ "\n    }\n}\n"

/-- The full `src/main.rs`: core + server + Lean-generated oracle tests. -/
def rustMain : String := rustCore ++ rustOracleTests

/-- `static/style.css`. -/
def styleCss : String := r#":root { color-scheme: dark; }
* { box-sizing: border-box; }
body {
  margin: 0;
  font-family: ui-monospace, Menlo, Consolas, monospace;
  background: radial-gradient(circle at 30% 20%, #2a0a4a, #07030f 70%);
  color: #e8e8ff;
  min-height: 100vh;
}
header {
  padding: 18px 22px;
  background: linear-gradient(90deg, rgba(255,0,204,.2), rgba(51,51,255,.2));
  border-bottom: 2px solid #ff44dd;
}
h1 { margin: 0; font-size: 22px; letter-spacing: 1px; text-shadow: 0 0 8px #ff44dd; }
.sub { opacity: .8; font-size: 12px; }
main { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; padding: 18px; }
.card {
  background: rgba(18,10,34,.8);
  border: 1px solid #5a2a8a;
  border-radius: 12px;
  padding: 14px;
  box-shadow: 0 0 18px rgba(106,0,170,.35);
}
.card h2 { margin: 0 0 8px; font-size: 16px; color: #66ffea; }
.vault { list-style: none; padding: 0; margin: 8px 0; max-height: 240px; overflow: auto; }
.vault li {
  padding: 6px 8px; margin: 4px 0; border-radius: 8px;
  background: #1d1140; border: 1px solid #3a2a6a; font-size: 12px;
  word-break: break-all; cursor: pointer;
}
.vault li.sel { outline: 2px solid #ffcc00; }
.aura { color: #ffd24a; font-weight: bold; }
button {
  font-family: inherit; cursor: pointer; color: #fff;
  background: linear-gradient(90deg, #ff2db8, #7a2dff);
  border: none; border-radius: 8px; padding: 8px 12px; margin: 4px 4px 0 0;
  box-shadow: 0 0 10px rgba(255,45,184,.5);
}
button:hover { filter: brightness(1.15); }
.full { grid-column: 1 / 3; }
.log { font-size: 12px; white-space: pre-wrap; max-height: 200px; overflow: auto; }
.tag { color: #66ffea; }
input {
  font-family: inherit; background: #1d1140; color: #e8e8ff;
  border: 1px solid #5a2a8a; border-radius: 8px; padding: 7px 9px; width: 60%;
}
.code { color: #9bffb0; }
.verify-ok { color: #76ff8a; }
.verify-bad { color: #ff6a6a; }
"#

/-- `static/index.html`. -/
def indexHtml : String := r#"<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Gödel Brainrot Stealer</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header>
    <h1>GÖDEL BRAINROT STEALER</h1>
    <div class="sub">extracted from a machine-verified Lean 4 core · brainrot = Gödel numbers</div>
  </header>
  <main>
    <section class="card" id="p1card">
      <h2 id="p1name"></h2>
      <div>aura: <span class="aura" id="p1aura"></span> · power: <span class="code" id="p1pow"></span></div>
      <ul class="vault" id="p1vault"></ul>
    </section>
    <section class="card" id="p2card">
      <h2 id="p2name"></h2>
      <div>aura: <span class="aura" id="p2aura"></span> · power: <span class="code" id="p2pow"></span></div>
      <ul class="vault" id="p2vault"></ul>
    </section>
    <section class="card full">
      <h2>actions</h2>
      <button onclick="stealSelected()">🥷 steal selected brainrot</button>
      <button onclick="fightRound()">⚔ fight (higher power wins +aura)</button>
      <button onclick="godelSlap()">🖐 Gödel slap (incompleteness debuff)</button>
      <button onclick="resetGame()">↺ reset</button>
    </section>
    <section class="card full">
      <h2>forge a new brainrot</h2>
      <input id="forgeInput" placeholder="sigma, looks, maxing">
      <button onclick="forge()">encode → add to current player</button>
      <button onclick="verifyForge()">verify against Rust /api/encode</button>
      <div id="forgeOut" class="sub"></div>
    </section>
    <section class="card full">
      <h2>event log</h2>
      <div class="log" id="log"></div>
    </section>
  </main>
  <script src="app.js"></script>
</body>
</html>
"#

/-- The body of `static/app.js` (everything after the Lean-injected `CORPUS`). -/
private def appJsBody : String := r#";

// ===========================================================================
//  Gödel Brainrot Stealer — browser client.
//  Mirrors the verified Lean semantics (encodeBrainrot / steal / fight / slap)
//  using JS BigInt for the (possibly huge) Gödel numbers.
// ===========================================================================

const PRIMES = [2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n];

function primeAt(i) { return i < PRIMES.length ? PRIMES[i] : 2n; }

// Verified Gödel numbering: product of primeAt(i) ^ (length of i-th token).
function encodeBig(tokens) {
  let n = 1n;
  tokens.forEach((t, i) => {
    const p = primeAt(i);
    for (let k = 0; k < t.length; k++) n *= p;
  });
  return n;
}

function mkBR(name) {
  const c = CORPUS.find(x => x.name === name) || {name, tokens: [name]};
  return { tokens: c.tokens.slice(), code: encodeBig(c.tokens) };
}

function freshState() {
  return {
    players: [
      { name: "SigmaOhioKing", aura: 120, vault: [mkBR("ohio"), mkBR("gyatt")] },
      { name: "SkibidiTheorem", aura: 80, vault: [mkBR("sigma"), mkBR("skibidi"), mkBR("fanum")] }
    ],
    sel: null,        // {p: 0|1, i: index}
    current: 0,       // which player forge() adds to
    log: []
  };
}

let S = freshState();

function power(p) { return p.vault.reduce((a, b) => a + b.code, 0n); }

function logLine(s) { S.log.unshift(s); if (S.log.length > 40) S.log.pop(); }

function brLabel(br) {
  return "[" + br.tokens.join(" · ") + "] = " + br.code.toString();
}

function render() {
  for (let p = 0; p < 2; p++) {
    const pl = S.players[p];
    document.getElementById("p" + (p+1) + "name").textContent =
      pl.name + (S.current === p ? "  (active)" : "");
    document.getElementById("p" + (p+1) + "aura").textContent = pl.aura;
    document.getElementById("p" + (p+1) + "pow").textContent = power(pl).toString();
    const ul = document.getElementById("p" + (p+1) + "vault");
    ul.innerHTML = "";
    pl.vault.forEach((br, i) => {
      const li = document.createElement("li");
      li.textContent = brLabel(br);
      if (S.sel && S.sel.p === p && S.sel.i === i) li.classList.add("sel");
      li.onclick = () => { S.sel = {p, i}; S.current = p; render(); };
      ul.appendChild(li);
    });
  }
  document.getElementById("log").textContent = S.log.join("\n");
}

// Mirror of Lean `steal`: attacker gains the code (+100 aura);
// victim loses it and half their aura (floor division).
function stealSelected() {
  if (!S.sel) { logLine("select a brainrot in the VICTIM's vault first"); render(); return; }
  const victimIdx = S.sel.p;
  const attackerIdx = 1 - victimIdx;
  const victim = S.players[victimIdx];
  const attacker = S.players[attackerIdx];
  const br = victim.vault[S.sel.i];
  victim.vault.splice(S.sel.i, 1);
  victim.aura = Math.floor(victim.aura / 2);
  attacker.vault.unshift(br);
  attacker.aura += 100;
  logLine("🥷 " + attacker.name + " heisted " + brLabel(br) + " from " + victim.name);
  S.sel = null;
  render();
}

// Mirror of Lean `fight`: higher total code wins; winner gains aura.
function fightRound() {
  const a = S.players[0], b = S.players[1];
  const pa = power(a), pb = power(b);
  const winner = pb > pa ? b : a;
  winner.aura += 50;
  logLine("⚔ " + a.name + " (" + pa + ") vs " + b.name + " (" + pb + ") → " + winner.name + " wins +50 aura");
  render();
}

// Gödel slap: incompleteness debuff — halve the selected brainrot's code,
// and free any imprisoned "ramanujan".
function godelSlap() {
  if (!S.sel) { logLine("select a brainrot to apply the incompleteness slap"); render(); return; }
  const pl = S.players[S.sel.p];
  const br = pl.vault[S.sel.i];
  const before = br.code;
  br.code = br.code / 2n;
  logLine("🖐 Gödel slap: incompleteness halves " + before.toString() + " → " + br.code.toString());
  if (br.tokens.includes("ramanujan")) logLine("   …and Ramanujan is freed!");
  render();
}

function parseTokens(raw) {
  return raw.split(",").map(s => s.trim()).filter(s => s.length > 0);
}

function forge() {
  const raw = document.getElementById("forgeInput").value;
  const tokens = parseTokens(raw);
  if (tokens.length === 0) { document.getElementById("forgeOut").textContent = "type some comma-separated tokens"; return; }
  const code = encodeBig(tokens);
  S.players[S.current].vault.unshift({ tokens, code });
  logLine("✦ forged " + brLabel({tokens, code}) + " for " + S.players[S.current].name);
  document.getElementById("forgeOut").textContent = "forged Gödel code " + code.toString();
  render();
}

// Cross-check the in-browser BigInt encoder against the verified Rust core.
async function verifyForge() {
  const raw = document.getElementById("forgeInput").value;
  const tokens = parseTokens(raw);
  const local = encodeBig(tokens).toString();
  const out = document.getElementById("forgeOut");
  try {
    const resp = await fetch("/api/encode?tokens=" + encodeURIComponent(tokens.join(",")));
    const j = await resp.json();
    if (j.code === local) {
      out.innerHTML = '<span class="verify-ok">✓ Rust core agrees: ' + j.code + '</span>';
    } else {
      out.innerHTML = '<span class="verify-bad">✗ mismatch! js=' + local + ' rust=' + j.code + '</span>';
    }
  } catch (e) {
    out.innerHTML = '<span class="verify-bad">could not reach Rust /api/encode (is the server running?)</span>';
  }
}

function resetGame() { S = freshState(); logLine("↺ new game"); render(); }

render();
"#

/-- `static/app.js`: the Lean-injected corpus followed by the client body. -/
def appJs : String := "const CORPUS = " ++ jsCorpus ++ appJsBody

/-- `webapp/README.md`. -/
def webappReadme : String := r#"# Gödel Brainrot Stealer — Rust/Web app (extracted from Lean)

This folder is **generated** by the Lean module `RequestProject/WebExtract.lean`
(run `#eval GodelBrainrot.Web.writeWebapp`). The Lean core
`RequestProject/GodelBrainrot.lean` is the source of truth: it computes the Gödel
codes with the verified `encodeBrainrot` and bakes them into the Rust oracle
tests, so the extracted Rust is checked against Lean.

## Run it

```
cd webapp
cargo run            # serves http://127.0.0.1:8080
```

Then open <http://127.0.0.1:8080> and play: steal brainrot, fight, Gödel-slap,
and forge new Gödel-encoded brainrot. The "verify against Rust" button checks the
browser's BigInt encoder against the server's verified `/api/encode` endpoint.

## Check the Lean oracle

```
cargo test           # asserts the Rust encoder matches Lean's encodeBrainrot
```

## Layout

- `src/main.rs`   — std-only HTTP server + Gödel encoder + Lean oracle tests
- `static/index.html`, `static/app.js`, `static/style.css` — the playable frontend

No external crates; only the Rust standard library is required.
"#

/-! ## The extractor -/

/-- Write the entire Rust/Web app under `webapp/`. Run with `#eval`. -/
def writeWebapp (root : System.FilePath := "webapp") : IO Unit := do
  IO.FS.createDirAll root
  IO.FS.createDirAll (root / "src")
  IO.FS.createDirAll (root / "static")
  IO.FS.writeFile (root / "Cargo.toml") cargoToml
  IO.FS.writeFile (root / "README.md") webappReadme
  IO.FS.writeFile (root / "src" / "main.rs") rustMain
  IO.FS.writeFile (root / "static" / "index.html") indexHtml
  IO.FS.writeFile (root / "static" / "app.js") appJs
  IO.FS.writeFile (root / "static" / "style.css") styleCss
  IO.println s!"wrote Gödel Brainrot webapp to {root}/ (cargo run, then http://127.0.0.1:8080)"

#eval writeWebapp

end GodelBrainrot.Web
