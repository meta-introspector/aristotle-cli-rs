import Mathlib
import RequestProject.Law.CodeStructure

/-!
# 5 U.S.C. § 553 — Informal ("Notice-and-Comment") Rulemaking Mechanics

This file models, **bottom-up and details-first**, the operational procedure by
which an executive agency converts a regulatory proposal into a binding
legislative rule under the Administrative Procedure Act, 5 U.S.C. § 553.

The statute fixes a deterministic pipeline of data structures and acts:

* **§ 553(b) — Notice.** "General notice of proposed rule making shall be
  published in the Federal Register" and shall include (1) a statement of the
  time, place, and nature of public rule making proceedings; (2) reference to the
  legal authority under which the rule is proposed; and (3) either the terms or
  substance of the proposed rule or a description of the subjects and issues
  involved.
* **§ 553(c) — Comment + statement.** "[T]he agency shall give interested persons
  an opportunity to participate in the rule making through submission of written
  data, views, or arguments ... After consideration of the relevant matter
  presented, the agency shall incorporate in the rules adopted a concise general
  statement of their basis and purpose."
* **§ 553(d) — Publication before effective date.** "The required publication or
  service of a substantive rule shall be made not less than 30 days before its
  effective date" (subject to exceptions).

Two judicially-developed constraints make the loop bite, and we model both:

* **Reasoned consideration.** The agency must respond to *significant* comments;
  a rule whose docket drops a significant comment is procedurally invalid.
* **Logical outgrowth.** The final rule must be a *logical outgrowth* of the
  proposal: it may not regulate a subject that interested persons could not have
  anticipated from the notice (no "bait-and-switch").

We model the **administrative record** (`RulemakingDocket`) as the dispositive
facts, define `ValidRulemakingProcedure` as the conjunction of the § 553
requirements, and prove the structural guarantees.
-/

namespace Law.USC.Title5

open Law

/-! ## § 553(b) — The Notice of Proposed Rulemaking (NPRM)

The structural contents the Federal Register notice must carry.  Subject matter
is tracked as a list of **topic identifiers** (`Nat`), modeling "the subjects and
issues involved" against which the final rule's scope is later tested. -/

/-- The contents of a Notice of Proposed Rulemaking (5 U.S.C. § 553(b)). -/
structure NPRM where
  /-- § 553(b)(2): reference to the legal authority for the rule. -/
  legalAuthority : String
  /-- § 553(b)(3): the terms or substance of the proposed rule. -/
  termsOrSubstance : String
  /-- § 553(b)(3): the subjects and issues involved, as topic identifiers. -/
  proposedTopics : List Nat
  /-- § 553(b)(1): the date the notice is published in the Federal Register. -/
  noticeDate : Nat
deriving DecidableEq, Repr

/-! ## § 553(c) — Public comments and the docket -/

/-- An individual public comment submitted to the agency docket. -/
structure PublicComment where
  /-- The commenter. -/
  author : String
  /-- The substance of the comment. -/
  content : String
  /-- Whether the comment raises a *significant* issue the agency must address. -/
  raisesSignificantIssue : Bool
deriving DecidableEq, Repr

/-! ## § 553(d) — The final rule -/

/-- The final rule, as published in the Federal Register. -/
structure FinalRule where
  /-- The operative text of the adopted rule. -/
  text : String
  /-- The subjects and issues the final rule actually regulates. -/
  regulatedTopics : List Nat
  /-- § 553(d): the date the final rule is published. -/
  publicationDate : Nat
  /-- The date on which the final rule takes effect. -/
  effectiveDate : Nat
deriving DecidableEq, Repr

/-- The complete administrative record compiled during the rulemaking. -/
structure RulemakingDocket where
  /-- The § 553(b) notice that opened the proceeding. -/
  nprm : NPRM
  /-- The close of the public comment window. -/
  commentDeadline : Nat
  /-- The public comments received. -/
  comments : List PublicComment
  /-- The comments the agency explicitly addressed in its statement. -/
  addressedComments : List PublicComment
  /-- § 553(c): the concise general statement of basis and purpose. -/
  statementOfBasisAndPurpose : String
  /-- The final rule adopted. -/
  finalRule : FinalRule
deriving DecidableEq, Repr

/-! ## Procedural predicates

Each predicate isolates one fine-grained § 553 requirement. -/

/-- **Reasoned consideration (§ 553(c)).** Every *significant* comment in the
docket must appear among the comments the agency addressed. -/
def allSignificantCommentsAddressed (d : RulemakingDocket) : Prop :=
  ∀ c ∈ d.comments, c.raisesSignificantIssue = true → c ∈ d.addressedComments

/-- **Logical outgrowth.** Every subject the final rule regulates must have been
among the subjects noticed in the NPRM, so that the rule is foreseeable from the
proposal (no bait-and-switch). -/
def isLogicalOutgrowth (d : RulemakingDocket) : Prop :=
  ∀ t ∈ d.finalRule.regulatedTopics, t ∈ d.nprm.proposedTopics

/-- **Meaningful comment window.** The comment period must close strictly after
the notice issues — interested persons must have a nonempty opportunity to
participate. -/
def commentWindowOpen (d : RulemakingDocket) : Prop :=
  d.nprm.noticeDate < d.commentDeadline

/-- **Consideration before adoption.** The final rule is published only after the
comment window has closed, so comments precede (and can inform) the rule. -/
def commentsConsideredBeforeFinal (d : RulemakingDocket) : Prop :=
  d.commentDeadline ≤ d.finalRule.publicationDate

/-- **The 30-day rule (§ 553(d)).** A substantive rule takes effect no sooner
than 30 days after its publication. -/
def thirtyDayNotice (d : RulemakingDocket) : Prop :=
  d.finalRule.publicationDate + 30 ≤ d.finalRule.effectiveDate

/-- **A valid § 553 informal rulemaking.** The conjunction of every procedural
requirement: a sufficient notice, a meaningful comment window, consideration of
the comments before adoption, reasoned response to significant comments, a final
rule within the noticed scope, a published statement of basis and purpose, and
30 days' lead time before the effective date. -/
structure ValidRulemakingProcedure (d : RulemakingDocket) : Prop where
  /-- § 553(b)(2): the notice references legal authority. -/
  has_valid_authority : d.nprm.legalAuthority ≠ ""
  /-- § 553(b)(3): the notice states the terms or substance proposed. -/
  notice_states_substance : d.nprm.termsOrSubstance ≠ ""
  /-- A meaningful opportunity to comment. -/
  comment_window_open : commentWindowOpen d
  /-- Comments are considered before the rule is adopted. -/
  comments_considered_before_final : commentsConsideredBeforeFinal d
  /-- § 553(c): significant comments are addressed. -/
  all_comments_considered : allSignificantCommentsAddressed d
  /-- The final rule is a logical outgrowth of the proposal. -/
  logical_outgrowth : isLogicalOutgrowth d
  /-- § 553(c): a concise general statement of basis and purpose is published. -/
  statement_published : d.statementOfBasisAndPurpose ≠ ""
  /-- § 553(d): at least 30 days' lead time before the effective date. -/
  thirty_day_notice : thirtyDayNotice d

/-! ### Structural guarantees & verification lemmas -/

/-
**Reasoned consideration bites.** A rulemaking is invalid if there is a
significant public comment in the docket that the agency failed to address.
-/
theorem invalid_if_significant_comment_ignored
    (d : RulemakingDocket)
    (ignored : PublicComment)
    (h_in_docket : ignored ∈ d.comments)
    (h_significant : ignored.raisesSignificantIssue = true)
    (h_not_addressed : ignored ∉ d.addressedComments) :
    ¬ ValidRulemakingProcedure d := by
  exact fun h => h_not_addressed <| h.all_comments_considered _ h_in_docket h_significant

/-- **Logical outgrowth is necessary.** Any valid rulemaking yields a final rule
that is a logical outgrowth of its proposal. -/
theorem cannot_bypass_logical_outgrowth
    (d : RulemakingDocket)
    (h_valid : ValidRulemakingProcedure d) :
    isLogicalOutgrowth d :=
  h_valid.logical_outgrowth

/-
**No bait-and-switch.** If the final rule regulates a subject that was never
noticed in the NPRM, the rulemaking is invalid.
-/
theorem invalid_if_new_topic
    (d : RulemakingDocket)
    (t : Nat)
    (h_regulated : t ∈ d.finalRule.regulatedTopics)
    (h_not_noticed : t ∉ d.nprm.proposedTopics) :
    ¬ ValidRulemakingProcedure d := by
  intro h_valid
  have h_logical_outgrowth : isLogicalOutgrowth d := h_valid.logical_outgrowth
  exact absurd (h_logical_outgrowth t h_regulated) h_not_noticed

/-
**The 30-day rule bites.** A rule made effective fewer than 30 days after
publication cannot issue through a valid § 553 procedure.
-/
theorem invalid_if_effective_too_soon
    (d : RulemakingDocket)
    (h_too_soon : d.finalRule.effectiveDate < d.finalRule.publicationDate + 30) :
    ¬ ValidRulemakingProcedure d := by
  intro h_valid;
  exact h_too_soon.not_ge h_valid.thirty_day_notice

/-
**Notice of authority is necessary.** A rulemaking whose notice omits the
legal authority for the rule is invalid.
-/
theorem invalid_without_authority
    (d : RulemakingDocket)
    (h_no_authority : d.nprm.legalAuthority = "") :
    ¬ ValidRulemakingProcedure d := by
  exact fun h => h.has_valid_authority h_no_authority

/-
**A meaningful comment window is necessary.** If the comment deadline does
not fall after the notice (so there was no opportunity to comment), the
rulemaking is invalid.
-/
theorem invalid_if_no_comment_window
    (d : RulemakingDocket)
    (h_no_window : d.commentDeadline ≤ d.nprm.noticeDate) :
    ¬ ValidRulemakingProcedure d := by
  contrapose! h_no_window;
  exact h_no_window.comment_window_open

/-! ### A worked, fully compliant example

A concrete docket that satisfies every § 553 requirement, witnessing that the
`ValidRulemakingProcedure` predicate is satisfiable (it is not vacuous). -/

/-- A model rulemaking record that complies with every step of § 553. -/
def exampleDocket : RulemakingDocket where
  nprm :=
    { legalAuthority := "5 U.S.C. § 301; 42 U.S.C. § 7411"
      termsOrSubstance := "Proposed emission standards for new sources."
      proposedTopics := [1, 2, 3]
      noticeDate := 0 }
  commentDeadline := 60
  comments :=
    [ { author := "Acme Corp.", content := "Standard is infeasible.",
        raisesSignificantIssue := true },
      { author := "A. Member of Public", content := "Nice rule!",
        raisesSignificantIssue := false } ]
  addressedComments :=
    [ { author := "Acme Corp.", content := "Standard is infeasible.",
        raisesSignificantIssue := true } ]
  statementOfBasisAndPurpose := "The standard is feasible; see record at 12–40."
  finalRule :=
    { text := "Final emission standards for new sources."
      regulatedTopics := [1, 2]
      publicationDate := 90
      effectiveDate := 130 }

/-
The worked example is a valid § 553 rulemaking.
-/
theorem exampleDocket_valid : ValidRulemakingProcedure exampleDocket := by
  constructor;
  all_goals norm_num [ exampleDocket ];
  all_goals norm_cast;
  · exact Nat.zero_lt_succ _;
  · exact Nat.le_add_left _ _;
  · exact fun c hc hc' => by fin_cases hc <;> trivial;
  · intro t ht; aesop;
  · exact Nat.le_add_left _ _

/-! ## Content addresses of the cited Title 5 sections

We give the cited § 553 provisions canonical content addresses in the spine,
placing them at Title 5, Chapter 5 (Administrative Procedure). -/

/-- `§ n` of Title 5, Chapter 5 (Administrative Procedure) as a `USCCitation`. -/
def cite (n : Nat) : USCCitation := ⟨5, 5, n⟩

/-
Distinct sections of Title 5, Chapter 5 receive distinct content addresses.
-/
theorem title5_addresses_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  exact fun h' => h ( by simpa [ cite ] using USCCitation.address_injective h' )

/-
Title 5 administrative provisions never collide with the constitutional
pseudo-title `0`.
-/
theorem title5_distinct_from_constitution (s : Nat) (c : USCCitation)
    (hc : c.title = 0) :
    (cite s).address ≠ c.address := by
  unfold cite; intro h; have := USCCitation.address_injective h; simp_all +decide ;
  grind

/-
Title 5 administrative provisions never collide with Title 1's rules of
construction.
-/
theorem title5_distinct_from_title1 (s : Nat) (c : USCCitation)
    (hc : c.title = 1) :
    (cite s).address ≠ c.address := by
  contrapose! hc;
  unfold USCCitation.address at hc;
  unfold cite at hc; simp_all +decide [ Nat.pair_eq_pair ] ;
  linarith

end Law.USC.Title5