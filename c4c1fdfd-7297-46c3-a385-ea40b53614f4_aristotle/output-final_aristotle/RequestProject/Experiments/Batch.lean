/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import RequestProject.Experiments.Lattice

/-! # Shared batches of sample heights, and what a batch can decide

The laboratory now lets a user *run a batch* — evaluate the counting data at a finite set of
heights — and *share* it, so that several batches can be pooled into one leaderboard. This file
says, formally, what pooling finitely many batches can and cannot establish about a candidate

`p.eval T = a·T·log T + b·T + c·log T + d`.

* `Batch` — a finite set of heights together with the count recorded at each of them, and
  `Batch.merge`, the pooling of two shared batches. `Batch.error_le_merge` and
  `Batch.error_le_merge_right` say that pooling can only make a candidate's error larger, and
  `Batch.bestError_le_merge` that the best attainable error grows with the pooled batch: sharing
  data is a strictly more demanding test.

* `Batch.exists_inadmissible_error_lt` — **no finite batch, however large and however many users
  contributed to it, can separate the asymptotically correct candidates from the wrong ones.**
  For every candidate `p` and every `ε > 0` there is a candidate `q` with the *wrong* leading
  coefficient whose error on the batch beats `p`'s by less than `ε`. Consequently
  `Batch.bestError_eq_bestError_inadmissible`: the best error over inadmissible candidates equals
  the best error over all candidates. A leaderboard built from shared batches is blind to the
  only property that matters asymptotically.

* `isLittleO_iff_admissible` — the criterion that does decide, and it needs unboundedly many
  heights: a candidate's error is `o(T log T)` exactly when it is admissible.

* `admissible_eval_isEquivalent` — **and if a batch does nominate an admissible candidate, that
  candidate is nothing new**: any two admissible candidates are asymptotically equivalent, hence
  asymptotically equivalent to the main term already assumed. So the answer to "does the shared
  leaderboard contain an interesting candidate?" is negative for a precise reason, not for want
  of looking: within this family, a candidate is either asymptotically wrong (and finite data
  cannot tell) or asymptotically the same as `(T/2π) log T`.

Nothing here proves the Riemann–von Mangoldt formula; results depending on it take it as a
hypothesis.
-/

open Filter Topology Asymptotics

namespace ZetaZeros.Experiments

/-- A batch of shared data: finitely many heights, and the count recorded at each height. -/
structure Batch where
  /-- The heights at which the batch was run. -/
  heights : Finset ℝ
  /-- The count recorded by the batch (only its values on `heights` are used). -/
  count : ℝ → ℝ

namespace Batch

/-- The error of a candidate on a batch, in the dashboard's interpolated metric. -/
noncomputable def error (B : Batch) (p : Candidate) (alpha : ℝ) : ℝ :=
  totalError p B.count alpha B.heights

lemma error_nonneg (B : Batch) (p : Candidate) (alpha : ℝ) : 0 ≤ B.error p alpha :=
  totalError_nonneg _ _ _ _

/-- The counting data of the pooled batch: readings of the first batch, extended by those of the
second at the heights the first did not visit. -/
noncomputable def mergeCount (B B' : Batch) : ℝ → ℝ :=
  fun T => if T ∈ B.heights then B.count T else B'.count T

/-- Pooling two shared batches. -/
noncomputable def merge (B B' : Batch) : Batch :=
  ⟨B.heights ∪ B'.heights, B.mergeCount B'⟩

@[simp] lemma merge_heights (B B' : Batch) : (B.merge B').heights = B.heights ∪ B'.heights := rfl

/-- **Pooling can only increase a candidate's error.** -/
theorem error_le_merge (B B' : Batch) (p : Candidate) (alpha : ℝ) :
    B.error p alpha ≤ (B.merge B').error p alpha := by
  simp only [Batch.error, totalError, merge_heights]
  have hstep : ∑ T ∈ B.heights, p.errAlpha B.count alpha T
      = ∑ T ∈ B.heights, p.errAlpha (B.merge B').count alpha T := by
    refine Finset.sum_congr rfl fun T hT => ?_
    simp only [Candidate.errAlpha, merge, mergeCount, if_pos hT]
  rw [hstep]
  refine Finset.sum_le_sum_of_subset_of_nonneg Finset.subset_union_left fun T _ _ => ?_
  exact p.errAlpha_nonneg _ _ _

/-- Pooling can only increase a candidate's error, seen from the second batch. Here the two
batches must agree wherever they overlap. -/
theorem error_le_merge_right (B B' : Batch) (p : Candidate) (alpha : ℝ)
    (hagree : ∀ T ∈ B.heights, T ∈ B'.heights → B.count T = B'.count T) :
    B'.error p alpha ≤ (B.merge B').error p alpha := by
  simp only [Batch.error, totalError, merge_heights]
  have hstep : ∑ T ∈ B'.heights, p.errAlpha B'.count alpha T
      = ∑ T ∈ B'.heights, p.errAlpha (B.merge B').count alpha T := by
    refine Finset.sum_congr rfl fun T hT => ?_
    by_cases hB : T ∈ B.heights
    · simp only [Candidate.errAlpha, merge, mergeCount, if_pos hB, hagree T hB hT]
    · simp only [Candidate.errAlpha, merge, mergeCount, if_neg hB]
  rw [hstep]
  refine Finset.sum_le_sum_of_subset_of_nonneg Finset.subset_union_right fun T _ _ => ?_
  exact p.errAlpha_nonneg _ _ _

/-- The errors attainable on a batch. -/
def errors (B : Batch) (alpha : ℝ) : Set ℝ := {e | ∃ p : Candidate, e = B.error p alpha}

lemma errors_nonempty (B : Batch) (alpha : ℝ) : (B.errors alpha).Nonempty :=
  ⟨_, ⟨Candidate.mk 0 0 0 0, rfl⟩⟩

lemma errors_bddBelow (B : Batch) (alpha : ℝ) : BddBelow (B.errors alpha) := by
  refine ⟨0, ?_⟩
  rintro e ⟨p, rfl⟩
  exact B.error_nonneg p alpha

/-- The best error attainable on a batch: the top of the leaderboard. -/
noncomputable def bestError (B : Batch) (alpha : ℝ) : ℝ := sInf (B.errors alpha)

lemma bestError_le (B : Batch) (alpha : ℝ) (p : Candidate) : B.bestError alpha ≤ B.error p alpha :=
  csInf_le (B.errors_bddBelow alpha) ⟨p, rfl⟩

lemma bestError_nonneg (B : Batch) (alpha : ℝ) : 0 ≤ B.bestError alpha := by
  refine le_csInf (B.errors_nonempty alpha) ?_
  rintro e ⟨p, rfl⟩
  exact B.error_nonneg p alpha

/-- **Sharing data is a more demanding test.** The best error attainable on the pooled batch is at
least the best error attainable on either contributor's batch. -/
theorem bestError_le_merge (B B' : Batch) (alpha : ℝ) :
    B.bestError alpha ≤ (B.merge B').bestError alpha := by
  refine le_csInf ((B.merge B').errors_nonempty alpha) ?_
  rintro e ⟨p, rfl⟩
  exact le_trans (B.bestError_le alpha p) (B.error_le_merge B' p alpha)

end Batch

/-! ### Finite data cannot see the leading coefficient -/

/-- The error over a fixed finite set of heights depends continuously on the leading coefficient
of the candidate. -/
lemma continuous_totalError_leading (N : ℝ → ℝ) (alpha : ℝ) (ts : Finset ℝ) (b c d : ℝ) :
    Continuous fun a : ℝ => totalError (Candidate.mk a b c d) N alpha ts := by
  refine continuous_finset_sum _ fun T _ => ?_
  have hev : Continuous fun a : ℝ => (Candidate.mk a b c d).eval T := by
    simp only [Candidate.eval]
    fun_prop
  have hbase : Continuous fun a : ℝ => max 1 |(Candidate.mk a b c d).eval T| :=
    continuous_const.max hev.abs
  have hpos : ∀ a : ℝ, (0 : ℝ) < max 1 |(Candidate.mk a b c d).eval T| ^ alpha := fun a =>
    Real.rpow_pos_of_pos (lt_of_lt_of_le one_pos (le_max_left _ _)) _
  have hden : Continuous fun a : ℝ => max 1 |(Candidate.mk a b c d).eval T| ^ alpha :=
    hbase.rpow_const fun a => Or.inl (lt_of_lt_of_le one_pos (le_max_left _ _)).ne'
  simp only [Candidate.errAlpha]
  exact ((continuous_const.sub hev).abs).div hden fun a => (hpos a).ne'

namespace Batch

/-- **No finite batch separates the admissible candidates from the wrong ones.** Given any
candidate `p` and any tolerance `ε > 0`, some candidate with the *wrong* leading coefficient — so
one that is not asymptotically equivalent to the zero-counting function — scores within `ε` of
`p` on the batch. Pooling more shared batches does not help: the statement holds for every finite
set of heights. -/
theorem exists_inadmissible_error_lt (B : Batch) (alpha : ℝ) (p : Candidate) {ε : ℝ}
    (hε : 0 < ε) : ∃ q : Candidate, ¬ q.Admissible ∧ B.error q alpha < B.error p alpha + ε := by
  set f : ℝ → ℝ := fun a => totalError (Candidate.mk a p.b p.c p.d) B.count alpha B.heights with hf
  have hcont : Continuous f := continuous_totalError_leading B.count alpha B.heights p.b p.c p.d
  have hfp : f p.a = B.error p alpha := by
    simp [hf, Batch.error]
  -- the values of `f` near `p.a` are within `ε` of `f p.a`
  have hball : ∀ᶠ a in 𝓝 p.a, f a < f p.a + ε := by
    have : ContinuousAt f p.a := hcont.continuousAt
    exact this.eventually_lt_const (by linarith)
  obtain ⟨δ, hδ, hsub⟩ := Metric.eventually_nhds_iff.1 hball
  -- two distinct nearby leading coefficients: at least one of them is inadmissible
  have h1 : dist (p.a + δ / 2) p.a < δ := by
    rw [Real.dist_eq]
    simp only [add_sub_cancel_left, abs_of_pos (by linarith : (0:ℝ) < δ / 2)]
    linarith
  have h2 : dist (p.a + δ / 4) p.a < δ := by
    rw [Real.dist_eq]
    simp only [add_sub_cancel_left, abs_of_pos (by linarith : (0:ℝ) < δ / 4)]
    linarith
  have hne : p.a + δ / 2 ≠ p.a + δ / 4 := by intro h; simp at h; linarith
  have hchoice : ¬ (Candidate.mk (p.a + δ / 2) p.b p.c p.d).Admissible ∨
      ¬ (Candidate.mk (p.a + δ / 4) p.b p.c p.d).Admissible := by
    by_contra hcon
    push_neg at hcon
    exact hne (hcon.1.trans hcon.2.symm)
  rcases hchoice with hbad | hbad
  · exact ⟨Candidate.mk (p.a + δ / 2) p.b p.c p.d, hbad, by
      simpa [Batch.error, hfp] using hsub h1⟩
  · exact ⟨Candidate.mk (p.a + δ / 4) p.b p.c p.d, hbad, by
      simpa [Batch.error, hfp] using hsub h2⟩

/-- The errors attainable on a batch by candidates with the wrong leading coefficient. -/
def inadmissibleErrors (B : Batch) (alpha : ℝ) : Set ℝ :=
  {e | ∃ p : Candidate, ¬ p.Admissible ∧ e = B.error p alpha}

/-- **The leaderboard cannot be used as evidence.** The best score attainable on a shared batch by
an asymptotically *wrong* candidate is exactly the best score attainable at all. -/
theorem bestError_eq_bestError_inadmissible (B : Batch) (alpha : ℝ) :
    sInf (B.inadmissibleErrors alpha) = B.bestError alpha := by
  have hbdd : BddBelow (B.inadmissibleErrors alpha) := by
    refine ⟨0, ?_⟩
    rintro e ⟨p, -, rfl⟩
    exact B.error_nonneg p alpha
  have hne : (B.inadmissibleErrors alpha).Nonempty := by
    obtain ⟨q, hq, -⟩ := B.exists_inadmissible_error_lt alpha (Candidate.mk 0 0 0 0) one_pos
    exact ⟨_, ⟨q, hq, rfl⟩⟩
  refine le_antisymm ?_ ?_
  · -- every score is matched to arbitrary precision by an inadmissible candidate
    refine le_csInf (B.errors_nonempty alpha) ?_
    rintro e ⟨p, rfl⟩
    refine le_of_forall_pos_le_add fun ε hε => ?_
    obtain ⟨q, hq, hlt⟩ := B.exists_inadmissible_error_lt alpha p hε
    exact le_trans (csInf_le hbdd ⟨q, hq, rfl⟩) hlt.le
  · refine le_csInf hne ?_
    rintro e ⟨p, -, rfl⟩
    exact B.bestError_le alpha p

end Batch

/-! ### What does decide, and why it produces nothing new -/

/-- **The criterion that decides needs unboundedly many heights.** Assuming the Riemann–von
Mangoldt input, a candidate's error against the zero count is `o(T log T)` exactly when its
leading coefficient is `1/2π`. No finite batch can test this hypothesis, and every candidate that
passes it is asymptotically equivalent to the main term. -/
theorem isLittleO_iff_admissible (h : RiemannVonMangoldt) (p : Candidate) :
    (fun T : ℝ => (zeroCount T : ℝ) - p.eval T) =o[atTop] (fun T : ℝ => T * Real.log T) ↔
      p.Admissible := by
  have hscale : (fun T : ℝ => T * Real.log T) = fun T : ℝ => (2 * Real.pi) * rvmMain T := by
    funext T
    have hpi : (2 : ℝ) * Real.pi ≠ 0 := by positivity
    simp only [rvmMain]
    field_simp
  have hpi : (2 : ℝ) * Real.pi ≠ 0 := by positivity
  rw [hscale, Asymptotics.isLittleO_const_mul_right_iff hpi]
  constructor
  · intro ho
    by_contra hbad
    refine not_tendsto_errRel_zero h p hbad ?_
    have := ho.tendsto_div_nhds_zero
    exact this.congr fun T => rfl
  · intro hp
    have hEq : Asymptotics.IsEquivalent atTop (fun T : ℝ => (zeroCount T : ℝ)) p.eval :=
      isEquivalent_iff_admissible h p |>.2 hp
    have hrvm : Asymptotics.IsEquivalent atTop p.eval rvmMain :=
      (eval_isEquivalent_rvmMain_iff p).2 hp
    exact (Asymptotics.IsEquivalent.isLittleO hEq).trans_isBigO hrvm.isBigO

/-- **A candidate that passes is nothing new.** Any two admissible candidates are asymptotically
equivalent; in particular every candidate a shared leaderboard could legitimately nominate is
asymptotically equivalent to the main term `(T/2π) log T` that the Riemann–von Mangoldt
hypothesis already supplies. Combined with `Batch.bestError_eq_bestError_inadmissible`, this is
the precise sense in which pooled batches produce no interesting candidate: the ones finite data
cannot rule out are wrong, and the ones that are right say nothing new. -/
theorem admissible_eval_isEquivalent {p q : Candidate} (hp : p.Admissible) (hq : q.Admissible) :
    Asymptotics.IsEquivalent atTop p.eval q.eval :=
  ((eval_isEquivalent_rvmMain_iff p).2 hp).trans ((eval_isEquivalent_rvmMain_iff q).2 hq).symm

/-- The dichotomy in one statement: assuming the Riemann–von Mangoldt input, every candidate is
either asymptotically equivalent to the assumed main term — hence carries no new information —
or has relative error bounded away from zero, in which case no amount of shared finite data can
detect the difference (`Batch.exists_inadmissible_error_lt`). -/
theorem candidate_dichotomy (h : RiemannVonMangoldt) (p : Candidate) :
    Asymptotics.IsEquivalent atTop p.eval rvmMain ∨
      ¬ Tendsto (p.errRel (fun T => (zeroCount T : ℝ))) atTop (𝓝 0) := by
  by_cases hp : p.Admissible
  · exact Or.inl ((eval_isEquivalent_rvmMain_iff p).2 hp)
  · exact Or.inr (not_tendsto_errRel_zero h p hp)

end ZetaZeros.Experiments
