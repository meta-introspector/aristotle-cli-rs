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

import RequestProject.Imported.Sessc5eb0028.WeilTestFunction
import RequestProject.Imported.Sessc5eb0028.ConjectureA
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
          simp only [SchwartzMap.add_apply]
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
          simp only [SchwartzMap.smul_apply]
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
          simp only [SchwartzMap.neg_apply]
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
  one_smul _ := expDecayExt _ _ (one_smul _ _)
  mul_smul _ _ _ := expDecayExt _ _ (mul_smul _ _ _)
  smul_zero _ := expDecayExt _ _ (smul_zero _)
  smul_add _ _ _ := expDecayExt _ _ (smul_add _ _ _)
  add_smul _ _ _ := expDecayExt _ _ (add_smul _ _ _)
  zero_smul _ := expDecayExt _ _ (zero_smul _ _)

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
    convert mul_le_mul_of_nonneg_right ( le_ciSup ( g.decayNorm_bddAbove ) t ) ( abs_nonneg r ) using 1 ; ring_nf;
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
    order.

    **DIRECTION NOTE**: In Lean's `TopologicalSpace` lattice, `t₁ ≤ t₂`
    means `t₁` is *finer* (has more open sets) than `t₂`. The statement
    below says the Schwartz subspace topology (`inferInstance`) is finer
    than `indBanachTopology`. Mathematically, the intended claim is the
    opposite: the ind-Banach topology should be finer. This likely
    requires flipping to `indBanachTopology ≤ inferInstance`.
    Additionally, proving the correct direction requires showing that
    the embedding `ExpDecayClass.toEvenSchwartz : E_b → EvenSchwartz`
    is continuous, which needs the norm on `E_b` to control all Schwartz
    seminorms (including derivatives). The current `decayNorm` only
    controls function values, not derivatives, so additional norm
    structure may be needed. -/
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

/-
Pointwise bound from decay norm.
-/
lemma decayNorm_pointwise_bound' {b : ℝ} (g : ExpDecayClass b) (t : ℝ) :
    |g.toEvenSchwartz t| ≤ ExpDecayClass.decayNorm g * Real.exp (-(1 / 2 + b) * |t|) := by
  convert mul_le_mul_of_nonneg_right ( le_ciSup ( g.decayNorm_bddAbove ) t ) ( Real.exp_nonneg ( - ( 1 / 2 + b ) * |t| ) ) using 1 ; ring;
  rw [ mul_assoc, ← Real.exp_add ] ; ring ; norm_num

/-
Decay norm controls sup norm.
-/
lemma decayNorm_controls_sup' {b : ℝ} (g : ExpDecayClass b) (hb : 0 < b) :
    ∀ t : ℝ, |g.toEvenSchwartz t| ≤ ExpDecayClass.decayNorm g := by
  intro t
  have h_exp_bound : Real.exp (-(1 / 2 + b) * |t|) ≤ 1 := by
    exact Real.exp_le_one_iff.mpr ( by nlinarith [ abs_nonneg t ] );
  exact le_trans ( decayNorm_pointwise_bound' g t ) ( mul_le_of_le_one_right ( by exact Real.iSup_nonneg fun _ => by positivity ) h_exp_bound )

/-
For fixed x, g ↦ ∫ g(t)g(t+x) dt is continuous on E_b.
-/
lemma autocorr_at_continuous_Eb' {b : ℝ} (hb : 0 < b) (x : ℝ) :
    Continuous (fun g : ExpDecayClass b =>
      ∫ t : ℝ, g.toEvenSchwartz t * g.toEvenSchwartz (t + x)) := by
  refine' continuous_iff_continuousAt.mpr _;
  intro g₀
  have h_cont : Filter.Tendsto (fun g => ∫ t, (g.toEvenSchwartz.toSchwartzMap t - g₀.toEvenSchwartz.toSchwartzMap t) * g.toEvenSchwartz.toSchwartzMap (t + x)) (nhds g₀) (nhds 0) ∧ Filter.Tendsto (fun g => ∫ t, g₀.toEvenSchwartz.toSchwartzMap t * (g.toEvenSchwartz.toSchwartzMap (t + x) - g₀.toEvenSchwartz.toSchwartzMap (t + x))) (nhds g₀) (nhds 0) := by
    constructor;
    · have h_integrable : ∀ g : ExpDecayClass b, ∫ t, |g.toEvenSchwartz.toSchwartzMap t - g₀.toEvenSchwartz.toSchwartzMap t| * |g.toEvenSchwartz.toSchwartzMap (t + x)| ≤ (ExpDecayClass.decayNorm g + ExpDecayClass.decayNorm g₀) * ExpDecayClass.decayNorm (g - g₀) * ∫ t, Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t + x|) := by
        intro g
        have h_integrable : ∀ t : ℝ, |g.toEvenSchwartz.toSchwartzMap t - g₀.toEvenSchwartz.toSchwartzMap t| * |g.toEvenSchwartz.toSchwartzMap (t + x)| ≤ (ExpDecayClass.decayNorm g + ExpDecayClass.decayNorm g₀) * ExpDecayClass.decayNorm (g - g₀) * Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t + x|) := by
          intro t
          have h_bound : |g.toEvenSchwartz.toSchwartzMap t - g₀.toEvenSchwartz.toSchwartzMap t| ≤ (g - g₀).decayNorm * Real.exp (-(1 / 2 + b) * |t|) := by
            convert decayNorm_pointwise_bound' ( g - g₀ ) t using 1
          have h_bound' : |g.toEvenSchwartz.toSchwartzMap (t + x)| ≤ (g.decayNorm + g₀.decayNorm) * Real.exp (-(1 / 2 + b) * |t + x|) := by
            have h_bound' : |g.toEvenSchwartz.toSchwartzMap (t + x)| ≤ ExpDecayClass.decayNorm g * Real.exp (-(1 / 2 + b) * |t + x|) := by
              convert decayNorm_pointwise_bound' g ( t + x ) using 1;
            exact h_bound'.trans ( mul_le_mul_of_nonneg_right ( le_add_of_nonneg_right <| by exact Real.iSup_nonneg fun _ => by positivity ) <| by positivity );
          convert mul_le_mul h_bound h_bound' ( by positivity ) ( by exact mul_nonneg ( ExpDecayClass.decayNorm_nonneg _ ) ( Real.exp_nonneg _ ) ) using 1 ; ring;
        rw [ ← MeasureTheory.integral_const_mul ];
        refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
        · exact Filter.Eventually.of_forall fun t => mul_nonneg ( abs_nonneg _ ) ( abs_nonneg _ );
        · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t + x|)) MeasureTheory.volume := by
            have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|)) MeasureTheory.volume := by
              have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|)) (Set.Ioi 0) := by
                have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b) * t)) (Set.Ioi 0) := by
                  have := ( exp_neg_integrableOn_Ioi 0 ( by linarith : 0 < 1 / 2 + b ) );
                  exact this;
                exact h_integrable.congr_fun ( fun t ht => by rw [ abs_of_pos ht.out ] ) measurableSet_Ioi;
              have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|)) (Set.Iio 0) MeasureTheory.volume := by
                convert h_integrable.comp_neg using 1 ; norm_num [ Set.indicator ];
                ext; simp [Set.indicator];
              convert MeasureTheory.IntegrableOn.integrable ( h_integrable.union ‹MeasureTheory.IntegrableOn ( fun t => Real.exp ( - ( 1 / 2 + b ) * |t| ) ) ( Set.Ioi 0 ) MeasureTheory.volume› ) using 1 ; norm_num [ Set.union_comm ];
            refine' h_integrable.mono' _ _;
            · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
            · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr <| by nlinarith [ abs_nonneg ( t + x ) ] ) ;
          exact h_integrable.const_mul _;
        · filter_upwards [ ] using fun t => by simpa only [ mul_assoc ] using h_integrable t;
      have h_integrable : Filter.Tendsto (fun g => (ExpDecayClass.decayNorm g + ExpDecayClass.decayNorm g₀) * ExpDecayClass.decayNorm (g - g₀) * ∫ t, Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t + x|)) (nhds g₀) (nhds 0) := by
        have h_integrable : Filter.Tendsto (fun g => (g.decayNorm + g₀.decayNorm) * (g - g₀).decayNorm) (nhds g₀) (nhds 0) := by
          have h_cont : Filter.Tendsto (fun g => ExpDecayClass.decayNorm (g - g₀)) (nhds g₀) (nhds 0) := by
            have h_cont : Filter.Tendsto (fun g => ‖g - g₀‖) (nhds g₀) (nhds 0) := by
              exact Continuous.tendsto' ( by continuity ) _ _ ( by norm_num );
            convert h_cont using 1;
          have h_cont : Filter.Tendsto (fun g => g.decayNorm) (nhds g₀) (nhds g₀.decayNorm) := by
            exact continuous_norm.tendsto g₀;
          simpa using Filter.Tendsto.mul ( h_cont.add_const g₀.decayNorm ) ‹Filter.Tendsto ( fun g : ExpDecayClass b => ( g - g₀ ).decayNorm ) ( nhds g₀ ) ( nhds 0 ) ›;
        simpa using h_integrable.mul_const _;
      refine' squeeze_zero_norm _ h_integrable;
      intro g; specialize ‹∀ g : ExpDecayClass b, ∫ t, |g.toEvenSchwartz.toSchwartzMap t - g₀.toEvenSchwartz.toSchwartzMap t| * |g.toEvenSchwartz.toSchwartzMap ( t + x )| ≤ ( g.decayNorm + g₀.decayNorm ) * ( g - g₀ ).decayNorm * ∫ t, Real.exp ( - ( 1 / 2 + b ) * |t| ) * Real.exp ( - ( 1 / 2 + b ) * |t + x| ) › g; simp_all +decide [ abs_mul, MeasureTheory.integral_const_mul ] ;
      refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm ( _ : ℝ → ℝ ) ) _;
      simpa [ abs_mul ] using h_integrable;
    · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => |g₀.toEvenSchwartz.toSchwartzMap t| * Real.exp (-(1 / 2 + b) * |t + x|)) := by
        have h_integrable : MeasureTheory.Integrable (fun t : ℝ => |g₀.toEvenSchwartz.toSchwartzMap t| * Real.exp (-(1 / 2 + b) * |t|)) := by
          have h_integrable : MeasureTheory.Integrable (fun t : ℝ => g₀.decayNorm * Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t|)) := by
            have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-(1 + 2 * b) * |t|)) := by
              have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 + 2 * b) * |t|)) (Set.Ioi 0) := by
                have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 + 2 * b) * t)) (Set.Ioi 0) := by
                  have := ( exp_neg_integrableOn_Ioi 0 ( by linarith : 0 < 1 + 2 * b ) );
                  exact this;
                exact h_integrable.congr_fun ( fun t ht => by rw [ abs_of_pos ht.out ] ) measurableSet_Ioi;
              have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 + 2 * b) * |t|)) (Set.Iio 0) := by
                rw [ ← MeasureTheory.integrable_indicator_iff ] at *;
                · convert h_integrable.comp_neg using 1;
                  ext; simp [Set.indicator];
                · norm_num;
                · norm_num;
              convert MeasureTheory.IntegrableOn.integrable ( h_integrable.union ‹MeasureTheory.IntegrableOn ( fun t => Real.exp ( - ( 1 + 2 * b ) * |t| ) ) ( Set.Ioi 0 ) MeasureTheory.volume› ) using 1 ; ext ; aesop;
            convert h_integrable.const_mul ( g₀.decayNorm ) using 2 ; rw [ mul_assoc, ← Real.exp_add ] ; ring;
          refine' h_integrable.mono' _ _;
          · exact MeasureTheory.AEStronglyMeasurable.mul ( g₀.toEvenSchwartz.toSchwartzMap.continuous.abs.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
          · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_mul_of_nonneg_right ( decayNorm_pointwise_bound' g₀ t ) ( by positivity ) ;
        have h_integrable : MeasureTheory.Integrable (fun t : ℝ => |g₀.toEvenSchwartz.toSchwartzMap t| * Real.exp (-(1 / 2 + b) * (|t| - |x|))) := by
          convert h_integrable.mul_const ( Real.exp ( ( 1 / 2 + b ) * |x| ) ) using 2 ; ring;
          simpa only [ mul_assoc, ← Real.exp_add ] using by ring;
        refine' h_integrable.mono' _ _;
        · exact MeasureTheory.AEStronglyMeasurable.mul ( g₀.toEvenSchwartz.toSchwartzMap.continuous.abs.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
        · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_mul_of_nonneg_left ( Real.exp_le_exp.mpr <| by cases abs_cases ( t + x ) <;> cases abs_cases t <;> cases abs_cases x <;> nlinarith ) ( by positivity ) ;
      have h_dominated : ∀ᶠ g in nhds g₀, ∀ t : ℝ, |g₀.toEvenSchwartz.toSchwartzMap t * (g.toEvenSchwartz.toSchwartzMap (t + x) - g₀.toEvenSchwartz.toSchwartzMap (t + x))| ≤ |g₀.toEvenSchwartz.toSchwartzMap t| * Real.exp (-(1 / 2 + b) * |t + x|) * (ExpDecayClass.decayNorm (g - g₀)) := by
        filter_upwards [ ] with g t
        have h_bound : |g.toEvenSchwartz.toSchwartzMap (t + x) - g₀.toEvenSchwartz.toSchwartzMap (t + x)| ≤ (g - g₀).decayNorm * Real.exp (-(1 / 2 + b) * |t + x|) := by
          convert decayNorm_pointwise_bound' ( g - g₀ ) ( t + x ) using 1;
        rw [ abs_mul ] ; nlinarith [ abs_nonneg ( g₀.toEvenSchwartz.toSchwartzMap t ) ] ;
      have h_dominated_conv : Filter.Tendsto (fun g => ∫ t, |g₀.toEvenSchwartz.toSchwartzMap t| * Real.exp (-(1 / 2 + b) * |t + x|) * (ExpDecayClass.decayNorm (g - g₀))) (nhds g₀) (nhds 0) := by
        simp +decide [ MeasureTheory.integral_mul_const ];
        convert tendsto_const_nhds.mul ( show Filter.Tendsto ( fun g : ExpDecayClass b => ( g - g₀ ).decayNorm ) ( nhds g₀ ) ( nhds 0 ) from ?_ ) using 2 <;> norm_num;
        exact?;
      refine' squeeze_zero_norm' _ h_dominated_conv;
      filter_upwards [ h_dominated ] with g hg;
      refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm _ ) ( MeasureTheory.integral_mono_of_nonneg _ _ _ );
      · exact Filter.Eventually.of_forall fun t => norm_nonneg _;
      · exact h_integrable.mul_const _;
      · filter_upwards [ ] using hg;
  have h_cont : Filter.Tendsto (fun g => ∫ t, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + x) - g₀.toEvenSchwartz.toSchwartzMap t * g₀.toEvenSchwartz.toSchwartzMap (t + x)) (nhds g₀) (nhds 0) := by
    convert h_cont.1.add h_cont.2 using 2 <;> ring;
    rw [ ← MeasureTheory.integral_add ] ; congr ; ext ; ring;
    · refine' MeasureTheory.Integrable.sub _ _;
      · have h_integrable : ∀ g : ExpDecayClass b, MeasureTheory.Integrable (fun t => g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + x)) MeasureTheory.volume := by
          intro g;
          have h_integrable : ∀ g : ExpDecayClass b, MeasureTheory.Integrable (fun t => g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + x)) MeasureTheory.volume := by
            intro g
            have h_integrable : MeasureTheory.Integrable (fun t => g.toEvenSchwartz.toSchwartzMap t) MeasureTheory.volume := by
              exact g.toEvenSchwartz.toSchwartzMap.integrable
            have h_integrable : MeasureTheory.Integrable (fun t => g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + x)) MeasureTheory.volume := by
              have h_bounded : ∃ C > 0, ∀ t : ℝ, |g.toEvenSchwartz.toSchwartzMap (t + x)| ≤ C := by
                have h_bounded : ∃ C > 0, ∀ t : ℝ, |g.toEvenSchwartz.toSchwartzMap t| ≤ C := by
                  have := decayNorm_controls_sup' g hb;
                  exact ⟨ Max.max g.decayNorm 1, by positivity, fun t => le_trans ( this t ) ( le_max_left _ _ ) ⟩;
                exact ⟨ h_bounded.choose, h_bounded.choose_spec.1, fun t => h_bounded.choose_spec.2 _ ⟩
              refine' MeasureTheory.Integrable.mono' ( h_integrable.norm.mul_const _ ) _ _;
              exact h_bounded.choose;
              · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( h_integrable.comp_add_right x |> MeasureTheory.Integrable.aestronglyMeasurable );
              · filter_upwards [ ] using fun t => by simpa only [ norm_mul ] using mul_le_mul_of_nonneg_left ( h_bounded.choose_spec.2 t ) ( norm_nonneg _ ) ;
            exact h_integrable;
          exact h_integrable g;
        simpa only [ add_comm ] using h_integrable _;
      · have h_integrable : MeasureTheory.Integrable (fun t => g₀.toEvenSchwartz.toSchwartzMap t * ‹ExpDecayClass b›.toEvenSchwartz.toSchwartzMap (x + t)) MeasureTheory.volume := by
          have h_integrable : MeasureTheory.Integrable (fun t => g₀.toEvenSchwartz.toSchwartzMap t) MeasureTheory.volume := by
            exact g₀.toEvenSchwartz.toSchwartzMap.integrable
          refine' MeasureTheory.Integrable.mono' _ _ _;
          use fun t => |g₀.toEvenSchwartz.toSchwartzMap t| * ( ExpDecayClass.decayNorm ‹_› );
          · exact h_integrable.norm.mul_const _;
          · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by exact Continuous.comp ( by exact ‹ExpDecayClass b›.toEvenSchwartz.toSchwartzMap.continuous ) ( continuous_const.add continuous_id' ) ) );
          · filter_upwards [ ] with t using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_left ( decayNorm_controls_sup' _ hb _ ) ( by positivity ) ;
        exact h_integrable;
    · refine' MeasureTheory.Integrable.sub _ _;
      · have h_integrable : ∀ (g : SchwartzMap ℝ ℝ), MeasureTheory.Integrable g := by
          exact?;
        have h_integrable : MeasureTheory.Integrable (fun t => g₀.toEvenSchwartz.toSchwartzMap t * ‹ExpDecayClass b›.toEvenSchwartz.toSchwartzMap (x + t)) MeasureTheory.volume := by
          have h_bounded : ∃ C, ∀ t, |‹ExpDecayClass b›.toEvenSchwartz.toSchwartzMap (x + t)| ≤ C := by
            have := ‹ExpDecayClass b›.has_decay;
            obtain ⟨ C, hC₀, hC ⟩ := this; exact ⟨ C, fun t => le_trans ( hC _ ) ( mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr ( by cases abs_cases ( x + t ) <;> nlinarith ) ) ) ⟩ ;
          refine' MeasureTheory.Integrable.mono' _ _ _;
          use fun t => |g₀.toEvenSchwartz.toSchwartzMap t| * h_bounded.choose;
          · exact MeasureTheory.Integrable.mul_const ( h_integrable _ |> MeasureTheory.Integrable.abs ) _;
          · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable _ |> MeasureTheory.Integrable.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by exact Continuous.comp ( by exact ‹ExpDecayClass b›.toEvenSchwartz.toSchwartzMap.continuous ) ( continuous_const.add continuous_id' ) ) );
          · filter_upwards [ ] using fun t => by simpa [ abs_mul ] using mul_le_mul_of_nonneg_left ( h_bounded.choose_spec t ) ( abs_nonneg _ ) ;
        exact h_integrable;
      · have h_integrable : MeasureTheory.Integrable (fun t => g₀.toEvenSchwartz.toSchwartzMap t) MeasureTheory.volume := by
          exact g₀.toEvenSchwartz.toSchwartzMap.integrable;
        refine' MeasureTheory.Integrable.mono' _ _ _;
        use fun t => |g₀.toEvenSchwartz.toSchwartzMap t| * ( ExpDecayClass.decayNorm g₀ );
        · exact h_integrable.norm.mul_const _;
        · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( h_integrable.comp_add_left x |> MeasureTheory.Integrable.aestronglyMeasurable );
        · filter_upwards [ ] with t using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_left ( decayNorm_controls_sup' g₀ hb _ ) ( by positivity ) ;
  convert h_cont.add_const ( ∫ t, g₀.toEvenSchwartz.toSchwartzMap t * g₀.toEvenSchwartz.toSchwartzMap ( t + x ) ) using 2 ; norm_num [ ContinuousAt ];
  refine' Filter.tendsto_congr' _;
  filter_upwards [ ] with g;
  rw [ MeasureTheory.integral_sub ];
  · ring;
  · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => |g.toEvenSchwartz.toSchwartzMap t| * |g.toEvenSchwartz.toSchwartzMap (t + x)|) := by
      have h_integrable : MeasureTheory.Integrable (fun t : ℝ => |g.toEvenSchwartz.toSchwartzMap t|) := by
        exact MeasureTheory.Integrable.abs ( g.toEvenSchwartz.toSchwartzMap.integrable );
      refine' MeasureTheory.Integrable.mono' _ _ _;
      use fun t => |g.toEvenSchwartz.toSchwartzMap t| * ( ExpDecayClass.decayNorm g );
      · exact h_integrable.mul_const _;
      · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( h_integrable.comp_add_right x |> MeasureTheory.Integrable.aestronglyMeasurable );
      · filter_upwards [ ] with t using by simpa [ abs_mul ] using mul_le_mul_of_nonneg_left ( decayNorm_controls_sup' g hb ( t + x ) ) ( abs_nonneg _ ) ;
    refine' h_integrable.mono' _ _;
    · exact MeasureTheory.AEStronglyMeasurable.mul ( g.toEvenSchwartz.toSchwartzMap.continuous.aestronglyMeasurable ) ( g.toEvenSchwartz.toSchwartzMap.continuous.comp_aestronglyMeasurable ( measurable_id.add_const x |> Measurable.aestronglyMeasurable ) );
    · norm_num [ abs_mul ];
  · have h_integrable : MeasureTheory.Integrable (fun t => g₀.toEvenSchwartz.toSchwartzMap t) MeasureTheory.volume := by
      exact g₀.toEvenSchwartz.toSchwartzMap.integrable;
    refine' MeasureTheory.Integrable.mono' _ _ _;
    use fun t => |g₀.toEvenSchwartz.toSchwartzMap t| * ( ExpDecayClass.decayNorm g₀ );
    · exact h_integrable.norm.mul_const _;
    · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( h_integrable.comp_add_right x |> MeasureTheory.Integrable.aestronglyMeasurable );
    · filter_upwards [ ] with t using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_left ( decayNorm_controls_sup' g₀ hb _ ) ( by positivity ) ;

/-
Helper: the Weil functional restricted to E_b is continuous in the norm topology.
    **The continuity theorem (CONJECTURED, not proven).**
    Proof would proceed by showing continuity on each `E_b` (where
    uniform decay control is available, so the cross-term-bounded-linear
    argument works), then using that the topology is the supremum of
    these.
    This is the key step: on each fixed E_b, the exponential decay control
    provides uniform bounds on the von Mangoldt sum.
-/

/-- Component 1: g ↦ h(0)·log(π) is continuous. -/
lemma weil_comp1_continuous_Eb (b : ℝ) (hb : 0 < b) :
    Continuous (fun g : ExpDecayClass b =>
      (∫ t : ℝ, g.toEvenSchwartz t * g.toEvenSchwartz (t + 0)) *
      Real.log Real.pi) := by
  exact (autocorr_at_continuous_Eb' hb 0).mul continuous_const

/-
Component 2: g ↦ ∑ Λ(n)/√n · h(log n) is continuous on E_b.
    The key insight: on E_b, all functions decay as exp(-(1/2+b)|t|),
    giving |h(log n)| ≤ C·‖g‖²_b · n^{-(1/2+b/2)}, so the sum
    ∑ Λ(n)/√n · |h(log n)| ≤ C·‖g‖²_b · ∑ Λ(n)·n^{-(1+b/2)} < ∞
    uniformly on bounded subsets.
-/
lemma weil_comp2_continuous_Eb (b : ℝ) (hb : 0 < b) :
    Continuous (fun g : ExpDecayClass b =>
      ∑' (n : ℕ), (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n *
        (∫ t : ℝ, g.toEvenSchwartz t *
              g.toEvenSchwartz (t + Real.log n))) := by
  -- Let's choose any two elements $g$ and $h$ in $E_b$.
  apply continuous_iff_continuousAt.mpr;
  intro g₀
  have h_cont : ContinuousOn (fun g : ExpDecayClass b => (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n) / Real.sqrt n * ∫ t : ℝ, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + Real.log n))) {g : ExpDecayClass b | ‖g - g₀‖ ≤ 1} := by
    refine' continuousOn_tsum _ _ _;
    use fun n => ( ArithmeticFunction.vonMangoldt n ) / Real.sqrt n * ( ( ‖g₀‖ + 1 ) * ( ‖g₀‖ + 1 ) * ( 2 * Real.pi + |Real.log n| ) * Real.exp ( - ( 1 / 2 + b / 2 ) * |Real.log n| ) );
    · exact fun n => Continuous.continuousOn ( by exact Continuous.mul ( continuous_const ) ( autocorr_at_continuous_Eb' hb ( Real.log n ) ) );
    · have h_summable : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n) * (2 * Real.pi + |Real.log n|) * Real.exp (-(1 / 2 + b / 2) * |Real.log n|) / Real.sqrt n) := by
        have h_summable : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n) * (2 * Real.pi + Real.log n) * n ^ (-(1 + b / 2))) := by
          have h_summable : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n) * (Real.log n) * n ^ (-(1 + b / 2))) := by
            have h_summable : Summable (fun n : ℕ => (Real.log n) ^ 2 * (n : ℝ) ^ (-(1 + b / 2))) := by
              -- We can compare our series with the convergent p-series $\sum_{n=1}^\infty n^{-(1 + b/2) + \epsilon}$ for any $\epsilon > 0$.
              have h_compare : ∀ ε > 0, ∃ C > 0, ∀ n : ℕ, n ≥ 2 → (Real.log n)^2 * (n : ℝ)^(-(1 + b / 2)) ≤ C * (n : ℝ)^(-(1 + b / 2) + ε) := by
                intro ε hε_pos
                obtain ⟨C, hC_pos, hC⟩ : ∃ C > 0, ∀ n : ℕ, n ≥ 2 → (Real.log n)^2 ≤ C * (n : ℝ)^ε := by
                  have h_compare : ∃ C > 0, ∀ n : ℕ, n ≥ 2 → Real.log n ≤ C * (n : ℝ)^(ε / 2) := by
                    use 2 / ε, by positivity, fun n hn => by have := Real.log_le_sub_one_of_pos ( by positivity : 0 < ( n : ℝ ) ^ ( ε / 2 ) ) ; rw [ Real.log_rpow ( by positivity ) ] at this; nlinarith [ show ( n : ℝ ) ≥ 2 by exact_mod_cast hn, Real.rpow_pos_of_pos ( by positivity : 0 < ( n : ℝ ) ) ( ε / 2 ), mul_div_cancel₀ ( 2 : ℝ ) ( ne_of_gt hε_pos ) ] ;
                  obtain ⟨ C, hC_pos, hC ⟩ := h_compare; use C^2; exact ⟨ sq_pos_of_pos hC_pos, fun n hn => by convert pow_le_pow_left₀ ( Real.log_nonneg <| Nat.one_le_cast.mpr <| by linarith ) ( hC n hn ) 2 using 1 ; rw [ mul_pow, ← Real.rpow_natCast, ← Real.rpow_natCast, ← Real.rpow_mul ( Nat.cast_nonneg _ ) ] ; ring ⟩ ;
                exact ⟨ C, hC_pos, fun n hn => by convert mul_le_mul_of_nonneg_right ( hC n hn ) ( Real.rpow_nonneg ( Nat.cast_nonneg n ) ( - ( 1 + b / 2 ) ) ) using 1 ; rw [ Real.rpow_add ( by positivity ) ] ; ring ⟩;
              -- Choose $\epsilon = \frac{b}{4}$.
              obtain ⟨C, hC_pos, hC⟩ : ∃ C > 0, ∀ n : ℕ, n ≥ 2 → (Real.log n)^2 * (n : ℝ)^(-(1 + b / 2)) ≤ C * (n : ℝ)^(-(1 + b / 2) + b / 4) := h_compare (b / 4) (by linarith);
              rw [ ← summable_nat_add_iff 2 ];
              exact Summable.of_nonneg_of_le ( fun n => by positivity ) ( fun n => hC _ ( by linarith ) ) ( Summable.mul_left _ <| by simpa using summable_nat_add_iff 2 |>.2 <| Real.summable_nat_rpow.2 <| by linarith );
            refine' .of_nonneg_of_le ( fun n => _ ) ( fun n => _ ) h_summable;
            · exact mul_nonneg ( mul_nonneg ( by rw [ ArithmeticFunction.vonMangoldt_apply ] ; positivity ) ( by positivity ) ) ( by positivity );
            · by_cases hn : n = 0 <;> simp_all +decide [ ArithmeticFunction.vonMangoldt ];
              split_ifs <;> nlinarith [ show 0 ≤ Real.log n * n ^ ( - ( b / 2 ) + -1 ) by positivity, show Real.log n.minFac ≤ Real.log n by exact Real.log_le_log ( Nat.cast_pos.mpr <| Nat.minFac_pos _ ) <| Nat.cast_le.mpr <| Nat.minFac_le <| Nat.pos_of_ne_zero hn, show 0 ≤ Real.log n ^ 2 * n ^ ( - ( b / 2 ) + -1 ) by positivity ];
          have h_summable : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n) * (2 * Real.pi) * n ^ (-(1 + b / 2))) := by
            have h_summable : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n) * n ^ (-(1 + b / 2))) := by
              have h_summable : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n) * (Real.log n) * n ^ (-(1 + b / 2)) / Real.log n) := by
                rw [ ← summable_nat_add_iff 2 ] at *;
                refine' .of_nonneg_of_le ( fun n => div_nonneg ( mul_nonneg ( mul_nonneg ( by exact_mod_cast ArithmeticFunction.vonMangoldt_nonneg ) ( Real.log_nonneg ( by norm_cast; linarith ) ) ) ( Real.rpow_nonneg ( by positivity ) _ ) ) ( Real.log_nonneg ( by norm_cast; linarith ) ) ) ( fun n => _ ) ( h_summable.mul_left ( 1 / Real.log 2 ) );
                field_simp;
                rw [ div_le_iff₀ ( Real.log_pos ( by norm_cast; linarith ) ) ];
                exact mul_le_mul_of_nonneg_left ( Real.log_le_log ( by positivity ) ( by norm_cast; linarith ) ) ( mul_nonneg ( by exact_mod_cast ArithmeticFunction.vonMangoldt_nonneg ) ( Real.log_nonneg ( by norm_cast; linarith ) ) );
              refine' h_summable.congr fun n => _;
              by_cases hn : n = 0 <;> by_cases hn' : Real.log n = 0 <;> simp_all +decide [ mul_assoc, mul_div_assoc ];
              norm_cast at * ; aesop;
            convert h_summable.mul_left ( 2 * Real.pi ) using 2 ; ring;
          convert h_summable.add ‹Summable fun n : ℕ => ArithmeticFunction.vonMangoldt n * Real.log n * ( n : ℝ ) ^ ( - ( 1 + b / 2 ) ) › using 2 ; ring;
        refine' .of_nonneg_of_le ( fun n => _ ) ( fun n => _ ) h_summable;
        · exact div_nonneg ( mul_nonneg ( mul_nonneg ( by exact ( ArithmeticFunction.vonMangoldt_nonneg ) ) ( by positivity ) ) ( by positivity ) ) ( by positivity );
        · by_cases hn : n = 0 <;> simp_all +decide [ Real.rpow_def_of_pos, abs_of_nonneg, Real.log_nonneg ];
          rw [ abs_of_nonneg ( Real.log_nonneg ( Nat.one_le_cast.mpr ( Nat.pos_of_ne_zero hn ) ) ) ] ; rw [ Real.rpow_def_of_pos ( Nat.cast_pos.mpr ( Nat.pos_of_ne_zero hn ) ) ] ; ring_nf ; norm_num [ hn ] ;
          rw [ show ( Real.sqrt n : ℝ ) ⁻¹ = Real.exp ( - ( Real.log n * ( 1 / 2 ) ) ) by rw [ Real.sqrt_eq_rpow, ← Real.rpow_neg ( Nat.cast_nonneg _ ), Real.rpow_def_of_pos ( Nat.cast_pos.mpr ( Nat.pos_of_ne_zero hn ) ) ] ; ring ] ; ring_nf ; norm_num [ Real.exp_add, Real.exp_neg, Real.exp_mul, Real.exp_log ( Nat.cast_pos.mpr ( Nat.pos_of_ne_zero hn ) ) ] ;
          norm_num [ ← Real.sqrt_eq_rpow ] ; ring_nf ; norm_num [ hn ];
          linarith;
      convert h_summable.mul_left ( ( ‖g₀‖ + 1 ) * ( ‖g₀‖ + 1 ) ) using 2 ; ring;
    · intro n g hg
      have h_bound : |∫ t : ℝ, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + Real.log n)| ≤ (‖g‖ * ‖g‖ * (2 * Real.pi + |Real.log n|) * Real.exp (-(1 / 2 + b / 2) * |Real.log n|)) := by
        have h_bound : ∀ t : ℝ, |g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + Real.log n)| ≤ ‖g‖ * ‖g‖ * Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t + Real.log n|) := by
          intro t
          have h_bound : |g.toEvenSchwartz.toSchwartzMap t| ≤ ‖g‖ * Real.exp (-(1 / 2 + b) * |t|) ∧ |g.toEvenSchwartz.toSchwartzMap (t + Real.log n)| ≤ ‖g‖ * Real.exp (-(1 / 2 + b) * |t + Real.log n|) := by
            exact ⟨ decayNorm_pointwise_bound' g t, decayNorm_pointwise_bound' g ( t + Real.log n ) ⟩;
          simpa only [ abs_mul ] using mul_le_mul h_bound.1 h_bound.2 ( by positivity ) ( by positivity ) |> le_trans <| by ring_nf; norm_num;
        refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm ( _ : ℝ → ℝ ) ) ( le_trans ( MeasureTheory.integral_mono_of_nonneg _ _ _ ) _ );
        use fun t => ‖g‖ * ‖g‖ * Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t + Real.log n|);
        · exact Filter.Eventually.of_forall fun x => norm_nonneg _;
        · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|) * Real.exp (-(1 / 2 + b) * |t + Real.log n|)) MeasureTheory.volume := by
            have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|)) MeasureTheory.volume := by
              have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|)) (Set.Ioi 0) := by
                have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b) * t)) (Set.Ioi 0) := by
                  have := ( exp_neg_integrableOn_Ioi 0 ( by linarith : 0 < 1 / 2 + b ) );
                  exact this;
                exact h_integrable.congr_fun ( fun x hx => by rw [ abs_of_pos hx.out ] ) measurableSet_Ioi;
              have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b) * |t|)) (Set.Iio 0) MeasureTheory.volume := by
                convert h_integrable.comp_neg using 1 ; norm_num [ Set.indicator ] ; ring_nf ; aesop;
              convert MeasureTheory.IntegrableOn.integrable ( h_integrable.union ‹MeasureTheory.IntegrableOn ( fun t => Real.exp ( - ( 1 / 2 + b ) * |t| ) ) ( Set.Ioi 0 ) MeasureTheory.volume› ) using 1 ; norm_num [ Set.union_comm ];
            refine' h_integrable.mono' _ _;
            · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
            · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr <| by nlinarith [ abs_nonneg ( t + Real.log n ) ] ) ;
          convert h_integrable.const_mul ( ‖g‖ * ‖g‖ ) using 2 ; ring;
        · filter_upwards [ ] using h_bound;
        · have := exp_decay_convolution_integral_bound ( 1 / 2 + b ) ( by linarith ) ( Real.log n );
          simp_all +decide [ mul_assoc, MeasureTheory.integral_const_mul ];
          gcongr;
          refine' le_trans this _;
          exact mul_le_mul ( by nlinarith [ Real.pi_gt_three, inv_mul_cancel₀ ( by linarith : ( 2⁻¹ + b ) ≠ 0 ) ] ) ( Real.exp_le_exp.mpr ( by nlinarith [ Real.pi_gt_three, abs_nonneg ( Real.log n ) ] ) ) ( by positivity ) ( by positivity );
      have h_bound : ‖g‖ ≤ ‖g₀‖ + 1 := by
        have := norm_sub_norm_le g g₀; linarith [ hg.out ] ;
      rw [ norm_mul, Real.norm_of_nonneg ( div_nonneg ( ArithmeticFunction.vonMangoldt_nonneg ) ( Real.sqrt_nonneg _ ) ) ];
      gcongr;
      · exact div_nonneg ( ArithmeticFunction.vonMangoldt_nonneg ) ( Real.sqrt_nonneg _ );
      · exact le_trans ‹_› ( mul_le_mul_of_nonneg_right ( mul_le_mul ( mul_le_mul h_bound h_bound ( by positivity ) ( by positivity ) ) le_rfl ( by positivity ) ( by positivity ) ) ( by positivity ) );
  exact h_cont.continuousAt ( Metric.closedBall_mem_nhds _ zero_lt_one )

/-
Component 3: the archimedean integral is continuous on E_b.
-/
lemma weil_comp3_continuous_Eb (b : ℝ) (hb : 0 < b) :
    Continuous (fun g : ExpDecayClass b =>
      ∫ x in Set.Ioi (0 : ℝ),
        (∫ t : ℝ, g.toEvenSchwartz t *
              g.toEvenSchwartz (t + x)) *
        (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))) := by
  refine' continuous_iff_continuousAt.mpr _;
  intro g;
  refine' MeasureTheory.tendsto_integral_filter_of_dominated_convergence _ _ _ _ _;
  use fun x => ( ‖g‖ + 1 ) ^ 2 * Real.exp ( - ( 1 / 2 + b / 2 ) * |x| ) * |1 / ( 1 - Real.exp ( -2 * x ) ) - 1 / ( 2 * x )| * ( 1 / ( 1 / 2 + b / 2 ) + |x| );
  · refine' Filter.Eventually.of_forall fun n => Measurable.aestronglyMeasurable _;
    refine' Measurable.mul _ _;
    · refine' MeasureTheory.StronglyMeasurable.measurable _;
      refine' MeasureTheory.StronglyMeasurable.integral_prod_right _;
      exact Continuous.stronglyMeasurable ( by fun_prop );
    · exact Measurable.sub ( measurable_const.div ( measurable_const.sub ( Real.continuous_exp.measurable.comp ( measurable_const.mul measurable_id' ) ) ) ) ( measurable_const.div ( measurable_const.mul measurable_id' ) );
  · refine' Filter.eventually_of_mem ( Metric.ball_mem_nhds _ zero_lt_one ) fun n hn => Filter.eventually_of_mem ( MeasureTheory.ae_restrict_mem measurableSet_Ioi ) fun x hx => _;
    -- Apply the decay bound to the integral.
    have h_integral_bound : |∫ t : ℝ, n.toEvenSchwartz.toSchwartzMap t * n.toEvenSchwartz.toSchwartzMap (t + x)| ≤ (‖g‖ + 1) ^ 2 * (1 / (1 / 2 + b / 2) + |x|) * Real.exp (-(1 / 2 + b / 2) * |x|) := by
      have h_integral_bound : ∀ t : ℝ, |n.toEvenSchwartz.toSchwartzMap t| ≤ (‖g‖ + 1) * Real.exp (-(1 / 2 + b / 2) * |t|) := by
        intro t
        have h_bound : |n.toEvenSchwartz.toSchwartzMap t| ≤ ‖n‖ * Real.exp (-(1 / 2 + b) * |t|) := by
          convert decayNorm_pointwise_bound' n t using 1;
        refine le_trans h_bound ?_;
        exact mul_le_mul ( by linarith [ norm_sub_norm_le n g, mem_ball_iff_norm.mp hn ] ) ( Real.exp_le_exp.mpr <| by nlinarith [ abs_nonneg t ] ) ( by positivity ) ( by positivity );
      have := @exp_decay_convolution_integral_bound ( 1 / 2 + b / 2 ) ( by linarith ) x;
      refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm ( _ : ℝ → ℝ ) ) ( le_trans ( MeasureTheory.integral_mono_of_nonneg _ _ _ ) _ );
      use fun t => ( ‖g‖ + 1 ) ^ 2 * Real.exp ( - ( 1 / 2 + b / 2 ) * |t| ) * Real.exp ( - ( 1 / 2 + b / 2 ) * |t + x| );
      · exact Filter.Eventually.of_forall fun t => norm_nonneg _;
      · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-(1 / 2 + b / 2) * |t|) * Real.exp (-(1 / 2 + b / 2) * |t + x|)) MeasureTheory.volume := by
          have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-(1 / 2 + b / 2) * |t|)) MeasureTheory.volume := by
            have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b / 2) * |t|)) (Set.Ioi 0) := by
              have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b / 2) * t)) (Set.Ioi 0) := by
                have := ( exp_neg_integrableOn_Ioi 0 ( by positivity : 0 < ( 1 / 2 + b / 2 ) ) );
                exact this;
              exact h_integrable.congr_fun ( fun t ht => by rw [ abs_of_pos ht.out ] ) measurableSet_Ioi;
            have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-(1 / 2 + b / 2) * |t|)) (Set.Iio 0) MeasureTheory.volume := by
              convert h_integrable.comp_neg using 1 ; norm_num [ Set.indicator ];
              norm_num [ Set.ext_iff ];
            convert MeasureTheory.IntegrableOn.integrable ( h_integrable.union ‹MeasureTheory.IntegrableOn ( fun t => Real.exp ( - ( 1 / 2 + b / 2 ) * |t| ) ) ( Set.Ioi 0 ) MeasureTheory.volume› ) using 1 ; norm_num [ Set.union_comm ];
          refine' h_integrable.mono' _ _;
          · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
          · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr <| by nlinarith [ abs_nonneg ( t + x ) ] ) ;
        simpa only [ mul_assoc ] using h_integrable.const_mul _;
      · filter_upwards [ ] with t using by simpa [ sq, mul_assoc, mul_comm, mul_left_comm ] using mul_le_mul ( h_integral_bound t ) ( h_integral_bound ( t + x ) ) ( by positivity ) ( by positivity ) ;
      · simp_all +decide [ mul_assoc, MeasureTheory.integral_const_mul ];
        exact mul_le_mul_of_nonneg_left this ( sq_nonneg _ );
    rw [ norm_mul ] ; convert mul_le_mul_of_nonneg_right h_integral_bound ( abs_nonneg _ ) using 1 ; ring;
  · have h_integrable : MeasureTheory.IntegrableOn (fun x => Real.exp (-(1 / 2 + b / 2) * |x|) * |1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x)| * (1 / (1 / 2 + b / 2) + |x|)) (Set.Ioi 0) := by
      have h_integrable : MeasureTheory.IntegrableOn (fun x => Real.exp (-(1 / 2 + b / 2) * x) * (1 / (1 / 2 + b / 2) + x)) (Set.Ioi 0) := by
        have h_integrable : MeasureTheory.IntegrableOn (fun x => Real.exp (-(1 / 2 + b / 2) * x) * x) (Set.Ioi 0) := by
          have h_integrable : ∫ x in Set.Ioi 0, Real.exp (-(1 / 2 + b / 2) * x) * x = 1 / (1 / 2 + b / 2) ^ 2 := by
            have := @integral_rpow_mul_exp_neg_mul_rpow;
            convert @this 1 1 ( 1 / 2 + b / 2 ) ( by norm_num ) ( by norm_num ) ( by positivity ) using 1 <;> norm_num [ Real.rpow_neg, mul_comm ];
            norm_cast;
          exact ( by contrapose! h_integrable; rw [ MeasureTheory.integral_undef h_integrable ] ; positivity );
        have h_integrable : MeasureTheory.IntegrableOn (fun x => Real.exp (-(1 / 2 + b / 2) * x) * (1 / (1 / 2 + b / 2))) (Set.Ioi 0) := by
          have h_integrable : ∫ x in Set.Ioi 0, Real.exp (-(1 / 2 + b / 2) * x) = 1 / (1 / 2 + b / 2) := by
            convert integral_exp_neg_mul_rpow zero_lt_one ( show 0 < 1 / 2 + b / 2 by positivity ) using 1 <;> norm_num [ Real.rpow_neg_one ];
          exact MeasureTheory.Integrable.mul_const ( by exact ( by contrapose! h_integrable; rw [ MeasureTheory.integral_undef h_integrable ] ; positivity ) ) _;
        simpa only [ mul_add ] using h_integrable.add ‹MeasureTheory.IntegrableOn ( fun x => Real.exp ( - ( 1 / 2 + b / 2 ) * x ) * x ) ( Set.Ioi 0 ) MeasureTheory.volume›;
      have h_integrable : ∀ x ∈ Set.Ioi 0, |1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x)| ≤ 1 := by
        intro x hx; rw [ abs_le ] ; constructor <;> norm_num at *;
        · field_simp;
          rw [ div_add_one, mul_div, le_div_iff₀ ] <;> nlinarith [ Real.exp_pos ( - ( x * 2 ) ), Real.exp_lt_one_iff.mpr ( show - ( x * 2 ) < 0 by linarith ), Real.add_one_le_exp ( - ( x * 2 ) ) ];
        · field_simp;
          rw [ div_le_iff₀ ] <;> nlinarith [ Real.exp_pos ( - ( 2 * x ) ), Real.exp_neg ( 2 * x ), mul_inv_cancel₀ ( ne_of_gt ( Real.exp_pos ( 2 * x ) ) ), Real.add_one_le_exp ( 2 * x ), Real.add_one_le_exp ( - ( 2 * x ) ) ];
      refine' MeasureTheory.Integrable.mono' _ _ _;
      refine' fun x => Real.exp ( - ( 1 / 2 + b / 2 ) * x ) * ( 1 / ( 1 / 2 + b / 2 ) + x );
      · aesop;
      · fun_prop;
      · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioi ] with x hx using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; rw [ abs_of_nonneg hx.out.le ] ; exact mul_le_mul_of_nonneg_right ( mul_le_of_le_one_right ( by positivity ) ( h_integrable x hx ) ) ( by linarith [ hx.out, one_div_nonneg.mpr ( show 0 ≤ 1 / 2 + b / 2 by positivity ) ] ) ;
    simpa only [ mul_assoc ] using h_integrable.const_mul _;
  · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioi ] with x hx using Filter.Tendsto.mul ( autocorr_at_continuous_Eb' hb x |> Continuous.tendsto <| g ) tendsto_const_nhds

lemma weilFunctional_continuous_on_Eb (b : ℝ) (hb : 0 < b) :
    Continuous (weilFunctional ∘ toWeilTestFunction hb) := by
  have h_cont : Continuous (fun g : ExpDecayClass b => (WeilDistribution_WTF (autocorrelation_WTF (toWeilTestFunction hb g)))) := by
    convert ( Continuous.sub ( Continuous.add ( weil_comp1_continuous_Eb b hb ) ( weil_comp3_continuous_Eb b hb ) ) ( weil_comp2_continuous_Eb b hb ) ) using 1;
    ext; simp [weil_autocorr_factors_WTF];
    ring!;
  exact h_cont

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