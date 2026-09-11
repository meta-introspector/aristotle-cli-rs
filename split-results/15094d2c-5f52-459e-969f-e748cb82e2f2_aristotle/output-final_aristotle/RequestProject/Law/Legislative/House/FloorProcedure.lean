import Mathlib
import RequestProject.Law.Legislative.CodeStructure
import RequestProject.Law.Constitution.Article1

/-!
# Floor Action in the U.S. House — Quorum, Voting, and Passage

This module models the final procedural gate: action on the floor of the House.
The governing authorities are

* **Rule XX (Voting and Quorum).**  Establishes how the House ascertains the
  presence of a quorum and records votes.
* **Article I, § 5, cl. 1.**  "[A] Majority of each [House] shall constitute a
  Quorum to do Business" — for the House of 435 voting Members, a quorum is 218.

We model the dispositive facts of a floor vote (`FloorVote`: yeas, nays, and the
number of Members present) and the *action* being taken, which fixes the threshold
required:

* a **simple majority** of those voting passes an ordinary measure or motion
  (Art. I, § 7);
* a **two-thirds** supermajority is required to pass a measure under **Suspension
  of the Rules**, and to **override a presidential veto** (Art. I, § 7, cl. 2).

We reuse the voting-threshold predicates already proved for Article I
(`Tally.passesMajority`, `Tally.passesTwoThirds`) and prove the structural
guarantees: no business without a quorum, simple-majority passage, and the
two-thirds requirement for suspension and veto override.
-/

namespace Law.Legislative.House.FloorProcedure

open Law.Legislative
open Law.Constitution.Article1

/-! ## Quorum (Rule XX; Art. I, § 5, cl. 1)

The House comprises 435 voting Members; a quorum is a simple majority, i.e. at
least 218 Members — equivalently, strictly more than 217 present. -/

/-- The number of voting Members of the House. -/
def houseMembership : Nat := 435

/-- The quorum threshold for the House: strictly more than 217 (i.e. at least 218)
Members present (Art. I, § 5, cl. 1). -/
def quorumThreshold : Nat := 217

/-- **A quorum is present** when more than `quorumThreshold` (217) Members are
present — i.e. a majority of the 435-Member House. -/
def quorumPresent (present : Nat) : Prop := present > quorumThreshold

instance (present : Nat) : Decidable (quorumPresent present) := by
  unfold quorumPresent; infer_instance

/-- 218 Members present constitute a quorum. -/
theorem quorum_at_218 : quorumPresent 218 := by decide

/-- 217 Members present do **not** constitute a quorum (it is one short of a
majority of 435). -/
theorem no_quorum_at_217 : ¬ quorumPresent 217 := by decide

/-- Any count at or below 217 fails the quorum requirement. -/
theorem no_quorum_below_majority (present : Nat) (h : present ≤ quorumThreshold) :
    ¬ quorumPresent present := by
  unfold quorumPresent
  omega

/-! ## Floor actions and their thresholds

The kind of action being taken on the floor fixes the vote threshold required. -/

/-- A floor action, classified by the vote threshold it requires. -/
inductive FloorAction
  /-- An ordinary measure or motion: simple majority of those voting (Art. I, § 7). -/
  | ordinaryPassage
  /-- A measure considered under Suspension of the Rules: two-thirds required. -/
  | suspensionOfRules
  /-- An override of a presidential veto: two-thirds required (Art. I, § 7, cl. 2). -/
  | vetoOverride
deriving DecidableEq, Repr

/-- The vote tally required for a floor action: a two-thirds supermajority for
suspension and veto override, a simple majority otherwise. -/
def FloorAction.requiresTwoThirds : FloorAction → Bool
  | FloorAction.ordinaryPassage => false
  | FloorAction.suspensionOfRules => true
  | FloorAction.vetoOverride => true

/-! ## The floor vote

A floor vote records the yeas, the nays, and the number of Members present.  The
`Tally` of yeas out of (yeas + nays) feeds the Article I threshold predicates. -/

/-- A recorded floor vote (Rule XX). -/
structure FloorVote where
  /-- Affirmative ("yea") votes. -/
  yeas : Nat
  /-- Negative ("nay") votes. -/
  nays : Nat
  /-- Total Members present for the vote. -/
  present : Nat
deriving DecidableEq, Repr

/-- The `Tally` of a floor vote: yeas out of the total votes cast (yeas + nays). -/
def FloorVote.tally (v : FloorVote) : Tally := ⟨v.yeas, v.yeas + v.nays⟩

/-- **Passage condition.**  A floor action *passes* iff a quorum is present and the
applicable threshold is met: a two-thirds supermajority for suspension and veto
override, a simple majority of those voting otherwise. -/
def FloorVote.passes (v : FloorVote) (act : FloorAction) : Prop :=
  quorumPresent v.present ∧
    (if act.requiresTwoThirds then v.tally.passesTwoThirds else v.tally.passesMajority)

/-! ### Structural guarantees -/

/-- **No business without a quorum.**  However lopsided the vote, an action fails
if no quorum is present. -/
theorem no_passage_without_quorum (v : FloorVote) (act : FloorAction)
    (h : ¬ quorumPresent v.present) : ¬ v.passes act := by
  rintro ⟨hq, _⟩
  exact h hq

/-- **Ordinary passage by simple majority.**  With a quorum present and a simple
majority of those voting, an ordinary measure passes. -/
theorem ordinary_passes_on_majority (v : FloorVote)
    (hq : quorumPresent v.present) (hm : v.tally.passesMajority) :
    v.passes FloorAction.ordinaryPassage := by
  refine ⟨hq, ?_⟩
  simp [FloorAction.requiresTwoThirds, hm]

/-- **Suspension requires two-thirds.**  A measure under Suspension of the Rules
that musters only a simple majority — short of two-thirds — does not pass. -/
theorem suspension_fails_on_bare_majority (v : FloorVote)
    (h : ¬ v.tally.passesTwoThirds) :
    ¬ v.passes FloorAction.suspensionOfRules := by
  rintro ⟨_, hpass⟩
  simp only [FloorAction.requiresTwoThirds, if_true] at hpass
  exact h hpass

/-- **Suspension passes on two-thirds.**  With a quorum and a two-thirds vote, a
measure under Suspension of the Rules passes. -/
theorem suspension_passes_on_two_thirds (v : FloorVote)
    (hq : quorumPresent v.present) (h : v.tally.passesTwoThirds) :
    v.passes FloorAction.suspensionOfRules := by
  refine ⟨hq, ?_⟩
  simp [FloorAction.requiresTwoThirds, h]

/-- **Veto override requires two-thirds.**  A veto-override vote short of
two-thirds fails. -/
theorem veto_override_fails_on_bare_majority (v : FloorVote)
    (h : ¬ v.tally.passesTwoThirds) :
    ¬ v.passes FloorAction.vetoOverride := by
  rintro ⟨_, hpass⟩
  simp only [FloorAction.requiresTwoThirds, if_true] at hpass
  exact h hpass

/-- **Veto override passes on two-thirds.**  With a quorum and a two-thirds vote,
a veto override succeeds. -/
theorem veto_override_passes_on_two_thirds (v : FloorVote)
    (hq : quorumPresent v.present) (h : v.tally.passesTwoThirds) :
    v.passes FloorAction.vetoOverride := by
  refine ⟨hq, ?_⟩
  simp [FloorAction.requiresTwoThirds, h]

/-- **A two-thirds vote a fortiori carries an ordinary measure.**  If a vote meets
the two-thirds bar (with at least one vote cast), then with a quorum it would also
pass as an ordinary measure — the supermajority threshold is the strictly harder
gate. -/
theorem two_thirds_also_passes_ordinary (v : FloorVote)
    (hq : quorumPresent v.present)
    (hpos : 0 < v.tally.total) (h : v.tally.passesTwoThirds) :
    v.passes FloorAction.ordinaryPassage := by
  refine ⟨hq, ?_⟩
  have hmaj : v.tally.passesMajority := twoThirds_imp_majority hpos h
  simp [FloorAction.requiresTwoThirds, hmaj]

/-! ## Worked examples -/

/-- A 300–135 vote of a full House (435 present): ordinary passage succeeds. -/
def exampleOrdinary : FloorVote := ⟨300, 135, 435⟩

theorem exampleOrdinary_passes :
    exampleOrdinary.passes FloorAction.ordinaryPassage := by
  apply ordinary_passes_on_majority
  · decide
  · unfold FloorVote.tally exampleOrdinary Tally.passesMajority
    decide

/-- A 200–235 vote (with a quorum present): ordinary passage fails for want of a
majority. -/
def exampleFailed : FloorVote := ⟨200, 235, 435⟩

theorem exampleFailed_fails :
    ¬ exampleFailed.passes FloorAction.ordinaryPassage := by
  unfold FloorVote.passes FloorVote.tally exampleFailed FloorAction.requiresTwoThirds
    quorumPresent quorumThreshold Tally.passesMajority Tally.passesTwoThirds
  decide

/-- A 290–145 vote under Suspension of the Rules with a full House: two-thirds is
met, so it passes. -/
def exampleSuspension : FloorVote := ⟨290, 145, 435⟩

theorem exampleSuspension_passes :
    exampleSuspension.passes FloorAction.suspensionOfRules := by
  apply suspension_passes_on_two_thirds
  · decide
  · unfold FloorVote.tally exampleSuspension Tally.passesTwoThirds
    decide

/-! ## Content addresses

We anchor the floor-action machinery at Rule XX (Voting and Quorum). -/

/-- Citation to Rule XX (Voting and Quorum). -/
def citeRuleXX : HouseRuleCitation := ⟨20, 1⟩

theorem floorProcedure_citation : citeRuleXX.rule = 20 := rfl

end Law.Legislative.House.FloorProcedure
