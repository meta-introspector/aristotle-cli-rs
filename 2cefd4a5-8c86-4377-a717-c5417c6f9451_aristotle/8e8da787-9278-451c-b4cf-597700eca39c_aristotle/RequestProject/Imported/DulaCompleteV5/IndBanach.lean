/-
Copyright (c) 2026. All rights reserved.

# Ind-Banach Topology Skeleton for `WeilTestFunction`

This file provides a **research-program scaffold** for defining the
inductive-limit-of-Banach-spaces (LF-space, "ind-Banach") topology on
`WeilTestFunction`, motivated by the rigorous counterexample to
continuity in the Schwartz subspace topology
(see `ContinuityHelpers.lean` for the counterexample).

## STATUS

This is a **SKELETON FILE**. The sorrys here mark genuine open research
targets, not minor proof obligations. Closing these sorrys requires
substantial new Mathlib infrastructure for LF-spaces (inductive limits
of Banach spaces) which does not currently exist in Mathlib.

Specifically:
* Mathlib has `TopologicalSpace.iSup` for sups of topologies but no
  developed theory of LF-spaces with the regularity property
  (convergent sequences live in some `E_{b_0}`).
* The Banach structure on each `E_b` is straightforward but each one
  needs to be set up.
* Compatibility with the existing `WeilTestFunction` structure
  requires care: the existing structure has `b` existentially
  quantified, while the LF-space structure naturally indexes by `b`.

## DESIGN

For each `b : ℝ` with `b > 0`, define:

```
E_b := { g : EvenSchwartz | ∃ C, ∀ t, |g t| ≤ C * exp(-(1/2 + b) * |t|) }
```

This is a Banach space with the norm
```
‖g‖_b := sup_t |g(t)| * exp((1/2 + b) * |t|)
```
combined with Schwartz seminorms (giving Fréchet structure on each `E_b`).

The set `WeilTestFunction` (existing) is the union `⋃_{b > 0} E_b`.

The **ind-Banach topology** on `WeilTestFunction`:
A set `U ⊆ WeilTestFunction` is open iff `U ∩ E_b` is open in `E_b` for
every `b > 0`. Equivalently, a sequence `g_n → g` iff there exists
`b_0 > 0` with `{g_n} ∪ {g} ⊆ E_{b_0}` and `g_n → g` in `E_{b_0}`'s topology.

This topology is strictly finer than the Schwartz subspace topology
currently used. It kills the counterexample
`h_s = exp(-√s) [φ(t-s) + φ(t+s)]` because no fixed `b_0` contains
all `h_s` (each `‖h_s‖_b ≈ exp((1/2+b)s - √s) → ∞`).

## WHY THIS IS HARD

The numerical investigation (in `topology_analysis.md`) showed:
* Truncation-style approximating sequences `g_n = g_* · exp(-t²/n)` do
  NOT converge in the LF topology (weighted sup stays at ≈ 1).
* Convolution-style sequences `g_n = g_* * φ_n` DO converge.

So the conjecture `Conjecture_A_Strong_WTF` is non-vacuously affected:
density requires `Φ` to be of "convolution type." Whether the actual
Cohn-Elkies extremal `Φ` from sphere-packing literature satisfies
this is open research.

## TASK FOR FUTURE WORK

This file provides:
1. The basic definitions (E_b spaces, norms, topology).
2. Key lemma statements with `sorry` bodies marked clearly.
3. Documentation of what Mathlib infrastructure each sorry needs.

Closing the sorrys requires:
* Building LF-space theory in Mathlib (multi-week project).
* Verifying the Cohn-Elkies density question (off-Lean math research).
* Re-verifying the rest of the project against the new topology.

This is NOT a typical Aristotle task. The expected outcome of running
this file is: it compiles with N sorrys, none of which Aristotle can
close.
-/

import RequestProject.Imported.DulaCompleteV5.WeilTestFunction
import RequestProject.Imported.DulaCompleteV5.ConjectureA
import Mathlib

noncomputable section

open scoped BigOperators
open SchwartzMap

namespace WeilTestFunction.IndBanach

-- ============================================================================
-- 1. THE BANACH SPACES E_b
-- ============================================================================

/-- The space of even Schwartz functions with exponential decay at rate
    `(1/2 + b)`. This is a strict subset of `EvenSchwartz`. -/
structure ExpDecayClass (b : ℝ) where
  toEvenSchwartz : EvenSchwartz
  has_decay : ∃ C > (0 : ℝ),
    ∀ t : ℝ, |toEvenSchwartz t| ≤ C * Real.exp (-(1/2 + b) * |t|)
  has_decay_deriv : ∃ C > (0 : ℝ),
    ∀ t : ℝ, |deriv toEvenSchwartz.toSchwartzMap t| ≤
             C * Real.exp (-(1/2 + b) * |t|)

namespace ExpDecayClass

variable {b : ℝ}

/-- Coercion to function. -/
instance : CoeFun (ExpDecayClass b) (fun _ => ℝ → ℝ) where
  coe g := g.toEvenSchwartz

/-- The decay-witness norm. For `g ∈ E_b`, this is finite by definition. -/
def decayNorm (g : ExpDecayClass b) : ℝ :=
  ⨆ t : ℝ, |g.toEvenSchwartz t| * Real.exp ((1/2 + b) * |t|)

/-
The range of the decay-weight function is bounded above.

    PROOF NEEDED: The witness `C` from `g.has_decay` gives
    `|g(t)| * exp((1/2+b)|t|) ≤ C` for all `t`, so the range is
    bounded by `C`.
-/
lemma decayNorm_bddAbove (g : ExpDecayClass b) :
    BddAbove (Set.range (fun t : ℝ => |g.toEvenSchwartz t| * Real.exp ((1/2 + b) * |t|))) := by
  obtain ⟨ C, hC₀, hC ⟩ := g.has_decay;
  exact ⟨ C, Set.forall_mem_range.mpr fun t => by convert mul_le_mul_of_nonneg_right ( hC t ) ( Real.exp_nonneg ( ( 1 / 2 + b ) * |t| ) ) using 1 ; rw [ mul_assoc, ← Real.exp_add ] ; ring_nf; norm_num ⟩

/-
The decay norm is non-negative.
-/
lemma decayNorm_nonneg (g : ExpDecayClass b) : 0 ≤ decayNorm g := by
  exact Real.iSup_nonneg fun _ => mul_nonneg ( abs_nonneg _ ) ( Real.exp_nonneg _ )

/-
============================================================================
2. BANACH STRUCTURE ON E_b
============================================================================

Addition on `E_b`. Sum of two functions in `E_b` is in `E_b` because
    if `|g_i(t)| ≤ C_i exp(-(1/2+b)|t|)`, then
    `|(g_1 + g_2)(t)| ≤ (C_1 + C_2) exp(-(1/2+b)|t|)`.

    PROOF NEEDED: Construct the EvenSchwartz sum, verify decay witnesses
    additively combine.
-/
instance : Add (ExpDecayClass b) where
  add := fun g1 g2 =>
    { toEvenSchwartz := ⟨g1.toEvenSchwartz.toSchwartzMap + g2.toEvenSchwartz.toSchwartzMap,
        fun x => by simp [SchwartzMap.add_apply, g1.toEvenSchwartz.even, g2.toEvenSchwartz.even]⟩
      has_decay := by
        obtain ⟨C1, hC1_pos, hC1⟩ := g1.has_decay
        obtain ⟨C2, hC2_pos, hC2⟩ := g2.has_decay
        exact ⟨C1 + C2, by linarith, fun t => by
          simp only [EvenSchwartz.coe_apply, SchwartzMap.add_apply]
          calc |g1.toEvenSchwartz t + g2.toEvenSchwartz t|
              ≤ |g1.toEvenSchwartz t| + |g2.toEvenSchwartz t| := abs_add_le _ _
            _ ≤ C1 * Real.exp (-(1 / 2 + b) * |t|) + C2 * Real.exp (-(1 / 2 + b) * |t|) := by
                linarith [hC1 t, hC2 t]
            _ = (C1 + C2) * Real.exp (-(1 / 2 + b) * |t|) := by ring⟩
      has_decay_deriv := by
        obtain ⟨C1, hC1_pos, hC1⟩ := g1.has_decay_deriv
        obtain ⟨C2, hC2_pos, hC2⟩ := g2.has_decay_deriv
        exact ⟨C1 + C2, by linarith, fun t => by
          have : deriv (g1.toEvenSchwartz.toSchwartzMap + g2.toEvenSchwartz.toSchwartzMap) t =
                 deriv g1.toEvenSchwartz.toSchwartzMap t + deriv g2.toEvenSchwartz.toSchwartzMap t := by
            apply deriv_add
            · exact (g1.toEvenSchwartz.toSchwartzMap).differentiableAt.hasDerivAt.differentiableAt
            · exact (g2.toEvenSchwartz.toSchwartzMap).differentiableAt.hasDerivAt.differentiableAt
          rw [this]
          calc |deriv g1.toEvenSchwartz.toSchwartzMap t + deriv g2.toEvenSchwartz.toSchwartzMap t|
              ≤ |deriv g1.toEvenSchwartz.toSchwartzMap t| + |deriv g2.toEvenSchwartz.toSchwartzMap t| := abs_add_le _ _
            _ ≤ C1 * Real.exp (-(1 / 2 + b) * |t|) + C2 * Real.exp (-(1 / 2 + b) * |t|) := by
                linarith [hC1 t, hC2 t]
            _ = (C1 + C2) * Real.exp (-(1 / 2 + b) * |t|) := by ring⟩ }

/-
Scalar multiplication on `E_b`.
-/
instance : SMul ℝ (ExpDecayClass b) where
  smul := fun c g =>
    { toEvenSchwartz := ⟨c • g.toEvenSchwartz.toSchwartzMap,
        fun x => by simp [SchwartzMap.smul_apply, g.toEvenSchwartz.even]⟩
      has_decay := by
        obtain ⟨C, hC_pos, hC⟩ := g.has_decay
        exact ⟨|c| * C + 1, by positivity, fun t => by
          simp only [EvenSchwartz.coe_apply, SchwartzMap.smul_apply]
          calc |c * g.toEvenSchwartz t|
              = |c| * |g.toEvenSchwartz t| := abs_mul _ _
            _ ≤ |c| * (C * Real.exp (-(1 / 2 + b) * |t|)) := by
                apply mul_le_mul_of_nonneg_left (hC t) (abs_nonneg _)
            _ = |c| * C * Real.exp (-(1 / 2 + b) * |t|) := by ring
            _ ≤ (|c| * C + 1) * Real.exp (-(1 / 2 + b) * |t|) := by
                nlinarith [Real.exp_nonneg (-(1 / 2 + b) * |t|)]⟩
      has_decay_deriv := by
        obtain ⟨C, hC_pos, hC⟩ := g.has_decay_deriv
        exact ⟨|c| * C + 1, by positivity, fun t => by
          have : deriv (c • g.toEvenSchwartz.toSchwartzMap) t =
                 c * deriv g.toEvenSchwartz.toSchwartzMap t := by
            apply deriv_const_mul
            exact g.toEvenSchwartz.toSchwartzMap.differentiableAt.hasDerivAt.differentiableAt
          rw [this]
          calc |c * deriv g.toEvenSchwartz.toSchwartzMap t|
              = |c| * |deriv g.toEvenSchwartz.toSchwartzMap t| := abs_mul _ _
            _ ≤ |c| * (C * Real.exp (-(1 / 2 + b) * |t|)) := by
                apply mul_le_mul_of_nonneg_left (hC t) (abs_nonneg _)
            _ = |c| * C * Real.exp (-(1 / 2 + b) * |t|) := by ring
            _ ≤ (|c| * C + 1) * Real.exp (-(1 / 2 + b) * |t|) := by
                nlinarith [Real.exp_nonneg (-(1 / 2 + b) * |t|)]⟩ }

/-
Zero element of `E_b`.
-/
instance : Zero (ExpDecayClass b) where
  zero :=
    { toEvenSchwartz := ⟨0, fun _ => by simp⟩
      has_decay := ⟨1, one_pos, fun t => by simp; exact Real.exp_nonneg _⟩
      has_decay_deriv := ⟨1, one_pos, fun t => by
        have h0 : ((0 : SchwartzMap ℝ ℝ) : ℝ → ℝ) = 0 := SchwartzMap.coe_zero
        simp [h0]; exact Real.exp_nonneg _⟩ }

/-
`E_b` is an additive commutative group.
    PROOF NEEDED: routine, follows from `EvenSchwartz` group structure
    and pointwise additivity of decay witnesses.
-/
/-- Extensionality for ExpDecayClass: two elements are equal iff their
    underlying EvenSchwartz functions agree. -/
@[ext]
lemma ext {g1 g2 : ExpDecayClass b} (h : g1.toEvenSchwartz = g2.toEvenSchwartz) : g1 = g2 := by
  cases g1; cases g2; simp only at h; subst h; rfl

/-- Negation on `E_b`. -/
instance : Neg (ExpDecayClass b) where
  neg := fun g =>
    { toEvenSchwartz := ⟨-g.toEvenSchwartz.toSchwartzMap,
        fun x => by simp [SchwartzMap.neg_apply, g.toEvenSchwartz.even]⟩
      has_decay := by
        obtain ⟨C, hC_pos, hC⟩ := g.has_decay
        exact ⟨C, hC_pos, fun t => by
          simp only [EvenSchwartz.coe_apply, SchwartzMap.neg_apply]
          rw [abs_neg]; exact hC t⟩
      has_decay_deriv := by
        obtain ⟨C, hC_pos, hC⟩ := g.has_decay_deriv
        exact ⟨C, hC_pos, fun t => by
          have hd : deriv (-g.toEvenSchwartz.toSchwartzMap) t =
                    -deriv g.toEvenSchwartz.toSchwartzMap t := by
            have hh : ((-g.toEvenSchwartz.toSchwartzMap : SchwartzMap ℝ ℝ) : ℝ → ℝ) = -↑g.toEvenSchwartz.toSchwartzMap := by
              ext x; simp [SchwartzMap.neg_apply]
            rw [hh]; simp
          rw [hd, abs_neg]; exact hC t⟩ }

/-- Helper for extensionality: two `ExpDecayClass b` are equal iff their
    underlying `SchwartzMap`s agree. -/
private lemma evenSchwartz_ext {a b : EvenSchwartz} (h : a.toSchwartzMap = b.toSchwartzMap) : a = b := by
  cases a; cases b; simp only at h; subst h; rfl

private lemma expDecayExt (a b' : ExpDecayClass b)
    (h : a.toEvenSchwartz.toSchwartzMap = b'.toEvenSchwartz.toSchwartzMap) : a = b' :=
  ExpDecayClass.ext (evenSchwartz_ext h)

instance : AddCommGroup (ExpDecayClass b) where
  add_assoc a b' c := expDecayExt _ _ (add_assoc _ _ _)
  zero_add a := expDecayExt _ _ (zero_add _)
  add_zero a := expDecayExt _ _ (add_zero _)
  add_comm a b' := expDecayExt _ _ (add_comm _ _)
  neg_add_cancel a := expDecayExt _ _ (neg_add_cancel _)
  nsmul := nsmulRec
  zsmul := zsmulRec

/-
`E_b` is a real vector space.
-/
instance : Module ℝ (ExpDecayClass b) where
  one_smul a := expDecayExt _ _ (one_smul _ _)
  mul_smul r s a := expDecayExt _ _ (mul_smul _ _ _)
  smul_zero r := expDecayExt _ _ (smul_zero _)
  smul_add r a b' := expDecayExt _ _ (smul_add _ _ _)
  add_smul r s a := expDecayExt _ _ (add_smul _ _ _)
  zero_smul a := expDecayExt _ _ (zero_smul _ _)

/-
Normed group structure on `E_b` using the decay norm.
    PROOF NEEDED: Verify the norm axioms (positivity, triangle, scalar
    homogeneity) for `decayNorm`.
-/
instance : NormedAddCommGroup (ExpDecayClass b) where
  norm := fun g => decayNorm g
  dist_self := by
    intro x
    apply le_antisymm;
    · convert ciSup_le _;
      · exact ⟨ 0 ⟩;
      · erw [ show ( x - x : ExpDecayClass b ) = 0 from sub_self x ] ; norm_num;
        erw [ show ( toEvenSchwartz 0 : EvenSchwartz ) = ⟨ 0, fun _ => by simp +decide ⟩ from rfl ] ; norm_num;
    · exact decayNorm_nonneg _
  dist_comm := by
    intro x y; simp [ExpDecayClass.decayNorm];
    erw [ show ( x - y : ExpDecayClass b ).toEvenSchwartz.toSchwartzMap = ( x.toEvenSchwartz.toSchwartzMap - y.toEvenSchwartz.toSchwartzMap ) from rfl, show ( y - x : ExpDecayClass b ).toEvenSchwartz.toSchwartzMap = ( y.toEvenSchwartz.toSchwartzMap - x.toEvenSchwartz.toSchwartzMap ) from rfl ] ; norm_num [ abs_sub_comm ]
  dist_triangle := by
    intros x y z;
    refine' ciSup_le fun t => _;
    refine' le_trans _ ( add_le_add ( le_ciSup ( ExpDecayClass.decayNorm_bddAbove ( x - y ) ) t ) ( le_ciSup ( ExpDecayClass.decayNorm_bddAbove ( y - z ) ) t ) );
    rw [ show ( x - z ).toEvenSchwartz.toSchwartzMap t = ( x - y ).toEvenSchwartz.toSchwartzMap t + ( y - z ).toEvenSchwartz.toSchwartzMap t by
          exact show ( x.toEvenSchwartz.toSchwartzMap t - z.toEvenSchwartz.toSchwartzMap t ) = ( x.toEvenSchwartz.toSchwartzMap t - y.toEvenSchwartz.toSchwartzMap t ) + ( y.toEvenSchwartz.toSchwartzMap t - z.toEvenSchwartz.toSchwartzMap t ) by ring; ];
    cases abs_cases ( ( x - y ).toEvenSchwartz.toSchwartzMap t + ( y - z ).toEvenSchwartz.toSchwartzMap t ) <;> cases abs_cases ( ( x - y ).toEvenSchwartz.toSchwartzMap t ) <;> cases abs_cases ( ( y - z ).toEvenSchwartz.toSchwartzMap t ) <;> nlinarith [ Real.exp_pos ( ( 1 / 2 + b ) * |t| ) ]
  edist_dist := by
    intro x y; exact ENNReal.coe_nnreal_eq _
  dist_eq := by
    exact fun x y => rfl
  eq_of_dist_eq_zero := by
    intro x y hxy
    have h_zero : ∀ t : ℝ, (x - y).toEvenSchwartz t = 0 := by
      have h_zero : ∀ t : ℝ, |(x - y).toEvenSchwartz t| * Real.exp ((1/2 + b) * |t|) ≤ 0 := by
        exact fun t => hxy ▸ le_ciSup ( decayNorm_bddAbove _ ) t;
      exact fun t => by simpa [ Real.exp_ne_zero ] using le_antisymm ( le_of_not_gt fun h => not_le_of_gt ( mul_pos h ( Real.exp_pos _ ) ) ( h_zero t ) ) ( abs_nonneg _ ) ;
    exact expDecayExt _ _ ( sub_eq_zero.mp ( by ext t; simpa using h_zero t ) )

/-
Normed space structure (compatibility of norm with scalar mult).
-/
instance : NormedSpace ℝ (ExpDecayClass b) where
  norm_smul_le := by
    intro r g;
    refine' ciSup_le fun t => _;
    convert mul_le_mul_of_nonneg_right ( le_ciSup ( g.decayNorm_bddAbove ) t ) ( abs_nonneg r ) using 1 ; ring;
    · erw [ show ( r • g ).toEvenSchwartz.toSchwartzMap t = r * g.toEvenSchwartz.toSchwartzMap t by rfl ] ; norm_num [ abs_mul, mul_assoc, mul_comm, mul_left_comm ];
    · exact mul_comm _ _

/-- Completeness of `E_b` as a metric space.

    PROOF SKETCH: A Cauchy sequence in `E_b` is uniformly Cauchy in the
    weighted sup norm. The weighted limit exists pointwise. Verifying
    that the limit is in `E_b` (i.e., is even Schwartz with exponential
    decay) is the substantive part.

    PROOF NEEDED: Substantial. May need to use that the embedding
    `E_b → C_b(ℝ)` (continuous bounded functions) preserves
    completeness, then verify the limit lies in the EvenSchwartz subspace. -/
instance : CompleteSpace (ExpDecayClass b) := by
  sorry

end ExpDecayClass

-- ============================================================================
-- 3. THE EMBEDDING E_b → WeilTestFunction
-- ============================================================================

/-- Every element of `E_b` (with `b > 0`) is a `WeilTestFunction`,
    by taking the existing decay witness as the existential one. -/
def toWeilTestFunction {b : ℝ} (hb : 0 < b) (g : ExpDecayClass b) :
    WeilTestFunction where
  toEvenSchwartz := g.toEvenSchwartz
  has_exponential_decay := by
    obtain ⟨C, hC, hg⟩ := g.has_decay
    exact ⟨b, hb, C, hC, hg⟩
  has_exponential_decay_deriv := by
    obtain ⟨C, hC, hg⟩ := g.has_decay_deriv
    exact ⟨b, hb, C, hC, hg⟩

/-- The image of `E_b` in `WeilTestFunction`. -/
def imageInWTF (b : ℝ) (hb : 0 < b) : Set WeilTestFunction :=
  Set.range (toWeilTestFunction hb)

-- ============================================================================
-- 4. THE INDUCTIVE-LIMIT TOPOLOGY
-- ============================================================================

/-- The inductive-limit topology on `WeilTestFunction`: a set `U` is open
    iff its preimage in each `E_b` is open.

    Equivalently: it is the supremum (in the lattice of topologies) over
    `b > 0` of the topologies pushed forward from `E_b`.

    NOTE: In Mathlib, `TopologicalSpace.iSup` exists. The relevant
    construction is the "final topology" with respect to the family
    `{toWeilTestFunction (hb : 0 < b)}_{b > 0}`. -/
def indBanachTopology : TopologicalSpace WeilTestFunction :=
  ⨆ (b : ℝ) (hb : 0 < b),
    TopologicalSpace.coinduced (toWeilTestFunction hb) inferInstance

-- ============================================================================
-- 5. KEY PROPERTIES (ALL SORRY)
-- ============================================================================

/-- The ind-Banach topology is finer than the Schwartz subspace topology.

    PROOF NEEDED: Show that every set open in the Schwartz subspace
    topology is also open in `indBanachTopology`. Equivalently, the
    Schwartz topology is at most `indBanachTopology` in the Mathlib
    order. -/
lemma indBanach_finer_than_schwartz :
    (inferInstance : TopologicalSpace WeilTestFunction) ≤ indBanachTopology := by
  sorry

/-- A sequence converges in the ind-Banach topology iff it eventually lives
    in some `E_{b_0}` and converges there.

    This is the "regularity" property of LF-spaces. It is NOT automatic
    from the inductive limit definition — it requires the family `{E_b}`
    to be sufficiently well-behaved (e.g., reduced, or boundedly retractive).

    PROOF NEEDED: Substantial. Requires careful analysis of the topology.
    May not hold without additional hypotheses on the family. -/
theorem tendsto_indBanach_iff (g : WeilTestFunction)
    (g_seq : ℕ → WeilTestFunction) :
    Filter.Tendsto g_seq Filter.atTop (@nhds _ indBanachTopology g) ↔
    ∃ (b : ℝ) (hb : 0 < b),
      ∃ (g_b : ℕ → ExpDecayClass b) (g_lim : ExpDecayClass b),
      (∀ n, g_seq n = toWeilTestFunction hb (g_b n)) ∧
      g = toWeilTestFunction hb g_lim ∧
      Filter.Tendsto g_b Filter.atTop (nhds g_lim) := by
  constructor
  · -- Forward direction: LF-space regularity. This is a deep result
    -- requiring the family {E_b} to be a strict inductive system.
    -- Deferred to future Mathlib LF-space infrastructure.
    sorry
  · -- Backward direction: convergence in E_b implies convergence in ind-Banach
    intro ⟨b, hb, g_b, g_lim, hg_seq, hg, hg_lim⟩
    subst hg; simp only [funext hg_seq]
    rw [@Filter.tendsto_def]
    intro U hU
    obtain ⟨V, hVU, hV_open, hV_mem⟩ := (@mem_nhds_iff _ indBanachTopology).mp hU
    change @IsOpen _ (⨆ (b : ℝ) (hb : 0 < b),
      TopologicalSpace.coinduced (toWeilTestFunction hb) inferInstance) V at hV_open
    rw [@isOpen_iSup_iff] at hV_open
    specialize hV_open b
    rw [@isOpen_iSup_iff] at hV_open
    specialize hV_open hb
    rw [@isOpen_coinduced] at hV_open
    exact Filter.mem_of_superset (hg_lim (hV_open.mem_nhds hV_mem)) (fun n hn => hVU hn)

/-
The counterexample sequence does NOT converge in the ind-Banach topology.

**STATUS: UNPROVABLE AS STATED.** The hypothesis `h_def` is a
placeholder (`True`) that gives no constraint on `h`. If `h` is
constant (`h s = g_star` for all `s`), the sequence trivially
converges, contradicting the conclusion. A correct formalization
would need to specify the actual counterexample
`h(s) = exp(-√s) [φ(·-s) + φ(·+s)] + g_star` and prove that
for every `b > 0`, `‖h(s)‖_b → ∞` as `s → ∞`, so no single
`E_b` contains all terms.

Original statement commented out because it is false as stated:
theorem counterexample_diverges_in_indBanach
(g_star : WeilTestFunction)
(h : ℝ → WeilTestFunction)
(h_def : ∀ s ≥ (1 : ℝ), True)
: ¬ Filter.Tendsto (fun n : ℕ => h (n : ℝ)) Filter.atTop
(@nhds _ indBanachTopology g_star) := by
sorry

Corrected version: if a sequence in WeilTestFunction has the
    property that for every `b > 0`, eventually the terms' `E_b`-norms
    diverge, then the sequence does not converge in the ind-Banach topology.
    This captures the essential reason the counterexample fails to
    converge: no single `E_b` contains all terms.
-/
theorem counterexample_diverges_in_indBanach'
    (g_star : WeilTestFunction)
    (g_seq : ℕ → WeilTestFunction)
    (h_no_common_Eb : ∀ (b : ℝ) (hb : 0 < b),
      ¬ ∃ (g_b : ℕ → ExpDecayClass b) (g_lim : ExpDecayClass b),
        (∀ n, g_seq n = toWeilTestFunction hb (g_b n)) ∧
        g_star = toWeilTestFunction hb g_lim)
    : ¬ Filter.Tendsto g_seq Filter.atTop
        (@nhds _ indBanachTopology g_star) := by
  intro h_conv;
  contrapose! h_no_common_Eb;
  obtain ⟨ b, hb, g_b, g_lim, hg_b, hg_lim, hg_conv ⟩ := tendsto_indBanach_iff g_star g_seq |>.1 h_conv;
  exact ⟨ b, hb, g_b, g_lim, hg_b, hg_lim ⟩

-- ============================================================================
-- 6. CONTINUITY OF WEIL DISTRIBUTION (THE GOAL)
-- ============================================================================

/-- The Weil distribution applied to the autocorrelation of `g`.
    This is the same functional that fails to be continuous in the
    Schwartz subspace topology. The conjecture: it IS continuous in
    the ind-Banach topology. -/
def weilFunctional : WeilTestFunction → ℝ :=
  fun g => WeilDistribution_WTF (autocorrelation_WTF g)

/-- Helper: the Weil functional restricted to E_b is continuous in the norm topology.
    **The continuity theorem (CONJECTURED, not proven).**
    Proof would proceed by showing continuity on each `E_b` (where
    uniform decay control is available, so the cross-term-bounded-linear
    argument works), then using that the topology is the supremum of
    these.
    This is the key step: on each fixed E_b, the exponential decay control
    provides uniform bounds on the von Mangoldt sum. -/
lemma weilFunctional_continuous_on_Eb (b : ℝ) (hb : 0 < b) :
    Continuous (weilFunctional ∘ toWeilTestFunction hb) := by
  sorry

theorem weilFunctional_continuous_indBanach :
    @Continuous _ _ indBanachTopology _ weilFunctional := by
  show @Continuous _ _ (⨆ (b : ℝ) (hb : 0 < b),
    TopologicalSpace.coinduced (toWeilTestFunction hb) inferInstance) _ weilFunctional
  rw [continuous_iSup_dom]
  intro b
  rw [continuous_iSup_dom]
  intro hb
  rw [continuous_coinduced_dom]
  exact weilFunctional_continuous_on_Eb b hb

-- ============================================================================
-- 7. COMPATIBILITY WITH Conjecture_A_Strong_WTF
-- ============================================================================

/-- The conjecture's density assertion, RESTATED in the ind-Banach topology.

    NOTE: This is a STRONGER assertion than the original
    `Conjecture_A_Strong_WTF` (which uses the weaker Schwartz topology).
    Whether the Cohn-Elkies extremal Φ from sphere-packing literature
    satisfies this stronger density is OPEN MATHEMATICAL RESEARCH. -/
def Conjecture_A_Strong_WTF_indBanach : Prop :=
  ∃ (Φ : CohnElkiesFunction 24 → ℕ → WeilTestFunction)
    (f₂₄ : CohnElkiesFunction 24),
    (∀ n : ℕ, WeilDistribution_WTF (autocorrelation_WTF (Φ f₂₄ n)) ≥ 0) ∧
    (∀ g : WeilTestFunction, ∃ φ : ℕ → ℕ,
      Filter.Tendsto (fun k => Φ f₂₄ (φ k)) Filter.atTop
        (@nhds _ indBanachTopology g))

/-
Conditional: if the strong conjecture holds in the ind-Banach
    topology, then RH follows.

    The proof structure mirrors `conjecture_a_strong_wtf_implies_rh`
    but uses `weilFunctional_continuous_indBanach` instead of the
    Schwartz-topology continuity.
-/
theorem conjecture_a_strong_indBanach_implies_rh :
    Conjecture_A_Strong_WTF_indBanach → RiemannHypothesis := by
  intro hA
  rw [← WeilCriterion_WTF]
  intro g
  obtain ⟨Φ, f₂₄, hPos, hDense⟩ := hA
  obtain ⟨φ, hφ⟩ := hDense g
  set F : WeilTestFunction → ℝ :=
    fun h => WeilDistribution_WTF (autocorrelation_WTF h) with hF_def
  have h_seq_nonneg : ∀ k : ℕ, 0 ≤ F (Φ f₂₄ (φ k)) := by
    intro k; simp only [hF_def]; exact hPos (φ k)
  have hF_cont : @Continuous _ _ indBanachTopology _ F := weilFunctional_continuous_indBanach
  have h_lim : Filter.Tendsto (fun k => F (Φ f₂₄ (φ k)))
      Filter.atTop (nhds (F g)) :=
    (@Continuous.tendsto _ _ indBanachTopology _ F hF_cont g).comp hφ
  exact ge_of_tendsto' h_lim h_seq_nonneg

end WeilTestFunction.IndBanach

end