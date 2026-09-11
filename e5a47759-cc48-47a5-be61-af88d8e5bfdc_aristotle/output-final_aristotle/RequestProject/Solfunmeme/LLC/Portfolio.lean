/-
  Portfolio.lean — the open-source investment portfolio of the uploaded
  `OpenSourceInvestmentPortfolio.md`, as a decidable admission rule.

  The document states criteria a company must meet before the portfolio will
  invest in it, a set of red flags that disqualify it, and two narrow
  exceptions.  This file turns that prose into a function of a candidate's
  answers, so that "does this company qualify?" has one answer, computed the
  same way every time, and so that the zero-knowledge schema in
  `RequestProject/LLC/ZKP.lean` has something definite to prove about.

  The criteria, as the document groups them:

    fitness      rule abiding, non-discrimination, documentation quality,
                 industry standards, governance, well-supported, update
                 frequency, engagement, privacy (no default tracking), and the
                 free/libre commitment;
    quality      pre-commit hooks, testing procedures, action on failing tests;
    security     security practices;
    reproducible reproducible builds;
    automation   infrastructure as code.

  Each is answered on a 0–5 scale.  Three of them are *mandatory* — the
  document's non-negotiables: an OSI-approved licence, non-discrimination, and
  no default tracking.  Two red flags disqualify outright: switching from an
  open licence to a restrictive one, and a non-free core promised to open
  "later".  The two exceptions — a proprietary dependency with no open
  alternative, and an essential cloud service — are excused only on the
  document's own terms: a transition plan in the first case, and abstraction
  behind open tooling in the second.

  What is proved:

    * `disqualified_is_not_eligible` — a red flag beats any score whatever:
      no amount of fitness rescues a licence switch or a non-free core;
    * `eligible_needs_osi_licence`, `eligible_needs_non_discrimination`,
      `eligible_needs_privacy` — each non-negotiable is really necessary;
    * `eligible_needs_threshold` — and the score threshold is really a
      threshold;
    * `fitness_monotone` — improving an answer never lowers the score, and
      `eligible_monotone_on_scores` — improving answers never loses
      eligibility;
    * `proprietary_exception_is_narrow`, `cloud_exception_is_narrow` — an
      exception claimed without the condition the document attaches to it
      leaves the candidate disqualified;
    * `eligible_decidable` — the rule is decidable, so a portfolio can be
      checked mechanically rather than argued about.
-/

import RequestProject.Solfunmeme.LLC.Entity

namespace LLC.Portfolio

/-! ### A candidate's answers -/

/-- The scored criteria of the document. -/
structure Scores where
  /-- Published rules and community guidelines. -/
  ruleAbiding : Nat
  /-- Documentation: open standards, reproducible, no login walls. -/
  documentation : Nat
  /-- Alignment with industry best practice. -/
  industryStandards : Nat
  /-- Transparent governance involving the community. -/
  governance : Nat
  /-- An established, active ecosystem. -/
  wellSupported : Nat
  /-- Update frequency and response to vulnerabilities. -/
  updateFrequency : Nat
  /-- Engagement with contributors: review, retention, patches. -/
  engagement : Nat
  /-- Quality systems: pre-commit hooks, tests, action on failures. -/
  qualitySystems : Nat
  /-- Security practice: audits, disclosure policy. -/
  security : Nat
  /-- Reproducible builds on stable or interchangeable foundations. -/
  reproducibility : Nat
  /-- Automation: infrastructure as code rather than manual consoles. -/
  automation : Nat
deriving DecidableEq, Repr, Inhabited

/-- The exceptions the document allows, and the condition attached to each. -/
structure Exceptions where
  /-- The candidate depends on proprietary technology. -/
  proprietaryDependency : Bool
  /-- There is no open alternative to it today. -/
  noOpenAlternative : Bool
  /-- And a plan to move off it. -/
  transitionPlan : Bool
  /-- The candidate depends on a commercial cloud. -/
  cloudDependency : Bool
  /-- Abstracted behind open tooling, so the dependency is portable. -/
  cloudAbstracted : Bool
deriving DecidableEq, Repr, Inhabited

/-- A candidate company. -/
structure Candidate where
  /-- The company's name. -/
  name : String
  /-- The scored criteria. -/
  scores : Scores
  /-- Licence approved by the Open Source Initiative. -/
  osiApprovedLicence : Bool
  /-- Open to all contributors and all uses. -/
  nonDiscrimination : Bool
  /-- No tracking by default; telemetry opt-in; runs without a cloud. -/
  privacyRespecting : Bool
  /-- Red flag: a licence switched from open to restrictive. -/
  licenceSwitched : Bool
  /-- Red flag: a proprietary core with openness promised later. -/
  nonFreeCore : Bool
  /-- The exceptions claimed. -/
  exceptions : Exceptions
deriving DecidableEq, Repr, Inhabited

/-! ### The rule -/

namespace Scores

/-- The fitness score: the sum of the eleven scored criteria. -/
def total (s : Scores) : Nat :=
  s.ruleAbiding + s.documentation + s.industryStandards + s.governance + s.wellSupported
    + s.updateFrequency + s.engagement + s.qualitySystems + s.security + s.reproducibility
    + s.automation

/-- Answer-by-answer improvement. -/
def le (s t : Scores) : Prop :=
  s.ruleAbiding ≤ t.ruleAbiding ∧ s.documentation ≤ t.documentation
    ∧ s.industryStandards ≤ t.industryStandards ∧ s.governance ≤ t.governance
    ∧ s.wellSupported ≤ t.wellSupported ∧ s.updateFrequency ≤ t.updateFrequency
    ∧ s.engagement ≤ t.engagement ∧ s.qualitySystems ≤ t.qualitySystems
    ∧ s.security ≤ t.security ∧ s.reproducibility ≤ t.reproducibility
    ∧ s.automation ≤ t.automation

end Scores

/-- The pass mark: three out of five on average across the eleven criteria. -/
def threshold : Nat := 33

/-- An exception claimed without its condition is not an exception. -/
def exceptionsHonoured (x : Exceptions) : Bool :=
  (!x.proprietaryDependency || (x.noOpenAlternative && x.transitionPlan))
    && (!x.cloudDependency || x.cloudAbstracted)

/-- The red flags. -/
def disqualified (c : Candidate) : Bool :=
  c.licenceSwitched || c.nonFreeCore || !exceptionsHonoured c.exceptions

/-- The non-negotiables. -/
def meetsNonNegotiables (c : Candidate) : Bool :=
  c.osiApprovedLicence && c.nonDiscrimination && c.privacyRespecting

/-- **The admission rule.** -/
def eligible (c : Candidate) : Bool :=
  !disqualified c && meetsNonNegotiables c && decide (threshold ≤ c.scores.total)

/-! ### What the rule guarantees -/

/-- **A red flag beats any score.** -/
theorem disqualified_is_not_eligible (c : Candidate) (h : disqualified c = true) :
    eligible c = false := by
  simp [eligible, h]

/-- **A licence switched away from open source disqualifies**, whatever else is
true of the company. -/
theorem licence_switch_disqualifies (c : Candidate) (h : c.licenceSwitched = true) :
    eligible c = false :=
  disqualified_is_not_eligible c (by simp [disqualified, h])

/-- **A non-free core disqualifies.** -/
theorem non_free_core_disqualifies (c : Candidate) (h : c.nonFreeCore = true) :
    eligible c = false :=
  disqualified_is_not_eligible c (by simp [disqualified, h])

/-- **The OSI licence is necessary.** -/
theorem eligible_needs_osi_licence (c : Candidate) (h : eligible c = true) :
    c.osiApprovedLicence = true := by
  simp only [eligible, meetsNonNegotiables, Bool.and_eq_true] at h
  exact h.1.2.1.1

/-- **Non-discrimination is necessary.** -/
theorem eligible_needs_non_discrimination (c : Candidate) (h : eligible c = true) :
    c.nonDiscrimination = true := by
  simp only [eligible, meetsNonNegotiables, Bool.and_eq_true] at h
  exact h.1.2.1.2

/-- **Respecting privacy is necessary.** -/
theorem eligible_needs_privacy (c : Candidate) (h : eligible c = true) :
    c.privacyRespecting = true := by
  simp only [eligible, meetsNonNegotiables, Bool.and_eq_true] at h
  exact h.1.2.2

/-- **The threshold is a threshold.** -/
theorem eligible_needs_threshold (c : Candidate) (h : eligible c = true) :
    threshold ≤ c.scores.total := by
  simp only [eligible, Bool.and_eq_true, decide_eq_true_eq] at h
  exact h.2

/-- **Eligibility is exactly the conjunction of the three tests.** -/
theorem eligible_iff (c : Candidate) :
    eligible c = true ↔
      disqualified c = false ∧ meetsNonNegotiables c = true ∧ threshold ≤ c.scores.total := by
  simp [eligible, and_assoc]

/-- **Improving an answer never lowers the score.** -/
theorem fitness_monotone {s t : Scores} (h : Scores.le s t) : s.total ≤ t.total := by
  obtain ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11⟩ := h
  simp only [Scores.total]
  omega

/-- **Improving answers never loses eligibility**, when nothing else changes. -/
theorem eligible_monotone_on_scores (c d : Candidate) (hsame : d = { c with scores := d.scores })
    (hle : Scores.le c.scores d.scores) (h : eligible c = true) : eligible d = true := by
  have hthr := eligible_needs_threshold c h
  have htotal := fitness_monotone hle
  rw [eligible_iff] at h ⊢
  refine ⟨?_, ?_, by omega⟩
  · rw [hsame]; simpa [disqualified] using h.1
  · rw [hsame]; simpa [meetsNonNegotiables] using h.2.1

/-- **The proprietary-technology exception is narrow**: claiming it without an
open alternative being absent, or without a transition plan, disqualifies. -/
theorem proprietary_exception_is_narrow (c : Candidate)
    (hdep : c.exceptions.proprietaryDependency = true)
    (hbad : c.exceptions.noOpenAlternative = false ∨ c.exceptions.transitionPlan = false) :
    eligible c = false := by
  refine disqualified_is_not_eligible c ?_
  simp only [disqualified, exceptionsHonoured, hdep, Bool.or_eq_true, Bool.not_eq_true']
  rcases hbad with h | h <;> simp [h]

/-- **The cloud exception is narrow**: an essential cloud dependency is excused
only if it is abstracted behind open tooling. -/
theorem cloud_exception_is_narrow (c : Candidate)
    (hdep : c.exceptions.cloudDependency = true) (hbad : c.exceptions.cloudAbstracted = false) :
    eligible c = false := by
  refine disqualified_is_not_eligible c ?_
  simp [disqualified, exceptionsHonoured, hdep, hbad]

/-- **The rule is decidable**: a portfolio can be checked, not argued. -/
theorem eligible_decidable (c : Candidate) : eligible c = true ∨ eligible c = false := by
  cases eligible c
  · exact Or.inr rfl
  · exact Or.inl rfl

/-! ### The portfolio -/

/-- The companies a portfolio may hold: exactly the eligible candidates. -/
def admit (cs : List Candidate) : List Candidate := cs.filter eligible

theorem admit_eligible (cs : List Candidate) : ∀ c ∈ admit cs, eligible c = true := by
  intro c hc
  exact (List.mem_filter.mp hc).2

theorem admit_subset (cs : List Candidate) : ∀ c ∈ admit cs, c ∈ cs := by
  intro c hc
  exact (List.mem_filter.mp hc).1

/-- **No disqualified company is ever held.** -/
theorem admit_excludes_disqualified (cs : List Candidate) :
    ∀ c ∈ admit cs, disqualified c = false := by
  intro c hc
  have := admit_eligible cs c hc
  rw [eligible_iff] at this
  exact this.1

/-! ### The criteria, as data

The same criteria, written out so they can be printed for a reader who is not
reading Lean.  `criteria_names_match_the_scores` keeps the list honest: it has
one entry for each of the eleven fields of `Scores`. -/

/-- The eleven scored criteria, in the order `Scores` lists them. -/
def criteriaNames : List String :=
  [ "rule-abiding: published rules and community guidelines",
    "documentation: open standards, reproducible, no login walls",
    "industry-standards: alignment with best practice",
    "governance: transparent and involving the community",
    "well-supported: an established, active ecosystem",
    "update-frequency: releases and response to vulnerabilities",
    "engagement: review, contributor retention, patches accepted",
    "quality-systems: hooks, tests, action taken on failures",
    "security: audits and a disclosure policy",
    "reproducibility: stable or interchangeable foundations",
    "automation: infrastructure as code rather than manual consoles" ]

/-- The score each criterion contributed, in the same order. -/
def scoreList (s : Scores) : List Nat :=
  [ s.ruleAbiding, s.documentation, s.industryStandards, s.governance, s.wellSupported,
    s.updateFrequency, s.engagement, s.qualitySystems, s.security, s.reproducibility,
    s.automation ]

/-- **The printed criteria are exactly the scored ones**: the list of names has
one entry per score, and the scores it names sum to the fitness total. -/
theorem criteria_names_match_the_scores (s : Scores) :
    criteriaNames.length = (scoreList s).length ∧ (scoreList s).sum = s.total := by
  constructor
  · rfl
  · simp [scoreList, Scores.total]
    omega

/-- The three non-negotiables. -/
def nonNegotiableNames : List String :=
  [ "an OSI-approved licence",
    "non-discrimination: open to all contributors and all uses",
    "privacy-respecting: no tracking by default, runs without a cloud" ]

/-- The red flags that disqualify outright. -/
def redFlagNames : List String :=
  [ "a licence switched from open to restrictive",
    "a proprietary core with openness promised later",
    "an exception claimed without the condition attached to it" ]

end LLC.Portfolio
