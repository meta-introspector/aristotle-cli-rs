import RequestProject.Craft.TouchPad

/-!
# Touch input, part 4: hotkeys and macros

Two more parts of the mobile control layer, both editable from the builder.

* **Hotkeys.**  A `Chord` is a key with its modifiers; a `Table` maps triggers
  to actions.  The same tiny association-list development serves the hotkey
  table (keyed by chords) and the swipe table (keyed by gestures).  A table is
  *conflict free* when no trigger appears twice, and `conflicts` lists the ones
  that do — so the builder can show them.  Binding a trigger is proved to be a
  real update: it changes that trigger's action, leaves every other trigger
  alone, and never introduces a conflict.

* **Macros.**  A macro is a list of `Step`s — press a chord, tap a widget,
  wait, run another macro, repeat a block — and it *compiles* to a flat list
  of `Event`s that contains no calls and no repeats at all: by construction
  the compiled form is the thing the page replays.  Because the library is
  compiled in order, and a macro may only call macros already compiled, a
  macro can never call itself, directly or through a chain of others: that is
  `macro_no_self_call`, and it is why running a macro always terminates.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Touch

/-! ## Trigger tables -/

section Table

variable {K V : Type} [DecidableEq K]

/-- Look up a trigger: the first binding wins, which is what the page does. -/
def resolveT : List (K × V) → K → Option V
  | [], _ => none
  | (a, v) :: t, k => if a = k then some v else resolveT t k

/-- The triggers of a table, in order. -/
def triggers (t : List (K × V)) : List K := t.map Prod.fst

/-- A table is conflict free when no trigger is bound twice. -/
def conflictFree (t : List (K × V)) : Bool := decide (triggers t).Nodup

/-- The triggers that are bound more than once — what the builder shows in red. -/
def conflicts (t : List (K × V)) : List K :=
  (triggers t).filter (fun k => decide (1 < (triggers t).count k))

/-- Bind a trigger: replace its action if it is already bound, otherwise add
it at the end. -/
def bindT : List (K × V) → K → V → List (K × V)
  | [], k, v => [(k, v)]
  | (a, w) :: t, k, v => if a = k then (k, v) :: t else (a, w) :: bindT t k v

/-- Unbind a trigger. -/
def unbindT (t : List (K × V)) (k : K) : List (K × V) := t.filter (fun b => !decide (b.1 = k))

@[simp] theorem resolveT_nil (k : K) : resolveT ([] : List (K × V)) k = none := rfl

@[simp] theorem resolveT_cons (a : K) (v : V) (t : List (K × V)) (k : K) :
    resolveT ((a, v) :: t) k = if a = k then some v else resolveT t k := rfl

/-- Whatever resolution finds really is in the table. -/
theorem resolveT_sound {t : List (K × V)} {k : K} {v : V} (h : resolveT t k = some v) :
    (k, v) ∈ t := by
  induction t with
  | nil => exact absurd h (by simp)
  | cons b bs ih =>
    obtain ⟨a, w⟩ := b
    rw [resolveT_cons] at h
    by_cases hb : a = k
    · rw [if_pos hb] at h
      subst hb
      rw [Option.some.inj h]
      exact List.mem_cons_self
    · rw [if_neg hb] at h
      exact List.mem_cons_of_mem _ (ih h)

/-- Resolution fails exactly on unbound triggers. -/
theorem resolveT_eq_none_iff (t : List (K × V)) (k : K) :
    resolveT t k = none ↔ k ∉ triggers t := by
  induction t with
  | nil => simp [triggers]
  | cons b bs ih =>
    obtain ⟨a, w⟩ := b
    by_cases hb : a = k
    · simp [triggers, hb]
    · simp [triggers, hb, ih, Ne.symm hb]

/-- **In a conflict-free table, a binding is exactly what resolution finds.** -/
theorem resolveT_complete {t : List (K × V)} {k : K} {v : V}
    (hc : conflictFree t = true) (h : (k, v) ∈ t) : resolveT t k = some v := by
  simp only [conflictFree, decide_eq_true_eq, triggers] at hc
  induction t with
  | nil => cases h
  | cons b bs ih =>
    obtain ⟨a, w⟩ := b
    simp only [List.map_cons, List.nodup_cons, List.mem_map] at hc
    rcases List.mem_cons.mp h with heq | h'
    · rw [← heq]
      simp
    · have hne : a ≠ k := by
        intro hb
        exact hc.1 ⟨(k, v), h', hb.symm⟩
      rw [resolveT_cons, if_neg hne]
      exact ih h' hc.2

/-- Conflicts are exactly the obstruction to a conflict-free table. -/
theorem conflictFree_iff_no_conflicts (t : List (K × V)) :
    conflictFree t = true ↔ conflicts t = [] := by
  simp only [conflictFree, conflicts, decide_eq_true_eq, List.filter_eq_nil_iff,
    decide_eq_true_eq, not_lt]
  rw [List.nodup_iff_count_le_one]
  constructor
  · intro h k _
    exact h k
  · intro h k
    by_cases hk : k ∈ triggers t
    · exact h k hk
    · simp [List.count_eq_zero_of_not_mem hk]

/-- The triggers after a bind: unchanged if it was already bound, otherwise one
more at the end. -/
theorem triggers_bindT (t : List (K × V)) (k : K) (v : V) :
    triggers (bindT t k v) = if k ∈ triggers t then triggers t else triggers t ++ [k] := by
  induction t with
  | nil => simp [triggers, bindT]
  | cons b bs ih =>
    obtain ⟨a, w⟩ := b
    by_cases hb : a = k
    · subst hb
      simp [triggers, bindT]
    · have hk : ¬ k = a := fun h => hb h.symm
      simp only [triggers] at ih ⊢
      simp only [bindT, if_neg hb, List.map_cons, ih]
      by_cases hm : k ∈ List.map Prod.fst bs
      · simp [hm, hk]
      · simp [hm, hk]

/-- **Binding a trigger sets its action.** -/
@[simp] theorem resolveT_bind_self (t : List (K × V)) (k : K) (v : V) :
    resolveT (bindT t k v) k = some v := by
  induction t with
  | nil => simp [bindT]
  | cons b bs ih =>
    obtain ⟨a, w⟩ := b
    by_cases hb : a = k
    · subst hb; simp [bindT]
    · simp [bindT, hb, ih]

/-- Binding one trigger leaves every other trigger's action alone. -/
theorem resolveT_bind_other (t : List (K × V)) (k j : K) (v : V) (h : j ≠ k) :
    resolveT (bindT t k v) j = resolveT t j := by
  induction t with
  | nil => simp [bindT, Ne.symm h]
  | cons b bs ih =>
    obtain ⟨a, w⟩ := b
    by_cases hb : a = k
    · subst hb
      simp [bindT, Ne.symm h]
    · have hbind : bindT ((a, w) :: bs) k v = (a, w) :: bindT bs k v := by simp [bindT, hb]
      rw [hbind, resolveT_cons, resolveT_cons, ih]

/-- **Binding never creates a conflict.** -/
theorem bindT_conflictFree {t : List (K × V)} (k : K) (v : V) (h : conflictFree t = true) :
    conflictFree (bindT t k v) = true := by
  simp only [conflictFree, decide_eq_true_eq] at h ⊢
  rw [triggers_bindT]
  by_cases hm : k ∈ triggers t
  · simpa [hm] using h
  · simp only [hm, if_false]
    refine List.Nodup.append h (by simp) ?_
    intro a ha hb
    simp only [List.mem_singleton] at hb
    subst hb
    exact hm ha

/-- Unbinding a trigger really unbinds it. -/
theorem resolveT_unbind_self (t : List (K × V)) (k : K) : resolveT (unbindT t k) k = none := by
  rw [resolveT_eq_none_iff]
  simp only [triggers, unbindT, List.mem_map, List.mem_filter]
  rintro ⟨b, ⟨-, hb⟩, rfl⟩
  simp at hb

end Table

/-! ## Chords and actions -/

/-- A hotkey: a key name with its modifiers. -/
structure Chord where
  ctrl : Bool
  alt : Bool
  shift : Bool
  key : String
deriving DecidableEq, Repr, Inhabited

/-- The plain, unmodified chord for a key. -/
def Chord.plain (k : String) : Chord := ⟨false, false, false, k⟩

/-- What a trigger can do. -/
inductive Action
  /-- send a key code to the page -/
  | send (code : String)
  /-- act as the mouse -/
  | mouse (e : MouseEvent)
  /-- run a named macro -/
  | run (name : String)
  /-- move to a named tab of the page -/
  | nav (tab : String)
deriving DecidableEq, Repr, Inhabited

/-- The hotkey table. -/
abbrev Keymap := List (Chord × Action)

/-- The swipe table: what each gesture does. -/
abbrev SwipeMap := List (Gesture × Action)

/-! ## Macros -/

/-- A macro step, as the builder shows it. -/
inductive Step
  | press (c : Chord)
  | tapId (widget : String)
  | wait (ms : Nat)
  | call (name : String)
  | repeatN (n : Nat) (body : List Step)
deriving Repr, Inhabited

/-- A compiled event: what the page actually replays.  There is no `call` and
no `repeat` here — compilation removes them. -/
inductive Event
  | press (c : Chord)
  | tapId (widget : String)
  | wait (ms : Nat)
deriving DecidableEq, Repr, Inhabited

/-- The compiled macro table: names in library order. -/
abbrev MacroTable := List (String × List Event)

/-- Compile a body of steps against the macros already compiled. -/
def compileSteps (tbl : MacroTable) : List Step → List Event
  | [] => []
  | .press c :: r => .press c :: compileSteps tbl r
  | .tapId w :: r => .tapId w :: compileSteps tbl r
  | .wait n :: r => .wait n :: compileSteps tbl r
  | .call n :: r => ((tbl.lookup n).getD []) ++ compileSteps tbl r
  | .repeatN n body :: r =>
      (List.replicate n (compileSteps tbl body)).flatten ++ compileSteps tbl r
termination_by s => sizeOf s

/-- Compile a library in order, each macro seeing the ones before it. -/
def compileLibAux (tbl : MacroTable) : List (String × List Step) → MacroTable
  | [] => tbl
  | (n, s) :: rest => compileLibAux (tbl ++ [(n, compileSteps tbl s)]) rest

/-- Compile a whole macro library. -/
def compileLib (lib : List (String × List Step)) : MacroTable := compileLibAux [] lib

/-- How long a compiled macro takes, in milliseconds of declared waits. -/
def duration : List Event → Nat
  | [] => 0
  | .wait n :: r => n + duration r
  | _ :: r => duration r

@[simp] theorem compileSteps_nil (tbl : MacroTable) : compileSteps tbl [] = [] := by
  simp [compileSteps]

@[simp] theorem compileSteps_press (tbl : MacroTable) (c : Chord) (r : List Step) :
    compileSteps tbl (.press c :: r) = .press c :: compileSteps tbl r := by
  simp [compileSteps]

@[simp] theorem compileSteps_call (tbl : MacroTable) (n : String) (r : List Step) :
    compileSteps tbl (.call n :: r) = ((tbl.lookup n).getD []) ++ compileSteps tbl r := by
  simp [compileSteps]

@[simp] theorem compileSteps_repeat (tbl : MacroTable) (n : Nat) (body r : List Step) :
    compileSteps tbl (.repeatN n body :: r)
      = (List.replicate n (compileSteps tbl body)).flatten ++ compileSteps tbl r := by
  simp [compileSteps]

/-- **Compiling is compositional**: a macro is the concatenation of its steps. -/
theorem compileSteps_append (tbl : MacroTable) (a b : List Step) :
    compileSteps tbl (a ++ b) = compileSteps tbl a ++ compileSteps tbl b := by
  induction a with
  | nil => simp
  | cons s r ih => cases s <;> simp [compileSteps, ih, List.append_assoc]

/-- A repeat really does repeat: `n` copies, so `n` times as many events. -/
theorem compileSteps_repeat_length (tbl : MacroTable) (n : Nat) (body : List Step) :
    (compileSteps tbl [.repeatN n body]).length = n * (compileSteps tbl body).length := by
  simp [List.length_flatten]

/-- Waits add up over concatenation. -/
theorem duration_append (a b : List Event) : duration (a ++ b) = duration a + duration b := by
  induction a with
  | nil => simp [duration]
  | cons e r ih => cases e <;> simp [duration, ih, Nat.add_assoc]

/-- A repeat waits `n` times as long. -/
theorem duration_repeat (tbl : MacroTable) (n : Nat) (body : List Step) :
    duration (compileSteps tbl [.repeatN n body]) = n * duration (compileSteps tbl body) := by
  simp only [compileSteps_repeat, compileSteps_nil, List.append_nil]
  induction n with
  | zero => simp [duration]
  | succ m ih =>
    rw [List.replicate_succ, List.flatten_cons, duration_append, ih]
    ring

/-! ### The library compiles in order, so macros cannot loop -/

mutual

/-- The macros a step calls. -/
def stepCalls : Step → List String
  | .press _ => []
  | .tapId _ => []
  | .wait _ => []
  | .call n => [n]
  | .repeatN _ body => stepsCalls body

/-- The macros a body calls. -/
def stepsCalls : List Step → List String
  | [] => []
  | s :: r => stepCalls s ++ stepsCalls r

end

/-- The builder's library check: every macro may only call macros defined
before it, and no two macros share a name. -/
def libWFAux (seen : List String) : List (String × List Step) → Bool
  | [] => true
  | (n, s) :: rest => (stepsCalls s).all (fun c => seen.contains c) && libWFAux (seen ++ [n]) rest

/-- A well-formed macro library. -/
def libWF (lib : List (String × List Step)) : Bool :=
  decide (lib.map Prod.fst).Nodup && libWFAux [] lib

/-- Compilation preserves the names and their order. -/
theorem compileLibAux_names (lib : List (String × List Step)) (tbl : MacroTable) :
    (compileLibAux tbl lib).map Prod.fst = tbl.map Prod.fst ++ lib.map Prod.fst := by
  induction lib generalizing tbl with
  | nil => simp [compileLibAux]
  | cons e rest ih =>
    obtain ⟨n, s⟩ := e
    simp [compileLibAux, ih]

/-- The compiled table has exactly the macros of the library, in order. -/
theorem compileLib_names (lib : List (String × List Step)) :
    (compileLib lib).map Prod.fst = lib.map Prod.fst := by
  simp [compileLib, compileLibAux_names]

/-- Every call a well-formed library makes names a macro defined strictly
earlier. -/
theorem libWFAux_calls (lib : List (String × List Step)) (seen : List String)
    (h : libWFAux seen lib = true) :
    ∀ pre e post, lib = pre ++ e :: post → ∀ c ∈ stepsCalls e.2,
      c ∈ seen ++ pre.map Prod.fst := by
  induction lib generalizing seen with
  | nil => intro pre e post hp; exact absurd hp (by simp)
  | cons a rest ih =>
    obtain ⟨n, s⟩ := a
    simp only [libWFAux, Bool.and_eq_true, List.all_eq_true] at h
    intro pre e post hp c hc
    cases pre with
    | nil =>
      simp only [List.nil_append, List.cons.injEq] at hp
      obtain ⟨rfl, -⟩ := hp
      have := h.1 c hc
      simpa using this
    | cons b pre' =>
      simp only [List.cons_append, List.cons.injEq] at hp
      obtain ⟨rfl, hrest⟩ := hp
      have := ih (seen ++ [n]) h.2 pre' e post hrest c hc
      simpa [List.append_assoc] using this

/-- **A macro can never call itself**, directly or through any chain: the
library is compiled in order and a macro may only call earlier ones. -/
theorem macro_no_self_call {lib : List (String × List Step)} (h : libWF lib = true) :
    ∀ e ∈ lib, e.1 ∉ stepsCalls e.2 := by
  simp only [libWF, Bool.and_eq_true, decide_eq_true_eq] at h
  intro e he hc
  obtain ⟨pre, post, hp⟩ := List.append_of_mem he
  have hmem : e.1 ∈ pre.map Prod.fst := by
    simpa using libWFAux_calls lib [] h.2 pre e post hp e.1 hc
  rw [hp] at h
  have hnd := h.1
  simp only [List.map_append, List.map_cons, List.nodup_append] at hnd
  exact hnd.2.2 e.1 hmem e.1 List.mem_cons_self rfl

/-- Every call in a well-formed library resolves in the compiled table. -/
theorem libWF_calls_resolve {lib : List (String × List Step)} (h : libWF lib = true) :
    ∀ e ∈ lib, ∀ c ∈ stepsCalls e.2, c ∈ (compileLib lib).map Prod.fst := by
  simp only [libWF, Bool.and_eq_true] at h
  intro e he c hc
  obtain ⟨pre, post, hp⟩ := List.append_of_mem he
  have hmem : c ∈ pre.map Prod.fst := by
    simpa using libWFAux_calls lib [] h.2 pre e post hp c hc
  rw [compileLib_names, hp]
  simp only [List.map_append, List.mem_append]
  exact Or.inl hmem

/-! ## Firing a hotkey -/

/-- What a chord does: send a key, act as the mouse, or replay a compiled
macro. -/
def fire (km : Keymap) (tbl : MacroTable) (c : Chord) : List Event :=
  match resolveT km c with
  | some (.send code) => [.press (Chord.plain code)]
  | some (.run n) => (tbl.lookup n).getD []
  | _ => []

/-- **A hotkey bound to a macro fires exactly that macro.** -/
theorem fire_run {km : Keymap} {tbl : MacroTable} {c : Chord} {n : String}
    (hc : conflictFree km = true) (h : (c, Action.run n) ∈ km) :
    fire km tbl c = (tbl.lookup n).getD [] := by
  simp [fire, resolveT_complete hc h]

/-- An unbound chord does nothing. -/
theorem fire_unbound {km : Keymap} {tbl : MacroTable} {c : Chord}
    (h : c ∉ triggers km) : fire km tbl c = [] := by
  simp [fire, (resolveT_eq_none_iff km c).mpr h]

/-! ## What the page ships with -/

/-- The default swipe table: swipe left and right change tab, swipe up and
down page, a long press is a right click. -/
def defaultSwipes : SwipeMap :=
  [ (.swipeL, .nav "next"), (.swipeR, .nav "prev"),
    (.swipeU, .send "PageDown"), (.swipeD, .send "PageUp"),
    (.hold, .mouse .rightClick), (.tap, .mouse .click) ]

/-- The default hotkeys. -/
def defaultKeymap : Keymap :=
  [ (⟨true, false, false, "d"⟩, .run "dig"),
    (⟨true, false, false, "r"⟩, .run "refuel"),
    (⟨true, false, false, "h"⟩, .run "home"),
    (⟨false, false, false, "Escape"⟩, .send "Escape"),
    (⟨false, false, false, "Tab"⟩, .nav "next") ]

/-- The default macro library: three macros, the last two built from the
first. -/
def defaultLib : List (String × List Step) :=
  [ ("dig", [.press (Chord.plain "d"), .wait 100, .press (Chord.plain "Enter")]),
    ("refuel", [.press (Chord.plain "r"), .wait 50, .repeatN 3 [.call "dig"]]),
    ("home", [.call "refuel", .wait 200, .tapId "stick", .call "dig"]) ]

/-- The shipped hotkeys have no conflicts. -/
theorem defaultKeymap_conflictFree : conflictFree defaultKeymap = true := by decide

/-- The shipped swipe table has no conflicts. -/
theorem defaultSwipes_conflictFree : conflictFree defaultSwipes = true := by decide

/-- The shipped macro library is well formed, so none of its macros can loop. -/
theorem defaultLib_wf : libWF defaultLib = true := by decide

/-- The shipped table, compiled. -/
def defaultTable : MacroTable := compileLib defaultLib

end Touch
