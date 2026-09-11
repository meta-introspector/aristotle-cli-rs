import Mathlib
import RequestProject.Law.Legislative.CodeStructure

/-!
# The House Rules Committee Gate — Special Rules, Amendments, and Time Limits

This module models the **traffic cop** of the House floor: the Committee on Rules,
which reports a *special rule* (an original-jurisdiction resolution) prescribing
the terms on which a measure will be considered.  The governing authority is

* **Rule XIII (Calendars and Committee Reports)**, under which the Rules Committee
  reports special orders of business that the House adopts by majority vote, and
  which then displace the standing order of business for the measure named.

A special rule fixes two things we model precisely:

1. **The amendment regime** — how amendments may be offered on the floor:
   * *Open*: any **germane** amendment may be offered.
   * *Closed*: **no** amendments may be offered.
   * *Structured* (a.k.a. "modified"): only **specific, pre-cleared** amendments
     printed in the Rules Committee report may be offered.

2. **The time allotment** — a formal bound on the hours of *general debate*.

We model a `SpecialRule` as the dispositive facts, define when a proposed
`Amendment` is *in order* under the rule, and prove the structural guarantees of
each regime, together with the debate-time bound.
-/

namespace Law.Legislative.House.RulesCommittee

open Law.Legislative

/-! ## Amendments

An amendment carries an identifier (so the structured regime can name a
pre-cleared set) and a germaneness flag (Rule XVI's germaneness requirement, which
the open regime enforces). -/

/-- A proposed floor amendment. -/
structure Amendment where
  /-- A numeric identifier for the amendment (used by structured rules). -/
  id : Nat
  /-- Whether the amendment is germane to the measure (Rule XVI). -/
  germane : Bool
deriving DecidableEq, Repr

/-! ## The amendment regime and the special rule

`AmendmentRegime` is the three-way classification of special rules.  A
`SpecialRule` bundles the regime, the list of pre-cleared amendment identifiers
(meaningful only for the structured regime), and the general-debate time
allotment in hours. -/

/-- The three classes of special rule governing floor amendments (Rule XIII). -/
inductive AmendmentRegime
  /-- Open rule: any germane amendment may be offered. -/
  | open
  /-- Closed rule: no floor amendments are permitted. -/
  | closed
  /-- Structured rule: only specifically pre-cleared amendments are permitted. -/
  | structured
deriving DecidableEq, Repr

/-- A special rule reported by the Committee on Rules (Rule XIII). -/
structure SpecialRule where
  /-- The amendment regime the rule establishes. -/
  regime : AmendmentRegime
  /-- Identifiers of the amendments pre-cleared by the rule (structured rules). -/
  preClearedAmendments : List Nat
  /-- The maximum hours of general debate the rule allots. -/
  debateHoursAllotted : Nat
deriving DecidableEq, Repr

/-- **When an amendment is in order** under a special rule:

* under an *open* rule, exactly the germane amendments;
* under a *closed* rule, none;
* under a *structured* rule, exactly those whose identifier was pre-cleared. -/
def SpecialRule.amendmentInOrder (sr : SpecialRule) (a : Amendment) : Prop :=
  match sr.regime with
  | AmendmentRegime.open => a.germane = true
  | AmendmentRegime.closed => False
  | AmendmentRegime.structured => a.id ∈ sr.preClearedAmendments

/-! ### Structural guarantees of the amendment regimes -/

/-- **Closed rule bars all amendments.**  Under a closed rule no amendment,
germane or not, is in order. -/
theorem closed_rule_bars_all (sr : SpecialRule) (a : Amendment)
    (h : sr.regime = AmendmentRegime.closed) : ¬ sr.amendmentInOrder a := by
  unfold SpecialRule.amendmentInOrder
  rw [h]
  exact id

/-- **Open rule admits germane amendments.**  Under an open rule, a germane
amendment is in order. -/
theorem open_rule_allows_germane (sr : SpecialRule) (a : Amendment)
    (hr : sr.regime = AmendmentRegime.open) (hg : a.germane = true) :
    sr.amendmentInOrder a := by
  unfold SpecialRule.amendmentInOrder
  rw [hr]
  exact hg

/-- **Open rule still bars non-germane amendments.**  Even under an open rule, an
amendment that is not germane is out of order (Rule XVI germaneness). -/
theorem open_rule_bars_nongermane (sr : SpecialRule) (a : Amendment)
    (hr : sr.regime = AmendmentRegime.open) (hg : a.germane = false) :
    ¬ sr.amendmentInOrder a := by
  unfold SpecialRule.amendmentInOrder
  rw [hr, hg]
  exact Bool.noConfusion

/-- **Structured rule admits only pre-cleared amendments.**  Under a structured
rule, a pre-cleared amendment is in order. -/
theorem structured_rule_allows_precleared (sr : SpecialRule) (a : Amendment)
    (hr : sr.regime = AmendmentRegime.structured)
    (hm : a.id ∈ sr.preClearedAmendments) : sr.amendmentInOrder a := by
  unfold SpecialRule.amendmentInOrder
  rw [hr]
  exact hm

/-- **Structured rule bars amendments not pre-cleared.**  An amendment whose
identifier was not pre-cleared is out of order under a structured rule. -/
theorem structured_rule_bars_unlisted (sr : SpecialRule) (a : Amendment)
    (hr : sr.regime = AmendmentRegime.structured)
    (hm : a.id ∉ sr.preClearedAmendments) : ¬ sr.amendmentInOrder a := by
  unfold SpecialRule.amendmentInOrder
  rw [hr]
  exact hm

/-! ## Time allotment for general debate

The special rule formally bounds the hours of general debate.  We model a debate
as compliant when the hours actually consumed do not exceed the allotment. -/

/-- The hours of general debate `used` comply with a special rule iff they do not
exceed the rule's allotment. -/
def SpecialRule.debateWithinAllotment (sr : SpecialRule) (used : Nat) : Prop :=
  used ≤ sr.debateHoursAllotted

/-- **The time allotment binds.**  Debate that runs past the allotted hours is not
within the allotment. -/
theorem debate_over_allotment_invalid (sr : SpecialRule) (used : Nat)
    (h : used > sr.debateHoursAllotted) : ¬ sr.debateWithinAllotment used := by
  unfold SpecialRule.debateWithinAllotment
  omega

/-- Debate consuming at most the allotted hours complies. -/
theorem debate_at_allotment_valid (sr : SpecialRule) (used : Nat)
    (h : used ≤ sr.debateHoursAllotted) : sr.debateWithinAllotment used := h

/-! ## A worked example

A structured rule pre-clears amendments 1 and 2 and allots one hour of general
debate.  Amendment 1 is in order; amendment 3 is not; a 1-hour debate complies. -/

/-- A structured special rule pre-clearing amendments `1` and `2`, with one hour
of general debate. -/
def exampleRule : SpecialRule :=
  { regime := AmendmentRegime.structured
    preClearedAmendments := [1, 2]
    debateHoursAllotted := 1 }

theorem exampleRule_admits_one :
    exampleRule.amendmentInOrder { id := 1, germane := true } := by
  unfold SpecialRule.amendmentInOrder exampleRule
  decide

theorem exampleRule_bars_three :
    ¬ exampleRule.amendmentInOrder { id := 3, germane := true } := by
  unfold SpecialRule.amendmentInOrder exampleRule
  decide

theorem exampleRule_debate_ok : exampleRule.debateWithinAllotment 1 := by
  unfold SpecialRule.debateWithinAllotment exampleRule
  decide

/-! ## Content addresses

We anchor the special-rules machinery at Rule XIII. -/

/-- Citation to Rule XIII (Calendars and Committee Reports). -/
def citeRuleXIII : HouseRuleCitation := ⟨13, 1⟩

theorem rulesCommittee_citation : citeRuleXIII.rule = 13 := rfl

end Law.Legislative.House.RulesCommittee
