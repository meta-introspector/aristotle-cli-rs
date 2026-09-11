import Mathlib
import RequestProject.Law.CodeStructure
import RequestProject.Law.Statutory.USC.Title5.Adjudication

/-!
# 5 U.S.C. § 704 — Final Agency Action and Exhaustion of Remedies

This file models, **bottom-up and details-first**, the precise procedural
threshold at which an agency file stops being a moving administrative target and
becomes ripe for judicial review.

5 U.S.C. § 704 provides that "[a]gency action made reviewable by statute and
*final agency action* for which there is no other adequate remedy in a court are
subject to judicial review."  Two judicially-developed conditions (*Bennett v.
Spear*) make "final agency action" bite, and we model both:

* **Consummation.** The action must mark the *consummation* of the agency's
  decisionmaking process — it must not be merely tentative or interlocutory (an
  ALJ's *initial* decision under § 557(b), say, is not yet final if it is still
  subject to agency review).
* **Legal consequences.** The action must be one by which rights or obligations
  have been determined, or from which legal consequences will flow.

Section 704 further provides that an interlocutory ruling is *not* directly
reviewable, and that — when an agency rule requires it — a party must first
appeal to "superior agency authority": the doctrine of **exhaustion of
administrative remedies**.

We reuse the `DecisionStage` model from the §§ 554/556/557 adjudication layer,
define `isFinalAgencyAction` and `reviewable`, and prove the structural
guarantees: only a consummated action with legal consequences is final, an
interlocutory or under-review file is not reviewable, and an unexhausted remedy
defeats review.
-/

namespace Law.USC.Title5.JudicialReview

open Law
open Law.USC.Title5.Adjudication (DecisionStage)

/-! ## The reviewable-action record

We track the consummation/legal-consequence facts of *Bennett v. Spear*, the
adjudicatory stage of the file (§ 557(b)), and the exhaustion posture. -/

/-- The dispositive facts bearing on reviewability under § 704. -/
structure AgencyAction where
  /-- The stage of the file in the formal adjudication pipeline (§ 557(b)). -/
  stage : DecisionStage
  /-- *Bennett* prong 1: the action consummates the agency's decisionmaking
  process (it is not tentative or interlocutory). -/
  consummatesProcess : Bool
  /-- *Bennett* prong 2: rights/obligations are determined or legal consequences
  flow from the action. -/
  legalConsequencesFlow : Bool
  /-- § 704: whether an agency rule *requires* an appeal to superior agency
  authority before review (i.e. whether exhaustion is mandatory here). -/
  exhaustionRequired : Bool
  /-- Whether the party has in fact exhausted the available agency remedies. -/
  remediesExhausted : Bool
  /-- Whether there exists another adequate remedy in a court (§ 704). -/
  otherAdequateRemedy : Bool
deriving DecidableEq, Repr

/-! ## Procedural predicates -/

/-- **Final agency action (§ 704; *Bennett v. Spear*).** The action both
consummates the agency's decisionmaking process and has legal consequences. -/
def isFinalAgencyAction (a : AgencyAction) : Prop :=
  a.consummatesProcess = true ∧ a.legalConsequencesFlow = true

/-- **Exhaustion satisfied (§ 704).** Either exhaustion is not required, or the
party has in fact exhausted the available agency remedies. -/
def exhaustionSatisfied (a : AgencyAction) : Prop :=
  a.exhaustionRequired = false ∨ a.remediesExhausted = true

/-- **Reviewable (§ 704).** The action is final, there is no other adequate
remedy in a court, and any required administrative remedies have been
exhausted. -/
structure Reviewable (a : AgencyAction) : Prop where
  /-- The action is final agency action. -/
  final : isFinalAgencyAction a
  /-- There is no other adequate remedy in a court. -/
  no_other_remedy : a.otherAdequateRemedy = false
  /-- Any required administrative remedies have been exhausted. -/
  exhausted : exhaustionSatisfied a

/-! ### Structural guarantees -/

/-- **Tentative action is not final.** An action that does not consummate the
agency's decisionmaking process is not final agency action. -/
theorem not_final_if_not_consummated
    (a : AgencyAction)
    (h : a.consummatesProcess = false) :
    ¬ isFinalAgencyAction a := by
  rintro ⟨hc, _⟩
  rw [h] at hc
  exact Bool.noConfusion hc

/-- **Action without legal consequences is not final.** -/
theorem not_final_if_no_legal_consequences
    (a : AgencyAction)
    (h : a.legalConsequencesFlow = false) :
    ¬ isFinalAgencyAction a := by
  rintro ⟨_, hl⟩
  rw [h] at hl
  exact Bool.noConfusion hl

/-- **Interlocutory rulings are not reviewable.** A file still at the ALJ's
initial-decision stage, or under agency review, is not yet final agency action,
hence not reviewable, unless it has consummated the process — which we encode by
requiring consummation for finality. A non-consummated action is unreviewable. -/
theorem interlocutory_not_reviewable
    (a : AgencyAction)
    (h : a.consummatesProcess = false) :
    ¬ Reviewable a := by
  intro hr
  exact not_final_if_not_consummated a h hr.final

/-- **Exhaustion bites.** If an agency rule requires exhaustion and the party has
not exhausted the available remedies, the action is not reviewable. -/
theorem not_reviewable_if_unexhausted
    (a : AgencyAction)
    (h_required : a.exhaustionRequired = true)
    (h_not_done : a.remediesExhausted = false) :
    ¬ Reviewable a := by
  intro hr
  rcases hr.exhausted with h | h
  · rw [h_required] at h; exact Bool.noConfusion h
  · rw [h_not_done] at h; exact Bool.noConfusion h

/-- **The adequate-alternative bar.** If there is another adequate remedy in a
court, § 704 review is unavailable. -/
theorem not_reviewable_if_other_remedy
    (a : AgencyAction)
    (h : a.otherAdequateRemedy = true) :
    ¬ Reviewable a := by
  intro hr
  rw [hr.no_other_remedy] at h
  exact Bool.noConfusion h

/-- **Reviewability requires finality.** Anything reviewable under § 704 is final
agency action. -/
theorem reviewable_implies_final
    (a : AgencyAction)
    (hr : Reviewable a) :
    isFinalAgencyAction a :=
  hr.final

/-! ### A worked, fully reviewable example -/

/-- A model agency action that is final, lacks any other adequate remedy, and has
exhausted (or did not require) administrative appeals. -/
def exampleAction : AgencyAction where
  stage := DecisionStage.finalAgencyDecision
  consummatesProcess := true
  legalConsequencesFlow := true
  exhaustionRequired := true
  remediesExhausted := true
  otherAdequateRemedy := false

/-- The worked example is reviewable under § 704. -/
theorem exampleAction_reviewable : Reviewable exampleAction where
  final := ⟨rfl, rfl⟩
  no_other_remedy := rfl
  exhausted := Or.inr rfl

/-- A model interlocutory file: the ALJ's initial decision, not yet consummated,
is not reviewable. -/
def exampleInterlocutory : AgencyAction where
  stage := DecisionStage.initialDecision
  consummatesProcess := false
  legalConsequencesFlow := false
  exhaustionRequired := true
  remediesExhausted := false
  otherAdequateRemedy := false

/-- The interlocutory example is not reviewable. -/
theorem exampleInterlocutory_not_reviewable : ¬ Reviewable exampleInterlocutory :=
  interlocutory_not_reviewable exampleInterlocutory rfl

/-! ## Content addresses

§ 704 lives in Title 5, Chapter 7 (Judicial Review). -/

/-- `§ n` of Title 5, Chapter 7 (Judicial Review) as a `USCCitation`. -/
def cite (n : Nat) : USCCitation := ⟨5, 7, n⟩

/-- Distinct judicial-review sections receive distinct content addresses. -/
theorem review_addresses_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  intro h'
  exact h (congrArg USCCitation.«section» (USCCitation.address_injective h'))

/-- The Chapter 7 judicial-review provisions never collide with the Chapter 5
administrative-procedure provisions (§§ 553–557). -/
theorem review_distinct_from_chapter5 (s : Nat) (c : USCCitation)
    (hc : c.chapter = 5) :
    (cite s).address ≠ c.address := by
  intro h
  have heq := USCCitation.address_injective h
  rw [← heq] at hc
  simp [cite] at hc

end Law.USC.Title5.JudicialReview
