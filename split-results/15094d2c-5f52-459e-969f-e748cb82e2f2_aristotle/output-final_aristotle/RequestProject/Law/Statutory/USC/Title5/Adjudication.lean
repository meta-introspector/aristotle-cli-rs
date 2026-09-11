import Mathlib
import RequestProject.Law.CodeStructure

/-!
# 5 U.S.C. §§ 554, 556–557 — Formal Agency Adjudication Mechanics

This file models, **bottom-up and details-first**, the operational procedure by
which an agency conducts a *formal* on-the-record adjudication — the internal
"trial" that produces the concrete track record courts later review.

The Administrative Procedure Act fixes a deterministic skeleton:

* **§ 554(d) — Separation of functions.** An employee or agent engaged in the
  performance of investigative or prosecuting functions for an agency in a case
  "may not, in that or a factually related case, participate or advise in the
  decision, recommended decision, or agency review."  The investigator/prosecutor
  is structurally walled off from the adjudicator.
* **§ 556(d) — Burden of proof.** "Except as otherwise provided by statute, the
  proponent of a rule or order has the burden of proof."  An order may issue only
  on "reliable, probative, and substantial evidence."
* **§ 556(e) — The exclusive record.** "The transcript of testimony and exhibits,
  together with all papers and requests filed in the proceeding, constitutes the
  exclusive record for decision."  A decision resting on material outside that
  record is procedurally void.
* **§ 557(c) — Reasoned decision.** The decision must include findings and
  conclusions, and the reasons or basis therefor, on all the material issues.

We model the **adjudicatory record** (`FormalAdjudication`) as the dispositive
facts, define `ValidFormalAdjudication` as the conjunction of the §§ 554/556/557
requirements, and prove the structural guarantees: a decision is void if the
decision-maker also investigated or prosecuted, if it rests on evidence outside
the exclusive record, if the proponent did not carry the burden of proof, or if
it lacks the required findings and reasons.
-/

namespace Law.USC.Title5.Adjudication

open Law

/-! ## § 554(d) — Agency personnel and the separation of functions

We track each participating agency employee together with whether that employee
performed an investigative or prosecuting function in the case. -/

/-- An agency employee participating in a formal proceeding. -/
structure AgencyEmployee where
  /-- The employee's identifier. -/
  name : String
  /-- § 554(d): whether the employee performed an investigative or prosecuting
  function in this (or a factually related) case. -/
  investigatedOrProsecuted : Bool
deriving DecidableEq, Repr

/-! ## § 556 — Evidence and the exclusive record

Each evidentiary item carries a flag recording whether it is part of the
official transcript/exhibits — i.e. whether it is *in the record*. -/

/-- An item of evidence considered in the proceeding. -/
structure Evidence where
  /-- The exhibit identifier. -/
  id : Nat
  /-- § 556(e): whether the item is part of the official transcript and
  exhibits (the exclusive record). -/
  inOfficialRecord : Bool
  /-- § 556(d): whether the item is reliable, probative, and substantial. -/
  reliableProbativeSubstantial : Bool
deriving DecidableEq, Repr

/-! ## The adjudicatory record -/

/-- The dispositive record of a formal agency adjudication. -/
structure FormalAdjudication where
  /-- The presiding employee (ALJ / agency) who renders the decision. -/
  decisionMaker : AgencyEmployee
  /-- The evidence the decision actually rests on. -/
  evidenceReliedOn : List Evidence
  /-- § 556(d): whether the proponent of the order carried the burden of proof. -/
  proponentCarriedBurden : Bool
  /-- § 557(c): the findings and conclusions supporting the decision. -/
  findingsAndReasons : String
deriving DecidableEq, Repr

/-! ## Procedural predicates

Each predicate isolates one fine-grained APA requirement. -/

/-- **Separation of functions (§ 554(d)).** The employee who decides the case may
not be one who performed investigative or prosecuting functions in it. -/
def separationOfFunctions (a : FormalAdjudication) : Prop :=
  a.decisionMaker.investigatedOrProsecuted = false

/-- **The exclusive record (§ 556(e)).** Every item of evidence the decision
rests on must be part of the official record. -/
def decisionOnExclusiveRecord (a : FormalAdjudication) : Prop :=
  ∀ e ∈ a.evidenceReliedOn, e.inOfficialRecord = true

/-- **Quality of the evidence (§ 556(d)).** Every item relied on must be
reliable, probative, and substantial. -/
def evidenceIsSubstantial (a : FormalAdjudication) : Prop :=
  ∀ e ∈ a.evidenceReliedOn, e.reliableProbativeSubstantial = true

/-- **A valid formal adjudication.** The conjunction of the §§ 554/556/557
requirements. -/
structure ValidFormalAdjudication (a : FormalAdjudication) : Prop where
  /-- § 554(d): the decision-maker did not investigate or prosecute the case. -/
  separation_of_functions : separationOfFunctions a
  /-- § 556(e): the decision rests only on the exclusive record. -/
  on_exclusive_record : decisionOnExclusiveRecord a
  /-- § 556(d): the proponent carried the burden of proof. -/
  proponent_carried_burden : a.proponentCarriedBurden = true
  /-- § 556(d): the evidence relied on is reliable, probative, and substantial. -/
  evidence_substantial : evidenceIsSubstantial a
  /-- § 557(c): the decision states findings, conclusions, and reasons. -/
  findings_stated : a.findingsAndReasons ≠ ""

/-! ### Structural guarantees & verification lemmas -/

/-- **Separation of functions bites.** A decision rendered by the very employee
who investigated or prosecuted the case cannot issue through a valid formal
adjudication (§ 554(d)). -/
theorem void_if_investigator_decides
    (a : FormalAdjudication)
    (h : a.decisionMaker.investigatedOrProsecuted = true) :
    ¬ ValidFormalAdjudication a := by
  intro hv
  have := hv.separation_of_functions
  rw [separationOfFunctions, h] at this
  exact Bool.noConfusion this

/-- **The exclusive-record rule bites (§ 556(e)).** If the decision rests on any
item of evidence outside the official record, the adjudication is void. -/
theorem void_if_extra_record_evidence
    (a : FormalAdjudication)
    (e : Evidence)
    (h_relied : e ∈ a.evidenceReliedOn)
    (h_outside : e.inOfficialRecord = false) :
    ¬ ValidFormalAdjudication a := by
  intro hv
  have := hv.on_exclusive_record e h_relied
  rw [h_outside] at this
  exact Bool.noConfusion this

/-- **The exclusive-record rule is necessary.** Any valid formal adjudication
rests only on the exclusive record. -/
theorem valid_implies_exclusive_record
    (a : FormalAdjudication)
    (hv : ValidFormalAdjudication a) :
    decisionOnExclusiveRecord a :=
  hv.on_exclusive_record

/-- **Burden of proof bites (§ 556(d)).** If the proponent did not carry the
burden of proof, no order may issue. -/
theorem void_if_burden_not_carried
    (a : FormalAdjudication)
    (h : a.proponentCarriedBurden = false) :
    ¬ ValidFormalAdjudication a := by
  intro hv
  rw [hv.proponent_carried_burden] at h
  exact Bool.noConfusion h

/-- **Unreliable evidence bites (§ 556(d)).** A decision resting on evidence that
is not reliable, probative, and substantial is void. -/
theorem void_if_unsubstantial_evidence
    (a : FormalAdjudication)
    (e : Evidence)
    (h_relied : e ∈ a.evidenceReliedOn)
    (h_weak : e.reliableProbativeSubstantial = false) :
    ¬ ValidFormalAdjudication a := by
  intro hv
  have := hv.evidence_substantial e h_relied
  rw [h_weak] at this
  exact Bool.noConfusion this

/-- **Reasoned decision is necessary (§ 557(c)).** A decision without findings,
conclusions, and reasons is void. -/
theorem void_if_no_findings
    (a : FormalAdjudication)
    (h : a.findingsAndReasons = "") :
    ¬ ValidFormalAdjudication a := by
  intro hv
  exact hv.findings_stated h

/-! ### A worked, fully compliant example

A concrete adjudication satisfying every §§ 554/556/557 requirement, witnessing
that `ValidFormalAdjudication` is satisfiable (not vacuous). -/

/-- A model formal adjudication that complies with §§ 554, 556, and 557. -/
def exampleAdjudication : FormalAdjudication where
  decisionMaker := { name := "ALJ Smith", investigatedOrProsecuted := false }
  evidenceReliedOn :=
    [ { id := 1, inOfficialRecord := true, reliableProbativeSubstantial := true },
      { id := 2, inOfficialRecord := true, reliableProbativeSubstantial := true } ]
  proponentCarriedBurden := true
  findingsAndReasons := "The agency finds the violation proved; see Tr. 12–40."

/-- The worked example is a valid formal adjudication. -/
theorem exampleAdjudication_valid : ValidFormalAdjudication exampleAdjudication where
  separation_of_functions := rfl
  on_exclusive_record := by
    intro e he
    fin_cases he <;> rfl
  proponent_carried_burden := rfl
  evidence_substantial := by
    intro e he
    fin_cases he <;> rfl
  findings_stated := by decide

/-! ## § 557(b) — From initial decision to final agency action

Under § 557(b), the presiding ALJ first issues an *initial decision*, which
"becomes the decision of the agency" unless there is an appeal to, or review by,
the agency.  We model that stage transition explicitly; it is the threshold that
ripens an action for judicial review (developed further alongside § 704).

States of an agency file in a formal proceeding. -/
inductive DecisionStage
  /-- The ALJ's initial (recommended) decision under § 557(b). -/
  | initialDecision
  /-- The matter is on intra-agency appeal or review. -/
  | onAgencyReview
  /-- The agency's final decision. -/
  | finalAgencyDecision
deriving DecidableEq, Repr

/-- § 557(b): if there is no appeal to or review by the agency, the ALJ's initial
decision *becomes* the final decision of the agency.  Otherwise the matter moves
to agency review before becoming final. -/
def nextStage (taken : Bool) : DecisionStage :=
  if taken then DecisionStage.onAgencyReview else DecisionStage.finalAgencyDecision

/-- With no appeal or review taken, the initial decision becomes the agency's
final decision (§ 557(b)). -/
theorem initial_becomes_final_without_review :
    nextStage false = DecisionStage.finalAgencyDecision := rfl

/-- When agency review is taken, the matter does not yet become final; it moves to
the agency-review stage. -/
theorem review_taken_not_yet_final :
    nextStage true = DecisionStage.onAgencyReview := rfl

/-! ## Content addresses of the cited Title 5 sections

The formal-adjudication provisions are placed at Title 5, Chapter 5
(Administrative Procedure), consistent with § 553. -/

/-- `§ n` of Title 5, Chapter 5 (Administrative Procedure) as a `USCCitation`. -/
def cite (n : Nat) : USCCitation := ⟨5, 5, n⟩

/-- Distinct adjudication sections receive distinct content addresses. -/
theorem adjudication_addresses_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  intro h'
  exact h (congrArg USCCitation.«section» (USCCitation.address_injective h'))

/-- The §§ 554/556/557 provisions never collide with the constitutional
pseudo-title `0`. -/
theorem adjudication_distinct_from_constitution (s : Nat) (c : USCCitation)
    (hc : c.title = 0) :
    (cite s).address ≠ c.address := by
  intro h
  have heq := USCCitation.address_injective h
  rw [← heq] at hc
  simp [cite] at hc

end Law.USC.Title5.Adjudication
