/-
  GovernanceProperties.lean — general form of the weighted-vote resolution rules
  in `lean4/Governance.lean`, plus two observations about the rule itself.

  Upstream proves eleven concrete instances of `resolve` (unanimous yes, unanimous
  no, ties, and six DAO scenarios) and one genuinely general statement,
  `no_contradiction`, which is automatic because `resolve` is a function.
  `quorumMet` is defined but never related to `resolve`.

  Here `resolve` is characterised completely, `quorumMet` is shown to be exactly
  its quorum test, and two consequences of the rule are recorded:
  abstentions are not neutral (they supply quorum), and the quorum test is
  "at least a third", not the "> 33%" stated in the header.
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Upstream.Governance

namespace Review.Governance

/-! ### `resolve`, completely characterised -/

theorem resolve_noQuorum_iff (t : Tally) (q : QuorumRule) :
    resolve t q = .noQuorum ↔ quorumMet t q = false := by
  unfold resolve quorumMet
  simp only [ge_iff_le, decide_eq_false_iff_not]
  split_ifs with h1 h2 <;> simp <;> omega

theorem resolve_passed_iff (t : Tally) (q : QuorumRule) :
    resolve t q = .passed ↔ quorumMet t q = true ∧ t.weightNo < t.weightYes := by
  unfold resolve quorumMet
  simp only [ge_iff_le, decide_eq_true_eq]
  split_ifs with h1 h2 <;> simp <;> omega

theorem resolve_failed_iff (t : Tally) (q : QuorumRule) :
    resolve t q = .failed ↔ quorumMet t q = true ∧ t.weightYes ≤ t.weightNo := by
  unfold resolve quorumMet
  simp only [ge_iff_le, decide_eq_true_eq]
  split_ifs with h1 h2 <;> simp <;> omega

/-- A tie always fails: a strict majority of weight is required. -/
theorem tie_fails (t : Tally) (q : QuorumRule) (h : t.weightYes = t.weightNo)
    (hq : quorumMet t q = true) : resolve t q = .failed := by
  rw [resolve_failed_iff]
  exact ⟨hq, le_of_eq h⟩

/-- More yes-weight, everything else fixed, never turns a pass into a non-pass. -/
theorem passed_mono (y y' n a e : Nat) (q : QuorumRule) (h : y ≤ y')
    (hp : resolve ⟨y, n, a, e⟩ q = .passed) : resolve ⟨y', n, a, e⟩ q = .passed := by
  rw [resolve_passed_iff] at hp ⊢
  simp only [quorumMet] at hp ⊢
  refine ⟨?_, by omega⟩
  have := hp.1
  simp only [ge_iff_le, decide_eq_true_eq] at this ⊢
  have : (y + n + a) * q.denominator ≤ (y' + n + a) * q.denominator :=
    Nat.mul_le_mul_right _ (by omega)
  omega

/-! ### Abstaining is not neutral

    `quorumMet` counts abstentions as participation, so an abstention can turn a
    proposal that would have failed for lack of quorum into a passed one. -/

theorem abstentions_supply_quorum :
    resolve ⟨1, 0, 0, 10⟩ defaultQuorum = .noQuorum ∧
    resolve ⟨1, 0, 3, 10⟩ defaultQuorum = .passed := by decide

/-! ### The quorum threshold is "≥ 1/3", not "> 33%"

    The module header says quorum is "(>33% of total weight)", but `quorumMet`
    tests `participated * 3 ≥ total`, which is satisfied at exactly one third. -/

theorem quorum_met_at_exactly_one_third (t : Tally)
    (h : (t.weightYes + t.weightNo + t.weightAbstain) * 3 = t.totalEligible) :
    quorumMet t defaultQuorum = true := by
  simp [quorumMet, defaultQuorum, h]

theorem quorum_at_exactly_one_third_example :
    quorumMet ⟨1, 0, 0, 3⟩ defaultQuorum = true := by decide

/-! ### One advertised claim does not match the proved theorem

    `governanceMain` prints "One less: 1639 vs 1638 → failed", but the theorem next
    to it, `minimum_coalition_minus_one`, is about the tie 1639 vs 1639.  The
    printed tally in fact passes. -/

theorem printed_1639_vs_1638_actually_passes :
    resolve ⟨1639, 1638, 0, daoWeight⟩ defaultQuorum = .passed := by decide

/-! ### Tier weights -/

theorem weight_le_diamond (t : Tier) : t.weight ≤ 8 := by
  cases t <;> simp [Tier.weight]

theorem weight_pos' (t : Tier) : 0 < t.weight := by
  cases t <;> simp [Tier.weight]

/-- `fib3` and `fib4` are given the same weight, so the weight function is not
    injective and the tier ladder is not strictly decreasing. -/
theorem weight_not_injective : Tier.fib3.weight = Tier.fib4.weight ∧ Tier.fib3 ≠ Tier.fib4 := by
  refine ⟨rfl, by decide⟩

end Review.Governance
