/-
# Riddick's Senate Procedure — Formal Model

Formalizes key facts about Riddick's Senate Procedure (S.Doc. 101-28), the most
comprehensive reference source covering Senate rules, precedents, and practices.

"Its principal purpose is to present a digest of precedents established in the
Senate. The current edition, published in 1992, covers significant Senate
precedents established from 1883 to 1992."
-/

import Mathlib

/-! ## Publication Facts -/

/-- The year range of precedents covered in Riddick's Senate Procedure. -/
def riddickCoverageStart : ℕ := 1883
def riddickCoverageEnd : ℕ := 1992

/-- Riddick's covers 110 years of precedents (1883-1992 inclusive). -/
theorem riddick_coverage_span :
    riddickCoverageEnd - riddickCoverageStart + 1 = 110 := by
  simp [riddickCoverageStart, riddickCoverageEnd]

/-- The publication year of the current edition. -/
def riddickPublicationYear : ℕ := 1992

/-! ## Organization

"It is organized around procedural topics, which are presented in alphabetical
order. For each procedural topic, the volume first presents a summary of the
general principles governing that topic followed by the text of relevant standing
rules, constitutional provisions, or rulemaking provisions of statute."

The report specifically mentions the cloture procedure as an example topic.
-/

/-- The structure of a topic entry in Riddick's. -/
structure RiddickTopicEntry where
  /-- The topic name. -/
  topicName : String
  /-- General principles summary is provided first. -/
  hasPrinciplesSummary : Bool
  /-- Relevant rule texts are included. -/
  hasRuleTexts : Bool
  /-- Precedent summaries organized alphabetically by subject. -/
  hasPrecedentSummaries : Bool

/-- Example: the Cloture Procedure entry, as described in the report.
    "the topic 'Cloture Procedure' has a subject heading 'Amendments After Cloture,'
    which is further divided into 18 topics" -/
def clotureEntry : RiddickTopicEntry where
  topicName := "Cloture Procedure"
  hasPrinciplesSummary := true
  hasRuleTexts := true
  hasPrecedentSummaries := true

/-- The number of subtopics under "Amendments After Cloture" in the Cloture
    Procedure entry. -/
def clotureAmendmentSubtopics : ℕ := 18

theorem cloture_amendment_subtopics_is_18 :
    clotureAmendmentSubtopics = 18 := by rfl

/-! ## Citation Conventions

"Footnotes provide citations to the date, the Congress, and the session when each
precedent was established and to the Congressional Record or Senate Journal pages."

"Footnote citations beginning with the word see indicate proceedings based on
presiding officers' responses to parliamentary inquiries. Citations without see
indicate precedents created by ruling of the presiding officers or by votes of
the Senate."
-/

/-- The citation style in Riddick's distinguishes precedent origins. -/
inductive RiddickCitationStyle where
  | withSee    -- "see ..." → parliamentary inquiry
  | withoutSee -- No "see" → ruling or Senate vote
  deriving DecidableEq, Repr

/-- Citations with "see" indicate parliamentary inquiries (lesser weight). -/
def RiddickCitationStyle.indicatesInquiry : RiddickCitationStyle → Prop
  | .withSee    => True
  | .withoutSee => False

instance (c : RiddickCitationStyle) : Decidable c.indicatesInquiry := by
  cases c <;> simp [RiddickCitationStyle.indicatesInquiry] <;> infer_instance

/-! ## Authorship

"It was written by Floyd M. Riddick, Parliamentarian of the Senate from 1964 to
1974, and Alan S. Frumin, Parliamentarian of the Senate from 1987 to 1995 and
2001 to 2012 and Parliamentarian Emeritus since 1997."
-/

/-- Riddick's tenure as Senate Parliamentarian. -/
def riddickTenureStart : ℕ := 1964
def riddickTenureEnd : ℕ := 1974

/-- Riddick served as Parliamentarian for 10 years. -/
theorem riddick_tenure_length :
    riddickTenureEnd - riddickTenureStart = 10 := by
  simp [riddickTenureStart, riddickTenureEnd]

/-- Frumin's first tenure as Senate Parliamentarian. -/
def fruminFirstTenureStart : ℕ := 1987
def fruminFirstTenureEnd : ℕ := 1995

/-- Frumin's second tenure as Senate Parliamentarian. -/
def fruminSecondTenureStart : ℕ := 2001
def fruminSecondTenureEnd : ℕ := 2012

/-- Frumin served a total of 19 years as Parliamentarian. -/
theorem frumin_total_tenure :
    (fruminFirstTenureEnd - fruminFirstTenureStart) +
    (fruminSecondTenureEnd - fruminSecondTenureStart) = 19 := by
  simp [fruminFirstTenureStart, fruminFirstTenureEnd,
        fruminSecondTenureStart, fruminSecondTenureEnd]

/-! ## UC Agreements Coverage in Riddick's

"A body of precedents has developed on how UC agreements are to be interpreted
and applied in different procedural situations. These precedents are covered in
Riddick's Senate Procedure, pp. 1311-1369." -/

/-- The page range for UC agreement precedents in Riddick's. -/
def ucPrecedentsStartPage : ℕ := 1311
def ucPrecedentsEndPage : ℕ := 1369

/-- UC agreement precedents span 59 pages in Riddick's. -/
theorem uc_precedents_pages :
    ucPrecedentsEndPage - ucPrecedentsStartPage + 1 = 59 := by
  simp [ucPrecedentsStartPage, ucPrecedentsEndPage]

