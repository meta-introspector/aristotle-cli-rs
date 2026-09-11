import Mathlib
import RequestProject.Law.CodeStructure
import RequestProject.Law.Constitution.Article3

/-!
# Justiciability — the Article III "Case or Controversy" gate

Article III, § 2 confines the federal judicial power to "Cases" and
"Controversies."  Standing (formalized in `Constitution/Article3.lean`) is the
first of several *justiciability* doctrines that enforce this limit.  A federal
court may reach the merits only if **all** of the following hold:

* **Standing** — injury in fact, causation, redressability (Art. III; see
  `Law.Constitution.Article3.StandingFacts`).
* **Ripeness** — the dispute is concrete and the harm is actual or imminent, not
  contingent on future events that may never occur.
* **Mootness** — a live controversy persists *throughout* the litigation; a
  dispute that has been resolved or overtaken by events is non-justiciable
  (subject to recognized exceptions).
* **No political question** — the issue is not textually committed to a
  coordinate political branch and is susceptible of judicial resolution
  (*Baker v. Carr*).
* **Not an advisory opinion** — the court does not opine on abstract or
  hypothetical questions outside an adversarial case.

This module models each doctrine and assembles them into a single justiciability
predicate, with the structural guarantee that *each* doctrine is necessary.
-/

namespace Law.Judicial.Justiciability

open Law
open Law.Constitution.Article3

/-! ## Ripeness

A claim is ripe when it presents a concrete dispute fit for judicial decision and
withholding review would work a hardship — not when it rests on "contingent
future events that may not occur as anticipated, or indeed may not occur at
all." -/

/-- The facts bearing on ripeness. -/
structure RipenessFacts where
  /-- The issues are fit for judicial decision (concrete, legal, fully formed). -/
  fitForDecision : Bool
  /-- The harm is actual or imminent rather than contingent on future events. -/
  harmNotContingent : Bool
deriving DecidableEq, Repr

/-- A claim is ripe iff it is fit for decision and the harm is not merely
contingent. -/
def RipenessFacts.ripe (r : RipenessFacts) : Prop :=
  r.fitForDecision = true ∧ r.harmNotContingent = true

/-- A claim resting on contingent future events that may never occur is not
ripe. -/
theorem not_ripe_if_contingent (r : RipenessFacts)
    (h : r.harmNotContingent = false) : ¬ r.ripe := by
  rintro ⟨_, hc⟩
  rw [h] at hc
  exact Bool.noConfusion hc

/-- A claim that is not yet fit for judicial decision is not ripe. -/
theorem not_ripe_if_unfit (r : RipenessFacts)
    (h : r.fitForDecision = false) : ¬ r.ripe := by
  rintro ⟨hf, _⟩
  rw [h] at hf
  exact Bool.noConfusion hf

/-! ## Mootness

Standing must persist; an "actual controversy must exist not only at the time the
complaint is filed, but through all stages" of the litigation.  A case becomes
moot when intervening events deprive the court of the ability to grant effectual
relief — unless a recognized exception applies (notably, conduct "capable of
repetition, yet evading review"). -/

/-- The facts bearing on mootness. -/
structure MootnessFacts where
  /-- A live controversy persists: effectual relief can still be granted. -/
  liveControversy : Bool
  /-- A recognized mootness exception applies (e.g. capable of repetition yet
  evading review; voluntary cessation; class actions). -/
  exceptionApplies : Bool
deriving DecidableEq, Repr

/-- A case is *not* moot iff a live controversy persists, or a recognized
exception applies. -/
def MootnessFacts.notMoot (m : MootnessFacts) : Prop :=
  m.liveControversy = true ∨ m.exceptionApplies = true

/-- A case with no live controversy and no applicable exception is moot. -/
theorem moot_if_dead_and_no_exception (m : MootnessFacts)
    (h₁ : m.liveControversy = false) (h₂ : m.exceptionApplies = false) :
    ¬ m.notMoot := by
  rintro (h | h)
  · rw [h₁] at h; exact Bool.noConfusion h
  · rw [h₂] at h; exact Bool.noConfusion h

/-- A persisting live controversy keeps the case from being moot. -/
theorem not_moot_of_live (m : MootnessFacts) (h : m.liveControversy = true) :
    m.notMoot := Or.inl h

/-- The "capable of repetition, yet evading review" (or other recognized)
exception keeps an otherwise-moot case alive. -/
theorem not_moot_of_exception (m : MootnessFacts)
    (h : m.exceptionApplies = true) : m.notMoot := Or.inr h

/-! ## Political question doctrine (*Baker v. Carr*)

A controversy presents a non-justiciable political question when it is textually
committed to a coordinate political branch, or there is a lack of judicially
discoverable and manageable standards for resolving it.  We model the two
leading *Baker* factors; a question is non-justiciable if *either* is present. -/

/-- The facts bearing on the political-question doctrine. -/
structure PoliticalQuestionFacts where
  /-- The issue is textually committed by the Constitution to a coordinate
  political branch. -/
  textuallyCommittedToOtherBranch : Bool
  /-- There are *no* judicially discoverable and manageable standards for
  resolving the issue. -/
  lacksJudicialStandards : Bool
deriving DecidableEq, Repr

/-- A matter is a non-justiciable political question if it is textually committed
to another branch *or* lacks judicially manageable standards. -/
def PoliticalQuestionFacts.isPoliticalQuestion (p : PoliticalQuestionFacts) : Prop :=
  p.textuallyCommittedToOtherBranch = true ∨ p.lacksJudicialStandards = true

/-- A matter neither committed to another branch nor lacking standards is *not* a
political question. -/
def PoliticalQuestionFacts.notPoliticalQuestion (p : PoliticalQuestionFacts) : Prop :=
  ¬ p.isPoliticalQuestion

/-- A textual commitment to a coordinate branch makes the question a political
question (non-justiciable). -/
theorem political_question_if_committed (p : PoliticalQuestionFacts)
    (h : p.textuallyCommittedToOtherBranch = true) : p.isPoliticalQuestion :=
  Or.inl h

/-- The absence of judicially manageable standards makes the question a political
question. -/
theorem political_question_if_no_standards (p : PoliticalQuestionFacts)
    (h : p.lacksJudicialStandards = true) : p.isPoliticalQuestion := Or.inr h

/-- A matter free of both *Baker* factors is judicially resolvable (not a
political question). -/
theorem not_political_question_of_neither (p : PoliticalQuestionFacts)
    (h₁ : p.textuallyCommittedToOtherBranch = false)
    (h₂ : p.lacksJudicialStandards = false) : p.notPoliticalQuestion := by
  rintro (h | h)
  · rw [h₁] at h; exact Bool.noConfusion h
  · rw [h₂] at h; exact Bool.noConfusion h

/-! ## The justiciability gate

A federal court may reach the merits only if standing, ripeness, mootness, the
political-question doctrine, and the bar on advisory opinions are *all*
satisfied. -/

/-- The full justiciability record of a matter before a federal court. -/
structure JusticiabilityFacts where
  /-- Article III standing (injury / causation / redressability). -/
  standing : StandingFacts
  /-- Ripeness. -/
  ripeness : RipenessFacts
  /-- Mootness posture. -/
  mootness : MootnessFacts
  /-- Political-question posture. -/
  politicalQuestion : PoliticalQuestionFacts
  /-- The court is asked to decide a concrete adversarial dispute, not to render
  an advisory opinion on an abstract or hypothetical question. -/
  notAdvisory : Bool
deriving Repr

/-- A matter is **justiciable** iff the plaintiff has standing, the claim is ripe
and not moot, it is not a political question, and it is not a request for an
advisory opinion. -/
def JusticiabilityFacts.justiciable (j : JusticiabilityFacts) : Prop :=
  j.standing.hasStanding ∧
    j.ripeness.ripe ∧
    j.mootness.notMoot ∧
    j.politicalQuestion.notPoliticalQuestion ∧
    j.notAdvisory = true

/-! ### Each doctrine is necessary -/

/-- No standing ⇒ not justiciable. -/
theorem not_justiciable_without_standing (j : JusticiabilityFacts)
    (h : ¬ j.standing.hasStanding) : ¬ j.justiciable := by
  rintro ⟨hs, _, _, _, _⟩; exact h hs

/-- Lack of ripeness ⇒ not justiciable. -/
theorem not_justiciable_if_unripe (j : JusticiabilityFacts)
    (h : ¬ j.ripeness.ripe) : ¬ j.justiciable := by
  rintro ⟨_, hr, _, _, _⟩; exact h hr

/-- Mootness ⇒ not justiciable. -/
theorem not_justiciable_if_moot (j : JusticiabilityFacts)
    (h : ¬ j.mootness.notMoot) : ¬ j.justiciable := by
  rintro ⟨_, _, hm, _, _⟩; exact h hm

/-- A political question ⇒ not justiciable. -/
theorem not_justiciable_if_political_question (j : JusticiabilityFacts)
    (h : j.politicalQuestion.isPoliticalQuestion) : ¬ j.justiciable := by
  rintro ⟨_, _, _, hp, _⟩; exact hp h

/-- A request for an advisory opinion ⇒ not justiciable. -/
theorem not_justiciable_if_advisory (j : JusticiabilityFacts)
    (h : j.notAdvisory = false) : ¬ j.justiciable := by
  rintro ⟨_, _, _, _, ha⟩
  rw [h] at ha
  exact Bool.noConfusion ha

/-- When every doctrine is satisfied, the matter is justiciable. -/
theorem justiciable_of_all
    (j : JusticiabilityFacts)
    (hs : j.standing.hasStanding)
    (hr : j.ripeness.ripe)
    (hm : j.mootness.notMoot)
    (hp : j.politicalQuestion.notPoliticalQuestion)
    (ha : j.notAdvisory = true) : j.justiciable :=
  ⟨hs, hr, hm, hp, ha⟩

/-! ### Worked example -/

/-- A fully justiciable matter: a plaintiff with standing, a ripe and live
controversy, no political question, and a concrete adversarial dispute. -/
def exampleJusticiable : JusticiabilityFacts where
  standing := ⟨true, true, true⟩
  ripeness := ⟨true, true⟩
  mootness := ⟨true, false⟩
  politicalQuestion := ⟨false, false⟩
  notAdvisory := true

theorem exampleJusticiable_justiciable : exampleJusticiable.justiciable := by
  refine ⟨⟨rfl, rfl, rfl⟩, ⟨rfl, rfl⟩, Or.inl rfl, ?_, rfl⟩
  rintro (h | h) <;> exact Bool.noConfusion h

/-! ## Content addressing

The justiciability doctrines elaborate the Article III "Case or Controversy"
limitation (Art. III, § 2), placed at the constitutional pseudo-title `0`,
chapter `3` (Article III), consistent with `Constitution/Article3.lean`. -/

/-- Art. III, § 2 (the Case-or-Controversy clause) as a `USCCitation`, matching
the `Constitution.Article3` addressing scheme. -/
def citeCaseOrControversy : USCCitation := Law.Constitution.Article3.cite 2

/-- The justiciability anchor sits in Article III (constitutional pseudo-title
`0`) and so never collides with any positive-law USC title `t ≥ 1`. -/
theorem justiciability_distinct_from_positive_law (c : USCCitation)
    (hc : 1 ≤ c.title) : citeCaseOrControversy.address ≠ c.address := by
  intro h
  have heq := USCCitation.address_injective h
  rw [← heq] at hc
  simp [citeCaseOrControversy, Law.Constitution.Article3.cite] at hc

end Law.Judicial.Justiciability
