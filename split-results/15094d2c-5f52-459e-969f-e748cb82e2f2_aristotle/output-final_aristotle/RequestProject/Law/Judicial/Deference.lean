import Mathlib
import RequestProject.Law.CodeStructure

/-!
# Judicial Deference — Skidmore, Chevron, and *Loper Bright*

This file builds the **deference overlay** of the judicial layer: the doctrines
that fix *whose* reading of an ambiguous statute governs when an agency has
construed the statute it administers and a court is asked to review that
construction.

The deference doctrines are case law (a fixed-point overlay on the statutory
text), but they are grounded in the Administrative Procedure Act's command that
"the reviewing court shall decide all relevant questions of law, interpret
constitutional and statutory provisions, and determine the meaning or
applicability of the terms of an agency action" (5 U.S.C. § 706).  *Loper Bright
Enterprises v. Raimondo*, 603 U.S. 369 (2024), reads that command to require
courts to exercise *independent judgment* about the best reading of a statute,
and on that basis **overruled** *Chevron U.S.A. Inc. v. Natural Resources
Defense Council*, 467 U.S. 837 (1984).

We model the three frameworks as functions from the dispositive facts of an
interpretive question to the outcome — *whose* interpretation governs — and prove
the structural guarantees that distinguish them:

* **Skidmore** (*Skidmore v. Swift & Co.*, 323 U.S. 134 (1944)) — an agency view
  is entitled to *respect* proportional to its "power to persuade," a function of
  the thoroughness of its consideration, the validity of its reasoning, its
  consistency, and the agency's relative expertise.  It never *binds*.
* **Chevron** (the overruled regime) — a *two-step* test: if the statute is clear
  the court follows it; if it is *ambiguous* and the agency's construction is
  *reasonable*, the court defers and the agency's construction *controls* — even
  if it is not the reading the court would independently reach.
* **Loper Bright** (the governing regime) — the court always exercises
  independent judgment to find the single best reading; statutory ambiguity is
  *not* an implied delegation and triggers *no* deference.  The agency's view
  governs only where Congress *expressly delegated* discretionary authority and
  the agency stayed within (and reasonably exercised) the bounds of that
  delegation.
-/

namespace Law.Judicial.Deference

open Law

/-! ## The interpretive question

We record the facts that the competing frameworks turn on:

* whether the traditional tools of construction yield a single best reading
  (`textClear`);
* whether the agency's construction coincides with that best reading
  (`agencyMatchesBestReading`);
* whether the agency's construction is at least *reasonable* / permissible
  (`agencyReasonable`) — the Chevron step-two question;
* whether Congress *expressly delegated* discretionary authority to the agency
  (`expressDelegation`) — the *Loper Bright* carve-out; and
* whether the agency acted *within* (and reasonably exercised) the bounds of any
  such delegation (`withinDelegatedBounds`).
-/

/-- The dispositive facts of an interpretive question about a statute an agency
administers. -/
structure InterpretiveQuestion where
  /-- Whether the traditional tools of statutory construction yield a single
  best reading (the statute is unambiguous). -/
  textClear : Bool
  /-- Whether the agency's construction coincides with the court's best reading. -/
  agencyMatchesBestReading : Bool
  /-- Chevron step two: whether the agency's construction is reasonable /
  permissible. -/
  agencyReasonable : Bool
  /-- Whether Congress *expressly delegated* discretionary authority to the
  agency to give meaning to a particular term (the *Loper Bright* carve-out). -/
  expressDelegation : Bool
  /-- Whether the agency stayed within, and reasonably exercised, the bounds of
  any express delegation. -/
  withinDelegatedBounds : Bool
deriving DecidableEq, Repr

/-- Who prevails on the question of law: the agency's construction, or the
court's own best reading. -/
inductive Governs where
  /-- The agency's construction controls. -/
  | agencyInterpretation : Governs
  /-- The court's independent best reading controls. -/
  | courtBestReading : Governs
deriving DecidableEq, Repr

/-! ## The Chevron two-step (the overruled regime) -/

/-- **Chevron resolution.** Step one: if the statute is clear, the clear meaning
controls (the court's reading). Step two: if it is ambiguous and the agency's
construction is reasonable, the court *defers* and the agency's construction
controls; otherwise the court's reading controls. -/
def chevronGoverns (q : InterpretiveQuestion) : Governs :=
  if q.textClear then Governs.courtBestReading
  else if q.agencyReasonable then Governs.agencyInterpretation
  else Governs.courtBestReading

/-- **Chevron deference.** The proposition that *Chevron* defers to the agency on
this question: the statute is ambiguous and the agency's construction is
reasonable. -/
def chevronDefers (q : InterpretiveQuestion) : Prop :=
  q.textClear = false ∧ q.agencyReasonable = true

/-! ## *Loper Bright* (the governing regime) -/

/-- **Loper Bright resolution.** The court exercises independent judgment to
reach the single best reading. The agency's view governs only where Congress
expressly delegated discretionary authority *and* the agency stayed within the
bounds of that delegation; otherwise the court's best reading controls. -/
def loperGoverns (q : InterpretiveQuestion) : Governs :=
  if q.expressDelegation && q.withinDelegatedBounds then
    Governs.agencyInterpretation
  else
    Governs.courtBestReading

/-- **Loper Bright deference.** The agency's view governs only via an express,
bounded delegation — never from ambiguity alone. -/
def loperDefers (q : InterpretiveQuestion) : Prop :=
  q.expressDelegation = true ∧ q.withinDelegatedBounds = true

/-! ### Worked example questions -/

/-- A question with an ambiguous statute, a reasonable but non-best agency
construction, and no express delegation: the paradigm post-*Loper Bright* shift. -/
def exampleShifted : InterpretiveQuestion where
  textClear := false
  agencyMatchesBestReading := false
  agencyReasonable := true
  expressDelegation := false
  withinDelegatedBounds := false

/-- A question with an express, bounded delegation: the agency governs under both
regimes. -/
def exampleDelegated : InterpretiveQuestion where
  textClear := false
  agencyMatchesBestReading := false
  agencyReasonable := true
  expressDelegation := true
  withinDelegatedBounds := true

/-! ### Structural guarantees: the two-step

Under *Chevron*, a clear statute is followed and a reasonable construction of an
ambiguous statute controls. -/

/-- **Chevron step one.** A clear statute is read by the court; there is no
deference. -/
theorem chevron_no_deference_if_clear (q : InterpretiveQuestion)
    (h : q.textClear = true) :
    chevronGoverns q = Governs.courtBestReading := by
  simp [chevronGoverns, h]

/-- **Chevron step two — deference.** When the statute is ambiguous and the
agency's construction is reasonable, the agency's construction controls. -/
theorem chevron_defers_on_ambiguity (q : InterpretiveQuestion)
    (h₁ : q.textClear = false) (h₂ : q.agencyReasonable = true) :
    chevronGoverns q = Governs.agencyInterpretation := by
  simp [chevronGoverns, h₁, h₂]

/-- **Chevron step two — no deference to an unreasonable construction.** An
ambiguous statute plus an unreasonable agency construction leaves the court's
reading in control. -/
theorem chevron_no_deference_if_unreasonable (q : InterpretiveQuestion)
    (h₁ : q.textClear = false) (h₂ : q.agencyReasonable = false) :
    chevronGoverns q = Governs.courtBestReading := by
  simp [chevronGoverns, h₁, h₂]

/-- `chevronGoverns` agrees with the `chevronDefers` predicate: the agency wins
exactly when *Chevron* defers. -/
theorem chevron_governs_iff_defers (q : InterpretiveQuestion) :
    chevronGoverns q = Governs.agencyInterpretation ↔ chevronDefers q := by
  unfold chevronGoverns chevronDefers
  cases h1 : q.textClear <;> cases h2 : q.agencyReasonable <;> simp_all

/-- **The vice *Loper Bright* identified.** Under *Chevron*, the agency's
construction can control even when it is *not* the court's best reading: there is
a question on which `chevronGoverns` picks the agency although the agency does not
match the best reading. -/
theorem chevron_can_override_best_reading :
    ∃ q : InterpretiveQuestion,
      chevronGoverns q = Governs.agencyInterpretation ∧
      q.agencyMatchesBestReading = false :=
  ⟨exampleShifted, by decide, by decide⟩

/-! ### Structural guarantees: *Loper Bright* -/

/-- **No deference from ambiguity.** Under *Loper Bright*, statutory ambiguity
without an express delegation does *not* hand the question to the agency; the
court's independent best reading controls. -/
theorem loper_no_deference_from_ambiguity (q : InterpretiveQuestion)
    (h : q.expressDelegation = false) :
    loperGoverns q = Governs.courtBestReading := by
  simp [loperGoverns, h]

/-- **Express delegations are still respected.** Where Congress expressly
delegated discretionary authority and the agency stayed within the bounds, the
agency's exercise governs even under *Loper Bright*. -/
theorem loper_respects_express_delegation (q : InterpretiveQuestion)
    (h₁ : q.expressDelegation = true) (h₂ : q.withinDelegatedBounds = true) :
    loperGoverns q = Governs.agencyInterpretation := by
  simp [loperGoverns, h₁, h₂]

/-- **Delegations have outer bounds.** An agency that exceeds the bounds of its
delegation does not get deference; the court's reading controls. -/
theorem loper_no_deference_outside_bounds (q : InterpretiveQuestion)
    (h : q.withinDelegatedBounds = false) :
    loperGoverns q = Governs.courtBestReading := by
  simp [loperGoverns, h]

/-- `loperGoverns` agrees with the `loperDefers` predicate. -/
theorem loper_governs_iff_defers (q : InterpretiveQuestion) :
    loperGoverns q = Governs.agencyInterpretation ↔ loperDefers q := by
  unfold loperGoverns loperDefers
  cases h1 : q.expressDelegation <;> cases h2 : q.withinDelegatedBounds <;> simp_all

/-! ### The doctrinal shift: *Loper Bright* overrules *Chevron* -/

/-- **The frameworks diverge.** There is an interpretive question on which
*Chevron* would defer to the agency yet *Loper Bright* would not: an ambiguous
statute, a reasonable agency construction, but no express delegation.  This is
exactly the class of cases the 2024 decision moved out of agency control and back
to the courts. -/
theorem chevron_and_loper_diverge :
    ∃ q : InterpretiveQuestion,
      chevronGoverns q = Governs.agencyInterpretation ∧
      loperGoverns q = Governs.courtBestReading :=
  ⟨exampleShifted, by decide, by decide⟩

/-- **The shifted class lands with the courts under *Loper Bright*.** An
ambiguous statute whose reasonable agency construction rests on *no* express
delegation is decided by the court under *Loper Bright*, even though *Chevron*
would have deferred.  (Stated over the divergence facts: ambiguous, reasonable,
but no express delegation.) -/
theorem loper_keeps_shifted_class (q : InterpretiveQuestion)
    (h_ambiguous : q.textClear = false)
    (h_reasonable : q.agencyReasonable = true)
    (h_no_delegation : q.expressDelegation = false) :
    chevronGoverns q = Governs.agencyInterpretation ∧
      loperGoverns q = Governs.courtBestReading := by
  refine ⟨?_, ?_⟩
  · simp [chevronGoverns, h_ambiguous, h_reasonable]
  · simp [loperGoverns, h_no_delegation]

/-! ## Skidmore respect

*Skidmore* is not a binding-deference rule but a measure of the *weight* an
agency interpretation earns by its "power to persuade."  We model the four
classic factors and define full Skidmore respect as their conjunction. -/

/-- The *Skidmore* factors bearing on an agency interpretation's power to
persuade. -/
structure SkidmoreFactors where
  /-- The thoroughness evident in the agency's consideration. -/
  thoroughness : Bool
  /-- The validity of the agency's reasoning. -/
  validReasoning : Bool
  /-- The consistency of the interpretation with earlier and later pronouncements. -/
  consistency : Bool
  /-- The agency's relative expertise / the formality and care of the process. -/
  expertise : Bool
deriving DecidableEq, Repr

/-- **Power to persuade.** Full *Skidmore* respect is earned when the agency's
interpretation is thorough, well-reasoned, consistent, and informed by the
agency's expertise. -/
def hasPowerToPersuade (s : SkidmoreFactors) : Prop :=
  s.thoroughness = true ∧ s.validReasoning = true ∧
    s.consistency = true ∧ s.expertise = true

/-- Thoroughness is necessary for full *Skidmore* respect. -/
theorem skidmore_needs_thoroughness (s : SkidmoreFactors)
    (h : s.thoroughness = false) :
    ¬ hasPowerToPersuade s := by
  simp [hasPowerToPersuade, h]

/-- Valid reasoning is necessary for full *Skidmore* respect. -/
theorem skidmore_needs_valid_reasoning (s : SkidmoreFactors)
    (h : s.validReasoning = false) :
    ¬ hasPowerToPersuade s := by
  simp [hasPowerToPersuade, h]

/-- Consistency is necessary for full *Skidmore* respect. -/
theorem skidmore_needs_consistency (s : SkidmoreFactors)
    (h : s.consistency = false) :
    ¬ hasPowerToPersuade s := by
  simp [hasPowerToPersuade, h]

/-- *Skidmore* respect is *persuasive, not controlling.* Even an interpretation
with full power to persuade does not, of itself, displace the court's role: it
is a reason a court may *adopt* the reading as its own best reading, not a rule
that the agency's view governs.  Formally, `hasPowerToPersuade` places no
constraint on who `loperGoverns`, as witnessed by interpretations of equal
persuasive force that fall on opposite sides of the delegation line. -/
theorem skidmore_does_not_control :
    ∃ s : SkidmoreFactors, ∃ q₁ q₂ : InterpretiveQuestion,
      hasPowerToPersuade s ∧
      loperGoverns q₁ = Governs.agencyInterpretation ∧
      loperGoverns q₂ = Governs.courtBestReading :=
  ⟨⟨true, true, true, true⟩, exampleDelegated, exampleShifted,
    ⟨rfl, rfl, rfl, rfl⟩, by decide, by decide⟩

/-! ## Worked examples -/

/-- Under the old regime the agency would have won this question. -/
theorem exampleShifted_chevron :
    chevronGoverns exampleShifted = Governs.agencyInterpretation := by decide

/-- Under the governing regime the court decides it for itself. -/
theorem exampleShifted_loper :
    loperGoverns exampleShifted = Governs.courtBestReading := by decide

/-- The express delegation is honored under *Loper Bright*. -/
theorem exampleDelegated_loper :
    loperGoverns exampleDelegated = Governs.agencyInterpretation := by decide

/-! ## Content addressing

The deference doctrines interpret the APA's scope-of-review command,
5 U.S.C. § 706, which lives in Title 5, Chapter 7 (Judicial Review). -/

/-- 5 U.S.C. § 706 (scope of review), the statutory anchor of the deference
doctrines, as a `USCCitation`. -/
def cite706 : USCCitation := ⟨5, 7, 706⟩

/-- § 706 lives in Chapter 7 and so never collides with the Chapter 5
administrative-procedure provisions (§§ 552–557). -/
theorem cite706_distinct_from_chapter5 (c : USCCitation) (hc : c.chapter = 5) :
    cite706.address ≠ c.address := by
  intro h
  have heq := USCCitation.address_injective h
  rw [← heq] at hc
  simp [cite706] at hc

end Law.Judicial.Deference
