import Mathlib
import RequestProject.Law.CodeStructure

/-!
# Subject-matter jurisdiction of the federal courts — 28 U.S.C. (and Art. III)

Before a federal court may reach the merits of a case it must possess
*subject-matter jurisdiction* — the constitutional and statutory power to hear
the *kind* of case presented.  Unlike personal jurisdiction or venue, it can
never be waived or forfeited and may be raised at any time.

This module formalizes the two principal heads of original district-court
jurisdiction and the Supreme Court's twofold jurisdiction:

* **Federal-question jurisdiction** (28 U.S.C. § 1331) under the *well-pleaded
  complaint* rule: the federal question must appear on the face of the
  plaintiff's own claim, not by way of anticipated defense.
* **Diversity jurisdiction** (28 U.S.C. § 1332) requiring *complete* diversity
  of citizenship and an amount in controversy *exceeding* \$75,000.
* **Supreme Court original jurisdiction** (Art. III, § 2, cl. 2; 28 U.S.C.
  § 1251) — a fixed constitutional list Congress can neither enlarge nor
  contract (*Marbury v. Madison*).
* **Supreme Court appellate jurisdiction** over a state court's final judgment
  (28 U.S.C. § 1257): a final judgment of the highest state court turning on a
  federal question.

Each head is modeled as the dispositive jurisdictional facts plus a rule, with
proven necessity guarantees.
-/

namespace Law.Judicial.Jurisdiction

open Law

/-! ## § 1331 — Federal-question jurisdiction (the well-pleaded complaint rule)

> The district courts shall have original jurisdiction of all civil actions
> arising under the Constitution, laws, or treaties of the United States.

Under the *well-pleaded complaint* rule, "arising under" is tested by the
plaintiff's own statement of the claim: a federal issue that surfaces only as a
defense (or as an anticipated defense, even a federal pre-emption defense) does
*not* confer § 1331 jurisdiction. -/

/-- The facts bearing on federal-question jurisdiction. -/
structure FederalQuestionCase where
  /-- A federal issue appears on the face of the plaintiff's well-pleaded
  complaint (the claim itself arises under federal law). -/
  federalQuestionOnFaceOfComplaint : Bool
  /-- The only federal issue is raised by way of (anticipated) defense. -/
  federalIssueOnlyInDefense : Bool
deriving DecidableEq, Repr

/-- § 1331 jurisdiction exists iff a federal question appears on the face of the
plaintiff's well-pleaded complaint. -/
def FederalQuestionCase.hasJurisdiction (c : FederalQuestionCase) : Prop :=
  c.federalQuestionOnFaceOfComplaint = true

/-- A case whose only federal issue is a defense, with no federal question on the
face of the complaint, does not arise under federal law for § 1331 purposes. -/
theorem no_federal_question_from_defense (c : FederalQuestionCase)
    (h : c.federalQuestionOnFaceOfComplaint = false) :
    ¬ c.hasJurisdiction := by
  simp [FederalQuestionCase.hasJurisdiction, h]

/-- A federal question on the face of the complaint confers § 1331
jurisdiction. -/
theorem federal_question_confers_jurisdiction (c : FederalQuestionCase)
    (h : c.federalQuestionOnFaceOfComplaint = true) :
    c.hasJurisdiction := h

/-! ## § 1332 — Diversity jurisdiction

> The district courts shall have original jurisdiction of all civil actions
> where the matter in controversy exceeds the sum or value of \$75,000 ... and
> is between ... citizens of different States ...

Two independent requirements: **complete diversity** (no plaintiff shares
citizenship with any defendant) and an amount in controversy *strictly
exceeding* the \$75,000 threshold (the threshold amount itself is not enough). -/

/-- The statutory amount-in-controversy threshold for § 1332 (in dollars).  The
amount in controversy must *exceed* this number. -/
def diversityThreshold : Nat := 75000

/-- The facts bearing on diversity jurisdiction. -/
structure DiversityCase where
  /-- Complete diversity: no plaintiff is a co-citizen of any defendant. -/
  completeDiversity : Bool
  /-- The amount in controversy, in dollars. -/
  amountInControversy : Nat
deriving DecidableEq, Repr

/-- § 1332 jurisdiction exists iff there is complete diversity *and* the amount
in controversy exceeds \$75,000. -/
def DiversityCase.hasJurisdiction (c : DiversityCase) : Prop :=
  c.completeDiversity = true ∧ c.amountInControversy > diversityThreshold

/-- Without complete diversity there is no § 1332 jurisdiction, however large the
stakes (a single co-citizen defeats diversity). -/
theorem no_diversity_without_complete_diversity (c : DiversityCase)
    (h : c.completeDiversity = false) :
    ¬ c.hasJurisdiction := by
  rintro ⟨hd, _⟩
  rw [h] at hd
  exact Bool.noConfusion hd

/-- An amount in controversy at or below the threshold defeats § 1332
jurisdiction (the threshold must be *exceeded*). -/
theorem no_diversity_at_threshold (c : DiversityCase)
    (h : c.amountInControversy ≤ diversityThreshold) :
    ¬ c.hasJurisdiction := by
  rintro ⟨_, ha⟩
  omega

/-- Complete diversity together with an amount in controversy exceeding the
threshold confers § 1332 jurisdiction. -/
theorem diversity_jurisdiction_of_elements (c : DiversityCase)
    (hd : c.completeDiversity = true)
    (ha : c.amountInControversy > diversityThreshold) :
    c.hasJurisdiction := ⟨hd, ha⟩

/-- Exactly \$75,000 is *not* enough — a worked instance of the strict-exceeds
rule. -/
theorem exactly_threshold_insufficient :
    ¬ (DiversityCase.mk true diversityThreshold).hasJurisdiction := by
  rintro ⟨_, ha⟩
  simp [diversityThreshold] at ha

/-! ## Original jurisdiction of the district courts

A federal district court has original subject-matter jurisdiction over a civil
action if it falls within *either* head (federal question or diversity).  This is
the disjunctive jurisdictional gate the court tests at the threshold. -/

/-- A civil action presented to a district court, carrying both jurisdictional
profiles. -/
structure DistrictCase where
  /-- The federal-question profile. -/
  fq : FederalQuestionCase
  /-- The diversity profile. -/
  div : DiversityCase
deriving Repr

/-- A district court has original jurisdiction iff the action satisfies federal-
question *or* diversity jurisdiction. -/
def DistrictCase.hasOriginalJurisdiction (c : DistrictCase) : Prop :=
  c.fq.hasJurisdiction ∨ c.div.hasJurisdiction

/-- An action presenting a federal question has district-court jurisdiction even
without diversity. -/
theorem original_jurisdiction_of_federal_question (c : DistrictCase)
    (h : c.fq.hasJurisdiction) : c.hasOriginalJurisdiction := Or.inl h

/-- An action with complete diversity and a sufficient amount has district-court
jurisdiction even without any federal question. -/
theorem original_jurisdiction_of_diversity (c : DistrictCase)
    (h : c.div.hasJurisdiction) : c.hasOriginalJurisdiction := Or.inr h

/-- If neither head is satisfied, the district court lacks original
jurisdiction. -/
theorem no_original_jurisdiction (c : DistrictCase)
    (hfq : ¬ c.fq.hasJurisdiction) (hdiv : ¬ c.div.hasJurisdiction) :
    ¬ c.hasOriginalJurisdiction := by
  rintro (h | h)
  · exact hfq h
  · exact hdiv h

/-! ## §§ 1251, 1257 — Supreme Court jurisdiction

The Constitution itself fixes the Supreme Court's *original* jurisdiction
(Art. III, § 2, cl. 2; restated in 28 U.S.C. § 1251) — cases affecting
ambassadors, other public ministers and consuls, and those in which a State is a
party.  *Marbury v. Madison*, 5 U.S. (1 Cranch) 137 (1803), holds that this list
is exhaustive: Congress may *neither enlarge nor contract* the Court's original
jurisdiction.  All other Supreme Court jurisdiction is *appellate*, including
review of a state court's final judgment under § 1257.  -/

/-- The constitutionally enumerated categories of the Supreme Court's original
jurisdiction (Art. III, § 2, cl. 2). -/
inductive OriginalJurisdictionCategory
  /-- Cases affecting ambassadors, other public ministers and consuls. -/
  | ambassadorsMinistersConsuls
  /-- Cases in which a State shall be a party. -/
  | stateIsParty
deriving DecidableEq, Repr, Fintype

/-- Whether a matter falls within the Court's *original* jurisdiction: exactly
when it fits one of the two constitutional categories. -/
def fitsOriginalJurisdiction (cat : Option OriginalJurisdictionCategory) : Prop :=
  cat.isSome = true

/-- **Marbury.** The Court's original jurisdiction is the constitutional list and
nothing more: a matter outside both enumerated categories is *not* within
original jurisdiction, and (the *Marbury* holding) Congress cannot place it there
by statute. -/
theorem no_original_jurisdiction_outside_enumeration :
    ¬ fitsOriginalJurisdiction (none) := by
  simp [fitsOriginalJurisdiction]

/-- A matter affecting ambassadors falls within original jurisdiction. -/
theorem ambassadors_within_original_jurisdiction :
    fitsOriginalJurisdiction
      (some OriginalJurisdictionCategory.ambassadorsMinistersConsuls) := by
  simp [fitsOriginalJurisdiction]

/-- A matter in which a State is a party falls within original jurisdiction. -/
theorem state_party_within_original_jurisdiction :
    fitsOriginalJurisdiction
      (some OriginalJurisdictionCategory.stateIsParty) := by
  simp [fitsOriginalJurisdiction]

/-- The facts bearing on Supreme Court appellate review of a state-court judgment
(28 U.S.C. § 1257). -/
structure StateCourtAppeal where
  /-- The judgment is *final* and was rendered by the highest state court in
  which a decision could be had. -/
  finalJudgmentOfHighestStateCourt : Bool
  /-- The case turns on a federal question (validity/construction of federal law,
  or a claimed federal right). -/
  federalQuestionPresented : Bool
deriving DecidableEq, Repr

/-- § 1257 appellate jurisdiction over a state-court judgment exists iff the
judgment is final from the highest state court *and* a federal question is
presented. -/
def StateCourtAppeal.reviewable (a : StateCourtAppeal) : Prop :=
  a.finalJudgmentOfHighestStateCourt = true ∧ a.federalQuestionPresented = true

/-- A non-final state-court judgment is not reviewable under § 1257. -/
theorem not_reviewable_if_not_final (a : StateCourtAppeal)
    (h : a.finalJudgmentOfHighestStateCourt = false) : ¬ a.reviewable := by
  rintro ⟨hf, _⟩
  rw [h] at hf
  exact Bool.noConfusion hf

/-- A state-court judgment resting on adequate and independent state grounds
(no federal question) is not reviewable under § 1257. -/
theorem not_reviewable_without_federal_question (a : StateCourtAppeal)
    (h : a.federalQuestionPresented = false) : ¬ a.reviewable := by
  rintro ⟨_, hq⟩
  rw [h] at hq
  exact Bool.noConfusion hq

/-- A final state-court judgment presenting a federal question is reviewable. -/
theorem reviewable_of_final_and_federal (a : StateCourtAppeal)
    (hf : a.finalJudgmentOfHighestStateCourt = true)
    (hq : a.federalQuestionPresented = true) : a.reviewable := ⟨hf, hq⟩

/-! ## Worked examples -/

/-- A pure state-law contract suit between citizens of different States for
\$100,000: diversity, but no federal question. -/
def exampleDiversityOnly : DistrictCase where
  fq := ⟨false, false⟩
  div := ⟨true, 100000⟩

theorem exampleDiversityOnly_jurisdiction :
    exampleDiversityOnly.hasOriginalJurisdiction := by
  refine Or.inr ⟨rfl, ?_⟩
  simp [diversityThreshold, exampleDiversityOnly]

/-- A federal civil-rights claim between co-citizens for \$1: federal question,
no diversity, yet the district court has jurisdiction. -/
def exampleFederalQuestionOnly : DistrictCase where
  fq := ⟨true, false⟩
  div := ⟨false, 1⟩

theorem exampleFederalQuestionOnly_jurisdiction :
    exampleFederalQuestionOnly.hasOriginalJurisdiction := Or.inl rfl

/-! ## Content addressing

Title 28 of the U.S. Code is the Judiciary and Judicial Procedure.  The
district-court jurisdiction provisions (§§ 1331, 1332) sit in Chapter 85; the
Supreme Court provisions (§§ 1251, 1257) sit in Chapter 81. -/

/-- 28 U.S.C. § 1331 (federal-question jurisdiction). -/
def cite1331 : USCCitation := ⟨28, 85, 1331⟩

/-- 28 U.S.C. § 1332 (diversity jurisdiction). -/
def cite1332 : USCCitation := ⟨28, 85, 1332⟩

/-- 28 U.S.C. § 1251 (Supreme Court original jurisdiction). -/
def cite1251 : USCCitation := ⟨28, 81, 1251⟩

/-- 28 U.S.C. § 1257 (Supreme Court appellate jurisdiction over state courts). -/
def cite1257 : USCCitation := ⟨28, 81, 1257⟩

/-- The four jurisdictional citations are pairwise distinct in the content-address
space. -/
theorem jurisdiction_citations_distinct :
    cite1331.address ≠ cite1332.address ∧
    cite1331.address ≠ cite1251.address ∧
    cite1331.address ≠ cite1257.address ∧
    cite1332.address ≠ cite1251.address ∧
    cite1332.address ≠ cite1257.address ∧
    cite1251.address ≠ cite1257.address := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    intro h <;>
    · have := USCCitation.address_injective h
      simp [cite1331, cite1332, cite1251, cite1257] at this

/-- The Title 28 jurisdiction provisions never collide with the constitutional
pseudo-title `0`. -/
theorem jurisdiction_distinct_from_constitution (c : USCCitation)
    (hc : c.title = 0) : cite1331.address ≠ c.address := by
  intro h
  have heq := USCCitation.address_injective h
  rw [← heq] at hc
  simp [cite1331] at hc

end Law.Judicial.Jurisdiction
