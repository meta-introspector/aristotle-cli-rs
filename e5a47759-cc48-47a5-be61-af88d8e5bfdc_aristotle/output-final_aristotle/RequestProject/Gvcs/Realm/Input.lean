import RequestProject.Gvcs.Realm.Chain

/-!
# How a player touches the game

`RequestProject/Realm/Rules.lean` says what a move is.  This file says how a
person on a phone, a tablet or a desktop *makes* one: by swiping a tile, by
pushing an on-screen joystick, by tapping a key of an on-screen keyboard, by
pressing a hotkey, or by running a macro they have built.

Everything here is one small pure model, and the page's JavaScript is a
transliteration of it (`web/input-test.mjs` runs the page's copy against the
vectors Lean prints, so the two cannot drift apart):

* `axisDir` — the direction a drag or a stick deflection means, with a dead
  zone.  One function serves the swipe, the joystick and the arrow keys.
* `Intent` — what the player is asking for, independent of how they asked:
  select a tile, march, strike, gather, build, train, end the turn, take a move
  back.  `Intent.code` / `Intent.ofCode` put an intent in a page's config line.
* `Session` — the transcript so far together with what is selected; `stepSession`
  is what any one intent does to it.  `stepSession_valid` is the safety
  property: **no gesture, key or macro can ever produce an illegal game.**
* `Keymap` — a list of chord/step bindings the player may rebind at will;
  `Book` — the macros they have built, which may call one another, expanded by
  `expand` under a fuel so that a cycle cannot hang the page.
* The parity theorems (`swipe_key_agree`, `press_act`, `press_call`,
  `stick_swipe_agree`) say that the four ways in reach a single semantics.
-/

namespace LifeTrac
namespace Realm

/-! ## Directions from a drag

Screen coordinates: `x` grows to the right, `y` grows *downwards*, so a drag
with `dy < 0` is northwards.  Directions are the game's: `0` north, `1` east,
`2` south, `3` west. -/

/-- The opposite direction. -/
def dirOpp (d : Nat) : Nat := (d + 2) % 4

@[simp] theorem dirOpp_dirOpp {d : Nat} (h : d < 4) : dirOpp (dirOpp d) = d := by
  interval_cases d <;> rfl

/-- The direction a displacement `(dx, dy)` means, or `none` if it stays inside
the dead zone of radius `dead` (a tap, or a stick at rest).  The larger
component wins; a tie goes to the horizontal. -/
def axisDir (dx dy : Int) (dead : Nat) : Option Nat :=
  if dx.natAbs ≤ dead ∧ dy.natAbs ≤ dead then none
  else if dy.natAbs ≤ dx.natAbs then some (if 0 < dx then 1 else 3)
  else some (if 0 < dy then 2 else 0)

/-- A gesture inside the dead zone is a tap, not a swipe. -/
theorem axisDir_dead {dx dy : Int} {dead : Nat}
    (hx : dx.natAbs ≤ dead) (hy : dy.natAbs ≤ dead) : axisDir dx dy dead = none := by
  simp [axisDir, hx, hy]

/-- A swipe always names one of the four directions of the board. -/
theorem axisDir_lt_four {dx dy : Int} {dead d : Nat} (h : axisDir dx dy dead = some d) :
    d < 4 := by
  unfold axisDir at h
  split at h
  · exact absurd h (by simp)
  · split at h <;> split at h <;> (simp at h; omega)

/-- A swipe the other way is the other way round: reversing a drag reverses the
direction it means.  (The dead zone is symmetric, so a tap stays a tap.) -/
theorem axisDir_neg (dx dy : Int) (dead : Nat) :
    axisDir (-dx) (-dy) dead = (axisDir dx dy dead).map dirOpp := by
  unfold axisDir
  simp only [Int.natAbs_neg]
  by_cases hd : dx.natAbs ≤ dead ∧ dy.natAbs ≤ dead
  · simp [hd]
  · rw [if_neg hd, if_neg hd]
    by_cases hle : dy.natAbs ≤ dx.natAbs
    · rw [if_pos hle, if_pos hle]
      have hdx : dx ≠ 0 := by
        rintro rfl
        exact hd ⟨by simp, by simp at hle; omega⟩
      by_cases hp : 0 < dx
      · rw [if_pos hp, if_neg (by omega : ¬ (0 < -dx))]; rfl
      · rw [if_neg hp, if_pos (by omega : 0 < -dx)]; rfl
    · rw [if_neg hle, if_neg hle]
      have hdy : dy ≠ 0 := by
        rintro rfl
        exact hle (by simp)
      by_cases hp : 0 < dy
      · rw [if_pos hp, if_neg (by omega : ¬ (0 < -dy))]; rfl
      · rw [if_neg hp, if_pos (by omega : 0 < -dy)]; rfl

/-- The gesture is scale free: measuring a drag in different units, with the
dead zone measured in the same units, means the same thing.  This is why the
same code serves a phone and a desktop. -/
theorem axisDir_scale (k : Nat) (hk : 0 < k) (dx dy : Int) (dead : Nat) :
    axisDir ((k : Int) * dx) ((k : Int) * dy) (k * dead) = axisDir dx dy dead := by
  have hnx : ((k : Int) * dx).natAbs = k * dx.natAbs := by
    simp [Int.natAbs_mul]
  have hny : ((k : Int) * dy).natAbs = k * dy.natAbs := by
    simp [Int.natAbs_mul]
  have hposx : 0 < (k : Int) * dx ↔ 0 < dx := by
    constructor
    · intro h; nlinarith [Int.natCast_pos.mpr hk]
    · intro h; positivity
  have hposy : 0 < (k : Int) * dy ↔ 0 < dy := by
    constructor
    · intro h; nlinarith [Int.natCast_pos.mpr hk]
    · intro h; positivity
  unfold axisDir
  rw [hnx, hny]
  have h1 : (k * dx.natAbs ≤ k * dead ∧ k * dy.natAbs ≤ k * dead) ↔
      (dx.natAbs ≤ dead ∧ dy.natAbs ≤ dead) := by
    constructor
    · rintro ⟨a, b⟩; exact ⟨Nat.le_of_mul_le_mul_left a hk, Nat.le_of_mul_le_mul_left b hk⟩
    · rintro ⟨a, b⟩; exact ⟨Nat.mul_le_mul_left _ a, Nat.mul_le_mul_left _ b⟩
  have h2 : (k * dy.natAbs ≤ k * dx.natAbs) ↔ (dy.natAbs ≤ dx.natAbs) :=
    ⟨fun a => Nat.le_of_mul_le_mul_left a hk, fun a => Nat.mul_le_mul_left _ a⟩
  simp only [h1, h2, hposx, hposy]

/-! ## What the player is asking for -/

/-- One thing a player can ask the page to do, whatever they used to ask it. -/
inductive Intent
  /-- Choose (or unchoose) the tile that acts. -/
  | select (tile : Nat)
  /-- March the chosen piece one step in a direction. -/
  | march (dir : Nat)
  /-- Strike one step from the chosen tile. -/
  | strike (dir : Nat)
  /-- Work the chosen tile. -/
  | gather
  /-- Raise a building on the chosen tile. -/
  | build (b : BKind)
  /-- Train a piece at the chosen building. -/
  | train (u : UKind)
  /-- Hand the turn over. -/
  | endTurn
  /-- Take the last move back. -/
  | undo
  deriving DecidableEq, Repr, Inhabited

/-- The intents a config line can carry: tiles on the board, directions of the
four. -/
def Intent.Ok : Intent → Prop
  | .select p => p < boardN
  | .march d => d < 4
  | .strike d => d < 4
  | _ => True

instance (i : Intent) : Decidable i.Ok := by
  cases i <;> unfold Intent.Ok <;> infer_instance

/-- An intent as one number, for the config line a page carries. -/
def Intent.code : Intent → Nat
  | .march d => d
  | .strike d => 4 + d
  | .gather => 8
  | .build b => 9 + b.code
  | .train u => 11 + u.code
  | .endTurn => 13
  | .undo => 14
  | .select p => 100 + p

/-- A number as an intent, when it names one. -/
def Intent.ofCode (n : Nat) : Option Intent :=
  if n < 4 then some (.march n)
  else if n < 8 then some (.strike (n - 4))
  else if n = 8 then some .gather
  else if n < 11 then some (.build (BKind.ofCode (n - 9)))
  else if n < 13 then some (.train (UKind.ofCode (n - 11)))
  else if n = 13 then some .endTurn
  else if n = 14 then some .undo
  else if 100 ≤ n ∧ n < 100 + boardN then some (.select (n - 100))
  else none

/-- **An intent survives being written down.**  The number a page carries for an
intent names that intent and no other, so a keymap or a macro saved into a page
means in the successor page exactly what it meant here. -/
theorem Intent.ofCode_code {i : Intent} (h : i.Ok) : Intent.ofCode i.code = some i := by
  cases i with
  | select p =>
      simp only [Intent.Ok, boardN] at h
      interval_cases p <;> rfl
  | march d =>
      simp only [Intent.Ok] at h
      interval_cases d <;> rfl
  | strike d =>
      simp only [Intent.Ok] at h
      interval_cases d <;> rfl
  | gather => simp [Intent.ofCode, Intent.code]
  | build b => cases b <;> simp [Intent.ofCode, Intent.code, BKind.code, BKind.ofCode]
  | train u => cases u <;> simp [Intent.ofCode, Intent.code, UKind.code, UKind.ofCode]
  | endTurn => simp [Intent.ofCode, Intent.code]
  | undo => simp [Intent.ofCode, Intent.code]

/-- Distinct intents get distinct numbers. -/
theorem Intent.code_inj {i j : Intent} (hi : i.Ok) (hj : j.Ok) (h : i.code = j.code) : i = j := by
  have := Intent.ofCode_code hi
  rw [h, Intent.ofCode_code hj] at this
  exact (Option.some_inj.mp this).symm

/-! ## A session: the transcript so far, and what is selected -/

/-- What the page is holding: the moves played, and the tile whose piece or
building is to act. -/
structure Session where
  /-- The transcript this page carries. -/
  moves : List Move
  /-- The tile the player has chosen, if any. -/
  sel : Option Nat
  deriving Repr, Inhabited

/-- The move an intent asks for, given what is selected.  `select` and `undo`
are not moves; everything else needs a selected tile except ending the turn. -/
def intentMove (sel : Option Nat) : Intent → Option Move
  | .march d => sel.map (fun p => Move.march p d)
  | .strike d => sel.map (fun p => Move.strike p d)
  | .gather => sel.map Move.gather
  | .build b => sel.map (fun p => Move.build p b)
  | .train u => sel.map (fun p => Move.train p u)
  | .endTurn => some Move.endTurn
  | .select _ => none
  | .undo => none

/-- Write a move down, if the rules allow it here.  A move that would break a
rule does nothing at all: the page will not write down an illegal move. -/
def playMove (s : Session) (m : Move) : Session :=
  match run s.moves with
  | none => s
  | some st => if (apply st m).isSome then { moves := s.moves ++ [m], sel := none } else s

/-- What one intent does to a session. -/
def stepSession (s : Session) (i : Intent) : Session :=
  match i with
  | .select p => { s with sel := if s.sel = some p then none else some p }
  | .undo => { moves := s.moves.dropLast, sel := none }
  | .endTurn => playMove s .endTurn
  | .march d => match s.sel with | none => s | some p => playMove s (.march p d)
  | .strike d => match s.sel with | none => s | some p => playMove s (.strike p d)
  | .gather => match s.sel with | none => s | some p => playMove s (.gather p)
  | .build b => match s.sel with | none => s | some p => playMove s (.build p b)
  | .train u => match s.sel with | none => s | some p => playMove s (.train p u)

/-- `stepSession` is `intentMove` followed by `playMove`: the intent says which
move is meant, and the rules say whether it may be written down. -/
theorem stepSession_of_intentMove {s : Session} {i : Intent} {m : Move}
    (h : intentMove s.sel i = some m) : stepSession s i = playMove s m := by
  cases i with
  | select p => simp [intentMove] at h
  | undo => simp [intentMove] at h
  | endTurn => simp only [intentMove, Option.some.injEq] at h; subst h; rfl
  | march d =>
      cases hs : s.sel with
      | none => rw [hs] at h; simp [intentMove] at h
      | some p => rw [hs] at h; simp [intentMove] at h; subst h; simp only [stepSession, hs]
  | strike d =>
      cases hs : s.sel with
      | none => rw [hs] at h; simp [intentMove] at h
      | some p => rw [hs] at h; simp [intentMove] at h; subst h; simp only [stepSession, hs]
  | gather =>
      cases hs : s.sel with
      | none => rw [hs] at h; simp [intentMove] at h
      | some p => rw [hs] at h; simp [intentMove] at h; subst h; simp only [stepSession, hs]
  | build b =>
      cases hs : s.sel with
      | none => rw [hs] at h; simp [intentMove] at h
      | some p => rw [hs] at h; simp [intentMove] at h; subst h; simp only [stepSession, hs]
  | train u =>
      cases hs : s.sel with
      | none => rw [hs] at h; simp [intentMove] at h
      | some p => rw [hs] at h; simp [intentMove] at h; subst h; simp only [stepSession, hs]

/-- Playing a move keeps the transcript legal. -/
theorem playMove_valid {s : Session} (h : valid s.moves = true) (m : Move) :
    valid (playMove s m).moves = true := by
  unfold playMove
  cases hr : run s.moves with
  | none => simpa using h
  | some st =>
    by_cases hok : (apply st m).isSome = true
    · simp only [hok, if_true]
      show (run (s.moves ++ [m])).isSome = true
      rw [run, runFrom_concat]
      change ((run s.moves).bind (fun t => apply t m)).isSome = true
      rw [hr]
      simpa using hok
    · simp only [hok]
      simpa using h

/-- **A player cannot build an illegal game.**  Whatever the intent — a swipe, a
joystick push, an on-screen key, a hotkey or a step of a macro — the transcript
the page holds afterwards is still one the rules allow. -/
theorem stepSession_valid {s : Session} (h : valid s.moves = true) (i : Intent) :
    valid (stepSession s i).moves = true := by
  cases i with
  | select p => simpa [stepSession] using h
  | undo =>
      simp only [stepSession, List.dropLast_eq_take]
      exact valid_take h _
  | endTurn => exact playMove_valid h _
  | march d =>
      simp only [stepSession]
      cases s.sel
      · exact h
      · exact playMove_valid h _
  | strike d =>
      simp only [stepSession]
      cases s.sel
      · exact h
      · exact playMove_valid h _
  | gather =>
      simp only [stepSession]
      cases s.sel
      · exact h
      · exact playMove_valid h _
  | build b =>
      simp only [stepSession]
      cases s.sel
      · exact h
      · exact playMove_valid h _
  | train u =>
      simp only [stepSession]
      cases s.sel
      · exact h
      · exact playMove_valid h _

/-- One move at most is written down per move played. -/
theorem playMove_length_le (s : Session) (m : Move) :
    (playMove s m).moves.length ≤ s.moves.length + 1 := by
  unfold playMove
  cases run s.moves with
  | none => simp
  | some st =>
    by_cases hok : (apply st m).isSome = true
    · simp [hok]
    · simp [hok]

/-- **One intent, at most one move.**  A swipe, a key or a step of a macro can
never write more than one move onto the page. -/
theorem stepSession_length_le (s : Session) (i : Intent) :
    (stepSession s i).moves.length ≤ s.moves.length + 1 := by
  cases i with
  | select p => simp [stepSession]
  | undo => simp [stepSession]; omega
  | endTurn => exact playMove_length_le s _
  | march d =>
      simp only [stepSession]
      cases s.sel
      · exact Nat.le_succ _
      · exact playMove_length_le s _
  | strike d =>
      simp only [stepSession]
      cases s.sel
      · exact Nat.le_succ _
      · exact playMove_length_le s _
  | gather =>
      simp only [stepSession]
      cases s.sel
      · exact Nat.le_succ _
      · exact playMove_length_le s _
  | build b =>
      simp only [stepSession]
      cases s.sel
      · exact Nat.le_succ _
      · exact playMove_length_le s _
  | train u =>
      simp only [stepSession]
      cases s.sel
      · exact Nat.le_succ _
      · exact playMove_length_le s _

/-- Running a whole list of intents: a macro, a recorded sequence, a session. -/
def runIntents (s : Session) (l : List Intent) : Session := l.foldl stepSession s

@[simp] theorem runIntents_nil (s : Session) : runIntents s [] = s := rfl

@[simp] theorem runIntents_cons (s : Session) (i : Intent) (l : List Intent) :
    runIntents s (i :: l) = runIntents (stepSession s i) l := rfl

/-- Intents compose: running one list after another is running the concatenation. -/
theorem runIntents_append (s : Session) (l k : List Intent) :
    runIntents s (l ++ k) = runIntents (runIntents s l) k := by
  induction l generalizing s with
  | nil => simp
  | cons i l ih => simp [ih]

/-- **A macro cannot build an illegal game either.**  Any number of intents,
from any source, leaves the transcript legal. -/
theorem runIntents_valid {s : Session} (h : valid s.moves = true) (l : List Intent) :
    valid (runIntents s l).moves = true := by
  induction l generalizing s with
  | nil => simpa using h
  | cons i l ih => exact ih (stepSession_valid h i)

/-- **A macro cannot run away.**  A run of `n` intents writes at most `n` moves,
so a macro is bounded by its own length however deeply it calls. -/
theorem runIntents_length_le (s : Session) (l : List Intent) :
    (runIntents s l).moves.length ≤ s.moves.length + l.length := by
  induction l generalizing s with
  | nil => simp
  | cons i l ih =>
    have h1 := ih (stepSession s i)
    have h2 := stepSession_length_le s i
    simp only [runIntents_cons, List.length_cons]
    omega

/-! ## Selecting -/

/-- Tapping the selected tile again unselects it. -/
theorem select_same (s : Session) (p : Nat) (h : s.sel = some p) :
    stepSession s (.select p) = { s with sel := none } := by
  simp [stepSession, h]

/-- Selection is a toggle: from nothing selected, two taps on the same tile
leave the session exactly as it was. -/
theorem select_toggle (s : Session) (p : Nat) (h : s.sel = none) :
    stepSession (stepSession s (.select p)) (.select p) = s := by
  cases s with
  | mk moves sel => cases h; simp [stepSession]

/-- Selecting never writes a move down. -/
@[simp] theorem select_moves (s : Session) (p : Nat) :
    (stepSession s (.select p)).moves = s.moves := rfl

/-! ## Keys, chords and macros -/

/-- A key with its modifiers: what a hotkey is bound to. -/
structure Chord where
  /-- The key itself, as the browser names it. -/
  key : String
  /-- Shift held. -/
  shift : Bool
  /-- Control (or command) held. -/
  ctrl : Bool
  /-- Alt held. -/
  alt : Bool
  deriving DecidableEq, Repr, Inhabited

/-- A step of a macro, and the target of a binding: either an intent, or a call
to another macro of the book. -/
inductive Step
  /-- Do this. -/
  | act (i : Intent)
  /-- Run macro number `n` of the book. -/
  | call (n : Nat)
  deriving DecidableEq, Repr, Inhabited

/-- A macro the player has built: a name and a body. -/
structure Macro where
  /-- What the player called it. -/
  name : String
  /-- What it does. -/
  body : List Step
  deriving Repr, Inhabited

/-- The macros a page carries. -/
abbrev Book := List Macro

/-- The bindings a page carries: which chord does what.  Later entries are
shadowed by earlier ones, which is what makes rebinding a matter of putting a
new entry in front. -/
abbrev Keymap := List (Chord × Step)

/-- What a chord is bound to. -/
def Keymap.find (km : Keymap) (c : Chord) : Option Step :=
  (km.find? (fun e => e.1 == c)).map Prod.snd

/-- Bind a chord, replacing whatever it was bound to. -/
def Keymap.bind (km : Keymap) (c : Chord) (st : Step) : Keymap :=
  (c, st) :: km.filter (fun e => e.1 != c)

/-- Unbind a chord. -/
def Keymap.unbind (km : Keymap) (c : Chord) : Keymap := km.filter (fun e => e.1 != c)

@[simp] theorem Keymap.find_bind_self (km : Keymap) (c : Chord) (st : Step) :
    (km.bind c st).find c = some st := by
  simp [Keymap.bind, Keymap.find]

/-- Dropping the entries for one chord does not change what any other chord is
bound to. -/
theorem Keymap.find?_filter_ne (km : Keymap) {c c' : Chord} (h : c' ≠ c) :
    (km.filter (fun e => e.1 != c)).find? (fun e => e.1 == c') =
      km.find? (fun e => e.1 == c') := by
  induction km with
  | nil => simp
  | cons e km ih =>
    by_cases he : e.1 = c
    · have hne : ¬ (e.1 = c') := fun h' => h (h'.symm.trans he)
      rw [List.filter_cons_of_neg (by simp [he]), ih, List.find?_cons_of_neg (by simp [hne])]
    · rw [List.filter_cons_of_pos (by simp [he])]
      by_cases he' : e.1 = c'
      · rw [List.find?_cons_of_pos (by simp [he']), List.find?_cons_of_pos (by simp [he'])]
      · rw [List.find?_cons_of_neg (by simp [he']), List.find?_cons_of_neg (by simp [he']), ih]

/-- Rebinding one chord leaves every other chord alone: the player can change
one key without disturbing the rest of their layout. -/
theorem Keymap.find_bind_other (km : Keymap) {c c' : Chord} (h : c' ≠ c) (st : Step) :
    (km.bind c st).find c' = km.find c' := by
  have hb : ((c, st).1 == c') = false := by simp; exact fun hh => h hh.symm
  simp only [Keymap.bind, Keymap.find, List.find?_cons, hb]
  rw [Keymap.find?_filter_ne km h]

@[simp] theorem Keymap.find_unbind (km : Keymap) (c : Chord) : (km.unbind c).find c = none := by
  simp only [Keymap.unbind, Keymap.find]
  induction km with
  | nil => simp
  | cons e km ih =>
    by_cases he : e.1 = c <;> simp [he]

/-- Binding a chord twice is binding it once: a layout never accumulates dead
entries for the same key. -/
theorem Keymap.bind_bind (km : Keymap) (c : Chord) (st st' : Step) :
    (km.bind c st').bind c st = km.bind c st := by
  simp [Keymap.bind, List.filter_filter]

/-- Expanding a macro body into the intents it performs.  `fuel` bounds how deep
a macro may call other macros, so a book in which two macros call each other
still terminates — the page cannot be hung by a cycle. -/
def expand (bk : Book) : Nat → List Step → List Intent
  | _, [] => []
  | 0, _ => []
  | fuel + 1, Step.act i :: rest => i :: expand bk (fuel + 1) rest
  | fuel + 1, Step.call n :: rest =>
      expand bk fuel ((bk.getD n ⟨"", []⟩).body) ++ expand bk (fuel + 1) rest
  termination_by fuel l => (fuel, l.length)

/-- Expansion is compositional: a macro body split in two expands to the two
halves' expansions, one after the other.  This is what lets the builder show a
macro step by step. -/
theorem expand_append (bk : Book) (f : Nat) (l k : List Step) :
    expand bk f (l ++ k) = expand bk f l ++ expand bk f k := by
  induction l generalizing f with
  | nil => simp [expand]
  | cons st l ih =>
    cases f with
    | zero => cases k <;> simp [expand]
    | succ f =>
      cases st with
      | act i => simp [expand, ih]
      | call n => simp [expand, ih, List.append_assoc]

/-- A macro with no calls in it is exactly the list of intents it was built
from: what the builder shows is what runs. -/
@[simp] theorem expand_acts (bk : Book) (f : Nat) (l : List Intent) :
    expand bk (f + 1) (l.map Step.act) = l := by
  induction l with
  | nil => simp [expand]
  | cons i l ih => simp [expand, ih]

/-! ## The four ways in

A swipe, a stick, an on-screen key and a hotkey all end up calling
`stepSession` on an `Intent`, which is the whole point of the model. -/

/-- The intent a drag on the board means: a march, or a strike if the player is
in striking mode (a two-finger drag, a right-button drag, or the toggle). -/
def swipeIntent (dx dy : Int) (dead : Nat) (strikeMode : Bool) : Option Intent :=
  (axisDir dx dy dead).map (fun d => if strikeMode then Intent.strike d else Intent.march d)

/-- The intent the on-screen joystick means when it is let go at a deflection of
`(dx, dy)` from its centre. -/
def stickIntent (dx dy : Int) (dead : Nat) (strikeMode : Bool) : Option Intent :=
  swipeIntent dx dy dead strikeMode

/-- **The stick is the swipe.**  A deflection of the joystick and a drag of the
same shape ask for the same thing. -/
theorem stick_swipe_agree (dx dy : Int) (dead : Nat) (b : Bool) :
    stickIntent dx dy dead b = swipeIntent dx dy dead b := rfl

/-- Pressing a chord: look it up, expand what it is bound to, run that. -/
def press (bk : Book) (km : Keymap) (fuel : Nat) (s : Session) (c : Chord) : Session :=
  match km.find c with
  | none => s
  | some st => runIntents s (expand bk fuel [st])

/-- Tapping a key of the on-screen keyboard is pressing its chord: the two
keyboards are one keymap, so customizing either customizes both. -/
def tapKey (bk : Book) (km : Keymap) (fuel : Nat) (s : Session) (c : Chord) : Session :=
  press bk km fuel s c

theorem tapKey_eq_press (bk : Book) (km : Keymap) (fuel : Nat) (s : Session) (c : Chord) :
    tapKey bk km fuel s c = press bk km fuel s c := rfl

/-- A chord bound to a single action does that action. -/
theorem press_act (bk : Book) (km : Keymap) (f : Nat) (s : Session) (c : Chord) (i : Intent)
    (h : km.find c = some (Step.act i)) :
    press bk km (f + 1) s c = stepSession s i := by
  simp [press, h, expand, runIntents]

/-- A chord bound to a macro runs that macro's body. -/
theorem press_call (bk : Book) (km : Keymap) (f : Nat) (s : Session) (c : Chord) (n : Nat)
    (h : km.find c = some (Step.call n)) :
    press bk km (f + 1) s c = runIntents s (expand bk f (bk.getD n ⟨"", []⟩).body) := by
  simp [press, h, expand]

/-- **A gesture and a hotkey are the same move.**  If a swipe means a direction
and a key is bound to marching in that direction, the two do the same thing to
the game — the player may use whichever their device affords. -/
theorem swipe_key_agree (bk : Book) (km : Keymap) (f : Nat) (s : Session) (c : Chord)
    {dx dy : Int} {dead d : Nat}
    (hg : axisDir dx dy dead = some d) (hk : km.find c = some (Step.act (Intent.march d))) :
    (swipeIntent dx dy dead false).map (stepSession s) = some (press bk km (f + 1) s c) := by
  simp [swipeIntent, hg, press_act bk km f s c _ hk]

/-- Whatever the player presses, the game stays legal. -/
theorem press_valid (bk : Book) (km : Keymap) (f : Nat) {s : Session} (c : Chord)
    (h : valid s.moves = true) : valid (press bk km f s c).moves = true := by
  unfold press
  cases km.find c with
  | none => exact h
  | some st => exact runIntents_valid h _

/-! ## What a page ships with

The default layout and the default macros.  A page carries these in its config
line; the player may change them, and the changed layout travels into the next
page. -/

/-- The chord for a plain key with no modifiers. -/
def key (k : String) : Chord := ⟨k, false, false, false⟩

/-- The layout a page ships with: arrows and WASD march, shifted arrows strike,
`g` gathers, `f` and `b` build, `w`/`s` train, space ends the turn, `u` takes
the last move back, and `1`–`3` run the three macros. -/
def defaultKeymap : Keymap :=
  [ (key "ArrowUp", .act (.march 0)), (key "ArrowRight", .act (.march 1)),
    (key "ArrowDown", .act (.march 2)), (key "ArrowLeft", .act (.march 3)),
    (⟨"ArrowUp", true, false, false⟩, .act (.strike 0)),
    (⟨"ArrowRight", true, false, false⟩, .act (.strike 1)),
    (⟨"ArrowDown", true, false, false⟩, .act (.strike 2)),
    (⟨"ArrowLeft", true, false, false⟩, .act (.strike 3)),
    (key "g", .act .gather),
    (key "f", .act (.build .farm)), (key "b", .act (.build .barracks)),
    (key "t", .act (.train .worker)), (key "y", .act (.train .soldier)),
    (key " ", .act .endTurn), (key "u", .act .undo),
    (key "1", .call 0), (key "2", .call 1), (key "3", .call 2) ]

/-- The macros a page ships with: gather and end the turn, march twice east,
and a "raise a farm" that gathers, builds and ends the turn. -/
def defaultBook : Book :=
  [ ⟨"work and pass", [.act .gather, .act .endTurn]⟩,
    ⟨"march east twice", [.act (.march 1), .act (.march 1)]⟩,
    ⟨"gather, farm, pass", [.act .gather, .act (.build .farm), .call 0]⟩ ]

/-- How deep a macro may call. -/
def macroFuel : Nat := 8

/-- The dead zone a page ships with, in CSS pixels: a drag shorter than this is
a tap, and a stick inside this radius is at rest. -/
def defaultDead : Nat := 24

/-! ## Writing the layout into a page

A page carries its layout and its macros in one line, `let CONFIG = {...}`,
beside the line that carries the transcript.  Steps travel as numbers, and
`Step.ofCode_code` is why a saved layout still means what it meant. -/

/-- A step of a macro as one number: intents even, macro calls odd. -/
def Step.code : Step → Nat
  | .act i => 2 * i.code
  | .call n => 2 * n + 1

/-- A number as a step, when it names one. -/
def Step.ofCode (n : Nat) : Option Step :=
  if n % 2 = 1 then some (.call (n / 2)) else (Intent.ofCode (n / 2)).map Step.act

/-- The steps a config line can carry. -/
def Step.Ok : Step → Prop
  | .act i => i.Ok
  | .call _ => True

instance (st : Step) : Decidable st.Ok := by
  cases st <;> unfold Step.Ok <;> infer_instance

/-- **A layout survives being written into a page.**  Every binding and every
macro step the page saves reads back as the step it was, so the customized
keyboard, the hotkeys and the macros travel unchanged into the successor
page. -/
theorem Step.ofCode_code {st : Step} (h : st.Ok) : Step.ofCode st.code = some st := by
  cases st with
  | act i =>
      simp only [Step.Ok] at h
      simp only [Step.code, Step.ofCode]
      rw [if_neg (by omega), Nat.mul_div_cancel_left _ (by norm_num), Intent.ofCode_code h]
      rfl
  | call n =>
      have h1 : (2 * n + 1) % 2 = 1 := by omega
      have h2 : (2 * n + 1) / 2 = n := by omega
      simp [Step.code, Step.ofCode, h1, h2]

/-- A string as a JSON string. -/
def jsonEsc (s : String) : String :=
  "\"" ++ ((s.replace "\\" "\\\\").replace "\"" "\\\"") ++ "\""

/-- A boolean as JSON. -/
def jsonBool (b : Bool) : String := if b then "true" else "false"

/-- A chord as JSON: the key and its three modifiers. -/
def chordJson (c : Chord) : String :=
  "[" ++ jsonEsc c.key ++ "," ++ jsonBool c.shift ++ "," ++ jsonBool c.ctrl ++ "," ++
    jsonBool c.alt ++ "]"

/-- A binding as JSON: the chord and the number of what it does. -/
def bindingJson (e : Chord × Step) : String :=
  "[" ++ chordJson e.1 ++ "," ++ toString e.2.code ++ "]"

/-- A keymap as JSON. -/
def keymapJson (km : Keymap) : String :=
  "[" ++ String.intercalate "," (km.map bindingJson) ++ "]"

/-- A macro as JSON: its name and the numbers of its steps. -/
def macroJson (m : Macro) : String :=
  "{\"name\":" ++ jsonEsc m.name ++ ",\"body\":[" ++
    String.intercalate "," (m.body.map (fun st => toString st.code)) ++ "]}"

/-- A book of macros as JSON. -/
def bookJson (bk : Book) : String :=
  "[" ++ String.intercalate "," (bk.map macroJson) ++ "]"

/-- The config line a page carries: the layout, the macros, the dead zone and
the macro fuel. -/
def configJson (km : Keymap) (bk : Book) : String :=
  "{\"keys\":" ++ keymapJson km ++ ",\"macros\":" ++ bookJson bk ++
    ",\"dead\":" ++ toString defaultDead ++ ",\"fuel\":" ++ toString macroFuel ++ "}"

/-- What a page ships with. -/
def defaultConfigJson : String := configJson defaultKeymap defaultBook

end Realm
end LifeTrac
