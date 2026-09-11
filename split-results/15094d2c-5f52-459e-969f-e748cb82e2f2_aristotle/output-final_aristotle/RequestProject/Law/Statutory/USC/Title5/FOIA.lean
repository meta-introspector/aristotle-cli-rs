import Mathlib
import RequestProject.Law.CodeStructure

/-!
# 5 U.S.C. § 552 — The Freedom of Information Act Processing Pipeline

This file models, **bottom-up and details-first**, the deterministic agency
response sequence the Freedom of Information Act prescribes for a records
request: receipt, search, exemption assessment, and the statutory time limits.

The statute fixes the pipeline:

* **§ 552(a)(3)(A) — Search predicate.** Upon "any request for records which
  (i) reasonably describes such records and (ii) is made in accordance with
  published rules," the agency "shall make the records promptly available."  A
  request that does not reasonably describe the records does not trigger the
  duty.
* **§ 552(b) — Exemptions.** Nine enumerated exemptions (e.g. (b)(1) classified
  national defense, (b)(6) personal privacy, (b)(7) law enforcement records).
  Only material falling within an exemption may be withheld; everything else
  must be released, and "[a]ny reasonably segregable portion" of a record must be
  provided after deletion of the exempt portions.
* **§ 552(a)(6)(A)(i) — The 20-day clock.** The agency must determine whether to
  comply "within 20 days (excepting Saturdays, Sundays, and legal public
  holidays)" after receipt of the request.
* **§ 552(a)(6)(B) — Unusual circumstances.** In unusual circumstances the time
  limit may be extended by written notice for not more than 10 additional working
  days.

We model the **FOIA request record** (`FOIARequest`), define `validFOIAResponse`
as the conjunction of the § 552 requirements, and prove the structural
guarantees: a non-describing request triggers no duty, withholding non-exempt
material is unlawful, exempt material may be withheld, segregable portions must
be released, and the response is untimely if it overruns the (possibly extended)
statutory clock.
-/

namespace Law.USC.Title5.FOIA

open Law

/-! ## § 552(b) — The nine statutory exemptions -/

/-- The nine enumerated FOIA exemptions of § 552(b). -/
inductive Exemption
  /-- (b)(1) classified national defense / foreign policy. -/
  | nationalDefense
  /-- (b)(2) internal personnel rules and practices. -/
  | internalPersonnel
  /-- (b)(3) specifically exempted by other statute. -/
  | otherStatute
  /-- (b)(4) trade secrets and confidential commercial information. -/
  | tradeSecrets
  /-- (b)(5) inter-agency or intra-agency privileged memoranda. -/
  | privilegedMemoranda
  /-- (b)(6) personal privacy. -/
  | personalPrivacy
  /-- (b)(7) law enforcement records. -/
  | lawEnforcement
  /-- (b)(8) financial institution regulation. -/
  | financialRegulation
  /-- (b)(9) geological and geophysical information about wells. -/
  | geological
deriving DecidableEq, Repr, Fintype

/-! ## Records and the request -/

/-- A record held by the agency that is responsive to the request. -/
structure Record where
  /-- The record identifier. -/
  id : Nat
  /-- The exemption (if any) under which the record is properly withholdable;
  `none` means the record is not exempt and must be released. -/
  exemption : Option Exemption
  /-- Whether the record contains a reasonably segregable non-exempt portion that
  must be released after redaction (§ 552(b), final sentence). -/
  hasSegregablePortion : Bool
deriving DecidableEq, Repr

/-- The dispositive record of a FOIA request and the agency's handling of it. -/
structure FOIARequest where
  /-- § 552(a)(3)(A)(i): whether the request reasonably describes the records. -/
  reasonablyDescribes : Bool
  /-- § 552(a)(3)(A)(ii): whether the request follows the agency's published
  rules. -/
  followsPublishedRules : Bool
  /-- The responsive records located by the agency's search. -/
  responsiveRecords : List Record
  /-- The records (by id) the agency actually withheld. -/
  withheldIds : List Nat
  /-- § 552(a)(6)(A)(i): the number of working days the agency took to respond. -/
  responseDays : Nat
  /-- § 552(a)(6)(B): whether the agency invoked (by written notice) the
  unusual-circumstances extension. -/
  unusualCircumstances : Bool
deriving DecidableEq, Repr

/-! ## Procedural predicates -/

/-- **The search predicate (§ 552(a)(3)(A)).** The agency's duty to search and
produce is triggered only by a request that reasonably describes the records and
follows the published rules. -/
def triggersDuty (r : FOIARequest) : Prop :=
  r.reasonablyDescribes = true ∧ r.followsPublishedRules = true

/-- **The statutory time limit (§ 552(a)(6)).** The base limit is 20 working
days, extended to 30 if (and only if) the agency invoked the
unusual-circumstances extension. -/
def statutoryLimit (r : FOIARequest) : Nat :=
  if r.unusualCircumstances then 30 else 20

/-- **Timeliness (§ 552(a)(6)).** The response is timely iff it issues within the
(possibly extended) statutory limit. -/
def timely (r : FOIARequest) : Prop :=
  r.responseDays ≤ statutoryLimit r

/-- **Lawful withholding (§ 552(b)).** A record is properly withheld only if it
falls within an exemption; only such records may appear on the withheld list, and
a wholly-exempt record with no segregable portion may be withheld in full. -/
def withholdingLawful (r : FOIARequest) : Prop :=
  ∀ rec ∈ r.responsiveRecords, rec.id ∈ r.withheldIds → rec.exemption.isSome = true

/-- **Segregability (§ 552(b), final sentence).** A record that is exempt but
contains a reasonably segregable non-exempt portion may not be withheld *in
full*: the segregable portion must be released, so the record's id may not appear
on the withheld list. -/
def segregablePortionsReleased (r : FOIARequest) : Prop :=
  ∀ rec ∈ r.responsiveRecords, rec.hasSegregablePortion = true → rec.id ∉ r.withheldIds

/-- **A valid FOIA response.** The conjunction of the § 552 requirements,
predicated on a request that triggers the duty. -/
structure ValidFOIAResponse (r : FOIARequest) : Prop where
  /-- The request triggered the agency's duty to respond. -/
  duty_triggered : triggersDuty r
  /-- § 552(a)(6): the response is timely. -/
  is_timely : timely r
  /-- § 552(b): only exempt records were withheld. -/
  withholding_lawful : withholdingLawful r
  /-- § 552(b): reasonably segregable portions were released. -/
  segregable_released : segregablePortionsReleased r

/-! ### Structural guarantees -/

/-- **The search predicate bites.** A request that does not reasonably describe
the records does not trigger the agency's duty. -/
theorem no_duty_if_vague
    (r : FOIARequest)
    (h : r.reasonablyDescribes = false) :
    ¬ triggersDuty r := by
  rintro ⟨hd, _⟩
  rw [h] at hd
  exact Bool.noConfusion hd

/-- **Published-rules predicate bites.** A request not made under the published
rules does not trigger the duty. -/
theorem no_duty_if_rules_ignored
    (r : FOIARequest)
    (h : r.followsPublishedRules = false) :
    ¬ triggersDuty r := by
  rintro ⟨_, hr⟩
  rw [h] at hr
  exact Bool.noConfusion hr

/-- **Unlawful withholding bites (§ 552(b)).** Withholding a non-exempt record
makes the response invalid. -/
theorem invalid_if_nonexempt_withheld
    (r : FOIARequest)
    (rec : Record)
    (h_resp : rec ∈ r.responsiveRecords)
    (h_withheld : rec.id ∈ r.withheldIds)
    (h_not_exempt : rec.exemption = none) :
    ¬ ValidFOIAResponse r := by
  intro hv
  have := hv.withholding_lawful rec h_resp h_withheld
  rw [h_not_exempt] at this
  exact Bool.noConfusion this

/-- **Lawful withholding of exempt material.** An exempt record (with no
segregable portion) may be withheld in full without rendering the response
invalid — exemptions are genuine, not vacuous. -/
theorem exempt_record_may_be_withheld
    (rec : Record)
    (h : rec.exemption.isSome = true) :
    ∃ r : FOIARequest, rec ∈ r.responsiveRecords ∧ rec.id ∈ r.withheldIds ∧
      withholdingLawful r := by
  refine ⟨{ reasonablyDescribes := true, followsPublishedRules := true,
            responsiveRecords := [rec], withheldIds := [rec.id],
            responseDays := 0, unusualCircumstances := false }, ?_, ?_, ?_⟩
  · exact List.mem_singleton.mpr rfl
  · exact List.mem_singleton.mpr rfl
  · intro rec' hrec' _
    rw [List.mem_singleton] at hrec'
    subst hrec'
    exact h

/-- **Segregability bites (§ 552(b)).** A record that contains a reasonably
segregable non-exempt portion may not be withheld in full; doing so invalidates
the response. -/
theorem invalid_if_segregable_withheld
    (r : FOIARequest)
    (rec : Record)
    (h_resp : rec ∈ r.responsiveRecords)
    (h_seg : rec.hasSegregablePortion = true)
    (h_withheld : rec.id ∈ r.withheldIds) :
    ¬ ValidFOIAResponse r := by
  intro hv
  exact hv.segregable_released rec h_resp h_seg h_withheld

/-- **The 20-day clock bites.** Absent the unusual-circumstances extension, a
response taking more than 20 working days is untimely. -/
theorem untimely_if_over_twenty
    (r : FOIARequest)
    (h_normal : r.unusualCircumstances = false)
    (h_slow : r.responseDays > 20) :
    ¬ timely r := by
  have hlim : statutoryLimit r = 20 := by simp [statutoryLimit, h_normal]
  rw [timely, hlim]
  omega

/-- **The extended clock bites.** Even with the unusual-circumstances extension, a
response taking more than 30 working days is untimely. -/
theorem untimely_if_over_thirty
    (r : FOIARequest)
    (h_slow : r.responseDays > 30) :
    ¬ timely r := by
  have hlim : statutoryLimit r ≤ 30 := by
    unfold statutoryLimit; cases r.unusualCircumstances <;> simp
  rw [timely]
  omega

/-! ### A worked, fully compliant example -/

/-- A model FOIA response: a well-described request, answered in 15 working days,
withholding one genuinely exempt record (no segregable portion) and releasing the
rest. -/
def exampleRequest : FOIARequest where
  reasonablyDescribes := true
  followsPublishedRules := true
  responsiveRecords :=
    [ { id := 1, exemption := none, hasSegregablePortion := false },
      { id := 2, exemption := some Exemption.personalPrivacy,
        hasSegregablePortion := false } ]
  withheldIds := [2]
  responseDays := 15
  unusualCircumstances := false

/-- The worked example is a valid FOIA response. -/
theorem exampleRequest_valid : ValidFOIAResponse exampleRequest where
  duty_triggered := ⟨rfl, rfl⟩
  is_timely := by
    have hlim : statutoryLimit exampleRequest = 20 := by
      simp [statutoryLimit, exampleRequest]
    rw [timely, hlim]
    decide
  withholding_lawful := by
    intro rec hrec hwith
    fin_cases hrec
    · simp [exampleRequest] at hwith
    · rfl
  segregable_released := by
    intro rec hrec hseg
    fin_cases hrec <;> simp at hseg

/-! ## Content addresses

§ 552 lives in Title 5, Chapter 5 (Administrative Procedure). -/

/-- `§ n` of Title 5, Chapter 5 (Administrative Procedure) as a `USCCitation`. -/
def cite (n : Nat) : USCCitation := ⟨5, 5, n⟩

/-- Distinct FOIA-chapter sections receive distinct content addresses. -/
theorem foia_addresses_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  intro h'
  exact h (congrArg USCCitation.«section» (USCCitation.address_injective h'))

/-- The § 552 provisions never collide with the constitutional pseudo-title `0`. -/
theorem foia_distinct_from_constitution (s : Nat) (c : USCCitation)
    (hc : c.title = 0) :
    (cite s).address ≠ c.address := by
  intro h
  have heq := USCCitation.address_injective h
  rw [← heq] at hc
  simp [cite] at hc

end Law.USC.Title5.FOIA
