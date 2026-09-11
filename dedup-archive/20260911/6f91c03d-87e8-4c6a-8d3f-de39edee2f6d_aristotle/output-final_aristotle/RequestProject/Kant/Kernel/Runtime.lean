/-
# The rendering kernel, §6–§13: the runtime as one state machine

The spec states the runtime's obligations five times over — the world
matches the history, a rejected move changes nothing, back/forward do not
lose history, a divergent move branches, opening a prefix token
reconstructs the prefix world.  They are all the same theorem, so here
there is one state machine and one invariant.

The runtime state is a **zipper**: a seed, the moves already applied, and
the moves rewound but still available for redo.  The current world is
*not* stored.  It is `K.replay seed past`, a function of the state, so
"the displayed world equals the replay of the history" is a definition
rather than an invariant anyone has to maintain.  What is left to prove
is only that the state stays *replayable*:

    Wf r  ↔  (K.replay r.seed r.past).isSome

Proved here:

* `dispatch_wf` — every event preserves `Wf`;
* `apply_eq_self_of_rejected` — a rejected move leaves the state
  **equal**, not merely equivalent;
* `apply_world` — an accepted move advances the world by exactly `step`,
  and truncates the redo branch (the divergence rule, stated explicitly);
* `rewind_world` — rewinding to `k` shows exactly the replay of the
  length-`k` prefix, and `rewind_no_loss` — no forward history is lost;
* `redo_undo` — undo then redo is the identity;
* `world_valid` — whatever the runtime displays is a valid world.
-/
import Mathlib
import RequestProject.Kant.Kernel.Core

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Kernel

open GameKernel

variable {K : GameKernel}

/-- The runtime state: a seed and a `past`/`future` zipper over moves.
The world is derived, never stored. -/
structure Runtime (K : GameKernel) where
  /-- The seed the history starts from. -/
  seed : SeedId
  /-- Moves applied so far, in order. -/
  past : List K.Move
  /-- Moves rewound and still redoable, nearest first. -/
  future : List K.Move

namespace Runtime

/-- The displayed world: a function of the state, by construction. -/
def world (r : Runtime K) : Option K.World := K.replay r.seed r.past

/-- The one invariant: the history replays. -/
def Wf (r : Runtime K) : Prop := (K.replay r.seed r.past).isSome

theorem wf_iff_world (r : Runtime K) : r.Wf ↔ r.world.isSome := Iff.rfl

/-- A fresh runtime on a seed. -/
def start (K : GameKernel) (s : SeedId) : Runtime K := ⟨s, [], []⟩

@[simp] theorem start_world (s : SeedId) : (start K s).world = K.gen s := by
  simp [start, world]


theorem start_wf {s : SeedId} (h : (K.gen s).isSome) : (start K s).Wf := by
  show (K.replay s []).isSome
  rw [replay_nil]
  exact h

/-- Replaying one more move is stepping the current world. -/
theorem replay_snoc (s : SeedId) (past : List K.Move) (m : K.Move) :
    K.replay s (past ++ [m]) = (K.replay s past).bind (fun w => K.step w m) := by
  rw [replay_append]
  cases K.replay s past <;> simp

/-! ## Appending one move -/

/-- Apply a move.  Illegal moves are refused; a legal move truncates the
redo branch — that is the divergence rule, and the branch that was
truncated remains reachable through the token that was already minted. -/
def apply (r : Runtime K) (m : K.Move) : Runtime K :=
  if (K.replay r.seed (r.past ++ [m])).isSome then ⟨r.seed, r.past ++ [m], []⟩ else r

/-- **A rejected move changes nothing at all** — the states are equal,
not merely equivalent. -/
theorem apply_eq_self_of_rejected {r : Runtime K} {m : K.Move}
    (h : r.world.bind (fun w => K.step w m) = none) : r.apply m = r := by
  have : K.replay r.seed (r.past ++ [m]) = none := by rw [replay_snoc]; exact h
  simp [apply, this]

/-- **An accepted move advances the world by exactly one `step`**,
records the move and clears the redo branch. -/
theorem apply_world {r : Runtime K} {w w' : K.World} {m : K.Move}
    (hw : r.world = some w) (hs : K.step w m = some w') :
    (r.apply m).world = some w' ∧
      (r.apply m).past = r.past ++ [m] ∧ (r.apply m).future = [] := by
  have hr : K.replay r.seed (r.past ++ [m]) = some w' := by
    rw [replay_snoc]
    show (r.world).bind (fun w => K.step w m) = some w'
    rw [hw]
    exact hs
  have happ : r.apply m = ⟨r.seed, r.past ++ [m], []⟩ := by simp [apply, hr]
  refine ⟨?_, ?_, ?_⟩
  · rw [happ]; exact hr
  · rw [happ]
  · rw [happ]

theorem apply_wf {r : Runtime K} (m : K.Move) (h : r.Wf) : (r.apply m).Wf := by
  by_cases hr : (K.replay r.seed (r.past ++ [m])).isSome
  · have happ : r.apply m = ⟨r.seed, r.past ++ [m], []⟩ := by simp [apply, hr]
    rw [happ]
    exact hr
  · have happ : r.apply m = r := by simp [apply, hr]
    rw [happ]
    exact h

/-! ## Navigation: rewind, undo, redo -/

/-- Rewind to the first `k` moves, keeping everything after them
redoable. -/
def rewind (r : Runtime K) (k : Nat) : Runtime K :=
  ⟨r.seed, r.past.take k, r.past.drop k ++ r.future⟩

/-- **Rewinding shows the replay of the prefix.** -/
@[simp] theorem rewind_world (r : Runtime K) (k : Nat) :
    (rewind r k).world = K.replay r.seed (r.past.take k) := rfl

/-- **Backward navigation loses no forward history**: everything the
runtime knew is still in the zipper, in order. -/
theorem rewind_no_loss (r : Runtime K) (k : Nat) :
    (rewind r k).past ++ (rewind r k).future = r.past ++ r.future := by
  simp [rewind, ← List.append_assoc]

theorem rewind_wf {r : Runtime K} (k : Nat) (h : r.Wf) : (rewind r k).Wf :=
  replay_take_isSome k h

/-- Step back one move, given the reversed history. -/
def undoOf (K : GameKernel) (s : SeedId) (future : List K.Move) :
    List K.Move → Runtime K
  | [] => ⟨s, [], future⟩
  | m :: rest => ⟨s, rest.reverse, m :: future⟩

/-- Step back one move. -/
def undo (r : Runtime K) : Runtime K := undoOf K r.seed r.future r.past.reverse

/-- Step forward into the redo branch, given that branch. -/
def redoOf (K : GameKernel) (s : SeedId) (past : List K.Move) :
    List K.Move → Runtime K
  | [] => ⟨s, past, []⟩
  | m :: ms =>
      if (K.replay s (past ++ [m])).isSome then ⟨s, past ++ [m], ms⟩ else ⟨s, past, m :: ms⟩

/-- Step forward into the redo branch. -/
def redo (r : Runtime K) : Runtime K := redoOf K r.seed r.past r.future

theorem redoOf_cons_pos {s : SeedId} {past : List K.Move} {m : K.Move} {ms : List K.Move}
    (h : (K.replay s (past ++ [m])).isSome) :
    redoOf K s past (m :: ms) = ⟨s, past ++ [m], ms⟩ := by
  simp only [redoOf]; rw [if_pos h]

theorem redoOf_cons_neg {s : SeedId} {past : List K.Move} {m : K.Move} {ms : List K.Move}
    (h : ¬ (K.replay s (past ++ [m])).isSome) :
    redoOf K s past (m :: ms) = ⟨s, past, m :: ms⟩ := by
  simp only [redoOf]; rw [if_neg h]

theorem undo_wf {r : Runtime K} (h : r.Wf) : (undo r).Wf := by
  unfold undo
  cases hp : r.past.reverse with
  | nil =>
      have : r.past = [] := by simpa using congrArg List.reverse hp
      have hgen : (K.gen r.seed).isSome := by simpa [Wf, this] using h
      simpa [undoOf, Wf] using hgen
  | cons m rest =>
      have hpast : r.past = rest.reverse ++ [m] := by
        simpa using congrArg List.reverse hp
      have hw : (K.replay r.seed (rest.reverse ++ [m])).isSome := by rw [← hpast]; exact h
      rw [replay_snoc] at hw
      show (K.replay r.seed rest.reverse).isSome
      cases hr : K.replay r.seed rest.reverse with
      | none => rw [hr] at hw; simp at hw
      | some _ => simp

theorem redo_wf {r : Runtime K} (h : r.Wf) : (redo r).Wf := by
  unfold redo
  cases hf : r.future with
  | nil => exact h
  | cons m ms =>
      by_cases hr : (K.replay r.seed (r.past ++ [m])).isSome
      · rw [redoOf_cons_pos hr]
        exact hr
      · rw [redoOf_cons_neg hr]
        exact h

/-- **Undo, then redo, is the identity.** -/
theorem redo_undo (r : Runtime K) (h : r.Wf) (hne : r.past ≠ []) : redo (undo r) = r := by
  cases hp : r.past.reverse with
  | nil => exact absurd (by simpa using congrArg List.reverse hp) hne
  | cons m rest =>
      have hpast : r.past = rest.reverse ++ [m] := by
        simpa using congrArg List.reverse hp
      have hu : undo r = ⟨r.seed, rest.reverse, m :: r.future⟩ := by
        unfold undo; rw [hp]; rfl
      have hw : (K.replay r.seed (rest.reverse ++ [m])).isSome := by rw [← hpast]; exact h
      rw [hu]
      show redoOf K r.seed rest.reverse (m :: r.future) = r
      rw [redoOf_cons_pos hw]
      show (⟨r.seed, rest.reverse ++ [m], r.future⟩ : Runtime K) = r
      rw [← hpast]

/-! ## Loading a token, and resetting -/

/-- Adopt a history that replays; otherwise keep the current state. -/
def load (r : Runtime K) (s : SeedId) (ms : List K.Move) : Runtime K :=
  if (K.replay s ms).isSome then ⟨s, ms, []⟩ else r

theorem load_wf {r : Runtime K} (s : SeedId) (ms : List K.Move) (h : r.Wf) :
    (load r s ms).Wf := by
  unfold load
  by_cases hs : (K.replay s ms).isSome
  · rw [if_pos hs]
    exact hs
  · rw [if_neg hs]
    exact h

theorem load_world {r : Runtime K} {s : SeedId} {ms : List K.Move} {w : K.World}
    (h : K.replay s ms = some w) : (load r s ms).world = some w := by
  have hs : (K.replay s ms).isSome := by rw [h]; rfl
  show (if (K.replay s ms).isSome then (⟨s, ms, []⟩ : Runtime K) else r).world = some w
  rw [if_pos hs]
  exact h

/-! ## One dispatcher -/

/-- Everything the user interface can do to the runtime. -/
inductive Event (K : GameKernel) where
  /-- Play a move. -/
  | act (m : K.Move)
  /-- Step back one move. -/
  | undo
  /-- Step forward one move. -/
  | redo
  /-- Jump to the length-`k` prefix. -/
  | rewind (k : Nat)
  /-- Adopt a shared history. -/
  | load (s : SeedId) (ms : List K.Move)
  /-- Back to the seed, keeping the whole history redoable. -/
  | reset

/-- The single entry point.  Every user-visible transition goes through
here, which is what makes the invariant proof a single induction. -/
def dispatch (r : Runtime K) : Event K → Runtime K
  | .act m => r.apply m
  | .undo => undo r
  | .redo => redo r
  | .rewind k => rewind r k
  | .load s ms => load r s ms
  | .reset => rewind r 0

/-- **Every event preserves the invariant.** -/
theorem dispatch_wf (r : Runtime K) (e : Event K) (h : r.Wf) : (dispatch r e).Wf := by
  cases e with
  | act m => exact apply_wf m h
  | undo => exact undo_wf h
  | redo => exact redo_wf h
  | rewind k => exact rewind_wf k h
  | load s ms => exact load_wf s ms h
  | reset => exact rewind_wf 0 h

/-- **What the runtime displays is always a valid world** — because it
was recomputed from the seed, not because anything was signed. -/
theorem world_valid {r : Runtime K} {w : K.World} (h : r.world = some w) :
    K.validB w = true :=
  replay_valid h

/-- A well-formed runtime displays something. -/
theorem exists_world {r : Runtime K} (h : r.Wf) : ∃ w, r.world = some w :=
  Option.isSome_iff_exists.mp h

end Runtime

end Kant.Kernel
