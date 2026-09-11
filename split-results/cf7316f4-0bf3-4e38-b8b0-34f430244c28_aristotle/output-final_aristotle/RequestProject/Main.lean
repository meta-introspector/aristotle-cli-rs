/-
# Senate Parliamentary Reference Sources — Main Module

Ties together the formal model components and proves cross-cutting theorems
about the Senate procedural system described in the CRS report RL30788.
-/

import RequestProject.Basic
import RequestProject.Recognition
import RequestProject.Voting
import RequestProject.SenateManual
import RequestProject.UCagreements
import RequestProject.Enforcement
import RequestProject.Committees
import RequestProject.RulemakingStatutes
import RequestProject.Riddick

/-! ## Cross-Cutting Theorems

These theorems relate concepts across multiple modules and capture
the report's key structural insights about the Senate procedural system.
-/

open ProceduralSource PrecedentOrigin SenateAction VoteThreshold

/-! ### The Nine Sources of Senate Procedure

The report enumerates exactly 9 sources of Senate procedural authority.
(See "Multiple Sources of Senate Procedure") -/

/-- There are exactly 9 sources of Senate procedural authority. -/
theorem nine_procedural_sources :
    Fintype.card ProceduralSource = 9 := by
  decide

/-! ### Floor Enforceability Partition

The 9 sources are partitioned into 6 floor-enforceable and 3 non-enforceable. -/

/-- Exactly 6 of the 9 sources are enforceable on the Senate floor. -/
theorem six_floor_enforceable :
    (Finset.univ.filter (fun s : ProceduralSource => s.floorEnforceable)).card = 6 := by
  decide

/-- Exactly 3 of the 9 sources are NOT enforceable on the Senate floor. -/
theorem three_not_floor_enforceable :
    (Finset.univ.filter (fun s : ProceduralSource => ¬s.floorEnforceable)).card = 3 := by
  decide

/-- The enforceable and non-enforceable sources partition all 9 sources. -/
theorem enforceability_partition :
    (Finset.univ.filter (fun s : ProceduralSource => s.floorEnforceable)).card +
    (Finset.univ.filter (fun s : ProceduralSource => ¬s.floorEnforceable)).card =
    Fintype.card ProceduralSource := by
  decide

/-! ### Rulemaking Authority Sources

"Standing orders and rulemaking provisions of law have the same authority and
effect as the Senate's standing rules, because all are created through an exercise
of the Senate's constitutional rulemaking authority." -/

/-- There are exactly 4 sources deriving from rulemaking authority. -/
theorem four_rulemaking_sources :
    (Finset.univ.filter (fun s : ProceduralSource => s.fromRulemakingAuthority)).card = 4 := by
  decide

/-- All rulemaking sources are also floor-enforceable (they have the authority
    of standing rules). -/
theorem all_rulemaking_floor_enforceable :
    ∀ s : ProceduralSource, s.fromRulemakingAuthority → s.floorEnforceable := by
  intro s
  exact rulemaking_implies_floor_enforceable s

/-! ### The Asymmetry of Rules Changes

A deep structural insight from the report: while a simple majority can adopt
a rules change, a two-thirds supermajority is needed to invoke cloture on the
proposal to do so. This creates a fundamental asymmetry. -/

/-- The threshold gap: the cloture threshold on rules is strictly harder than
    the adoption threshold for the same rules change. -/
theorem rules_change_asymmetry :
    adoptRulesChange.requiredThreshold ≠ invokeClotureOnRules.requiredThreshold := by
  simp [SenateAction.requiredThreshold]

/-- Moreover, the cloture threshold on rules changes is strictly harder than
    the general cloture threshold. -/
theorem rules_cloture_harder :
    invokeClotureGeneral.requiredThreshold.strictness <
    invokeClotureOnRules.requiredThreshold.strictness :=
  cloture_on_rules_harder_than_general

/-! ### Precedent Weight is Well-Ordered

The report establishes a strict total order on precedent weight. -/

/-- The precedent weight function is injective (distinct origins have distinct weights). -/
theorem precedent_weight_injective :
    Function.Injective PrecedentOrigin.weight := by
  intro a b hab
  cases a <;> cases b <;> simp_all [PrecedentOrigin.weight]

/-- The weight ordering is strict and total. -/
theorem precedent_weight_strict_total (a b : PrecedentOrigin) (h : a ≠ b) :
    a.weight < b.weight ∨ b.weight < a.weight := by
  cases a <;> cases b <;> simp_all [PrecedentOrigin.weight]

/-! ### Continuing Body Arithmetic

The continuing body principle relies on the arithmetic fact that 2/3 > 1/2.
This ensures a quorum persists across Congresses. -/

/-- At least 66 Senators continue across any Congress transition.
    (Two-thirds of 100 seats are not up for election.) -/
theorem continuing_senators_at_least_66 :
    2 * totalSenateSeats / 3 ≥ 66 := by
  simp [totalSenateSeats]

/-- The continuing Senators (66+) exceed the quorum requirement (51). -/
theorem continuing_exceeds_quorum :
    2 * totalSenateSeats / 3 ≥ quorumRequired := by
  simp [totalSenateSeats, quorumRequired]

/-! ### The Hierarchy of Vote Thresholds

The report implies a strict ordering of vote thresholds:
simple majority < 3/5 sworn < 2/3 present and voting < unanimous consent -/

/-- The strictness ordering is strict and total on all four thresholds. -/
theorem threshold_strict_order :
    simpleMajority.strictness < threeFifthsSworn.strictness ∧
    threeFifthsSworn.strictness < twoThirdsPresentAndVoting.strictness ∧
    twoThirdsPresentAndVoting.strictness < unanimousConsent.strictness := by
  simp [VoteThreshold.strictness]

/-- The strictness function is injective. -/
theorem threshold_strictness_injective :
    Function.Injective VoteThreshold.strictness := by
  intro a b hab
  cases a <;> cases b <;> simp_all [VoteThreshold.strictness]

/-! ### Summary Statistics -/

/-- The Senate Manual contains 7 components, and the Senate has 44 standing rules
    (118th Congress). Together these form the core reference framework. -/
theorem manual_and_rules_summary :
    Fintype.card ManualComponent = 7 ∧ numStandingRules118th = 44 := by
  exact ⟨manual_has_seven_components, num_standing_rules⟩

/-- Riddick's covers 110 years of precedents, the Manual allocates 79 sections
    to standing orders, and there are exactly 3 categories of rulemaking statutes. -/
theorem reference_sources_summary :
    riddickCoverageEnd - riddickCoverageStart + 1 = 110 ∧
    Finset.card (Finset.Icc 60 138) = 79 ∧
    Fintype.card RulemakingCategory = 3 := by
  refine ⟨riddick_coverage_span, standing_order_sections_count, three_rulemaking_categories⟩

