import RequestProject.Nix.NixWars.Keymap

/-!
# Emitting the keyboard, the hotkeys and the macro builder

The caps, the keymaps and the books of `RequestProject.NixWars.Keymap` are
printed here as JSON, together with the script that draws the on-screen
keyboard, dispatches the hotkeys and runs the macro builder. As everywhere
else in this project the page carries no hand-written table: the keys the
player sees are the keys Lean proved cover the cabinet, and the macro keys are
the lines of play Lean proved win.

`probeVectors` and `expandVectors` are golden values — lookups and macro
expansions computed here, in Lean, for the headless harness to check the
page's own `kmLookIn` and `kmExpand` against.
-/

namespace NixWars
namespace Keys

open Agents

/-! ## Printing the tables -/

/-- The doors of the board, by name. -/
def doorNames : List String := Wasm.boardIR.map Wasm.DoorIR.name

/-- A string as JSON, with the two characters that matter escaped. -/
def jsonStr (s : String) : String :=
  let esc := s.foldl (fun acc c =>
    if c == '"' then acc ++ "\\\""
    else if c == '\\' then acc ++ "\\\\"
    else acc.push c) ""
  "\"" ++ esc ++ "\""

/-- A boolean as JSON. -/
def jsonBool (b : Bool) : String := if b then "true" else "false"

/-- An action as JSON: `["cmd",tag,arg]` or `["macro",i]`. -/
def actJson : Action → String
  | .move m => "[\"cmd\"," ++ jsonStr m.tag ++ "," ++ toString m.arg ++ "]"
  | .macroCall i => "[\"macro\"," ++ toString i ++ "]"

/-- A cap as JSON. -/
def capJson (c : Cap) : String :=
  "{\"key\":" ++ jsonStr c.chord.key ++
  ",\"ctrl\":" ++ jsonBool c.chord.ctrl ++
  ",\"shift\":" ++ jsonBool c.chord.shift ++
  ",\"label\":" ++ jsonStr c.label ++
  ",\"row\":" ++ toString c.row ++
  ",\"span\":" ++ toString c.span ++
  ",\"act\":" ++ actJson c.act ++ "}"

/-- A step as JSON: `["cmd",tag,arg]` or `["call",i]`. -/
def stepJson : Step → String
  | .cmd m => "[\"cmd\"," ++ jsonStr m.tag ++ "," ++ toString m.arg ++ "]"
  | .call i => "[\"call\"," ++ toString i ++ "]"

/-- A macro as JSON. -/
def macroJson (m : Macro) : String :=
  "{\"name\":" ++ jsonStr m.name ++ ",\"steps\":[" ++
    String.intercalate "," (m.steps.map stepJson) ++ "]}"

/-- A command on the wire, as JSON. -/
def moveJson (m : Move) : String := "[" ++ jsonStr m.tag ++ "," ++ toString m.arg ++ "]"

/-- An object keyed by door name. -/
def byDoor (f : String → String) : String :=
  "{" ++ String.intercalate ","
    (doorNames.map (fun d => jsonStr d ++ ":" ++ f d)) ++ "}"

/-- The caps of every door. -/
def capsJson : String :=
  byDoor (fun d => "[" ++ String.intercalate "," ((defaultCaps d).map capJson) ++ "]")

/-- The book of every door. -/
def booksJson : String :=
  byDoor (fun d => "[" ++ String.intercalate "," ((defaultBook d).map macroJson) ++ "]")

/-- **Golden expansions.** Every macro of every door, expanded here in Lean;
the page's `kmExpand` must produce the same list. -/
def expandVectorsJson : String :=
  byDoor (fun d =>
    let bk := defaultBook d
    "[" ++ String.intercalate ","
      ((List.range bk.length).map (fun i =>
        "[" ++ String.intercalate ","
          ((expandSteps bk [.call i]).map moveJson) ++ "]")) ++ "]")

/-- Chords the harness looks up: every key of the door, and three keys that
are on no keyboard at all. -/
def probeChords (d : String) : List Chord :=
  (defaultCaps d).map Cap.chord ++
    [plain "\u00a7", { ctrl := true, key := "a" }, { shift := true, key := "z" }]

/-- **Golden lookups.** What each probe chord does, computed here in Lean. -/
def probeVectorsJson : String :=
  "[" ++ String.intercalate ",\n"
    (doorNames.flatMap (fun d =>
      (probeChords d).map (fun c =>
        let want := match look (defaultKeymap d) c with
          | none => "null"
          | some a => actJson a
        "[" ++ jsonStr d ++ "," ++ jsonStr c.key ++ "," ++ jsonBool c.ctrl ++ "," ++
          jsonBool c.shift ++ "," ++ want ++ "]"))) ++ "]"

/-- Everything the page needs for keys and macros. -/
def keymapJson : String :=
  "{\"caps\":" ++ capsJson ++
  ",\"books\":" ++ booksJson ++
  ",\"expand\":" ++ expandVectorsJson ++
  ",\"probes\":" ++ probeVectorsJson ++ "}"

/-! ## The script

`kmLookIn` is the page's copy of `NixWars.Keys.look` — first match wins — and
`kmExpand` is its copy of `NixWars.Keys.expandSteps`, including the rule that a
call may only reach the macros defined before it, which is what makes a macro
unable to loop. The harness checks both against `KMAP.probes` and
`KMAP.expand`. -/

def keymapJs : String := r#"
// ---- keys, caps, hotkeys and macros ----
// KMAP.caps are the keys NixWars.Keys.defaultCaps puts on each cabinet, proved
// to carry every command of that cabinet and nothing else; KMAP.books are the
// lines of play the development proves win. Nothing here is hand-written.
let KM = null;                 // the player's copy: { caps: {...}, books: {...} }
let kbEdit = false, kbSel = -1, kbCapture = false;
let kmRecording = null, kmDraft = [], kmTimer = null;

function kmClone(x) { return JSON.parse(JSON.stringify(x)); }
function kmDefaults() { return { caps: kmClone(KMAP.caps), books: kmClone(KMAP.books) }; }
function kmLoad() {
  KM = kmDefaults();
  try {
    const raw = localStorage.getItem("nixwars.keys");
    if (raw) {
      const j = JSON.parse(raw);
      if (j && j.caps && j.books) KM = j;
    }
  } catch (err) { /* no storage: defaults, every time */ }
}
function kmSave() {
  try { localStorage.setItem("nixwars.keys", JSON.stringify(KM)); } catch (err) {}
}
function kmCaps(d) { return (KM.caps[d || door] ||= []); }
function kmBook(d) { return (KM.books[d || door] ||= []); }

// NixWars.Keys.look: the first cap whose chord matches wins.
function kmLookIn(caps, key, ctrl, shift) {
  for (const c of caps || [])
    if (c.key === key && !!c.ctrl === !!ctrl && !!c.shift === !!shift) return c.act;
  return null;
}
function kmLook(d, key, ctrl, shift) { return kmLookIn(kmCaps(d), key, ctrl, shift); }

// NixWars.Keys.expandSteps: a call is expanded against the macros defined
// *before* it, so a macro cannot call itself and expansion always stops.
function kmExpand(book, steps) {
  const out = [];
  for (const s of steps) {
    if (s[0] === "cmd") { out.push([s[1], s[2]]); continue; }
    const i = s[1];
    if (i >= 0 && i < book.length)
      for (const m of kmExpand(book.slice(0, i), book[i].steps)) out.push(m);
  }
  return out;
}
function kmExpandMacro(i, d) {
  const bk = kmBook(d);
  return (i >= 0 && i < bk.length) ? kmExpand(bk.slice(0, i), bk[i].steps) : [];
}

// ---- doing what a key says ----
function kmDo(act) {
  if (!act) return;
  if (act[0] === "cmd") { send(act[1], act[2]); return; }
  kmPlayMacro(act[1]);
}
// the whole macro, at once (this is what the harness plays)
function kmPlayAll(i) {
  const moves = kmExpandMacro(i);
  for (const [tag, arg] of moves) send(tag, arg);
  return moves.length;
}
// the whole macro, one command a frame, so you can watch it
function kmPlayMacro(i) {
  const moves = kmExpandMacro(i);
  kmStop();
  if (!moves.length) { mbSay("macro " + i + " is empty"); return; }
  if (typeof setInterval !== "function") { kmPlayAll(i); return; }
  let at = 0;
  kmTimer = setInterval(() => {
    if (at >= moves.length) { kmStop(); return; }
    const [tag, arg] = moves[at++];
    send(tag, arg);
  }, 40);
}
function kmStop() { if (kmTimer !== null) { clearInterval(kmTimer); kmTimer = null; } }

// ---- the hotkeys ----
function kmKeyDown(e) {
  const tag = ((e.target || {}).tagName || "").toUpperCase();
  if (tag === "INPUT" || tag === "SELECT" || tag === "TEXTAREA") return;
  const key = (e.key || "").toLowerCase();
  if (kbCapture) {
    if (e.preventDefault) e.preventDefault();
    kbCapture = false;
    kbAddCap(key, !!e.ctrlKey, !!e.shiftKey);
    return;
  }
  const act = kmLook(door, key, !!e.ctrlKey, !!e.shiftKey);
  if (!act) return;
  if (e.preventDefault) e.preventDefault();
  kmDo(act);
}

// ---- drawing the keyboard ----
function kmActLabel(act) {
  if (!act) return "--";
  if (act[0] === "cmd") return act[1].toUpperCase() + (act[2] ? " " + act[2] : "");
  const bk = kmBook(), m = bk[act[1]];
  return "MACRO " + (act[1] + 1) + (m ? ": " + m.name : "");
}
function kmKeyName(c) {
  const k = c.key === " " ? "SPACE" : c.key.toUpperCase();
  return (c.ctrl ? "CTRL+" : "") + (c.shift ? "SHIFT+" : "") + k;
}
function kbRender() {
  const box = document.getElementById("kbrows");
  if (!box) return;
  const caps = kmCaps();
  let rows = 0;
  for (const c of caps) if (c.row + 1 > rows) rows = c.row + 1;
  let html = "";
  for (let r = 0; r < rows; r++) {
    html += '<div class="kbrow">';
    caps.forEach((c, i) => {
      if (c.row !== r) return;
      const cls = "kbkey" + (kbEdit && i === kbSel ? " kbsel" : "") +
                  (c.act[0] === "macro" ? " kbmacro" : "");
      html += '<button class="' + cls + '" style="flex:' + Math.max(1, c.span) +
              '" onclick="kbTap(' + i + ')" title="' + kmKeyName(c) + ' &rarr; ' +
              kmActLabel(c.act) + '">' + c.label +
              '<span class="kbsub">' + kmKeyName(c) + '</span></button>';
    });
    html += "</div>";
  }
  box.innerHTML = html;
  kbEditor();
}
function kbTap(i) {
  const caps = kmCaps();
  if (!caps[i]) return;
  if (!kbEdit) { kmDo(caps[i].act); return; }
  kbSel = (kbSel === i) ? -1 : i;
  kbRender();
}
function kbEditToggle() {
  kbEdit = !kbEdit;
  kbSel = -1;
  const b = document.getElementById("kbeditbtn");
  if (b) b.textContent = kbEdit ? "DONE" : "CUSTOMIZE";
  kbRender();
}
function kbToggle() {
  const w = document.getElementById("kbrows"), b = document.getElementById("kbtoggle");
  if (!w) return;
  const hidden = w.style.display === "none";
  w.style.display = hidden ? "" : "none";
  if (b) b.textContent = hidden ? "HIDE KEYBOARD" : "SHOW KEYBOARD";
}
// the editor for the selected cap
function kbEditor() {
  const box = document.getElementById("kbedit");
  if (!box) return;
  if (!kbEdit) { box.innerHTML = ""; return; }
  const caps = kmCaps(), c = caps[kbSel];
  let html = '<div class="small">Tap a key to select it, then point it at another ' +
             'command, drag it to another row, make it wider, or take it off. ' +
             'Rearranging a keyboard never changes what its keys do &mdash; that is ' +
             'proved (keymapOf_moveCap). ADD KEY listens for the next keystroke.</div>' +
             '<div><button onclick="kbCaptureStart()" id="kbcap">ADD KEY</button>' +
             '<button onclick="kmReset()">DEFAULTS</button>' +
             '<button onclick="kmExport()">EXPORT</button>' +
             '<input id="kmjson" placeholder="paste a layout">' +
             '<button onclick="kmImport()">IMPORT</button></div>';
  if (c) {
    const tags = Object.keys(DOORS[door].prog);
    html += '<div class="kbform"><span class="small">' + kmKeyName(c) + '</span>' +
            '<input id="kblabel" value="' + c.label + '" oninput="kbSetLabel()">' +
            '<select id="kbact" onchange="kbSetAct()">';
    for (const t of tags)
      html += '<option value="cmd:' + t + '"' +
              (c.act[0] === "cmd" && c.act[1] === t ? " selected" : "") + '>' +
              t.toUpperCase() + "</option>";
    kmBook().forEach((m, i) => {
      html += '<option value="macro:' + i + '"' +
              (c.act[0] === "macro" && c.act[1] === i ? " selected" : "") + '>MACRO ' +
              (i + 1) + ": " + m.name + "</option>";
    });
    html += "</select>" +
            '<input id="kbarg" value="' + (c.act[0] === "cmd" ? c.act[2] : 0) +
            '" oninput="kbSetAct()" title="argument">' +
            '<button onclick="kbMove(-1)">ROW &uarr;</button>' +
            '<button onclick="kbMove(1)">ROW &darr;</button>' +
            '<button onclick="kbSize(-1)">NARROWER</button>' +
            '<button onclick="kbSize(1)">WIDER</button>' +
            '<button onclick="kbRemove()">REMOVE</button></div>';
  }
  box.innerHTML = html;
}
function kbSel_() { return kmCaps()[kbSel]; }
function kbSetLabel() {
  const c = kbSel_(), el = document.getElementById("kblabel");
  if (!c || !el) return;
  c.label = el.value || c.label;
  kmSave();
  kbRender();
}
function kbSetAct() {
  const c = kbSel_(), el = document.getElementById("kbact"),
        ar = document.getElementById("kbarg");
  if (!c || !el) return;
  const v = String(el.value || ""), arg = Number((ar && ar.value) || 0) || 0;
  c.act = v.slice(0, 6) === "macro:" ? ["macro", Number(v.slice(6))]
                                     : ["cmd", v.slice(4), arg];
  kmSave();
  kbRender();
}
function kbMove(d) {
  const c = kbSel_();
  if (!c) return;
  c.row = Math.max(0, c.row + d);
  kmSave();
  kbRender();
}
function kbSize(d) {
  const c = kbSel_();
  if (!c) return;
  c.span = Math.max(1, Math.min(8, c.span + d));
  kmSave();
  kbRender();
}
function kbRemove() {
  const caps = kmCaps();
  if (kbSel < 0 || kbSel >= caps.length) return;
  caps.splice(kbSel, 1);
  kbSel = -1;
  kmSave();
  kbRender();
}
function kbCaptureStart() {
  kbCapture = true;
  const b = document.getElementById("kbcap");
  if (b) b.textContent = "PRESS A KEY...";
}
function kbAddCap(key, ctrl, shift) {
  const caps = kmCaps();
  const tags = Object.keys(DOORS[door].prog);
  let at = -1;
  caps.forEach((c, i) => {
    if (c.key === key && !!c.ctrl === !!ctrl && !!c.shift === !!shift) at = i;
  });
  if (at < 0) {
    caps.push({ key: key, ctrl: !!ctrl, shift: !!shift,
                label: (key === " " ? "SPACE" : key.toUpperCase()),
                row: 1, span: 1, act: ["cmd", tags[0], 0] });
    at = caps.length - 1;
  }
  kbSel = at;
  kmSave();
  kbRender();
}
// bind an action to a key, replacing whatever it did (NixWars.Keys.kmBind)
function kmBindKey(key, ctrl, shift, act) {
  const caps = kmCaps();
  for (const c of caps)
    if (c.key === key && !!c.ctrl === !!ctrl && !!c.shift === !!shift) {
      c.act = act;
      kmSave();
      kbRender();
      return c;
    }
  const cap = { key: key, ctrl: !!ctrl, shift: !!shift,
                label: (key === " " ? "SPACE" : key.toUpperCase()),
                row: 2, span: 2, act: act };
  caps.push(cap);
  kmSave();
  kbRender();
  return cap;
}
function kmReset() {
  KM = kmDefaults();
  kbSel = -1;
  kmSave();
  kbRender();
  mbRender();
}
function kmExport() {
  const s = JSON.stringify(KM);
  const el = document.getElementById("kmjson");
  if (el) el.value = s;
  mbSay("layout exported below; copy it, or paste one and press IMPORT");
  const out = document.getElementById("mbout");
  if (out) out.textContent = s;
  return s;
}
function kmImport(text) {
  const el = document.getElementById("kmjson");
  const s = text || (el && el.value) || "";
  try {
    const j = JSON.parse(s);
    if (!j || !j.caps || !j.books) throw new Error("not a layout");
    KM = j;
    kmSave();
    kbRender();
    mbRender();
    mbSay("layout imported");
    return true;
  } catch (err) { mbSay("bad layout: " + err); return false; }
}

// ---- the macro builder ----
function mbSay(s) {
  const el = document.getElementById("mbsay");
  if (el) el.textContent = s;
}
function mbStepLabel(s) {
  if (s[0] === "cmd") return s[1].toUpperCase() + (s[2] ? " " + s[2] : "");
  const m = kmBook()[s[1]];
  return "CALL MACRO " + (s[1] + 1) + (m ? " (" + m.name + ")" : "");
}
function mbRender() {
  const box = document.getElementById("mblist");
  if (box) {
    let html = "";
    kmBook().forEach((m, i) => {
      const n = kmExpandMacro(i).length;
      html += '<div class="mbrow"><button onclick="kmPlayMacro(' + i + ')">PLAY</button>' +
              '<button onclick="mbAddCall(' + i + ')">USE IN DRAFT</button>' +
              '<button onclick="mbAssign(' + i + ')">TO KEY F' + (i + 1) + '</button>' +
              '<span class="small">MACRO ' + (i + 1) + " &mdash; " + m.name +
              " &mdash; " + m.steps.length + " step" + (m.steps.length === 1 ? "" : "s") +
              ", " + n + " command" + (n === 1 ? "" : "s") + "</span></div>";
    });
    box.innerHTML = html || '<span class="small">no macros yet</span>';
  }
  const dr = document.getElementById("mbdraft");
  if (dr) {
    let html = "";
    kmDraft.forEach((s, i) => {
      html += '<button onclick="mbDrop(' + i + ')" title="remove">' +
              mbStepLabel(s) + " &times;</button>";
    });
    dr.innerHTML = html || '<span class="small">the draft is empty: press RECORD and ' +
      'play, or press a command button, or drop a whole macro in with USE IN DRAFT</span>';
  }
}
function mbRecord() {
  const b = document.getElementById("mbrec");
  if (kmRecording === null) {
    kmRecording = [];
    if (b) b.textContent = "STOP RECORDING";
    mbSay("recording: every command you send is written down");
  } else {
    for (const s of kmRecording) kmDraft.push(s);
    kmRecording = null;
    if (b) b.textContent = "RECORD";
    mbSay("recorded " + kmDraft.length + " step(s) in the draft");
    mbRender();
  }
}
function mbAddCall(i) {
  // a call may only reach a macro already in the book, which is what makes
  // expansion terminate (NixWars.Keys.expandSteps_call_ge)
  if (i < 0 || i >= kmBook().length) return;
  kmDraft.push(["call", i]);
  mbRender();
}
function mbAddCmd(tag, arg) { kmDraft.push(["cmd", tag, Number(arg) || 0]); mbRender(); }
function mbAddSelected() {
  const el = document.getElementById("mbtag"), ar = document.getElementById("mbarg");
  if (!el) return;
  mbAddCmd(String(el.value || ""), (ar && ar.value) || 0);
}
function mbDrop(i) { kmDraft.splice(i, 1); mbRender(); }
function mbClear() { kmDraft = []; mbRender(); }
function mbSave() {
  if (!kmDraft.length) { mbSay("nothing to save"); return null; }
  const el = document.getElementById("mbname");
  const name = ((el && el.value) || "").trim() || ("MACRO " + (kmBook().length + 1));
  const m = { name: name, steps: kmDraft.slice() };
  kmBook().push(m);
  kmDraft = [];
  kmSave();
  kbRender();
  mbRender();
  mbSay('saved "' + name + '" as macro ' + kmBook().length);
  return m;
}
function mbDeleteLast() {
  const bk = kmBook();
  if (!bk.length) return;
  // only the last macro may go: the ones before it may be called by it
  bk.pop();
  kmSave();
  kbRender();
  mbRender();
}
function mbAssign(i) {
  const key = "f" + (i + 1);
  kmBindKey(key, false, false, ["macro", i]);
  mbSay("macro " + (i + 1) + " is on " + key.toUpperCase());
}
function mbPreview() {
  const moves = kmExpand(kmBook(), kmDraft);
  const out = document.getElementById("mbout");
  if (out)
    out.textContent = moves.length
      ? moves.map(m => m[0].toUpperCase() + (m[1] ? " " + m[1] : "")).join("  ")
      : "(empty)";
  return moves;
}
function mbPlayDraft() {
  for (const [tag, arg] of kmExpand(kmBook(), kmDraft)) send(tag, arg);
}

// ---- the page against Lean ----
// KMAP.probes are lookups and KMAP.expand are macro expansions computed in
// Lean from the same tables; these are the page's own answers to them.
function kmSelfTest() {
  let ok = 0, total = 0;
  for (const [d, key, ctrl, shift, want] of KMAP.probes) {
    total++;
    const got = kmLookIn(KMAP.caps[d], key, ctrl, shift);
    if (JSON.stringify(got === undefined ? null : got) === JSON.stringify(want)) ok++;
  }
  for (const d of Object.keys(KMAP.expand)) {
    const bk = KMAP.books[d];
    KMAP.expand[d].forEach((want, i) => {
      total++;
      const got = kmExpand(bk.slice(0, i), bk[i].steps);
      if (JSON.stringify(got) === JSON.stringify(want)) ok++;
    });
  }
  return { ok: ok, total: total };
}
// the commands of the cabinet you are standing at, in the builder's picker
function kmFillTags() {
  const sel = document.getElementById("mbtag");
  if (!sel) return;
  let html = "";
  for (const t of Object.keys(DOORS[door].prog))
    html += '<option value="' + t + '">' + t.toUpperCase() + "</option>";
  sel.innerHTML = html;
}
// Each cabinet has its own keyboard and its own book, so walking to another
// one redraws both. render() calls this after every command.
let kbDoor = null;
function kbSync() {
  if (KM === null || kbDoor === door) return;
  kbDoor = door;
  kbSel = -1;
  kmDraft = [];
  kmStop();
  kmFillTags();
  kbRender();
  mbRender();
}
// on a phone the keyboard is a scroll away: this brings it up
function kbJump() {
  const el = document.getElementById("kbrows");
  if (!el) return;
  if (el.style && el.style.display === "none") kbToggle();
  if (el.scrollIntoView) el.scrollIntoView({ behavior: "smooth", block: "center" });
}
function kmInit() {
  kmLoad();
  kbDoor = null;
  kbSync();
  if (window.addEventListener) window.addEventListener("keydown", kmKeyDown);
}
"#

/-- The keyboard, the editor and the macro builder, as markup. -/
def keymapHtml : String := r#"
<h2>KEYBOARD &mdash; ON SCREEN, AND THE HOTKEYS</h2>
<div class="kbbar">
  <button onclick="kbToggle()" id="kbtoggle">HIDE KEYBOARD</button>
  <button onclick="kbEditToggle()" id="kbeditbtn">CUSTOMIZE</button>
  <button onclick="kmStop()">STOP MACRO</button>
</div>
<div id="kbrows" class="kbrows"></div>
<div id="kbedit" class="kbedit"></div>
<p class="small">The keys on screen and the keys under your fingers are one
table, emitted from the Lean development: every command of this cabinet is on
some key and no key sends anything the cabinet has not got, both proved
(defaultCaps_complete, defaultCaps_sound). Rebind a key and only that key
moves; put it back and the whole map is back (look_bind_undo). Your layout is
kept in this browser.</p>

<h2>MACRO BUILDER</h2>
<div id="mblist" class="mblist"></div>
<div class="kbbar">
  <button onclick="mbRecord()" id="mbrec">RECORD</button>
  <select id="mbtag"></select>
  <input id="mbarg" value="0" title="argument">
  <button onclick="mbAddSelected()">ADD STEP</button>
  <button onclick="mbPreview()">PREVIEW</button>
  <button onclick="mbPlayDraft()">PLAY DRAFT</button>
  <button onclick="mbClear()">CLEAR</button>
  <input id="mbname" placeholder="name">
  <button onclick="mbSave()">SAVE MACRO</button>
  <button onclick="mbDeleteLast()">DELETE LAST</button>
</div>
<div id="mbdraft" class="mbdraft"></div>
<div id="mbsay" class="small"></div>
<pre id="mbout"></pre>
<button id="kbjump" class="kbjump" onclick="kbJump()">&#9000; KEYS</button>
<p class="small">RECORD writes down every command you send, from any control on
the page &mdash; button, swipe, joystick or key &mdash; and replaying what it
wrote does exactly what you did (record_replay). A macro may call the macros
saved before it, and only those, so no macro can loop (expandSteps_call_ge);
two macros end to end run one and then the other (play_append). Each cabinet
starts with three: an opening, the opening twice, and the whole line of play
this development proves wins &mdash; on F1, F2 and F3.</p>
"#

/-- The rules that make a page of this project fit a phone: no tap flash, no
text inflation, thumb-sized controls and one column on a narrow screen. -/
def mobileCss : String := r#"
* { -webkit-tap-highlight-color:transparent; }
html { -webkit-text-size-adjust:100%; }
button, select, input { touch-action:manipulation; }
@media (max-width:700px) {
  body { padding:.6rem; font-size:13px; }
  h1 { font-size:1rem; }
  button { padding:.5rem .6rem; min-height:44px; }
  input, select { min-height:40px; }
  .grid { grid-template-columns:1fr; }
  pre { font-size:12px; }
  .gate { width:150px; height:150px; }
  .knob { width:56px; height:56px; left:47px; top:47px; }
  .pad button { min-width:56px; min-height:48px; }
  canvas { width:100%; height:auto; }
}
"#

/-- The keyboard's and the builder's styling. -/
def keyboardCss : String := r#"
.kbbar { display:flex; flex-wrap:wrap; gap:4px; align-items:center; margin:.3rem 0; }
.kbrows { margin:.3rem 0; }
.kbrow { display:flex; gap:4px; margin-bottom:4px; }
.kbkey { flex:1; min-height:52px; display:flex; flex-direction:column; align-items:center;
         justify-content:center; line-height:1.1; margin:0; touch-action:manipulation; }
.kbkey .kbsub { font-size:.6rem; opacity:.55; letter-spacing:.05em; }
.kbkey.kbmacro { border-color:#8fffa5; }
.kbkey.kbsel { background:#14361a; outline:1px solid #8fffa5; }
.kbedit { margin:.3rem 0; }
.kbform { display:flex; flex-wrap:wrap; gap:4px; align-items:center; margin:.3rem 0; }
.kbform input { width:6rem; }
.mblist { margin:.3rem 0; }
.mbrow { display:flex; flex-wrap:wrap; gap:4px; align-items:center; margin-bottom:3px; }
.mbdraft { display:flex; flex-wrap:wrap; gap:4px; margin:.3rem 0; }
select { background:#060806; color:#3cff5a; border:1px solid #2f7a3a; padding:.3rem;
         font-family:inherit; }
.kbjump { display:none; }
@media (max-width:700px) {
  .kbkey { min-height:58px; }
  .kbjump { display:block; position:fixed; right:10px; bottom:10px; z-index:9;
            opacity:.92; box-shadow:0 0 8px #04140a; }
}
"#

/-- The keyboard's styling and the phone rules together, as the board's page
takes them. -/
def keymapCss : String := keyboardCss ++ mobileCss

end Keys
end NixWars
