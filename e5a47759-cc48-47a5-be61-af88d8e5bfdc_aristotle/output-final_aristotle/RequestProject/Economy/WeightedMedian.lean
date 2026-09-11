/-
# Weighted median settlement

The settlement operator is stated as a *predicate*: `IsWeightedMedian obs m`
holds of every weighted median, and the robustness theorems are proved for
every `m` satisfying it, so nothing depends on a tie-breaking convention.

Three results:

* `median_mem_range` — if the honest observations lie in `[lo, hi]` and the
  adversarial weight is strictly below half of the total weight, then every
  weighted median lies in `[lo, hi]`;
* `median_eq_of_weight_majority` — a weight majority reporting one value forces
  that value;
* `mean_influence_unbounded` — a single positive-weight observation moves the
  weighted *mean* to any target whatsoever, however small its weight.  This is
  why the mean is not the default settlement operator.

The hypothesis in the first result is on *half the total weight*, not merely
"adversary weighs less than honest": with abstentions or zero-weight
participants those are different statements.
-/
import RequestProject.Economy.Intervals

namespace RequestProject.Economy

/-- One weighted observation.  The weight is the protocol's stake × reputation
score; nothing here depends on how it was computed. -/
structure Obs where
  weight : ℚ
  value : ℚ
deriving Repr, DecidableEq

namespace Obs

/-- All weights are nonnegative. -/
def WeightsNonneg (os : List Obs) : Prop := ∀ o ∈ os, 0 ≤ o.weight

def totalWeight (os : List Obs) : ℚ := (os.map Obs.weight).sum

/-- Total weight of the observations reporting at most `m`. -/
def weightAtMost (os : List Obs) (m : ℚ) : ℚ :=
  ((os.filter (fun o => decide (o.value ≤ m))).map Obs.weight).sum

/-- Total weight of the observations reporting at least `m`. -/
def weightAtLeast (os : List Obs) (m : ℚ) : ℚ :=
  ((os.filter (fun o => decide (m ≤ o.value))).map Obs.weight).sum

/-- Total weight of the observations reporting exactly `v`. -/
def weightEq (os : List Obs) (v : ℚ) : ℚ :=
  ((os.filter (fun o => decide (o.value = v))).map Obs.weight).sum

/-- `m` is a weighted median: at least half the weight is at most `m`, and at
least half is at least `m`. -/
def IsWeightedMedian (os : List Obs) (m : ℚ) : Prop :=
  totalWeight os ≤ 2 * weightAtMost os m ∧ totalWeight os ≤ 2 * weightAtLeast os m

instance (os : List Obs) (m : ℚ) : Decidable (IsWeightedMedian os m) := by
  unfold IsWeightedMedian; infer_instance

@[simp] theorem totalWeight_nil : totalWeight [] = 0 := rfl

@[simp] theorem totalWeight_cons (o : Obs) (os : List Obs) :
    totalWeight (o :: os) = o.weight + totalWeight os := by simp [totalWeight]

theorem totalWeight_append (os ps : List Obs) :
    totalWeight (os ++ ps) = totalWeight os + totalWeight ps := by
  simp [totalWeight]

theorem totalWeight_nonneg {os : List Obs} (h : WeightsNonneg os) : 0 ≤ totalWeight os := by
  induction os with
  | nil => simp
  | cons o t ih =>
      have h1 : 0 ≤ o.weight := h o (List.mem_cons_self ..)
      have h2 : 0 ≤ totalWeight t := ih fun x hx => h x (List.mem_cons_of_mem _ hx)
      simp only [totalWeight_cons]
      linarith

/-- A filtered subtotal never exceeds the total, when weights are nonnegative. -/
theorem filter_weight_le_total {os : List Obs} (h : WeightsNonneg os)
    (P : Obs → Bool) : ((os.filter P).map Obs.weight).sum ≤ totalWeight os := by
  induction os with
  | nil => simp
  | cons o t ih =>
      have h1 : 0 ≤ o.weight := h o (List.mem_cons_self ..)
      have ih' := ih fun x hx => h x (List.mem_cons_of_mem _ hx)
      by_cases hp : P o = true
      · rw [List.filter_cons_of_pos hp]
        simp only [List.map_cons, List.sum_cons, totalWeight_cons]
        linarith
      · rw [List.filter_cons_of_neg (by simpa using hp)]
        simp only [totalWeight_cons]
        linarith

theorem weightAtLeast_nonneg {os : List Obs} (h : WeightsNonneg os) (m : ℚ) :
    0 ≤ weightAtLeast os m := by
  induction os with
  | nil => simp [weightAtLeast]
  | cons o t ih =>
      have h1 : 0 ≤ o.weight := h o (List.mem_cons_self ..)
      have ih' := ih fun x hx => h x (List.mem_cons_of_mem _ hx)
      by_cases hp : m ≤ o.value <;>
        simp only [weightAtLeast, List.filter_cons, decide_eq_true_eq, hp, if_true, if_false,
          List.map_cons, List.sum_cons] at * <;> linarith

theorem weightAtMost_nonneg {os : List Obs} (h : WeightsNonneg os) (m : ℚ) :
    0 ≤ weightAtMost os m := by
  induction os with
  | nil => simp [weightAtMost]
  | cons o t ih =>
      have h1 : 0 ≤ o.weight := h o (List.mem_cons_self ..)
      have ih' := ih fun x hx => h x (List.mem_cons_of_mem _ hx)
      by_cases hp : o.value ≤ m <;>
        simp only [weightAtMost, List.filter_cons, decide_eq_true_eq, hp, if_true, if_false,
          List.map_cons, List.sum_cons] at * <;> linarith

theorem weightAtLeast_append (os ps : List Obs) (m : ℚ) :
    weightAtLeast (os ++ ps) m = weightAtLeast os m + weightAtLeast ps m := by
  simp [weightAtLeast, List.filter_append]

theorem weightAtMost_append (os ps : List Obs) (m : ℚ) :
    weightAtMost (os ++ ps) m = weightAtMost os m + weightAtMost ps m := by
  simp [weightAtMost, List.filter_append]

/-- Observations that all report strictly below `m` contribute nothing at or
above `m`. -/
theorem weightAtLeast_eq_zero {os : List Obs} {m : ℚ} (h : ∀ o ∈ os, o.value < m) :
    weightAtLeast os m = 0 := by
  have : os.filter (fun o => decide (m ≤ o.value)) = [] := by
    rw [List.filter_eq_nil_iff]
    intro o ho
    simp only [decide_eq_true_eq, not_le]
    exact h o ho
  simp [weightAtLeast, this]

theorem weightAtMost_eq_zero {os : List Obs} {m : ℚ} (h : ∀ o ∈ os, m < o.value) :
    weightAtMost os m = 0 := by
  have : os.filter (fun o => decide (o.value ≤ m)) = [] := by
    rw [List.filter_eq_nil_iff]
    intro o ho
    simp only [decide_eq_true_eq, not_le]
    exact h o ho
  simp [weightAtMost, this]

/-- **Range preservation.** If the honest observations all report values in
`[lo, hi]`, and the adversarial weight is strictly less than half the total,
then every weighted median of the combined list lies in `[lo, hi]`. -/
theorem median_mem_range {honest adv : List Obs} {lo hi m : ℚ}
    (hnn : WeightsNonneg (honest ++ adv))
    (hrange : ∀ o ∈ honest, lo ≤ o.value ∧ o.value ≤ hi)
    (hadv : 2 * totalWeight adv < totalWeight (honest ++ adv))
    (hmed : IsWeightedMedian (honest ++ adv) m) : lo ≤ m ∧ m ≤ hi := by
  have hnnH : WeightsNonneg honest := fun o ho => hnn o (List.mem_append_left _ ho)
  have hnnA : WeightsNonneg adv := fun o ho => hnn o (List.mem_append_right _ ho)
  obtain ⟨hlow, hhigh⟩ := hmed
  constructor
  · -- if `m < lo`, no honest observation is at most `m`
    by_contra hc
    push_neg at hc
    have hzero : weightAtMost honest m = 0 :=
      weightAtMost_eq_zero fun o ho => lt_of_lt_of_le hc (hrange o ho).1
    have hle : weightAtMost adv m ≤ totalWeight adv := filter_weight_le_total hnnA _
    rw [weightAtMost_append, hzero, zero_add] at hlow
    linarith
  · by_contra hc
    push_neg at hc
    have hzero : weightAtLeast honest m = 0 :=
      weightAtLeast_eq_zero fun o ho => lt_of_le_of_lt (hrange o ho).2 hc
    have hle : weightAtLeast adv m ≤ totalWeight adv := filter_weight_le_total hnnA _
    rw [weightAtLeast_append, hzero, zero_add] at hhigh
    linarith

/-- Observations reporting exactly `v` and observations reporting at least
`m > v` are disjoint, so their weights add to at most the total. -/
theorem weightAtLeast_add_weightEq_le {os : List Obs} (hnn : WeightsNonneg os) {v m : ℚ}
    (hvm : v < m) : weightAtLeast os m + weightEq os v ≤ totalWeight os := by
  induction os with
  | nil => simp [weightAtLeast, weightEq]
  | cons o t ih =>
      have h1 : 0 ≤ o.weight := hnn o (List.mem_cons_self ..)
      have ih' := ih fun x hx => hnn x (List.mem_cons_of_mem _ hx)
      by_cases hge : m ≤ o.value
      · have hne : ¬ (o.value = v) := by intro hv; rw [hv] at hge; linarith
        have e1 : weightAtLeast (o :: t) m = o.weight + weightAtLeast t m := by
          simp [weightAtLeast, hge]
        have e2 : weightEq (o :: t) v = weightEq t v := by
          simp [weightEq, hne]
        rw [e1, e2, totalWeight_cons]; linarith
      · have e1 : weightAtLeast (o :: t) m = weightAtLeast t m := by
          simp [weightAtLeast, hge]
        by_cases heq : o.value = v
        · have e2 : weightEq (o :: t) v = o.weight + weightEq t v := by
            simp [weightEq, heq]
          rw [e1, e2, totalWeight_cons]; linarith
        · have e2 : weightEq (o :: t) v = weightEq t v := by
            simp [weightEq, heq]
          rw [e1, e2, totalWeight_cons]; linarith

theorem weightAtMost_add_weightEq_le {os : List Obs} (hnn : WeightsNonneg os) {v m : ℚ}
    (hmv : m < v) : weightAtMost os m + weightEq os v ≤ totalWeight os := by
  induction os with
  | nil => simp [weightAtMost, weightEq]
  | cons o t ih =>
      have h1 : 0 ≤ o.weight := hnn o (List.mem_cons_self ..)
      have ih' := ih fun x hx => hnn x (List.mem_cons_of_mem _ hx)
      by_cases hle : o.value ≤ m
      · have hne : ¬ (o.value = v) := by intro hv; rw [hv] at hle; linarith
        have e1 : weightAtMost (o :: t) m = o.weight + weightAtMost t m := by
          simp [weightAtMost, hle]
        have e2 : weightEq (o :: t) v = weightEq t v := by
          simp [weightEq, hne]
        rw [e1, e2, totalWeight_cons]; linarith
      · have e1 : weightAtMost (o :: t) m = weightAtMost t m := by
          simp [weightAtMost, hle]
        by_cases heq : o.value = v
        · have e2 : weightEq (o :: t) v = o.weight + weightEq t v := by
            simp [weightEq, heq]
          rw [e1, e2, totalWeight_cons]; linarith
        · have e2 : weightEq (o :: t) v = weightEq t v := by
            simp [weightEq, heq]
          rw [e1, e2, totalWeight_cons]; linarith

/-- **Majority determination.** If a strict weight majority reports the same
value `v`, then `v` is the only weighted median. -/
theorem median_eq_of_weight_majority {os : List Obs} {v m : ℚ} (hnn : WeightsNonneg os)
    (hmaj : totalWeight os < 2 * weightEq os v) (hmed : IsWeightedMedian os m) : m = v := by
  obtain ⟨hlow, hhigh⟩ := hmed
  rcases lt_trichotomy m v with h | h | h
  · exfalso
    have := weightAtMost_add_weightEq_le hnn h
    linarith
  · exact h
  · exfalso
    have := weightAtLeast_add_weightEq_le hnn h
    linarith

/-! ### Why not the mean -/

/-- The weighted mean.  `0` for an empty or zero-weight list. -/
def weightedMean (os : List Obs) : ℚ :=
  let w := totalWeight os
  if w = 0 then 0 else ((os.map (fun o => o.weight * o.value)).sum) / w

/-- **Unbounded influence of the mean.** However large the honest weight `W`
and however concentrated the honest reports, one extra observation of weight
`1` moves the weighted mean to any target. -/
theorem mean_influence_unbounded (W t : ℚ) (hW : 0 < W) :
    ∃ y : ℚ, weightedMean [⟨W, 0⟩, ⟨1, y⟩] = t := by
  refine ⟨t * (W + 1), ?_⟩
  have hw : totalWeight [⟨W, 0⟩, ⟨1, t * (W + 1)⟩] = W + 1 := by
    simp [totalWeight]
  have hne : W + 1 ≠ 0 := by linarith
  simp only [weightedMean, hw, hne, if_false, List.map_cons, List.map_nil, List.sum_cons,
    List.sum_nil]
  rw [div_eq_iff hne]
  ring

/-- …while the weighted median of the same list is pinned to the honest value.
Concretely: a thousand honest reports of `0` and one adversarial report of a
million settle at `0`, where the mean settles near `999`. -/
theorem median_resists_outlier :
    IsWeightedMedian [⟨1000, 0⟩, ⟨1, 1000000⟩] 0 := by
  constructor <;>
    simp [totalWeight, weightAtMost, weightAtLeast] <;> norm_num

theorem mean_does_not_resist_outlier :
    weightedMean [⟨1000, 0⟩, ⟨1, 1000000⟩] = 1000000 / 1001 := by
  simp [weightedMean, totalWeight]
  norm_num

/-! ### Settlement

The network proposes a settled value; the protocol *checks* it.  A settlement
requires a minimum total weight and a minimum number of confirmations;
otherwise the contractual fallback applies.  Nothing here establishes that the
settled value is physically correct.
-/

structure SettlementRule where
  minWeight : ℚ
  minCount : Nat
  fallback : ℚ

inductive SettlementOutcome where
  | settled (value : ℚ)
  | fellBack (value : ℚ) (reason : String)
deriving Repr, DecidableEq

/-- Check a proposed settlement value against the rule and the observations. -/
def settle (rule : SettlementRule) (os : List Obs) (proposed : ℚ) : SettlementOutcome :=
  if os.length < rule.minCount then
    SettlementOutcome.fellBack rule.fallback "insufficient confirmations"
  else if totalWeight os < rule.minWeight then
    SettlementOutcome.fellBack rule.fallback "insufficient weight"
  else if IsWeightedMedian os proposed then
    SettlementOutcome.settled proposed
  else
    SettlementOutcome.fellBack rule.fallback "proposed value is not a weighted median"

/-- **Settlement soundness.** A settled value really is a weighted median of
the observations, and the thresholds really were met — so the robustness
theorems above apply to it. -/
theorem settle_sound {rule : SettlementRule} {os : List Obs} {proposed value : ℚ}
    (h : settle rule os proposed = SettlementOutcome.settled value) :
    value = proposed ∧ IsWeightedMedian os proposed ∧
      rule.minCount ≤ os.length ∧ rule.minWeight ≤ totalWeight os := by
  unfold settle at h
  by_cases h1 : os.length < rule.minCount
  · rw [if_pos h1] at h; exact absurd h (by simp)
  · rw [if_neg h1] at h
    by_cases h2 : totalWeight os < rule.minWeight
    · rw [if_pos h2] at h; exact absurd h (by simp)
    · rw [if_neg h2] at h
      by_cases h3 : IsWeightedMedian os proposed
      · rw [if_pos h3] at h
        simp only [SettlementOutcome.settled.injEq] at h
        exact ⟨h.symm, h3, by omega, by linarith [not_lt.mp h2]⟩
      · rw [if_neg h3] at h; exact absurd h (by simp)

/-- A fallback is never silently a settlement. -/
theorem settle_fallback {rule : SettlementRule} {os : List Obs} {proposed : ℚ}
    (h : ¬ IsWeightedMedian os proposed) :
    ∃ reason, settle rule os proposed = SettlementOutcome.fellBack rule.fallback reason := by
  unfold settle
  by_cases h1 : os.length < rule.minCount
  · rw [if_pos h1]; exact ⟨_, rfl⟩
  · rw [if_neg h1]
    by_cases h2 : totalWeight os < rule.minWeight
    · rw [if_pos h2]; exact ⟨_, rfl⟩
    · rw [if_neg h2, if_neg h]; exact ⟨_, rfl⟩

end Obs

end RequestProject.Economy
