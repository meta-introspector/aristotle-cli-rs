import RequestProject.TouchSystem

/-!
Emits the payload of `touch.html` — the mobile control layer page — and of the
control overlay that every other page carries.

What it ships:

* the pad, hotkeys, swipes and macro library the page starts from, exactly as
  Lean defines them, plus the macro table Lean compiles from that library;
* a table of test vectors: inputs together with the answers Lean's own
  functions give, which the page's Self-check tab and `scripts/test_touch.js`
  replay against the page's JavaScript transcription.

Usage, from the project root:

    lake build RequestProject.TouchSystem
    lake env lean --run scripts/emit_touch.lean > /tmp/touch.json
    python3 scripts/build_touch.py /tmp/touch.json touch.html
    python3 scripts/mobilize.py /tmp/touch.json
    node scripts/test_touch.js
-/

open Touch

/-! ## JSON helpers -/

def esc (s : String) : String :=
  "\"" ++ String.ofList (s.toList.flatMap (fun c =>
    if c = '"' then ['\\', '"']
    else if c = '\\' then ['\\', '\\']
    else if c = '\n' then ['\\', 'n']
    else [c])) ++ "\""

def jarr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"

def jobj (fs : List (String × String)) : String :=
  "{" ++ String.intercalate "," (fs.map (fun f => esc f.1 ++ ":" ++ f.2)) ++ "}"

def jint (n : Int) : String := toString n

def jnat (n : Nat) : String := toString n

def jbool (b : Bool) : String := if b then "true" else "false"

/-! ## Encoding the model -/

def rectJson (r : Rect) : String :=
  jobj [("x", jint r.x), ("y", jint r.y), ("w", jint r.w), ("h", jint r.h)]

def kindJson : WidgetKind → String
  | .key c => jobj [("t", esc "key"), ("code", esc c)]
  | .stick => jobj [("t", esc "stick")]
  | .trackpad => jobj [("t", esc "trackpad")]
  | .macroBtn n => jobj [("t", esc "macro"), ("name", esc n)]

def widgetJson (w : Widget) : String :=
  jobj [("id", esc w.id), ("kind", kindJson w.kind), ("rect", rectJson w.rect)]

def layoutJson (l : Layout) : String := jarr (l.widgets.map widgetJson)

def chordJson (c : Chord) : String :=
  jobj [("ctrl", jbool c.ctrl), ("alt", jbool c.alt), ("shift", jbool c.shift),
        ("key", esc c.key)]

def actionJson : Action → String
  | .send c => jobj [("t", esc "send"), ("code", esc c)]
  | .mouse e => jobj [("t", esc "mouse"), ("e", esc (match e with
      | .click => "click" | .rightClick => "rightClick" | .drag => "drag" | .move => "move"))]
  | .run n => jobj [("t", esc "run"), ("name", esc n)]
  | .nav t => jobj [("t", esc "nav"), ("tab", esc t)]

def gestureName : Gesture → String
  | .tap => "tap" | .hold => "hold" | .swipeL => "swipeL" | .swipeR => "swipeR"
  | .swipeU => "swipeU" | .swipeD => "swipeD" | .drag => "drag"

def dirName : Dir8 → String
  | .neutral => "neutral" | .e => "e" | .ne => "ne" | .n => "n" | .nw => "nw"
  | .w => "w" | .sw => "sw" | .s => "s" | .se => "se"

def padKeyName : PadKey → String
  | .up => "up" | .down => "down" | .left => "left" | .right => "right"

def keymapJson (km : Keymap) : String :=
  jarr (km.map (fun b => jobj [("chord", chordJson b.1), ("action", actionJson b.2)]))

def swipesJson (sm : SwipeMap) : String :=
  jarr (sm.map (fun b => jobj [("gesture", esc (gestureName b.1)), ("action", actionJson b.2)]))

partial def stepJson : Step → String
  | .press c => jobj [("t", esc "press"), ("chord", chordJson c)]
  | .tapId w => jobj [("t", esc "tap"), ("widget", esc w)]
  | .wait n => jobj [("t", esc "wait"), ("ms", jnat n)]
  | .call n => jobj [("t", esc "call"), ("name", esc n)]
  | .repeatN n body => jobj [("t", esc "repeat"), ("n", jnat n),
      ("body", jarr (body.map stepJson))]

def eventJson : Event → String
  | .press c => jobj [("t", esc "press"), ("chord", chordJson c)]
  | .tapId w => jobj [("t", esc "tap"), ("widget", esc w)]
  | .wait n => jobj [("t", esc "wait"), ("ms", jnat n)]

def libJson (lib : List (String × List Step)) : String :=
  jarr (lib.map (fun e => jobj [("name", esc e.1), ("steps", jarr (e.2.map stepJson))]))

def tableJson (tbl : MacroTable) : String :=
  jarr (tbl.map (fun e => jobj [("name", esc e.1), ("events", jarr (e.2.map eventJson))]))

def outJson : Out → String
  | .key c => jobj [("t", esc "key"), ("chord", chordJson c)]
  | .tapId w => jobj [("t", esc "tap"), ("widget", esc w)]
  | .wait n => jobj [("t", esc "wait"), ("ms", jnat n)]
  | .mouse e p => jobj [("t", esc "mouse"), ("e", esc (match e with
      | .click => "click" | .rightClick => "rightClick" | .drag => "drag" | .move => "move")),
      ("x", jint p.x), ("y", jint p.y)]
  | .nav t => jobj [("t", esc "nav"), ("tab", esc t)]
  | .hold ks => jobj [("t", esc "hold"), ("keys", jarr (ks.map (fun k => esc (padKeyName k))))]

/-! ## Test vectors -/

def vec (fn : String) (args : List String) (out : String) : String :=
  jobj [("fn", esc fn), ("args", jarr args), ("out", out)]

/-- Traces to classify: taps, holds, the four swipes, drags, ties and edge
cases, each also translated, reversed and mirrored. -/
def traceCases : List Trace :=
  [ ⟨⟨100, 100⟩, ⟨100, 100⟩, 80⟩,
    ⟨⟨100, 100⟩, ⟨105, 103⟩, 120⟩,
    ⟨⟨100, 100⟩, ⟨105, 103⟩, 800⟩,
    ⟨⟨100, 100⟩, ⟨100, 100⟩, 500⟩,
    ⟨⟨100, 100⟩, ⟨160, 100⟩, 200⟩,
    ⟨⟨160, 100⟩, ⟨100, 100⟩, 200⟩,
    ⟨⟨100, 300⟩, ⟨100, 360⟩, 200⟩,
    ⟨⟨100, 360⟩, ⟨100, 300⟩, 200⟩,
    ⟨⟨100, 100⟩, ⟨140, 140⟩, 200⟩,
    ⟨⟨100, 100⟩, ⟨140, 141⟩, 200⟩,
    ⟨⟨100, 100⟩, ⟨125, 100⟩, 200⟩,
    ⟨⟨100, 100⟩, ⟨100, 125⟩, 900⟩,
    ⟨⟨0, 0⟩, ⟨-60, -20⟩, 150⟩,
    ⟨⟨380, 800⟩, ⟨320, 700⟩, 150⟩ ]

def traceJson (t : Trace) : String :=
  jobj [("sx", jint t.start.x), ("sy", jint t.start.y),
        ("fx", jint t.finish.x), ("fy", jint t.finish.y), ("ms", jnat t.ms)]

def gestureVectors : List String :=
  let c := defaultGesture
  traceCases.flatMap (fun t =>
    [ vec "recognize" [traceJson t] (esc (gestureName (recognize c t))),
      vec "recognize" [traceJson (t.translate ⟨17, -23⟩)]
        (esc (gestureName (recognize c (t.translate ⟨17, -23⟩)))),
      vec "recognize" [traceJson t.reverse] (esc (gestureName (recognize c t.reverse))),
      vec "recognize" [traceJson t.mirrorX] (esc (gestureName (recognize c t.mirrorX))) ])

def stickCases : List Pt :=
  [ ⟨0, 0⟩, ⟨5, 5⟩, ⟨12, 0⟩, ⟨13, 0⟩, ⟨40, 0⟩, ⟨-40, 0⟩, ⟨0, 40⟩, ⟨0, -40⟩,
    ⟨40, 40⟩, ⟨-40, 40⟩, ⟨40, -40⟩, ⟨-40, -40⟩, ⟨60, 25⟩, ⟨25, 60⟩,
    ⟨60, 30⟩, ⟨30, 60⟩, ⟨100, 100⟩, ⟨-100, 3⟩ ]

def stickVectors : List String :=
  let c := defaultStick
  stickCases.flatMap (fun v =>
    [ vec "dir8" [jint v.x, jint v.y] (esc (dirName (dir8 c v))),
      vec "dir8keys" [jint v.x, jint v.y]
        (jarr ((dir8 c v).keys.map (fun k => esc (padKeyName k)))),
      vec "knob" [jint v.x, jint v.y]
        (jobj [("x", jint (knob c v).x), ("y", jint (knob c v).y)]) ])

def hitCases : List Pt :=
  [ ⟨90, 700⟩, ⟨200, 660⟩, ⟨300, 700⟩, ⟨30, 500⟩, ⟨60, 570⟩, ⟨330, 520⟩,
    ⟨0, 0⟩, ⟨389, 843⟩, ⟨16, 620⟩, ⟨166, 620⟩, ⟨165, 769⟩, ⟨120, 546⟩ ]

def hitVectors : List String :=
  hitCases.map (fun p =>
    vec "hitTest" [jint p.x, jint p.y]
      (match defaultPad.hitTest p with
       | some w => esc w.id
       | none => "null"))

def editCases : List (String × Edit) :=
  [ ("move stick right", .move "stick" 40 0),
    ("move stick off screen", .move "stick" 400 0),
    ("move stick onto the trackpad", .move "stick" 100 0),
    ("shrink a key below the target size", .resize "k-esc" (-10) 0),
    ("grow a key into its neighbour", .resize "k-esc" 40 0),
    ("grow a key a little", .resize "k-esc" 4 4),
    ("remove a key", .remove "k-tab"),
    ("add a new key", .add ⟨"k-new", .key "F1", ⟨16, 200, 60, 60⟩⟩),
    ("add a key on top of another", .add ⟨"k-new", .key "F1", ⟨20, 500, 60, 60⟩⟩),
    ("add a key with a used id", .add ⟨"k-esc", .key "F1", ⟨16, 200, 60, 60⟩⟩),
    ("add a key that is too small", .add ⟨"k-new", .key "F1", ⟨16, 200, 20, 20⟩⟩),
    ("rebind a key to a macro", .rebind "k-esc" (.macroBtn "dig")) ]

def editJson : Edit → String
  | .add w => jobj [("t", esc "add"), ("widget", widgetJson w)]
  | .remove id => jobj [("t", esc "remove"), ("id", esc id)]
  | .move id dx dy => jobj [("t", esc "move"), ("id", esc id), ("dx", jint dx), ("dy", jint dy)]
  | .resize id dw dh => jobj [("t", esc "resize"), ("id", esc id), ("dw", jint dw), ("dh", jint dh)]
  | .rebind id k => jobj [("t", esc "rebind"), ("id", esc id), ("kind", kindJson k)]

def editVectors : List String :=
  editCases.map (fun e =>
    vec "applyEdit" [esc e.1, editJson e.2]
      (match applyEdit phoneScreen defaultPad e.2 with
       | some l => layoutJson l
       | none => "null"))

def macroVectors : List String :=
  [ vec "compileLib" [] (tableJson defaultTable),
    vec "libWF" [] (jbool (libWF defaultLib)),
    vec "duration" [esc "home"]
      (jnat (duration ((defaultTable.lookup "home").getD []))),
    vec "duration" [esc "refuel"]
      (jnat (duration ((defaultTable.lookup "refuel").getD []))),
    vec "macroLength" [esc "home"]
      (jnat ((defaultTable.lookup "home").getD []).length),
    vec "conflictsKeys" [] (jarr ((conflicts defaultKeymap).map chordJson)),
    vec "conflictsSwipes" [] (jarr ((conflicts defaultSwipes).map (fun g => esc (gestureName g)))),
    vec "conflictsClash" []
      (jarr ((conflicts (defaultKeymap ++ [(⟨true, false, false, "d"⟩, .nav "next")])).map
        chordJson)) ]

def inputCases : List Input :=
  [ .touch ⟨⟨90, 700⟩, ⟨92, 702⟩, 90⟩,
    .touch ⟨⟨60, 570⟩, ⟨60, 570⟩, 90⟩,
    .touch ⟨⟨30, 500⟩, ⟨30, 500⟩, 90⟩,
    .touch ⟨⟨300, 700⟩, ⟨340, 690⟩, 200⟩,
    .touch ⟨⟨200, 200⟩, ⟨120, 205⟩, 150⟩,
    .touch ⟨⟨200, 200⟩, ⟨280, 205⟩, 150⟩,
    .touch ⟨⟨200, 200⟩, ⟨200, 200⟩, 900⟩,
    .stickAt ⟨40, -40⟩,
    .stickAt ⟨0, 0⟩,
    .chord ⟨true, false, false, "d"⟩,
    .chord ⟨false, false, false, "Tab"⟩,
    .chord ⟨false, true, false, "q"⟩ ]

def inputJson : Input → String
  | .touch t => jobj [("t", esc "touch"), ("trace", traceJson t)]
  | .stickAt v => jobj [("t", esc "stick"), ("x", jint v.x), ("y", jint v.y)]
  | .chord c => jobj [("t", esc "chord"), ("chord", chordJson c)]

def handleVectors : List String :=
  inputCases.map (fun i =>
    let r := handle defaultSystem i
    vec "handle" [inputJson i]
      (jobj [("outs", jarr (r.2.map outJson)),
             ("px", jint r.1.pointer.x), ("py", jint r.1.pointer.y)]))

def clampVectors : List String :=
  [(⟨-30, 900⟩ : Pt), ⟨195, 300⟩, ⟨500, -20⟩, ⟨389, 843⟩].map (fun p =>
    let q := clampPt phoneScreen p
    vec "clampPt" [jint p.x, jint p.y] (jobj [("x", jint q.x), ("y", jint q.y)]))

def allVectors : List String :=
  gestureVectors ++ stickVectors ++ hitVectors ++ editVectors ++ macroVectors
    ++ handleVectors ++ clampVectors

def payload : String :=
  jobj [
    ("screen", rectJson phoneScreen),
    ("pad", layoutJson defaultPad),
    ("minTarget", jint minTarget),
    ("gesture", jobj [("slop", jint defaultGesture.slop),
                      ("swipeMin", jint defaultGesture.swipeMin),
                      ("holdMs", jnat defaultGesture.holdMs)]),
    ("stick", jobj [("radius", jint defaultStick.radius), ("dead", jint defaultStick.dead)]),
    ("keymap", keymapJson defaultKeymap),
    ("swipes", swipesJson defaultSwipes),
    ("lib", libJson defaultLib),
    ("table", tableJson defaultTable),
    ("pointer", jobj [("x", jint defaultSystem.pointer.x), ("y", jint defaultSystem.pointer.y)]),
    ("vectors", jarr allVectors)
  ]

def main : IO Unit := IO.println payload
