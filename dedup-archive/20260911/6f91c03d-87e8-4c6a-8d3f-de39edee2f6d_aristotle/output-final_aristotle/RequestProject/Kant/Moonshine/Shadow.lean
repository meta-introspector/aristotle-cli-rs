/-
# Shadow evidence: landmarks, typed distances, and candidate regions

Up to three catalogue objects can be used as landmarks for a new object:
measure the distance to each, publish the measurements, and let any peer
recompute what they rule out.  This is *evidence about a location*, not an
identity and not a trust statement.

Two design rules are enforced by the types rather than by convention:

* **A guarantee is a carried proof, not a tag.**  `Dissimilarity`,
  `Pseudometric` and `Metric` are structures bundling the laws they claim,
  so a theorem that needs the triangle inequality cannot be instantiated
  with a score that does not have one.  A weighted composite gets exactly
  the guarantees its components supplied (`Pseudometric.wsum`).
* **A frame is evidence, never an identity.**  `ShadowFrame` *references* a
  target and at most three distinct anchors, and yields a candidate set —
  never a reconstructed object.

Proved:

* `mem_candidates_self` — **soundness**: with exact (or tolerated)
  measurements the true object is always a candidate, so triangulation
  never excludes the truth, and the noisy region is never empty by
  accident;
* `candidates_mono` — **monotonicity**: adding anchors can only shrink the
  candidate set, and widening the tolerance can only grow it;
* `candidates_diameter_le` — with a genuine pseudometric, one anchor bounds
  the diameter of the region: this is what a frame *can* deliver;
* `three_anchors_leave_192_candidates` — and what it cannot: three
  well-separated anchors in the 194-dimensional multiplicity space leave at
  least 192 distinct candidates, at tolerance zero.  Three scalar
  measurements cannot locate a point in 194 dimensions; the API therefore
  returns a region;
* `l1Rep` is a metric, while the truncated q-series distance `l1Trunc` is a
  pseudometric and **not** a metric (`l1Trunc_not_metric`) — two series
  agreeing below the cutoff are at distance zero.

Counts are deliberately *not* shared: `shadowAnchorBound` is the size of a
frame and has nothing to do with the three CRT coordinates or with any
replication threshold, which live in other modules under other names.
-/
import Mathlib
import RequestProject.Kant.Moonshine.RepRing

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

open Finset

/-! ## Distances that carry their own guarantees -/

/-- The weakest useful comparison: non-negative, and zero on the diagonal.
No symmetry, no triangle inequality — a digest-derived score is typically
only this. -/
structure Dissimilarity (X : Type) where
  d : X → X → ℚ
  nonneg : ∀ x y, 0 ≤ d x y
  self_zero : ∀ x, d x x = 0

/-- A quasimetric: triangle inequality but possibly asymmetric. -/
structure Quasimetric (X : Type) extends Dissimilarity X where
  triangle : ∀ x y z, d x z ≤ d x y + d y z

/-- A pseudometric: symmetric with a triangle inequality, but distinct
points may be at distance zero. -/
structure Pseudometric (X : Type) extends Dissimilarity X where
  symm : ∀ x y, d x y = d y x
  triangle : ∀ x y z, d x z ≤ d x y + d y z

/-- A metric: a pseudometric that separates points. -/
structure Metric (X : Type) extends Pseudometric X where
  eq_of_dist_zero : ∀ x y, d x y = 0 → x = y

/-- Every quasimetric is in particular a dissimilarity, and every metric a
pseudometric — the forgetful directions, which are the only ones available. -/
def Pseudometric.toQuasimetric {X : Type} (P : Pseudometric X) : Quasimetric X :=
  { P.toDissimilarity with triangle := P.triangle }

/-- **A weighted composite inherits exactly what its parts supplied.**  Two
pseudometrics with non-negative weights give a pseudometric. -/
def Pseudometric.wsum {X : Type} (P Q : Pseudometric X) {a b : ℚ}
    (ha : 0 ≤ a) (hb : 0 ≤ b) : Pseudometric X where
  d x y := a * P.d x y + b * Q.d x y
  nonneg x y := by
    have := P.nonneg x y; have := Q.nonneg x y
    positivity
  self_zero x := by simp [P.self_zero, Q.self_zero]
  symm x y := by rw [P.symm, Q.symm]
  triangle x y z := by
    have h1 := P.triangle x y z
    have h2 := Q.triangle x y z
    nlinarith [P.nonneg x y, Q.nonneg x y]

/-! ## Feature spaces: the L¹ distance on multiplicity vectors -/

/-- The L¹ distance on representation multiplicity vectors. -/
def l1RepDist (v w : RepVector) : ℚ := ∑ i, |((v i : ℚ) - (w i : ℚ))|

/-- **L¹ on multiplicity vectors is a genuine metric.** -/
def l1Rep : Metric RepVector where
  d := l1RepDist
  nonneg _ _ := Finset.sum_nonneg fun _ _ => abs_nonneg _
  self_zero v := by simp [l1RepDist]
  symm v w := Finset.sum_congr rfl fun i _ => abs_sub_comm _ _
  triangle u v w := by
    rw [l1RepDist, l1RepDist, l1RepDist, ← Finset.sum_add_distrib]
    exact Finset.sum_le_sum fun i _ => abs_sub_le _ _ _
  eq_of_dist_zero v w h := by
    have hz : ∀ i ∈ (Finset.univ : Finset IrrepIndex), |((v i : ℚ) - (w i : ℚ))| = 0 := by
      refine (Finset.sum_eq_zero_iff_of_nonneg fun i _ => abs_nonneg _).mp h
    funext i
    have := hz i (Finset.mem_univ i)
    have : ((v i : ℚ)) = ((w i : ℚ)) := by
      have := abs_eq_zero.mp this
      linarith
    exact_mod_cast this

@[simp] theorem l1RepDist_self (v : RepVector) : l1RepDist v v = 0 := by simp [l1RepDist]

/-- The truncated q-series distance: only coefficients up to `N` are
compared. -/
def l1TruncDist (N : ℕ) (V W : QSeries) : ℚ :=
  ∑ m ∈ Finset.range (N + 1), l1RepDist (V m) (W m)

/-- It is a pseudometric… -/
def l1Trunc (N : ℕ) : Pseudometric QSeries where
  d := l1TruncDist N
  nonneg _ _ := Finset.sum_nonneg fun _ _ => l1Rep.nonneg _ _
  self_zero V := by simp [l1TruncDist]
  symm V W := Finset.sum_congr rfl fun m _ => l1Rep.symm (V m) (W m)
  triangle U V W := by
    rw [l1TruncDist, l1TruncDist, l1TruncDist, ← Finset.sum_add_distrib]
    exact Finset.sum_le_sum fun m _ => l1Rep.triangle (U m) (V m) (W m)

/-- …and **not** a metric: two series that first differ above the cutoff are
at distance zero.  Anything that reasons from "distance zero" to "same
object" is unsound here. -/
theorem l1Trunc_not_metric (N : ℕ) :
    ∃ V W : QSeries, V ≠ W ∧ (l1Trunc N).d V W = 0 := by
  classical
  refine ⟨fun _ => (fun _ => 0), fun m => if m = N + 1 then irrep 0 else fun _ => 0, ?_, ?_⟩
  · intro h
    have := congrFun (congrFun h (N + 1)) 0
    simp [irrep] at this
  · simp only [l1Trunc, l1TruncDist, l1RepDist]
    refine Finset.sum_eq_zero fun m hm => ?_
    have hmN : m ≠ N + 1 := by
      have := Finset.mem_range.mp hm
      omega
    simp [hmN]

/-! ## Frames: at most three landmarks, and what they rule out -/

/-- How many landmarks a frame may carry.  This constant belongs to the
evidence layer alone: it is not the number of CRT coordinates and not any
replication threshold. -/
def shadowAnchorBound : ℕ := 3

/-- Evidence about where an object sits: a reference to the target, at most
three distinct anchors, and one measurement per anchor.  A frame is not
addressable as an object — it *mentions* its target. -/
structure ShadowFrame (X : Type) where
  /-- The object the evidence is about. -/
  target : X
  /-- Anchor–measurement pairs. -/
  observations : List (X × ℚ)
  /-- The declared measurement tolerance. -/
  tolerance : ℚ
  tolerance_nonneg : 0 ≤ tolerance
  anchor_bound : observations.length ≤ shadowAnchorBound
  anchors_nodup : (observations.map Prod.fst).Nodup
  target_not_anchor : target ∉ observations.map Prod.fst

/-- The candidate region described by a list of observations: everything
whose measured distances agree with them, within tolerance.  This is a
*description* a peer recomputes, never a closure it must trust. -/
def candidates {X : Type} (D : Dissimilarity X) (obs : List (X × ℚ)) (tol : ℚ) : Set X :=
  { y | ∀ p ∈ obs, |D.d y p.1 - p.2| ≤ tol }

/-- The region of a frame. -/
def ShadowFrame.region {X : Type} (D : Dissimilarity X) (F : ShadowFrame X) : Set X :=
  candidates D F.observations F.tolerance

/-- The observations a target actually generates against a list of anchors. -/
def observe {X : Type} (D : Dissimilarity X) (x : X) (anchors : List X) : List (X × ℚ) :=
  anchors.map (fun a => (a, D.d x a))

/-- **Soundness.**  Measurements taken from a real object always leave that
object in the region — at tolerance zero, and a fortiori with any
non-negative tolerance.  So an empty region means a misconfiguration, never
a refutation. -/
theorem mem_candidates_self {X : Type} (D : Dissimilarity X) (x : X) (anchors : List X)
    {tol : ℚ} (htol : 0 ≤ tol) : x ∈ candidates D (observe D x anchors) tol := by
  intro p hp
  simp only [observe, List.mem_map] at hp
  obtain ⟨a, _, rfl⟩ := hp
  simpa using htol

/-- The region is never empty when the measurements came from an object. -/
theorem region_nonempty {X : Type} (D : Dissimilarity X) (x : X) (anchors : List X)
    {tol : ℚ} (htol : 0 ≤ tol) : (candidates D (observe D x anchors) tol).Nonempty :=
  ⟨x, mem_candidates_self D x anchors htol⟩

/-- **Monotonicity in the anchors.**  More landmarks can only rule more out. -/
theorem candidates_mono {X : Type} (D : Dissimilarity X) {obs obs' : List (X × ℚ)}
    (h : obs ⊆ obs') (tol : ℚ) : candidates D obs' tol ⊆ candidates D obs tol :=
  fun _ hy p hp => hy p (h hp)

/-- Monotonicity in the tolerance. -/
theorem candidates_mono_tol {X : Type} (D : Dissimilarity X) (obs : List (X × ℚ))
    {t t' : ℚ} (h : t ≤ t') : candidates D obs t ⊆ candidates D obs t' :=
  fun _ hy p hp => le_trans (hy p hp) h

/-- **What a frame does deliver.**  With a genuine pseudometric, a single
anchor bounds the diameter of the region: any two candidates are within
`2·(r + tol)` of each other. -/
theorem candidates_diameter_le {X : Type} (P : Pseudometric X) {obs : List (X × ℚ)}
    {a : X} {r tol : ℚ} (ha : (a, r) ∈ obs) {y z : X}
    (hy : y ∈ candidates P.toDissimilarity obs tol)
    (hz : z ∈ candidates P.toDissimilarity obs tol) :
    P.d y z ≤ 2 * (r + tol) := by
  have hy' := abs_le.mp (hy (a, r) ha)
  have hz' := abs_le.mp (hz (a, r) ha)
  have h := P.triangle y a z
  have hsymm : P.d a z = P.d z a := P.symm a z
  rw [hsymm] at h
  simp only at hy' hz'
  linarith [h, hy'.1, hy'.2, hz'.1, hz'.2]

/-! ## What three landmarks cannot do -/

/-- The unit multiplicity vector `[ρ k]`, as a point of the feature space. -/
private def unit (k : IrrepIndex) : RepVector := irrep k

private theorem l1_unit_zero (k : IrrepIndex) : l1RepDist (unit k) (fun _ => 0) = 1 := by
  have hi : ∀ i : IrrepIndex,
      |((unit k i : ℤ) : ℚ) - (((fun _ => 0 : RepVector) i : ℤ) : ℚ)| = if i = k then 1 else 0 := by
    intro i; by_cases h : i = k <;> simp [unit, irrep, h]
  rw [l1RepDist, Finset.sum_congr rfl (fun i (_ : i ∈ Finset.univ) => hi i)]
  simp

private theorem l1_unit_unit {k j : IrrepIndex} (h : k ≠ j) :
    l1RepDist (unit k) (unit j) = 2 := by
  have hi : ∀ i : IrrepIndex, |((unit k i : ℤ) : ℚ) - ((unit j i : ℤ) : ℚ)|
      = (if i = k then (1:ℚ) else 0) + (if i = j then (1:ℚ) else 0) := by
    intro i
    by_cases hk : i = k <;> by_cases hj : i = j
    · exact absurd (hk.symm.trans hj) h
    · simp [unit, irrep, hk, h]
    · simp [unit, irrep, hj, Ne.symm h]
    · simp [unit, irrep, hk, hj]
  rw [l1RepDist, Finset.sum_congr rfl (fun i (_ : i ∈ Finset.univ) => hi i),
    Finset.sum_add_distrib]
  simp
  norm_num

private theorem unit_ne {k j : IrrepIndex} (h : k ≠ j) : unit k ≠ unit j := by
  intro he
  have h2 := l1_unit_unit h
  rw [he, l1RepDist_self] at h2
  exact absurd h2 (by norm_num)

private theorem zero_ne_unit (k : IrrepIndex) : (fun _ => 0 : RepVector) ≠ unit k := by
  intro he
  have h1 := l1_unit_zero k
  rw [← he, l1RepDist_self] at h1
  exact absurd h1 (by norm_num)

/-- **Three well-separated anchors leave at least 192 candidates.**  With the
anchors `0`, `[ρ 0]`, `[ρ 1]` and the exact observations `(1, 2, 2)`, every
one of the remaining 192 basis vectors satisfies all three measurements — at
tolerance zero.  Three scalar constraints cannot pin down a point of a
194-dimensional space, so localisation returns a region and the schema has
no field that claims otherwise. -/
theorem three_anchors_leave_192_candidates :
    ∃ (obs : List (RepVector × ℚ)) (f : Fin 192 → RepVector),
      obs.length = 3 ∧ (obs.map Prod.fst).Nodup ∧ Function.Injective f ∧
      ∀ t : Fin 192, f t ∈ candidates l1Rep.toDissimilarity obs 0 := by
  classical
  refine ⟨[((fun _ => 0 : RepVector), 1), (unit 0, 2), (unit 1, 2)],
    fun t => unit ⟨t.val + 2, by omega⟩, rfl, ?_, ?_, ?_⟩
  · simp only [List.map_cons, List.map_nil, List.nodup_cons, List.mem_cons,
      List.not_mem_nil, or_false, List.nodup_nil, and_true, not_or]
    exact ⟨⟨zero_ne_unit 0, zero_ne_unit 1⟩, unit_ne (by decide), not_false⟩
  · intro s t hst
    have h' : unit (⟨s.val + 2, by omega⟩ : IrrepIndex) = unit ⟨t.val + 2, by omega⟩ := hst
    by_contra hne
    refine unit_ne (k := ⟨s.val + 2, by omega⟩) (j := ⟨t.val + 2, by omega⟩) ?_ h'
    intro hh
    exact hne (Fin.ext (by have := Fin.mk.inj_iff.mp hh; omega))
  · intro t p hp
    have hk0 : (⟨t.val + 2, by omega⟩ : IrrepIndex) ≠ 0 := by
      intro hh
      have : t.val + 2 = 0 := by simpa using congrArg Fin.val hh
      omega
    have hk1 : (⟨t.val + 2, by omega⟩ : IrrepIndex) ≠ 1 := by
      intro hh
      have : t.val + 2 = 1 := by simpa using congrArg Fin.val hh
      omega
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hp
    rcases hp with rfl | rfl | rfl
    · simp [l1Rep, l1_unit_zero]
    · simp [l1Rep, l1_unit_unit hk0]
    · simp [l1Rep, l1_unit_unit hk1]

end Kant.Moonshine
