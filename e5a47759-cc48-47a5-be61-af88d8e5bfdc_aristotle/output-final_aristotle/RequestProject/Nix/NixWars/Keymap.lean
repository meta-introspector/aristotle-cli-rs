import RequestProject.Nix.NixWars.Agents

/-!
# Keys, caps and macros: the customizable control surface

`Controls` gave the cabinets a thumb: a swipe, a mouse drag and a push of the
on-screen joystick all go through one classifier. This file gives them the
other half of a modern control surface, and gives it the same treatment — the
page carries no hand-written binding table, and every claim the panel makes
about itself is checked here.

* a **chord** is a key with its modifiers, and a **keymap** is an association
  list from chords to **actions**: send a command, or run a macro. `kmBind`
  and `kmDrop` are the two edits a player can make, and they behave: the key
  you just bound is bound (`look_bind_self`), no other key moves
  (`look_bind_of_ne`), binding twice is binding once (`kmBind_kmBind`), and
  rebinding a key back to what it was restores the whole map
  (`look_bind_undo`) — so customisation is always undoable;

* a **cap** is one key of the on-screen keyboard: a chord, a label, the row it
  sits in, how wide it is, and what it does. The keymap *is* the caps
  (`keymapOf`), so the on-screen keyboard and the hotkeys cannot disagree
  (`onscreen_eq_hotkey`), and dragging a cap to another row or making it wider
  changes nothing about what it does (`keymapOf_moveCap`, `keymapOf_resizeCap`);

* the default caps are proved to be *exactly* the cabinet's controls: every
  command of every door on the board is on some key (`defaultCaps_complete`),
  no key sends anything the door does not have (`defaultCaps_sound`), and no
  chord is bound twice (`defaultCaps_nodup`);

* a **macro** is a named list of steps, and a step is a command or a call to
  another macro. A call may only reach macros defined *before* it — that is
  built into `expandSteps`, which passes `bk.take i` to the callee — so
  expansion is total and no macro can loop (`expandSteps_call_ge`). Expansion
  is a monoid map (`expandSteps_append`), so a macro built out of two macros
  runs one and then the other (`play_append`);

* the default books are the *proved* lines of play of `Agents`, and each one is
  replayed here through the shipped WebAssembly module: expanding the macro and
  calling the module's exports in that order lands on the vector Lean says
  (`bookLine_replay`);

* and the macro builder's record button is faithful: recording the keys you
  press and replaying the recording is the same as having pressed them
  (`record_replay`).
-/

set_option maxRecDepth 1000000

namespace NixWars
namespace Keys

open Agents

/-! ## Chords -/

/-- A key with its modifiers, as the browser reports it: the key name is
lower-case (`"a"`, `"arrowleft"`, `" "`). -/
structure Chord where
  /-- Was control held? -/
  ctrl : Bool := false
  /-- Was shift held? -/
  shift : Bool := false
  /-- The key, lower-cased. -/
  key : String
  deriving DecidableEq, Repr, Inhabited

/-- A plain key, no modifiers. -/
def plain (k : String) : Chord := { key := k }

/-- What a key does. -/
inductive Action
  /-- Send one command of the cabinet. -/
  | move (m : Move)
  /-- Run macro number `i` of the door's book. -/
  | macroCall (i : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- The command a key sends, if it sends one. -/
def Action.tagOf : Action → Option String
  | .move m => some m.tag
  | .macroCall _ => none

/-- A keymap: chords in order, first match wins. -/
abbrev Keymap := List (Chord × Action)

/-- What a chord does under a keymap. -/
def look : Keymap → Chord → Option Action
  | [], _ => none
  | (c, a) :: r, c' => if c = c' then some a else look r c'

/-- Unbind a chord. -/
def kmDrop (c : Chord) (m : Keymap) : Keymap := m.filter (fun b => !(decide (b.1 = c)))

/-- Bind a chord, replacing whatever it did before. -/
def kmBind (c : Chord) (a : Action) (m : Keymap) : Keymap := (c, a) :: kmDrop c m

/-! ### Customisation behaves -/

/-- The key you just bound is bound. -/
@[simp] theorem look_bind_self (c : Chord) (a : Action) (m : Keymap) :
    look (kmBind c a m) c = some a := by simp [kmBind, look]

/-- An unbound key is unbound. -/
theorem look_drop_self (c : Chord) (m : Keymap) : look (kmDrop c m) c = none := by
  induction m with
  | nil => simp [kmDrop, look]
  | cons b m ih =>
      obtain ⟨k, a⟩ := b
      simp only [kmDrop, List.filter_cons] at *
      by_cases hk : k = c
      · simpa [hk] using ih
      · simp [hk, look, ih]

/-- Unbinding one key leaves the others alone. -/
theorem look_drop_of_ne {c c' : Chord} (h : c' ≠ c) (m : Keymap) :
    look (kmDrop c m) c' = look m c' := by
  induction m with
  | nil => simp [kmDrop, look]
  | cons b m ih =>
      obtain ⟨k, a⟩ := b
      simp only [kmDrop, List.filter_cons] at *
      by_cases hk : k = c
      · subst hk
        simp only [decide_true, Bool.not_true, Bool.false_eq_true, if_false]
        rw [ih, look]
        simp [Ne.symm h]
      · simp [hk, look, ih]

/-- Binding one key leaves the others alone. -/
theorem look_bind_of_ne {c c' : Chord} (h : c' ≠ c) (a : Action) (m : Keymap) :
    look (kmBind c a m) c' = look m c' := by
  simp [kmBind, look, Ne.symm h, look_drop_of_ne h]

/-- Binding a key twice is binding it once: the map does not grow. -/
theorem kmBind_kmBind (c : Chord) (a a' : Action) (m : Keymap) :
    kmBind c a (kmBind c a' m) = kmBind c a m := by
  simp [kmBind, kmDrop, List.filter_filter]

/-- **Customisation is undoable.** Rebinding a key back to what it did restores
the map, whatever it was bound to in between. -/
theorem look_bind_undo {c : Chord} {a : Action} {m : Keymap} (h : look m c = some a)
    (a' : Action) (c' : Chord) :
    look (kmBind c a (kmBind c a' m)) c' = look m c' := by
  by_cases hc : c' = c
  · subst hc; simp [h]
  · rw [look_bind_of_ne hc, look_bind_of_ne hc]

/-- A map with no chord bound twice stays that way. -/
theorem keys_nodup_bind (c : Chord) (a : Action) (m : Keymap)
    (h : (m.map Prod.fst).Nodup) : ((kmBind c a m).map Prod.fst).Nodup := by
  simp only [kmBind, kmDrop, List.map_cons, List.nodup_cons]
  refine ⟨?_, List.Nodup.sublist ((List.filter_sublist (l := m)).map Prod.fst) h⟩
  intro hm
  simp only [List.mem_map, List.mem_filter] at hm
  obtain ⟨b, ⟨_, hb⟩, hbc⟩ := hm
  simp [hbc] at hb

/-! ## Caps: the on-screen keyboard

A cap is one key of the on-screen keyboard. The caps *are* the keymap, so the
thumb and the hotkey cannot drift apart. -/

/-- One key of the on-screen keyboard. -/
structure Cap where
  /-- The chord this cap is, on a physical keyboard. -/
  chord : Chord
  /-- What is written on it. -/
  label : String
  /-- Which row of the keyboard it sits in. -/
  row : Nat
  /-- How many units wide it is. -/
  span : Nat
  /-- What it does. -/
  act : Action
  deriving DecidableEq, Repr, Inhabited

/-- A command cap. -/
def mv (key label tag : String) (arg : Nat := 0) (row : Nat := 0) (span : Nat := 1) : Cap :=
  { chord := plain key, label := label, row := row, span := span, act := .move ⟨tag, arg⟩ }

/-- A macro cap. -/
def mc (key label : String) (i : Nat) (row : Nat := 2) (span : Nat := 2) : Cap :=
  { chord := plain key, label := label, row := row, span := span, act := .macroCall i }

/-- The keymap a keyboard denotes. -/
def keymapOf (caps : List Cap) : Keymap := caps.map (fun c => (c.chord, c.act))

/-- **The on-screen key and the hotkey are the same key.** Tapping a cap does
what pressing its chord does. -/
theorem onscreen_eq_hotkey (caps : List Cap) (ch : Chord) (c : Cap)
    (h : caps.find? (fun c => decide (c.chord = ch)) = some c) :
    look (keymapOf caps) ch = some c.act := by
  induction caps with
  | nil => simp at h
  | cons b caps ih =>
      by_cases hb : b.chord = ch
      · rw [List.find?_cons_of_pos (by simpa using hb)] at h
        cases h
        simp [keymapOf, look, hb]
      · rw [List.find?_cons_of_neg (by simpa using hb)] at h
        simp only [keymapOf, List.map_cons, look, if_neg hb]
        exact ih h

/-! ### Editing the keyboard -/

/-- Point a cap at a different action. -/
def rebind (ch : Chord) (a : Action) (caps : List Cap) : List Cap :=
  caps.map (fun c => if c.chord = ch then { c with act := a } else c)

/-- Drag a cap into another row. -/
def moveCap (ch : Chord) (r : Nat) (caps : List Cap) : List Cap :=
  caps.map (fun c => if c.chord = ch then { c with row := r } else c)

/-- Make a cap wider or narrower. -/
def resizeCap (ch : Chord) (w : Nat) (caps : List Cap) : List Cap :=
  caps.map (fun c => if c.chord = ch then { c with span := w } else c)

/-- Take a cap off the keyboard. -/
def removeCap (ch : Chord) (caps : List Cap) : List Cap :=
  caps.filter (fun c => !(decide (c.chord = ch)))

/-- **Rearranging the keyboard never changes what the keys do.** -/
@[simp] theorem keymapOf_moveCap (ch : Chord) (r : Nat) (caps : List Cap) :
    keymapOf (moveCap ch r caps) = keymapOf caps := by
  induction caps with
  | nil => rfl
  | cons c caps ih =>
      simp only [keymapOf, moveCap, List.map_cons, List.map_map, Function.comp_def] at *
      by_cases h : c.chord = ch <;> simp [h, ih]

/-- **Resizing a key never changes what it does.** -/
@[simp] theorem keymapOf_resizeCap (ch : Chord) (w : Nat) (caps : List Cap) :
    keymapOf (resizeCap ch w caps) = keymapOf caps := by
  induction caps with
  | nil => rfl
  | cons c caps ih =>
      simp only [keymapOf, resizeCap, List.map_cons, List.map_map, Function.comp_def] at *
      by_cases h : c.chord = ch <;> simp [h, ih]

/-- The keyboard keeps its keys when it is rearranged. -/
theorem moveCap_chords (ch : Chord) (r : Nat) (caps : List Cap) :
    (moveCap ch r caps).map Cap.chord = caps.map Cap.chord := by
  induction caps with
  | nil => rfl
  | cons c caps ih =>
      simp only [moveCap, List.map_cons, List.map_map, Function.comp_def] at *
      by_cases h : c.chord = ch <;> simp [h, ih]

/-- Rebinding a cap rebinds its chord. -/
theorem look_rebind_self (ch : Chord) (a : Action) (caps : List Cap)
    (h : ch ∈ caps.map Cap.chord) : look (keymapOf (rebind ch a caps)) ch = some a := by
  induction caps with
  | nil => simp at h
  | cons c caps ih =>
      simp only [keymapOf, rebind, List.map_cons, List.map_map, Function.comp_def] at *
      by_cases hc : c.chord = ch
      · simp [hc, look]
      · have hmem : ch ∈ caps.map Cap.chord := by
          simp only [List.mem_cons] at h
          exact h.resolve_left (fun hh => hc hh.symm)
        simp only [look, if_neg hc]
        exact ih hmem

/-- Rebinding one cap leaves the other keys alone. -/
theorem look_rebind_of_ne {ch ch' : Chord} (h : ch' ≠ ch) (a : Action) (caps : List Cap) :
    look (keymapOf (rebind ch a caps)) ch' = look (keymapOf caps) ch' := by
  induction caps with
  | nil => rfl
  | cons c caps ih =>
      simp only [keymapOf, rebind, List.map_cons, List.map_map, Function.comp_def] at *
      by_cases hc : c.chord = ch
      · simp only [if_pos hc, look]
        subst hc
        simp [Ne.symm h, ih]
      · simp only [if_neg hc, look, ih]

/-- A removed cap is not on the keyboard any more. -/
theorem chord_not_mem_removeCap (ch : Chord) (caps : List Cap) :
    ch ∉ (removeCap ch caps).map Cap.chord := by
  simp only [removeCap, List.mem_map, List.mem_filter, not_exists]
  rintro c ⟨⟨_, hc⟩, rfl⟩
  simp at hc

/-! ## Macros -/

/-- A step of a macro: a command, or a call to an earlier macro. -/
inductive Step
  /-- Send one command. -/
  | cmd (m : Move)
  /-- Run macro number `i` of the same book. -/
  | call (i : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- A named macro. -/
structure Macro where
  /-- What the player called it. -/
  name : String
  /-- What it does. -/
  steps : List Step
  deriving DecidableEq, Repr, Inhabited

/-- A door's book of macros. -/
abbrev Book := List Macro

/-- **Expansion.** A macro's calls are expanded against the macros defined
*before* it — `bk.take i` — so expansion is total by construction and a macro
cannot call itself, directly or round a cycle. -/
def expandSteps : Book → List Step → List Move
  | _, [] => []
  | bk, .cmd m :: rest => m :: expandSteps bk rest
  | bk, .call i :: rest =>
      (if h : i < bk.length then expandSteps (bk.take i) (bk[i]'h).steps else []) ++
        expandSteps bk rest
termination_by bk steps => (bk.length, steps.length)

/-- A list of commands, as steps. -/
def ofMoves (ms : List Move) : List Step := ms.map .cmd

@[simp] theorem expandSteps_map_cmd (bk : Book) (ms : List Move) :
    expandSteps bk (ms.map Step.cmd) = ms := by
  induction ms with
  | nil => simp [expandSteps]
  | cons m ms ih => simpa [expandSteps] using ih

theorem expandSteps_ofMoves (bk : Book) (ms : List Move) :
    expandSteps bk (ofMoves ms) = ms := by
  simp [ofMoves]

/-- **Expansion is a monoid map**: a macro built by putting two macros end to
end expands to their expansions, end to end. -/
theorem expandSteps_append (bk : Book) (s t : List Step) :
    expandSteps bk (s ++ t) = expandSteps bk s ++ expandSteps bk t := by
  induction s with
  | nil => simp [expandSteps]
  | cons a s ih =>
      cases a with
      | cmd m => simp [expandSteps, ih]
      | call i => simp [expandSteps, ih, List.append_assoc]

/-- **No macro can loop.** A call that does not point strictly backwards
expands to nothing at all. -/
theorem expandSteps_call_ge (bk : Book) (i : Nat) (h : bk.length ≤ i) :
    expandSteps bk [.call i] = [] := by
  simp [expandSteps, Nat.not_lt.mpr h]

/-! ### Playing a macro on the shipped module -/

/-- Playing a list of commands, one after another, through the WebAssembly the
page ships (`Agents.wasmPlay`). -/
def play (door : String) (bk : Book) (steps : List Step) (st : List Nat) : Option (List Nat) :=
  wasmPlay door (expandSteps bk steps) st

/-- Commands compose: playing two lines is playing the first and then the
second. -/
theorem wasmPlay_append (door : String) (ms ns : List Move) (st : List Nat) :
    wasmPlay door (ms ++ ns) st = (wasmPlay door ms st).bind (wasmPlay door ns) := by
  induction ms generalizing st with
  | nil => simp [wasmPlay]
  | cons m ms ih =>
      cases h : wasmCall door m st with
      | none => simp [wasmPlay, h]
      | some st' => simp [wasmPlay, h, ih]

/-- **Macros compose.** A macro made of two macros runs the first and then the
second, on the module itself. -/
theorem play_append (door : String) (bk : Book) (s t : List Step) (st : List Nat) :
    play door bk (s ++ t) st = (play door bk s st).bind (play door bk t) := by
  simp [play, expandSteps_append, wasmPlay_append]

/-! ### Recording

The builder's record button watches the keys you press and writes them down.
`record` is what it writes; `pressAll` is what the keys did. They agree. -/

/-- One keystroke, as a step. Keys that are not bound write nothing down. -/
def stepOfChord (km : Keymap) (c : Chord) : List Step :=
  match look km c with
  | none => []
  | some (.move m) => [.cmd m]
  | some (.macroCall i) => [.call i]

/-- What the record button writes down. -/
def record (km : Keymap) : List Chord → List Step
  | [] => []
  | c :: cs => stepOfChord km c ++ record km cs

/-- What the keys did, pressed one at a time. -/
def pressAll (door : String) (km : Keymap) (bk : Book) :
    List Chord → List Nat → Option (List Nat)
  | [], st => some st
  | c :: cs, st =>
      match play door bk (stepOfChord km c) st with
      | none => none
      | some st' => pressAll door km bk cs st'

/-- **The record button is faithful.** Replaying a recorded macro does exactly
what pressing those keys did. -/
theorem record_replay (door : String) (km : Keymap) (bk : Book) (cs : List Chord)
    (st : List Nat) : play door bk (record km cs) st = pressAll door km bk cs st := by
  induction cs generalizing st with
  | nil => simp [play, record, expandSteps, wasmPlay, pressAll]
  | cons c cs ih =>
      rw [record, play_append]
      cases h : play door bk (stepOfChord km c) st with
      | none => simp [h, pressAll]
      | some st' => simp [h, pressAll, ih]

/-! ## The default keyboards

One keyboard per door: the commands of the cabinet on the keys, and three macro
keys. Everything the page draws is emitted from this table. -/

/-- The keys of a door, by name. -/
def defaultCaps : String → List Cap
  | "nixwars" =>
      [mv "1" "WARP 1" "warp" 1, mv "9" "WARP 99" "warp" 99, mv "s" "SCAN" "scan",
       mv "t" "STATUS" "status", mv "j" "J-NAV" "jnav", mv "u" "UNLOCK" "unlock" 0 1,
       mv "q" "QUIT" "quit" 0 1,
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "dash" =>
      [mv "a" "\u2190 LEFT" "left", mv "d" "RIGHT \u2192" "right", mv " " "TICK" "tick" 0 0 2,
       mv "arrowleft" "\u2190" "left" 0 1, mv "arrowright" "\u2192" "right" 0 1,
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "market" =>
      [mv "b" "BUY" "buy", mv "s" "SELL" "sell", mv "h" "HOLD" "hold",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "lord" =>
      [mv "a" "ATTACK" "attack", mv "h" "HEAL" "heal", mv "f" "FLEE" "flee",
       mv "r" "REST" "rest",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "hunt" =>
      [mv "m" "MOVE 17" "move" 17, mv "s" "SHOOT 48" "shoot" 48, mv "e" "SENSE" "sense",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "zx81" =>
      [mv "s" "STEP" "step", mv "f" "FAST 30" "fast" 30, mv "r" "RESET" "reset",
       mv "l" "LOAD 0" "load" 0,
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "frens" =>
      [mv "c" "CLAIM" "claim", mv "p" "PASS" "pass", mv "k" "CROWN" "crown",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "tycoon" =>
      [mv "m" "MINE" "mine", mv "f" "FORGE" "forge", mv "r" "RUN" "run",
       mv "d" "DUMP" "dump",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "meme" =>
      [mv "b" "BREED" "breed", mv "m" "MUTATE" "mutate", mv "s" "SELECT" "select",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "hyper" =>
      [mv "f" "FWD 3" "fwd" 3, mv "b" "BACK 3" "back" 3, mv "h" "HOME" "home",
       mv "y" "Y \u2014 FIX" "fix",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "oracle" =>
      [mv "w" "WITNESS" "witness", mv "l" "LIFT" "lift", mv "m" "MINT" "mint",
       mv "a" "AUDIT" "audit",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "vote" =>
      [mv "a" "AYE" "aye", mv "n" "NAY" "nay", mv "t" "TALLY" "tally",
       mv "x" "NEXT" "next",
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "qbert" =>
      [mv "q" "\u2196 UL" "ul", mv "w" "\u2197 UR" "ur", mv "a" "\u2199 DL" "dl",
       mv "s" "\u2198 DR" "dr",
       mv "arrowleft" "\u2196" "ul" 0 1, mv "arrowup" "\u2197" "ur" 0 1,
       mv "arrowdown" "\u2199" "dl" 0 1, mv "arrowright" "\u2198" "dr" 0 1,
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "frontier" =>
      [mv "1" "+X" "turn" 0, mv "2" "-X" "turn" 1, mv "3" "+Y" "turn" 2,
       mv "4" "-Y" "turn" 3, mv "5" "+Z" "turn" 4, mv "6" "-Z" "turn" 5,
       mv "z" "THR +" "thrust" 0 1, mv "x" "THR -" "brake" 0 1,
       mv " " "FLY" "fly" 0 1 2, mv "k" "DOCK" "dock" 0 1,
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | "invaders" =>
      [mv "a" "\u2190 LEFT" "left", mv "d" "RIGHT \u2192" "right",
       mv " " "FIRE" "fire" 0 0 2, mv "t" "LET THEM MOVE" "tick" 0 1 2,
       mv "arrowleft" "\u2190" "left" 0 1, mv "arrowright" "\u2192" "right" 0 1,
       mc "f1" "M1 OPENING" 0, mc "f2" "M2 TWICE" 1, mc "f3" "M3 THE LINE" 2]
  | _ => []

/-- The default keymap of a door. -/
def defaultKeymap (door : String) : Keymap := keymapOf (defaultCaps door)

/-! ### The default keyboards are exactly the cabinets' controls -/

/-- The commands a door has, from the board the module was compiled from. -/
def doorTags (door : String) : List String :=
  match Wasm.boardIR.find? (fun d => d.name == door) with
  | none => []
  | some d => d.table.map Prod.fst

/-- Every command of every door is on some key. -/
def capsComplete : Bool :=
  Wasm.boardIR.all (fun d =>
    (d.table.map Prod.fst).all (fun t =>
      (defaultCaps d.name).any (fun c => c.act.tagOf == some t)))

/-- No key sends a command the cabinet does not have, and no macro key points
past the end of the door's book of three. -/
def capsSound : Bool :=
  Wasm.boardIR.all (fun d =>
    (defaultCaps d.name).all (fun c =>
      match c.act with
      | .move m => (doorTags d.name).contains m.tag
      | .macroCall i => decide (i < 3)))

/-- No chord is bound twice on any keyboard. -/
def capsNodup : Bool :=
  Wasm.boardIR.all (fun d => ((defaultCaps d.name).map Cap.chord).Nodup)

/-- **Nothing on the cabinet is unreachable from the keyboard.** -/
theorem defaultCaps_complete : capsComplete = true := by rfl

/-- **No key is a dead key.** -/
theorem defaultCaps_sound : capsSound = true := by rfl

/-- **No key is bound twice.** -/
theorem defaultCaps_nodup : capsNodup = true := by rfl

/-! ## The default books

Every door's book has three macros: an opening, the opening twice — a macro
that calls a macro, which is the point of the builder — and the whole proved
line of play from `Agents`. -/

/-- The book of a door, built from its card. -/
def bookOf (c : Card) : Book :=
  [{ name := "OPENING", steps := ofMoves (c.moves.take 3) },
   { name := "OPENING TWICE", steps := [.call 0, .call 0] },
   { name := c.marquee ++ " \u2014 THE PROVED LINE", steps := ofMoves c.moves }]

/-- The book of a door, by name. -/
def defaultBook (door : String) : Book :=
  match agentCards.find? (fun c => c.door == door) with
  | none => []
  | some c => bookOf c

/-- **The whole line is a macro key.** Expanding macro 2 of a door's book and
calling the shipped module's exports in that order lands exactly on the vector
the card promises — the pyramid cleared, the rank cleared, the ship at Sgr A*. -/
theorem bookLine_replay (c : Card) (hc : c ∈ agentCards) :
    play c.door (bookOf c) [.call 2] c.start = some c.finish := by
  have h : expandSteps (bookOf c) [Step.call 2] = c.moves := by
    simp [bookOf, expandSteps, ofMoves]
  simp [play, h, agentCards_replay c hc]

/-- **A macro that calls a macro twice runs it twice.** -/
theorem bookTwice_expand (c : Card) :
    expandSteps (bookOf c) [.call 1] =
      expandSteps (bookOf c) [.call 0] ++ expandSteps (bookOf c) [.call 0] := by
  simp [bookOf, expandSteps, ofMoves]

/-- Every door on the board has a book of three macros. -/
def booksSized : Bool := Wasm.boardIR.all (fun d => (defaultBook d.name).length == 3)

theorem defaultBook_sized : booksSized = true := by rfl

end Keys
end NixWars
