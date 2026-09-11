import RequestProject.Math.UnivalentCore

/-!
# Altland–Zirnbauer spectral reduction and the Bott clock

This module formalizes the genuinely checkable kernel of the Altland–Zirnbauer
(AZ) classification: the **eightfold Bott clock** of real symmetry classes and
the **dimensional reduction** invariance that relates a symmetry class in
dimension `d` to its neighbour.

* `KGroup` encodes the possible groups of strong topological invariants.
* `realK : ZMod 8 → KGroup` is the period-8 sequence of `KO`-groups of a point
  `(ℤ, ℤ₂, ℤ₂, 0, ℤ, 0, 0, 0)`.
* `complexK : ZMod 2 → KGroup` is the period-2 complex case `(ℤ, 0)`.
* `azReal s d = realK (s - d)` is the strong invariant of a real AZ class at
  Bott-clock position `s` in spatial dimension `d`.

The two reduction operations from the specification are realized as the unit
shift `padDegen` (adding a spectator/degenerate band advances the clock) and the
reflection `activateNeg` (a domain wall negates the clock). The central result
`azReal_reduction` states that simultaneously advancing the symmetry class and
the dimension leaves the topological invariant unchanged — the spectral-reduction
invariance.
-/

namespace RequestProject.AZ

/-- The possible groups of strong topological invariants in the AZ table. -/
inductive KGroup
  | trivial
  | Z
  | Z2
  deriving DecidableEq, Repr

/-- The **Bott clock**: real AZ symmetry classes are arranged 8-periodically. -/
abbrev BottClock := ZMod 8

/-- Advancing the Bott clock by adding a spectator (degenerate) band. -/
def padDegen (q : BottClock) : BottClock := q + 1

/-- A domain wall reflects the Bott clock. -/
def activateNeg (q : BottClock) : BottClock := -q

/-- The real `KO`-theory sequence of a point, `(ℤ, ℤ₂, ℤ₂, 0, ℤ, 0, 0, 0)`,
giving the strong invariant group as a function of the Bott-clock index. -/
def realK : BottClock → KGroup := fun q =>
  match (q.val : ℕ) with
  | 0 => KGroup.Z
  | 1 => KGroup.Z2
  | 2 => KGroup.Z2
  | 4 => KGroup.Z
  | _ => KGroup.trivial

/-- The complex `K`-theory sequence of a point, `(ℤ, 0)`, 2-periodic. -/
def complexK : ZMod 2 → KGroup := fun q =>
  match (q.val : ℕ) with
  | 0 => KGroup.Z
  | _ => KGroup.trivial

/-- The strong topological invariant of a **real** AZ class at Bott-clock
position `s` in spatial dimension `d`. -/
def azReal (s : BottClock) (d : ℕ) : KGroup := realK (s - (d : BottClock))

/-- The strong topological invariant of a **complex** AZ class (A, AIII) at
position `s` in spatial dimension `d`. -/
def azComplex (s : ZMod 2) (d : ℕ) : KGroup := complexK (s - (d : ZMod 2))

/-- **Bott periodicity of the clock.** Advancing the spectator band eight times
returns to the start. -/
theorem padDegen_iterate_eight (q : BottClock) : padDegen^[8] q = q := by
  have h8 : (8 : ZMod 8) = 0 := by decide
  simp only [padDegen, Function.iterate_succ, Function.iterate_zero, Function.comp_apply, id_eq]
  linear_combination h8

/-- **Real periodicity.** The `KO` sequence repeats with period 8. -/
theorem realK_period (q : BottClock) : realK (q + 8) = realK q := by
  have h8 : (8 : ZMod 8) = 0 := by decide
  congr 1
  linear_combination h8

/-- **Spectral-reduction invariance.** Adding a spectator band advances both the
symmetry class and the spatial dimension, leaving the topological invariant
unchanged. This is the dimensional-reduction ladder of the Bott clock. -/
theorem azReal_reduction (s : BottClock) (d : ℕ) :
    azReal (padDegen s) (d + 1) = azReal s d := by
  unfold azReal padDegen
  congr 1
  push_cast
  ring

/-- **Reflection symmetry of the clock.** The reflected class in the reflected
dimension carries the same `KO` sequence value as a reflected-index lookup,
exhibiting the domain-wall symmetry `activateNeg`. -/
theorem azReal_activateNeg (s : BottClock) (d : ℕ) :
    azReal (activateNeg s) d = realK (-(s + (d : BottClock))) := by
  unfold azReal activateNeg
  congr 1
  ring

end RequestProject.AZ
