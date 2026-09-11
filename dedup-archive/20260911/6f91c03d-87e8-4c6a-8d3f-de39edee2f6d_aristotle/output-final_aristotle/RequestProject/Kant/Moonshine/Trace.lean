/-
# Evaluation witnesses: the trace appended to a post, and value-derived place

A post can carry more than its bytes.  If the bytes are code, then an
*evaluation witness* — the trace of running it — is extra data that is
**checkable**: a reader replays it instead of believing it.  And once a
value is in hand, an object can be placed *by its value* rather than by the
hash of its source, so that "the location of π is near the value of π"
becomes literally true: the coordinate of π is its own leading digits.

Three separate things, kept separate:

| layer | what it is | derived from |
|---|---|---|
| source identity | the digest of the code bytes | the code |
| evaluation witness | a replayable trace and the value it yields | running the code |
| value placement | a coordinate in `ZMod 196883` | the **value**, not the source |

Proved here:

* replaying a compiled trace computes the value (`run_compile`), so the
  trace is a witness and not a claim;
* a post whose claimed value is wrong **cannot** produce a passing trace
  (`check_sound`, `forged_value_rejected`) — the added attribute is
  falsifiable, unlike free text;
* appending the trace makes a **new artifact**: its identity differs from
  the source's (`traced_identity_ne_source`), so nothing is silently
  mutated;
* the value placement is *semantic*: two different programs with the same
  value sit at the same coordinate (`same_value_same_placement`), while
  their source-hash placements differ (`same_value_different_source_place`);
* placement by value is locality-preserving — successors are neighbours
  (`valueClass_succ`) and nearby reals get nearby coordinates
  (`realPlace_lipschitz`);
* **π sits at its own digits**: `realPlace π = 3141592` (`realPlace_pi`).

The honest limit is unchanged: a value determines a coordinate, never an
identity (`value_placement_does_not_determine_content`).
-/
import Mathlib
import RequestProject.Kant.Bytes
import RequestProject.Kant.Moonshine.Crt

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

open Kant.Bytes

/-! ## A small language, its evaluation, and its trace -/

/-- Code that can be posted and run. -/
inductive Expr where
  | lit : Int → Expr
  | neg : Expr → Expr
  | add : Expr → Expr → Expr
  | mul : Expr → Expr → Expr
deriving DecidableEq, Repr

/-- The value of an expression. -/
def Expr.eval : Expr → Int
  | .lit n => n
  | .neg a => -a.eval
  | .add a b => a.eval + b.eval
  | .mul a b => a.eval * b.eval

/-- One step of the trace. -/
inductive Instr where
  | push : Int → Instr
  | neg | add | mul
deriving DecidableEq, Repr

/-- The trace of an evaluation: the steps a checker replays. -/
def compile : Expr → List Instr
  | .lit n => [.push n]
  | .neg a => compile a ++ [.neg]
  | .add a b => compile a ++ compile b ++ [.add]
  | .mul a b => compile a ++ compile b ++ [.mul]

/-- Executing one step. -/
def step (st : List Int) : Instr → Option (List Int)
  | .push n => some (n :: st)
  | .neg => match st with
    | v :: rest => some ((-v) :: rest)
    | _ => none
  | .add => match st with
    | b :: a :: rest => some ((a + b) :: rest)
    | _ => none
  | .mul => match st with
    | b :: a :: rest => some ((a * b) :: rest)
    | _ => none

/-- Replaying a trace. -/
def run : List Instr → List Int → Option (List Int)
  | [], st => some st
  | i :: is, st => match step st i with
    | some st' => run is st'
    | none => none

theorem run_append (p q : List Instr) (st : List Int) :
    run (p ++ q) st = (run p st).bind (fun st' => run q st') := by
  induction p generalizing st with
  | nil => simp [run]
  | cons i is ih =>
      simp only [List.cons_append, run]
      cases step st i with
      | none => simp
      | some st' => simpa using ih st'

/-- **Replay is evaluation.**  The trace of an expression, run on any stack,
pushes exactly its value. -/
theorem run_compile (e : Expr) (st : List Int) : run (compile e) st = some (e.eval :: st) := by
  induction e generalizing st with
  | lit n => simp [compile, run, step, Expr.eval]
  | neg a ih => simp [compile, run_append, ih, run, step, Expr.eval]
  | add a b iha ihb => simp [compile, run_append, iha, ihb, run, step, Expr.eval]
  | mul a b iha ihb => simp [compile, run_append, iha, ihb, run, step, Expr.eval]

/-! ## A post that carries its evaluation witness -/

/-- A post: the code, the claimed value, and the trace offered as evidence. -/
structure TracedPost where
  source : Expr
  value : Int
  trace : List Instr
deriving DecidableEq, Repr

/-- The honest post for a piece of code. -/
def TracedPost.ofExpr (e : Expr) : TracedPost := ⟨e, e.eval, compile e⟩

/-- What a reader checks: that the trace is the trace of *this* source, and
that replaying it yields the claimed value. -/
def TracedPost.check (p : TracedPost) : Bool :=
  decide (p.trace = compile p.source) && decide (run p.trace [] = some [p.value])

/-- An honest post checks. -/
@[simp] theorem check_ofExpr (e : Expr) : (TracedPost.ofExpr e).check = true := by
  simp [TracedPost.check, TracedPost.ofExpr, run_compile]

/-- **A passing trace cannot lie**: whatever a post claims, if it checks then
its value is the value of its source. -/
theorem check_sound {p : TracedPost} (h : p.check = true) : p.value = p.source.eval := by
  simp only [TracedPost.check, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨ht, hr⟩ := h
  rw [ht, run_compile] at hr
  exact ((List.cons.injEq _ _ _ _ ▸ Option.some.inj hr).1).symm

/-- …so a forged value is refused, whatever trace is attached to it. -/
theorem forged_value_rejected (e : Expr) (v : Int) (t : List Instr) (hv : v ≠ e.eval) :
    (TracedPost.mk e v t).check = false := by
  by_contra h
  simp only [Bool.not_eq_false] at h
  exact hv (check_sound h)

/-! ## Appending the trace makes a new artifact -/

/-- Bytes of an expression, for content addressing. -/
def Expr.encode (e : Expr) : Blob := ((repr e).pretty).toUTF8.toList

/-- Bytes of a post: the source, then the witness, separated. -/
def TracedPost.encode (p : TracedPost) : Blob :=
  p.source.encode ++ [0] ++ ((repr p.value).pretty ++ ";" ++ (repr p.trace).pretty).toUTF8.toList

/-- The content identity of the traced artifact. -/
def TracedPost.identity (p : TracedPost) : Blob := digest p.encode

/-- **The witness does not overwrite the code.**  A traced post is a new
content object with its own identity; the source keeps the identity it
always had. -/
theorem traced_identity_ne_source :
    let e : Expr := .add (.lit 1) (.lit 2)
    (TracedPost.ofExpr e).identity ≠ digest e.encode := by
  native_decide

/-! ## Placement by value -/

/-- The value placement: the coordinate *is* the value, reduced.  Unlike a
digest-derived class this is semantic — it depends on what the code computes
and not on how it was written. -/
def valueClass (v : Int) : PlacementClass := (v : ZMod 196883)

/-- The placement of a post, from its (checked) value. -/
def TracedPost.placement (p : TracedPost) : PlacementClass := valueClass p.value

/-- **Same value, same place.**  Two programs that compute the same thing are
placed together, however differently they are written. -/
theorem same_value_same_placement {p q : TracedPost} (hp : p.check = true)
    (hq : q.check = true) (h : p.source.eval = q.source.eval) :
    p.placement = q.placement := by
  rw [TracedPost.placement, TracedPost.placement, check_sound hp, check_sound hq, h]

/-- Placement by value is locality-preserving: adjacent values are adjacent
coordinates. -/
theorem valueClass_succ (v : Int) : valueClass (v + 1) = valueClass v + 1 := by
  simp [valueClass]

theorem valueClass_add (v w : Int) : valueClass (v + w) = valueClass v + valueClass w := by
  simp [valueClass]

/-- Two genuinely different programs with the same value: they share a value
placement… -/
theorem same_value_different_source :
    let a : Expr := .mul (.add (.lit 1) (.lit 2)) (.lit 2)
    let b : Expr := .lit 6
    a ≠ b ∧ (TracedPost.ofExpr a).placement = (TracedPost.ofExpr b).placement := by
  refine ⟨by decide, ?_⟩
  simp [TracedPost.placement, TracedPost.ofExpr, valueClass, Expr.eval]

/-- …while their *source* digests, and hence their hash-derived placements,
are unrelated.  This is the point of placing by value. -/
theorem same_value_different_source_place :
    let a : Expr := .mul (.add (.lit 1) (.lit 2)) (.lit 2)
    let b : Expr := .lit 6
    placementOf a.encode ≠ placementOf b.encode := by
  native_decide

/-- The honest limit survives evaluation: a value places an object, it does
not identify it. -/
theorem value_placement_does_not_determine_content :
    ∃ a b : Blob, a ≠ b ∧ placementOf a = placementOf b :=
  placement_does_not_determine_content

/-! ## Real values: π is placed at π -/

/-- The place of a real value: its first six decimals, as an integer. -/
noncomputable def realPlace (x : ℝ) : ℤ := ⌊x * 10 ^ 6⌋

/-- **π sits at its own digits.** -/
theorem realPlace_pi : realPlace Real.pi = 3141592 := by
  have h1 : (3.141592 : ℝ) < Real.pi := Real.pi_gt_d6
  have h2 : Real.pi < 3.141593 := Real.pi_lt_d6
  rw [realPlace, Int.floor_eq_iff]
  constructor <;> push_cast <;> nlinarith

/-- The coordinate of π in the placement ring. -/
theorem pi_placement : valueClass (realPlace Real.pi) = (3141592 : ZMod 196883) := by
  rw [realPlace_pi]
  rfl

/-- **Nearby values are placed nearby.**  The place of a real differs from
the place of another by at most the scaled distance between them, plus one
for the rounding. -/
theorem realPlace_lipschitz (x y : ℝ) :
    |(realPlace x : ℝ) - (realPlace y : ℝ)| < |x - y| * 10 ^ 6 + 1 := by
  have hx1 : (⌊x * 10 ^ 6⌋ : ℝ) ≤ x * 10 ^ 6 := Int.floor_le _
  have hx2 : x * 10 ^ 6 < (⌊x * 10 ^ 6⌋ : ℝ) + 1 := Int.lt_floor_add_one _
  have hy1 : (⌊y * 10 ^ 6⌋ : ℝ) ≤ y * 10 ^ 6 := Int.floor_le _
  have hy2 : y * 10 ^ 6 < (⌊y * 10 ^ 6⌋ : ℝ) + 1 := Int.lt_floor_add_one _
  have hxy : |x - y| * 10 ^ 6 = |x * 10 ^ 6 - y * 10 ^ 6| := by
    rw [← abs_of_nonneg (by norm_num : (0:ℝ) ≤ (10:ℝ) ^ 6), ← abs_mul]
    ring_nf
  rw [realPlace, realPlace, hxy, abs_sub_lt_iff]
  constructor <;> rcases abs_cases (x * 10 ^ 6 - y * 10 ^ 6) with ⟨h, _⟩ | ⟨h, _⟩ <;>
    rw [h] <;> linarith

end Kant.Moonshine
