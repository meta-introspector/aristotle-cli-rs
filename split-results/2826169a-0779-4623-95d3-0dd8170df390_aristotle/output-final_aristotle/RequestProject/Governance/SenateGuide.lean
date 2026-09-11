/-
# Senate Manual Structure — Formal Model

Formalizes the structure and contents of the Senate Manual (S.Doc. 117-1),
as described in the report. The Manual compiles the chief official parliamentary
authorities in a single document.
-/

import Mathlib

/-! ## Components of the Senate Manual

The current edition (117th Congress) contains the following components,
as listed in the report under "The Senate Manual and Authorities It Contains":
-/

/-- The components of the Senate Manual as enumerated in the report. -/
inductive ManualComponent where
  | standingRules              -- "Standing Rules of the Senate"
  | standingOrders             -- "Select Standing Orders not embraced in the Rules"
  | chamberRegulations         -- "United States Senate Chamber and Gallery Regulations"
  | impeachmentRules           -- "Rules for Impeachment Trials"
  | cleavesManual              -- "Cleaves' Manual ... in Regard to Conferences"
  | legislativeProcedures      -- "Select Legislative Procedures Enacted in Law"
  | constitution               -- "Constitution of the United States"
  deriving DecidableEq, Repr, Fintype

open ManualComponent

/-- The Senate Manual contains exactly 7 major components. -/
theorem manual_has_seven_components :
    Fintype.card ManualComponent = 7 := by
  decide

/-! ## Section Numbering

"Individual provisions of each procedural authority are assigned section numbers
that run throughout the Manual in a single sequence and always appear in bold type.
The section numbers assigned to the standing rules correspond to the numbers of
the rules themselves. For example, paragraph 2 of Senate Rule XXII, which sets
forth the cloture rule, is found at section 22.2 of the Manual."
-/

/-- A section reference in the Senate Manual.
    The report notes that sections use a dotted notation (e.g., §22.2). -/
structure ManualSection where
  rule : ℕ       -- Rule number (e.g., 22 for Rule XXII)
  paragraph : ℕ  -- Paragraph within the rule (e.g., 2)
  deriving DecidableEq, Repr

/-- The cloture rule is at Manual §22.2. -/
def clotureSection : ManualSection := ⟨22, 2⟩

/-- Standing orders are compiled in Manual §§60-138. -/
def standingOrderSectionRange : Set ℕ := Set.Icc 60 138

/-- There are 79 sections allocated to standing orders (60 through 138 inclusive). -/
theorem standing_order_sections_count :
    Finset.card (Finset.Icc 60 138) = 79 := by decide

/-! ## Standing Rules

"At the start of the 118th Congress, there were 44 standing rules of the Senate."
-/

/-- The number of standing rules at the start of the 118th Congress. -/
def numStandingRules118th : ℕ := 44

/-- There are exactly 44 standing rules. -/
theorem num_standing_rules : numStandingRules118th = 44 := by rfl

/-! ## Continuing Body Principle

"The Senate does not readopt its standing rules at the beginning of each new Congress
but instead regards its rules as continuing in effect without need for readoption."

"The Senate is a continuing body; only one-third of its membership enters on new
terms of office after every biennial election, so a quorum is continuous.
This principle is embodied in paragraph 2 of Senate Rule V."
-/

/-- The fraction of Senators whose terms begin each Congress. -/
def fractionNewTerms : ℚ := 1 / 3

/-- The fraction of continuing Senators (who do NOT enter on new terms). -/
def fractionContinuing : ℚ := 1 - fractionNewTerms

/-- The continuing fraction is 2/3, ensuring a quorum persists. -/
theorem continuing_fraction_is_two_thirds :
    fractionContinuing = 2 / 3 := by
  simp [fractionContinuing, fractionNewTerms]
  ring

/-- Since 2/3 > 1/2, a quorum of the full Senate continues across Congresses,
    justifying the continuing body principle (Rule V, ¶2). -/
theorem continuing_exceeds_quorum_fraction :
    fractionContinuing > (1 : ℚ) / 2 := by
  simp [fractionContinuing, fractionNewTerms]
  norm_num

/-! ## Key Manual References

The report mentions several specific Manual section references. -/

/-- The motion to adjourn is covered in Manual §§6.4, 9, and 22.1. -/
def adjournmentSections : List ManualSection :=
  [⟨6, 4⟩, ⟨9, 0⟩, ⟨22, 1⟩]

/-- Rule XXXIII authorizes the Rules Committee to make regulations for the Senate wing.
    Manual §33. -/
def ruleXXXIII_section : ManualSection := ⟨33, 0⟩

/-- Rule XXVI, ¶2 requires committees to adopt written rules and publish them in the
    Congressional Record not later than March 1 of the first session. Manual §26.2. -/
def committeeRulesDeadline_section : ManualSection := ⟨26, 2⟩


/-! ## Merged from SenateStudyGuide.lean (semantic dedup: senate reference) -/

/-
# Senate Parliamentary Procedures — Study Guide as CRT Numbers

## Overview

Each term, definition, and concept from the Senate Parliamentary Procedures
and Formal Modeling Study Guide is encoded as a natural number, then projected
into the CRT address space ℤ/47 × ℤ/59 × ℤ/71 via the die plate.

This is the "each term becomes a cell" step: every glossary entry, every
quiz answer, every structural concept becomes a point in the 196883-slot
Monster-compatible address space.

## Encoding scheme

Each concept is assigned a canonical cardinality (its "weight" in the
governance universe), then mapped through addressOfState to get its
CRT coordinates, Bott grade, and j-distance.

## The 9 procedural sources

  1. Constitution            (weight: 1787, year of ratification)
  2. Standing rules           (weight: 44,   Rule XXII etc.)
  3. Standing orders          (weight: 12,   typical count)
  4. Rulemaking statutes      (weight: 67,   2/3 threshold)
  5. Precedents               (weight: 110,  years of Riddick coverage)
  6. UC agreements            (weight: 100,  unanimous = 100%)
  7. Committee rules          (weight: 20,   typical committee size)
  8. Party conference rules   (weight: 2,    two parties)
  9. Informal practices       (weight: 1,    custom)

Floor-enforceable: sources 1-6 (boardroom)
Non-enforceable:   sources 7-9 (arcade)

## Voting thresholds

  Simple majority:     51
  Cloture:             60
  Superthreshold:      67
  Quorum:              51
  Continuing body:     66+ (2/3 continuing members)

## Precedent weights

  Senate vote:         3
  Presiding officer:   2
  Parliamentary inquiry: 1
-/


set_option maxHeartbeats 400000

namespace SenateStudyGuide

/- ## §1. The 9 Procedural Sources as Numbers -/

/-- The 9 sources of Senate procedural authority, each with a canonical weight. -/
structure ProceduralSource where
  name       : String
  weight     : ℕ
  enforceable : Bool  -- floor-enforceable?
deriving Repr

/-- The complete list of 9 procedural sources. -/
def sources : List ProceduralSource :=
  [ { name := "Constitution",          weight := 1787, enforceable := true  }
  , { name := "Standing rules",        weight := 44,   enforceable := true  }
  , { name := "Standing orders",       weight := 12,   enforceable := true  }
  , { name := "Rulemaking statutes",   weight := 67,   enforceable := true  }
  , { name := "Precedents",            weight := 110,  enforceable := true  }
  , { name := "UC agreements",         weight := 100,  enforceable := true  }
  , { name := "Committee rules",       weight := 20,   enforceable := false }
  , { name := "Party conference rules", weight := 2,    enforceable := false }
  , { name := "Informal practices",    weight := 1,    enforceable := false }
  ]

/-- There are exactly 9 procedural sources. -/
theorem sources_count : sources.length = 9 := by simp [sources]

/-- 6 sources are floor-enforceable (the boardroom). -/
theorem boardroom_count : (sources.filter (·.enforceable)).length = 6 := by
  simp [sources, List.filter]

/-- 3 sources are non-enforceable (the arcade). -/
theorem arcade_count : (sources.filter (fun s => !s.enforceable)).length = 3 := by
  simp [sources, List.filter]

/-- The 6+3 partition matches the boardroom/arcade split. -/
theorem boardroom_arcade_partition : 6 + 3 = 9 := by norm_num

/- ## §2. CRT Addresses of Procedural Sources

Each source's weight is projected into ℤ/47 × ℤ/59 × ℤ/71. -/

/-- CRT address of a weight: (w mod 47, w mod 59, w mod 71). -/
def crtAddr (w : ℕ) : ℕ × ℕ × ℕ := (w % 47, w % 59, w % 71)

/-- Bott grade of a weight: (sum of CRT coordinates) mod 8. -/
def bottGrade (w : ℕ) : Fin 8 :=
  let (a, b, c) := crtAddr w
  ⟨(a + b + c) % 8, by omega⟩

/-- The Constitution (1787) has CRT address (1, 17, 9). -/
theorem constitution_addr : crtAddr 1787 = (1, 17, 12) := by native_decide

/-- Standing rules (44) has CRT address (44, 44, 44) — all coordinates equal! -/
theorem standing_rules_addr : crtAddr 44 = (44, 44, 44) := by native_decide

/-- The superthreshold (67) has CRT address (20, 8, 67) — note 67 < 71. -/
theorem superthreshold_addr : crtAddr 67 = (20, 8, 67) := by native_decide

/-- The cloture threshold (60) has CRT address (13, 1, 60). -/
theorem cloture_addr : crtAddr 60 = (13, 1, 60) := by native_decide

/-- The quorum (51) has CRT address (4, 51, 51). -/
theorem quorum_addr : crtAddr 51 = (4, 51, 51) := by native_decide

/- ## §3. Voting Thresholds as Numbers -/

/-- The key voting thresholds in the Senate. -/
structure VotingThreshold where
  name      : String
  votes     : ℕ
  fraction  : String  -- human-readable fraction
deriving Repr

def thresholds : List VotingThreshold :=
  [ { name := "Simple majority",    votes := 51, fraction := "50%+1" }
  , { name := "Cloture",            votes := 60, fraction := "3/5"   }
  , { name := "Superthreshold",     votes := 67, fraction := "2/3"   }
  , { name := "Quorum",             votes := 51, fraction := "51/100" }
  , { name := "Continuing body",    votes := 66, fraction := "2/3 of 100" }
  ]

/-- The asymmetry of rules changes: simple majority to adopt, 2/3 for cloture. -/
theorem rules_change_asymmetry : 51 < 67 := by norm_num

/-- The cloture gap: 67 - 60 = 7, matching |sspB| = 7
    (the 7 larger supersingular primes: 19, 23, 29, 31, 41, 59, 71). -/
theorem cloture_gap_is_7 : 67 - 60 = 7 := by norm_num

/-- The 8+7 partition of 15 supersingular primes. -/
theorem ss_partition : 8 + 7 = 15 := by norm_num

/- ## §4. Precedent Weights -/

/-- Precedent origin and weight. -/
structure PrecedentOrigin where
  origin : String
  weight : ℕ
deriving Repr

def precedentOrigins : List PrecedentOrigin :=
  [ { origin := "Full Senate vote",        weight := 3 }
  , { origin := "Presiding officer ruling", weight := 2 }
  , { origin := "Parliamentary inquiry",    weight := 1 }
  ]

/-- Precedent weights are strictly ordered. -/
theorem precedent_strict_order : 1 < 2 ∧ 2 < 3 := by norm_num

/-- Precedent weights are injective (distinct origins → distinct weights). -/
theorem precedent_weights_injective :
    (precedentOrigins.map (·.weight)).Nodup := by simp [precedentOrigins, List.Nodup]

/- ## §5. Priority of Recognition -/

/-- Recognition priority order. -/
inductive RecognitionPriority where
  | majorityLeader   : RecognitionPriority
  | minorityLeader   : RecognitionPriority
  | majorityManager  : RecognitionPriority
  | minorityManager  : RecognitionPriority
  | regularMember    : RecognitionPriority
deriving DecidableEq, Repr

/-- Priority rank: lower number = higher priority. -/
def priorityRank : RecognitionPriority → ℕ
  | .majorityLeader  => 1
  | .minorityLeader  => 2
  | .majorityManager => 3
  | .minorityManager => 4
  | .regularMember   => 5

/-- The Majority Leader always has highest priority. -/
theorem majority_leader_first (p : RecognitionPriority) :
    priorityRank .majorityLeader ≤ priorityRank p := by
  cases p <;> simp [priorityRank]

/- ## §6. The Continuing Body Principle -/

/-- The Senate is a continuing body: 2/3 of members continue across elections. -/
theorem continuing_body_quorum :
    -- 2/3 of 100 = 66+, which exceeds quorum of 51
    66 ≥ 51 := by norm_num

/-- Only 1/3 of the Senate is up for election at any time. -/
theorem election_fraction : 100 / 3 = 33 := by norm_num

/-- Continuing members always exceed quorum. -/
theorem continuing_exceeds_quorum : 100 - 33 ≥ 51 := by norm_num

/- ## §7. Mandatory Submissions to the Senate

Two types of questions the presiding officer must submit:
  1. Constitutional questions
  2. Germaneness questions (Rule XVI, appropriations amendments) -/

/-- The two mandatory submission types. -/
inductive MandatorySubmission where
  | constitutional : MandatorySubmission
  | germaneness    : MandatorySubmission
deriving DecidableEq, Repr

/-- Germaneness questions are decided without debate. -/
def isDebatable : MandatorySubmission → Bool
  | .constitutional => true
  | .germaneness    => false

/- ## §8. Riddick's Citation Convention -/

/-- Citation types in Riddick's Senate Procedure. -/
inductive RiddickCitation where
  | withSee    : RiddickCitation  -- "see" → parliamentary inquiry response (weight 1)
  | withoutSee : RiddickCitation  -- no "see" → ruling or vote (weight 2-3)
deriving DecidableEq, Repr

/-- Citations without "see" carry more authority. -/
def citationMinWeight : RiddickCitation → ℕ
  | .withSee    => 1
  | .withoutSee => 2

theorem citation_ordering : citationMinWeight .withSee < citationMinWeight .withoutSee := by
  simp [citationMinWeight]

/- ## §9. MonsterBase and CRT Connection -/

/-- MonsterBase = ZMod 71 × ZMod 59 × ZMod 47. -/
abbrev MonsterBase := ZMod 71 × ZMod 59 × ZMod 47

/-- The die plate size matches the Monster irrep. -/
theorem monster_base_size : 47 * 59 * 71 = 196883 := by norm_num

/-- The CRT reconstruction theorem: elements of MonsterBase are uniquely
    determined by their three projections. This is the mathematical backbone
    of the governance model — no information loss in the CRT encoding. -/
theorem crt_unique_recovery (a b : MonsterBase) (h1 : a.1 = b.1)
    (h2 : a.2.1 = b.2.1) (h3 : a.2.2 = b.2.2) : a = b := by
  ext <;> assumption

/- ## §10. The Passive Systems Leak -/

/-- A passive window: undetected violations accumulate until a trigger. -/
structure PassiveWindow where
  duration      : ℕ   -- window length in legislative days
  violationRate : ℕ   -- max violations per day
  triggerType   : String  -- "Point of Order" or "block submission"
deriving Repr

/-- Total violations in a passive window are bounded. -/
def totalViolations (w : PassiveWindow) : ℕ := w.duration * w.violationRate

/-- The leak is closed by demand-driven enforcement:
    active enforcement reduces the violation rate to 0. -/
theorem leak_closed (w : PassiveWindow) (h : w.violationRate = 0) :
    totalViolations w = 0 := by
  simp [totalViolations, h]

/- ## §11. Glossary as CRT-addressed terms

Each glossary term gets a canonical weight and CRT address. -/

/-- A glossary entry with its CRT encoding. -/
structure GlossaryEntry where
  term       : String
  weight     : ℕ
  addr47     : ℕ   -- weight mod 47
  addr59     : ℕ   -- weight mod 59
  addr71     : ℕ   -- weight mod 71
  bottGrade  : ℕ   -- (addr47 + addr59 + addr71) mod 8
deriving Repr

/-- Construct a glossary entry from a term and weight. -/
def mkGlossary (term : String) (w : ℕ) : GlossaryEntry :=
  let a47 := w % 47
  let a59 := w % 59
  let a71 := w % 71
  { term      := term
    weight    := w
    addr47    := a47
    addr59    := a59
    addr71    := a71
    bottGrade := (a47 + a59 + a71) % 8 }

/-- The complete glossary, each term assigned a weight derived from
    its structural role in the Senate governance model. -/
def glossary : List GlossaryEntry :=
  [ mkGlossary "Appeal"                   2    -- binary: sustain/reverse
  , mkGlossary "Boardroom"                6    -- floor-enforceable sources
  , mkGlossary "Arcade"                   3    -- non-enforceable sources
  , mkGlossary "CID"                      196883  -- content identifier = Monster
  , mkGlossary "Cloture"                  60   -- cloture threshold
  , mkGlossary "Continuing Body"          66   -- continuing members
  , mkGlossary "CRT"                      196883  -- Chinese Remainder Theorem
  , mkGlossary "Germaneness"              16   -- Rule XVI
  , mkGlossary "MonsterBase"              196883  -- ZMod 71 × ZMod 59 × ZMod 47
  , mkGlossary "Parliamentary Inquiry"    1    -- lowest precedent weight
  , mkGlossary "PassiveWindow"            7    -- cloture gap = 7
  , mkGlossary "Point of Order"           51   -- majority vote to sustain
  , mkGlossary "Precedent"                110  -- years of Riddick coverage
  , mkGlossary "Quorum"                   51   -- minimum for business
  , mkGlossary "Riddick"                  110  -- 110 years of history
  , mkGlossary "Rulemaking Authority"     1787 -- constitutional origin
  , mkGlossary "Senate Manual"            117  -- S.Doc. 117-1
  , mkGlossary "Sua Sponte"               67   -- only under cloture (2/3)
  , mkGlossary "Superthreshold"           67   -- 2/3 for rules change cloture
  , mkGlossary "Unanimous Consent"        100  -- 100% agreement
  , mkGlossary "ZMod"                     8    -- Bott period base
  ]

/-- The glossary has 21 entries. -/
theorem glossary_count : glossary.length = 21 := by simp [glossary, mkGlossary]

/- ## §12. Cross-domain invariants

The Senate study guide content connects to the Monster/Moonshine universe
through shared CRT coordinates and Bott grades. -/

/-- The cloture gap (7) matches |sspB| = 7.
    sspB = {19, 23, 29, 31, 41, 59, 71} — the 7 larger supersingular primes. -/
theorem cloture_gap_matches_sspB : 67 - 60 = 7 ∧ [19, 23, 29, 31, 41, 59, 71].length = 7 := by
  constructor <;> simp

/-- The boardroom (6) + arcade (3) = 9 sources.
    6 = |sspA ∩ {2,3,5,7,11,13}|, 3 = |{47,59,71}| (CRT primes). -/
theorem boardroom_arcade_matches_ss :
    6 + 3 = 9 ∧ [47, 59, 71].length = 3 := by constructor <;> simp

/-- The superthreshold 67 is a supersingular prime. -/
theorem superthreshold_is_ss : 67 ∈ ([2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 67, 71] : List ℕ) := by
  simp

/-- The Constitution weight 1787 has Bott grade: -/
theorem constitution_bott : bottGrade 1787 = ⟨6, by omega⟩ := by native_decide

/-- The cloture threshold 60 has Bott grade: -/
theorem cloture_bott : bottGrade 60 = ⟨2, by omega⟩ := by native_decide

/-- The quorum 51 has Bott grade: -/
theorem quorum_bott : bottGrade 51 = ⟨2, by omega⟩ := by native_decide

/-- The superthreshold 67 has Bott grade: -/
theorem superthreshold_bott : bottGrade 67 = ⟨7, by omega⟩ := by native_decide

/- ## §13. Essay Framework — Structural Invariants

The five essay topics map to structural invariants:

  1. Point of Order (enforcement) → demand-driven enforcement stream
  2. 8+7 partition (supersingular) → cloture gap = |sspB|
  3. Hierarchy of authority → precedent weight ordering
  4. Continuing body (liveness) → quorum persistence across sessions
  5. UC agreements (override) → single-senator veto power
-/

/-- The five essay topics as structural invariants. -/
def essayInvariants : List (String × ℕ) :=
  [ ("Point of Order enforcement",           51)    -- majority vote
  , ("8+7 supersingular partition",          15)    -- 15 ss primes
  , ("Hierarchy of authority",               3)     -- max precedent weight
  , ("Continuing body liveness",             66)    -- continuing members
  , ("UC override power",                    1)     -- single senator
  ]

/-- There are exactly 5 essay topics. -/
theorem essay_count : essayInvariants.length = 5 := by simp [essayInvariants]

end SenateStudyGuide
