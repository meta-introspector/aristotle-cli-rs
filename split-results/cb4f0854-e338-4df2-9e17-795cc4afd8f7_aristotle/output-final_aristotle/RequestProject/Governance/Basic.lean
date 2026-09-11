/-
# Senate Parliamentary Reference Sources — Formal Model

A Lean 4 formalization of the key structural and procedural concepts described in
the Congressional Research Service report "Parliamentary Reference Sources: Senate"
(RL30788, updated November 17, 2023).

This module defines the basic types and structures modeling Senate procedural
authorities, their hierarchy, and enforcement mechanisms.
-/

import Mathlib

/-! ## Procedural Authority Sources

The Senate's procedures derive from multiple sources (Introduction, "Multiple Sources
of Senate Procedure"). We enumerate them here.
-/

/-- The different sources of Senate procedural authority, as enumerated in the report.
    See "Multiple Sources of Senate Procedure". -/
inductive ProceduralSource where
  | constitution        -- Requirements imposed by the U.S. Constitution
  | standingRule        -- Standing Rules of the Senate (44 rules as of 118th Congress)
  | standingOrder       -- Permanent standing orders (Senate Manual §§60-138)
  | rulemakingStatute   -- Statutory provisions establishing procedural requirements
  | precedent           -- Published precedents of the Senate
  | unanimousConsent    -- Unanimous consent agreements
  | committeeRule       -- Rules of procedure adopted by each standing committee
  | partyConferenceRule -- Rules of Senate party conferences
  | informalPractice    -- Informal practices adhered to by custom
  deriving DecidableEq, Repr, Fintype

open ProceduralSource

/-! ## Floor Enforceability

A key distinction in the report is between authorities that are enforceable on the
Senate floor (via points of order) and those that are not. See "Enforcing Senate
Rules and Precedents" and "Rules of Senate Party Conferences".
-/

/-- Whether a procedural source is enforceable on the Senate floor via points of order.

From the report:
- Standing rules, standing orders, constitutional provisions, rulemaking statutes,
  UC agreements, and precedents are enforceable on the floor.
- Committee rules are enforced only within committees ("no point of order pertaining
  to committee rules can be raised on the Senate floor").
- Party conference rules "cannot be enforced on the Senate floor."
- Informal practices "are not enforceable on the Senate floor." -/
def ProceduralSource.floorEnforceable : ProceduralSource → Prop
  | constitution        => True
  | standingRule        => True
  | standingOrder       => True
  | rulemakingStatute   => True
  | precedent           => True
  | unanimousConsent    => True
  | committeeRule       => False
  | partyConferenceRule => False
  | informalPractice    => False

instance (s : ProceduralSource) : Decidable s.floorEnforceable := by
  cases s <;> simp [ProceduralSource.floorEnforceable] <;> infer_instance

/-- Committee rules are not enforceable on the Senate floor.
    "Committees are responsible for enforcing their own rules, and no point of order
    pertaining to committee rules can be raised on the Senate floor." -/
theorem committeeRule_not_floor_enforceable :
    ¬ ProceduralSource.committeeRule.floorEnforceable := by
  simp [ProceduralSource.floorEnforceable]

/-- Party conference rules are not enforceable on the Senate floor.
    "The rules of the conferences of the two parties in the Senate are not adopted by
    the Senate itself, and accordingly, they cannot be enforced on the Senate floor." -/
theorem partyConferenceRule_not_floor_enforceable :
    ¬ ProceduralSource.partyConferenceRule.floorEnforceable := by
  simp [ProceduralSource.floorEnforceable]

/-- Informal practices are not enforceable on the Senate floor.
    "Although these unofficial practices cannot be enforced on the Senate floor,
    many of them are well established and customarily followed." -/
theorem informalPractice_not_floor_enforceable :
    ¬ ProceduralSource.informalPractice.floorEnforceable := by
  simp [ProceduralSource.floorEnforceable]

/-- Standing rules are enforceable on the floor. -/
theorem standingRule_floor_enforceable :
    ProceduralSource.standingRule.floorEnforceable := by
  simp [ProceduralSource.floorEnforceable]

/-- The Constitution is enforceable on the floor. -/
theorem constitution_floor_enforceable :
    ProceduralSource.constitution.floorEnforceable := by
  simp [ProceduralSource.floorEnforceable]

/-! ## Equal Authority of Certain Sources

The report states that standing orders and rulemaking statutes "have the same
authority and effect as the Senate's standing rules, because all are created through
an exercise of the Senate's constitutional rulemaking authority."
(See "Constitutional Rulemaking Authority of the Senate")
-/

/-- Sources created through the Senate's constitutional rulemaking authority.
    These all have equal procedural authority on the floor. -/
def ProceduralSource.fromRulemakingAuthority : ProceduralSource → Prop
  | standingRule      => True
  | standingOrder     => True
  | rulemakingStatute => True
  | unanimousConsent  => True
  | _                 => False

instance (s : ProceduralSource) : Decidable s.fromRulemakingAuthority := by
  cases s <;> simp [ProceduralSource.fromRulemakingAuthority] <;> infer_instance

/-- Standing orders derive from the Senate's rulemaking authority. -/
theorem standingOrder_from_rulemaking :
    ProceduralSource.standingOrder.fromRulemakingAuthority := by
  simp [ProceduralSource.fromRulemakingAuthority]

/-- Rulemaking statutes derive from the Senate's rulemaking authority. -/
theorem rulemakingStatute_from_rulemaking :
    ProceduralSource.rulemakingStatute.fromRulemakingAuthority := by
  simp [ProceduralSource.fromRulemakingAuthority]

/-- All sources from rulemaking authority are floor-enforceable.
    This captures the report's statement that these sources "have the same authority
    and effect as the Senate's standing rules." -/
theorem rulemaking_implies_floor_enforceable (s : ProceduralSource)
    (h : s.fromRulemakingAuthority) : s.floorEnforceable := by
  cases s <;> simp_all [ProceduralSource.fromRulemakingAuthority,
    ProceduralSource.floorEnforceable]

/-! ## Precedent Weight

"All precedents do not carry equal weight." The report establishes a hierarchy:
1. Precedents based on a vote of the Senate (most authoritative)
2. Precedents based on rulings of the presiding officer
3. Responses of the presiding officer to parliamentary inquiries (least authoritative)
-/

/-- The origin of a Senate precedent, determining its relative weight. -/
inductive PrecedentOrigin where
  | senateVote           -- Vote of the full Senate on a question of order
  | presidingOfficerRule -- Ruling of the presiding officer (not appealed)
  | parliamentaryInquiry -- Presiding officer's response to a parliamentary inquiry
  deriving DecidableEq, Repr, Fintype

open PrecedentOrigin

/-- The weight/authority of a precedent origin, higher is more authoritative.
    "Precedents based on a vote of the Senate have more weight than those based on
    rulings of the presiding officer. Responses of the presiding officer to
    parliamentary inquiries have even less weight." -/
def PrecedentOrigin.weight : PrecedentOrigin → ℕ
  | senateVote           => 3
  | presidingOfficerRule => 2
  | parliamentaryInquiry => 1

/-- Senate vote precedents outweigh presiding officer rulings. -/
theorem senateVote_gt_presidingOfficerRule :
    senateVote.weight > presidingOfficerRule.weight := by
  simp [PrecedentOrigin.weight]

/-- Presiding officer rulings outweigh parliamentary inquiry responses. -/
theorem presidingOfficerRule_gt_parliamentaryInquiry :
    presidingOfficerRule.weight > parliamentaryInquiry.weight := by
  simp [PrecedentOrigin.weight]

/-- Senate vote precedents outweigh parliamentary inquiry responses (transitivity). -/
theorem senateVote_gt_parliamentaryInquiry :
    senateVote.weight > parliamentaryInquiry.weight := by
  simp [PrecedentOrigin.weight]

/-- The weight ordering is total: for any two origins, one is ≥ the other. -/
theorem precedent_weight_total (a b : PrecedentOrigin) :
    a.weight ≤ b.weight ∨ b.weight ≤ a.weight := by
  omega
