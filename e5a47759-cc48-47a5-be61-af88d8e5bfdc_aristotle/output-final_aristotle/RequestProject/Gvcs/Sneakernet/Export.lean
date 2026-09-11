import RequestProject.Gvcs.Sneakernet.Session

/-!
# Exporting the sneakernet game

Plumbing for `lake exe sneaker`: the rule-book circuit, the demo key, the board
and the sealed letters are turned into files a player can carry.

* `circJson` writes a `BCirc` as nested JSON arrays, so the page evaluates the
  *same* circuit the theorems are about rather than a hand-written copy;
* `batchOf` writes a UUCP-style batch — a bang path and the ciphertext bits —
  which is what actually travels on the tape;
* `page` is a self-contained playable page: two players seal moves, a courier
  carries them hop by hop, a relay evaluates the rule book on the ciphertexts
  and the referee decrypts a single verdict bit.

Nothing here is proved; the proofs are in `Fhe.lean`, `Uucp.lean`, `Sealed.lean`
and `Session.lean`.  This file only serialises them.
-/

namespace LifeTrac
namespace Sneakernet
namespace Export

open Session

/-- A boolean as JSON. -/
def boolJson (b : Bool) : String := if b then "true" else "false"

/-- The rule-book circuit as nested JSON arrays. -/
def circJson {n : ℕ} : BCirc n → String
  | .var i => "[\"var\"," ++ toString i.val ++ "]"
  | .const b => "[\"const\"," ++ boolJson b ++ "]"
  | .not a => "[\"not\"," ++ circJson a ++ "]"
  | .and a b => "[\"and\"," ++ circJson a ++ "," ++ circJson b ++ "]"
  | .xor a b => "[\"xor\"," ++ circJson a ++ "," ++ circJson b ++ "]"

/-- The four cells of a patch as a JSON array. -/
def boardJson (s : Patch.State) : String :=
  "[" ++ String.intercalate "," ((List.finRange 4).map fun i => boolJson (s i)) ++ "]"

/-- The ciphertext bits of a sealed move as a JSON array. -/
def ctJson (ct : Fin 3 → ℤ) : String :=
  "[" ++ String.intercalate "," ((List.finRange 3).map fun i => toString (ct i)) ++ "]"

/-- A bang path, written the way it is addressed. -/
def bangPath (from_ : String) (route : List String) : String :=
  String.intercalate "!" (from_ :: route)

/-- A UUCP-style batch: the work file line, then the data file with one
ciphertext per line. -/
def batchOf (name : String) (from_ : String) (route : List String)
    (ct : Fin 3 → ℤ) : String :=
  let path := bangPath from_ route
  "# uucp batch, written by `lake exe sneaker` from the Lean development\n" ++
  "# the payload is a sealed move: three ciphertext bits under the referee's key\n" ++
  "C D." ++ name ++ " X." ++ name ++ " " ++ path ++ "\n" ++
  "D." ++ name ++ " 3\n" ++
  String.intercalate "\n" ((List.finRange 3).map fun i => toString (ct i)) ++ "\n" ++
  "X." ++ name ++ " rmail referee\n"

/-- The parameters the page needs, as JSON. -/
def paramsJson : String :=
  "{\"modulus\":" ++ toString demoP ++
  ",\"noiseMax\":2,\"budget\":" ++ toString demoB ++
  ",\"board\":" ++ boardJson board ++
  ",\"circuit\":" ++ circJson Patch.game.circuit ++
  ",\"bound\":" ++ toString (BCirc.bound demoB Patch.game.circuit) ++ "}"

/-- The demo letters, as JSON, with the verdict ciphertext Lean computes for
each of them against the opening board. -/
def lettersJson : String :=
  let one := fun (who : String) (route : List String) (a : Patch.Move) =>
    "{\"from\":\"" ++ who ++ "\",\"path\":\"" ++ bangPath who route ++
    "\",\"hops\":" ++ toString route.length ++
    ",\"ct\":" ++ ctJson (ctMove a) ++
    ",\"verdictCt\":\"" ++
      toString (Patch.game.verdictCt (Fin.append (ctState board) (ctMove a))) ++
    "\",\"verdict\":" ++
      boolJson (dec demoP (Patch.game.verdictCt (Fin.append (ctState board) (ctMove a)))) ++ "}"
  "[" ++ one "ada" ["decvax", "ihnp4", "farm"] adaMove ++ "," ++
    one "bob" ["ihnp4", "farm"] bobMove ++ "]"

/-- The playable page.  The rule book, the key and the opening board are the
ones the theorems are about; the page only re-runs them. -/
def page : String :=
  "<!doctype html>\n<html lang=\"en\"><head><meta charset=\"utf-8\">\n" ++
  "<title>Sneakernet &middot; a game played by post, under encryption</title>\n" ++
  "<style>\n" ++
  "body{background:#101614;color:#e8f1ea;font-family:system-ui,sans-serif;margin:0;padding:2rem;}\n" ++
  "h1,h2{font-weight:600;} main{max-width:60rem;margin:0 auto;}\n" ++
  "button{background:#27403a;color:#e8f1ea;border:1px solid #4d6f64;border-radius:.4rem;" ++
  "padding:.4rem .8rem;font-size:1rem;cursor:pointer;} button:hover{background:#33544b;}\n" ++
  "select{background:#1b2622;color:#e8f1ea;border:1px solid #4d6f64;border-radius:.4rem;padding:.3rem;}\n" ++
  ".patch{display:grid;grid-template-columns:repeat(2,5rem);gap:.5rem;margin:1rem 0;}\n" ++
  ".cell{width:5rem;height:5rem;border-radius:.4rem;display:flex;align-items:center;" ++
  "justify-content:center;font-size:.8rem;}\n" ++
  ".solid{background:#6b5433;border:2px solid #8a6d43;} .hole{background:#1b2622;border:2px dashed #4d6f64;}\n" ++
  "textarea{width:100%;height:8rem;background:#0b100e;color:#b9d6c6;border:1px solid #4d6f64;" ++
  "border-radius:.4rem;font-family:ui-monospace,monospace;font-size:.8rem;padding:.5rem;}\n" ++
  "#log{font-family:ui-monospace,monospace;font-size:.85rem;white-space:pre-wrap;" ++
  "background:#0b100e;border:1px solid #2c3b35;border-radius:.4rem;padding:.75rem;max-height:18rem;overflow:auto;}\n" ++
  ".row{display:flex;gap:.6rem;align-items:center;flex-wrap:wrap;margin:.6rem 0;}\n" ++
  "code{color:#9fd3b6;}\n" ++
  "</style></head><body><main>\n" ++
  "<h1>Sneakernet</h1>\n" ++
  "<p>Two players share one 2&times;2 patch of ground and never meet. Each seals a move under " ++
  "the referee&rsquo;s key and posts it along a bang path. A relay checks the sealed move against " ++
  "the rule book <em>without decrypting it</em>, and the referee decrypts a single verdict bit.</p>\n" ++
  "<h2>The patch</h2>\n<div class=\"patch\" id=\"patch\"></div>\n" ++
  "<h2>Seal a move</h2>\n<div class=\"row\">\n" ++
  "<select id=\"who\"><option value=\"ada\">ada (3 hops)</option>" ++
  "<option value=\"bob\">bob (2 hops)</option></select>\n" ++
  "<select id=\"cell\"><option value=\"0\">cell 0</option><option value=\"1\">cell 1</option>" ++
  "<option value=\"2\">cell 2</option><option value=\"3\">cell 3</option></select>\n" ++
  "<select id=\"act\"><option value=\"dig\">dig</option><option value=\"fill\">fill</option></select>\n" ++
  "<button id=\"seal\">seal and post</button>\n" ++
  "<button id=\"courier\">run a courier round</button>\n" ++
  "</div>\n" ++
  "<h2>The tape</h2>\n" ++
  "<p>This is what travels: a bang path and three ciphertext bits. Copy it onto a stick, " ++
  "carry it, and paste it in on the other machine.</p>\n" ++
  "<textarea id=\"tape\"></textarea>\n<div class=\"row\">" ++
  "<button id=\"import\">deliver a pasted tape</button></div>\n" ++
  "<h2>Log</h2>\n<div id=\"log\"></div>\n" ++
  "<script>\n" ++
  "const PARAMS = " ++ paramsJson ++ ";\n" ++
  "const P = BigInt(PARAMS.modulus);\n" ++
  "const NOISEMAX = PARAMS.noiseMax;\n" ++
  "let board = PARAMS.board.slice();\n" ++
  "let flight = [];\n" ++
  "function dec(c){ const r = ((c % P) + P) % P; return (r % 2n) === 1n; }\n" ++
  "function rnd(n){ return BigInt(Math.floor(Math.random()*n)); }\n" ++
  "function enc(b){ const r = rnd(NOISEMAX+1), q = rnd(1000) - 500n;\n" ++
  "  return (b?1n:0n) + 2n*r + P*q; }\n" ++
  "function evalEnc(c, cs){\n" ++
  "  switch(c[0]){\n" ++
  "    case 'var': return cs[c[1]];\n" ++
  "    case 'const': return c[1] ? 1n : 0n;\n" ++
  "    case 'not': return evalEnc(c[1], cs) + 1n;\n" ++
  "    case 'and': return evalEnc(c[1], cs) * evalEnc(c[2], cs);\n" ++
  "    case 'xor': return evalEnc(c[1], cs) + evalEnc(c[2], cs);\n" ++
  "  }\n" ++
  "}\n" ++
  "function encodeMove(cell, dig){ return [ (cell % 2) === 1, Math.floor(cell/2) === 1, dig ]; }\n" ++
  "function sealMove(cell, dig){ return encodeMove(cell, dig).map(enc); }\n" ++
  "function stateCt(){ return board.map(enc); }\n" ++
  "function legalPlain(cell, dig){ return dig ? board[cell] : !board[cell]; }\n" ++
  "function log(s){ const d = document.getElementById('log'); d.textContent += s + '\\n'; " ++
  "d.scrollTop = d.scrollHeight; }\n" ++
  "function drawPatch(){\n" ++
  "  const p = document.getElementById('patch'); p.innerHTML = '';\n" ++
  "  board.forEach((solid, i) => { const d = document.createElement('div');\n" ++
  "    d.className = 'cell ' + (solid ? 'solid' : 'hole');\n" ++
  "    d.textContent = 'cell ' + i + (solid ? ' \\u00b7 solid' : ' \\u00b7 hole'); p.appendChild(d); });\n" ++
  "}\n" ++
  "function tapeOf(pkt){\n" ++
  "  return '# uucp batch\\nC D.' + pkt.name + ' X.' + pkt.name + ' ' + pkt.path + '\\nD.' +\n" ++
  "    pkt.name + ' 3\\n' + pkt.ct.map(x => x.toString()).join('\\n') + '\\nX.' + pkt.name +\n" ++
  "    ' rmail referee\\n';\n" ++
  "}\n" ++
  "function parseTape(text){\n" ++
  "  const lines = text.split('\\n').map(s => s.trim()).filter(s => s.length && s[0] !== '#');\n" ++
  "  const cLine = lines.find(s => s.startsWith('C '));\n" ++
  "  const path = cLine ? cLine.split(' ').pop() : 'unknown';\n" ++
  "  const nums = lines.filter(s => /^-?[0-9]+$/.test(s)).map(s => BigInt(s));\n" ++
  "  if (nums.length < 3) return null;\n" ++
  "  const hops = path.split('!').length - 1;\n" ++
  "  return { name: 'tape', path: path, from: path.split('!')[0], hops: hops, " ++
  "ct: nums.slice(0,3) };\n" ++
  "}\n" ++
  "function referee(pkt){\n" ++
  "  const cs = stateCt().concat(pkt.ct);\n" ++
  "  const vct = evalEnc(PARAMS.circuit, cs);\n" ++
  "  const ok = dec(vct);\n" ++
  "  log('relay verdict ciphertext for ' + pkt.from + ': ' + vct.toString().slice(0,40) + '...');\n" ++
  "  log('referee decrypts one bit: ' + (ok ? 'legal' : 'illegal'));\n" ++
  "  if (ok) {\n" ++
  "    const cellIdx = (dec(pkt.ct[0]) ? 1 : 0) + (dec(pkt.ct[1]) ? 2 : 0);\n" ++
  "    const dig = dec(pkt.ct[2]);\n" ++
  "    board[cellIdx] = !dig;\n" ++
  "    log('applied: ' + pkt.from + ' ' + (dig ? 'dug' : 'filled') + ' cell ' + cellIdx);\n" ++
  "  } else {\n" ++
  "    log('refused: the patch is unchanged');\n" ++
  "  }\n" ++
  "  drawPatch();\n" ++
  "}\n" ++
  "document.getElementById('seal').onclick = () => {\n" ++
  "  const who = document.getElementById('who').value;\n" ++
  "  const cell = parseInt(document.getElementById('cell').value, 10);\n" ++
  "  const dig = document.getElementById('act').value === 'dig';\n" ++
  "  const route = who === 'ada' ? ['decvax','ihnp4','farm'] : ['ihnp4','farm'];\n" ++
  "  const pkt = { name: who + flight.length, from: who, path: [who].concat(route).join('!'),\n" ++
  "    hops: route.length, ct: sealMove(cell, dig) };\n" ++
  "  flight.push(pkt);\n" ++
  "  document.getElementById('tape').value = tapeOf(pkt);\n" ++
  "  log(who + ' seals a move and posts it: ' + pkt.path + ' (' + pkt.hops + ' hops to go)');\n" ++
  "};\n" ++
  "document.getElementById('courier').onclick = () => {\n" ++
  "  if (!flight.length) { log('no mail in flight'); return; }\n" ++
  "  const still = [];\n" ++
  "  for (const pkt of flight) {\n" ++
  "    pkt.hops -= 1;\n" ++
  "    if (pkt.hops <= 0) { log('delivered: ' + pkt.path); referee(pkt); }\n" ++
  "    else { log('in flight: ' + pkt.path + ' (' + pkt.hops + ' hops to go)'); still.push(pkt); }\n" ++
  "  }\n" ++
  "  flight = still;\n" ++
  "};\n" ++
  "document.getElementById('import').onclick = () => {\n" ++
  "  const pkt = parseTape(document.getElementById('tape').value);\n" ++
  "  if (!pkt) { log('that tape has no readable batch on it'); return; }\n" ++
  "  log('a tape arrives by hand from ' + pkt.from);\n" ++
  "  referee(pkt);\n" ++
  "};\n" ++
  "drawPatch();\n" ++
  "log('the referee publishes the patch; the rule book is the circuit proved in Lean');\n" ++
  "</script>\n" ++
  "</main></body></html>\n"

/-- What the emitted directory contains. -/
def readme : String :=
  "# Sneakernet\n\n" ++
  "A two-player game played by post.  Everything here is written by\n" ++
  "`lake exe sneaker` out of the Lean development; nothing is hand-made.\n\n" ++
  "## Files\n\n" ++
  "* `index.html` — the playable page: seal a move, run courier rounds, or carry\n" ++
  "  a tape across by hand and paste it in;\n" ++
  "* `mail/ada.batch`, `mail/bob.batch` — the two demo letters as UUCP batches,\n" ++
  "  the bang path and the three ciphertext bits that actually travel;\n" ++
  "* `params.json` — the referee's key, the opening board and the rule book as a\n" ++
  "  circuit;\n" ++
  "* `letters.json` — the demo letters with the verdict ciphertext Lean computes\n" ++
  "  for each of them.\n\n" ++
  "## What is proved about it\n\n" ++
  "* the encrypted verdict is the truth — `SealedGame.verdict_correct`, and with\n" ++
  "  recryption at every gate, for a rule book of any depth,\n" ++
  "  `BCirc.dec_evalR`;\n" ++
  "* no cheating — the referee's position only ever changes by a move the rule\n" ++
  "  book accepted, so whatever arrives in the post the position is one legal\n" ++
  "  play could have produced (`SealedGame.reach_runMail`);\n" ++
  "* the post loses nothing and the batching does not matter\n" ++
  "  (`Wire.payloads_step`, `Wire.step_add`), and everything is delivered after\n" ++
  "  more rounds than the longest bang path (`Wire.delivered_all`);\n" ++
  "* for this very board and these very keys: Ada's dig is accepted and Bob's is\n" ++
  "  refused (`Session.ada_accepted`, `Session.bob_rejected`), both letters land\n" ++
  "  after four courier rounds (`Session.round_delivered`), and the delivery\n" ++
  "  order does not matter (`Session.round_order_irrelevant`).\n\n" ++
  "## Not a security claim\n\n" ++
  "The scheme is the textbook integer one: the key is an odd modulus and a\n" ++
  "ciphertext is the bit plus twice a small noise plus a multiple of the modulus.\n" ++
  "What is proved is *correctness* — decryption returns the bit, and the rule\n" ++
  "book evaluated on ciphertexts returns the right verdict.  The demo key is\n" ++
  "small and the noise is small; nothing here is a claim about hardness.\n"

end Export
end Sneakernet
end LifeTrac
