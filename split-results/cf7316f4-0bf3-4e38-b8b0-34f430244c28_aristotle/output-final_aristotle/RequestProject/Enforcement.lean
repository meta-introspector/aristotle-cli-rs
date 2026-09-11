/-
# Enforcement Mechanisms — Formal Model

Formalizes the enforcement mechanisms described in the report, including
points of order, rulings, and appeals.

"The Senate's presiding officer ... does not always call the chamber's attention
to a violation of Senate rules. The Senate can violate its procedures unless a
Senator, at the right moment, makes a point of order."
-/

import Mathlib
import RequestProject.Basic

/-! ## Points of Order and Rulings

The report describes a sequence of events when a procedural question arises:
1. A Senator raises a point of order
2. The presiding officer makes a ruling (usually without debate)
3. Any Senator may appeal the ruling
4. The Senate votes on the appeal (usually by majority vote)
5. The vote establishes a precedent
-/

/-- The possible outcomes when a point of order is raised. -/
inductive PointOfOrderOutcome where
  | sustained       -- The presiding officer sustains the point of order
  | overruled       -- The presiding officer overrules the point of order
  | submittedToSenate -- The presiding officer submits the question to the Senate
  deriving DecidableEq, Repr

/-- Whether a ruling was appealed and the result. -/
inductive AppealOutcome where
  | notAppealed         -- No Senator appealed
  | upheld              -- Senate voted to uphold the ruling
  | overturned          -- Senate voted to overturn the ruling
  deriving DecidableEq, Repr

open PointOfOrderOutcome AppealOutcome

/-- A complete procedural ruling event. -/
structure RulingEvent where
  pointOfOrder : PointOfOrderOutcome
  appeal : AppealOutcome
  /-- The precedent origin determined by how this ruling was resolved. -/
  precedentOrigin : PrecedentOrigin

open PrecedentOrigin

/-- When a ruling is not appealed, it creates a presiding officer ruling precedent. -/
def rulingNotAppealed_origin :
    RulingEvent → Prop := fun e =>
  e.appeal = notAppealed → e.precedentOrigin = presidingOfficerRule

/-- When the Senate votes on an appeal, it creates a Senate vote precedent
    (the most authoritative kind). -/
def rulingAppealed_origin :
    RulingEvent → Prop := fun e =>
  (e.appeal = upheld ∨ e.appeal = overturned) → e.precedentOrigin = senateVote

/-! ## The Two Mandatory Submission Cases

"The presiding officer must submit two types of questions of order to the Senate:
1. Under Rule XVI, ¶4: germaneness of amendments to appropriations bills
2. Constitutional questions (by precedent)"
-/

/-- Types of points of order that must be submitted to the Senate. -/
inductive MandatorySubmission where
  | germanenessAppropriations  -- Rule XVI, ¶4
  | constitutionalQuestion     -- By precedent
  deriving DecidableEq, Repr

/-- Whether debate is allowed on a mandatory submission.
    "Under Rule XVI, paragraph 4, the Senate decides questions concerning the
    germaneness or relevance of most amendments to appropriations bills and does
    so without debate."
    "the Senate is to decide all constitutional questions, with debate usually allowed." -/
def MandatorySubmission.debateAllowed : MandatorySubmission → Prop
  | .germanenessAppropriations => False
  | .constitutionalQuestion    => True

instance (m : MandatorySubmission) : Decidable m.debateAllowed := by
  cases m <;> simp [MandatorySubmission.debateAllowed] <;> infer_instance

/-- Germaneness questions on appropriations bills are decided without debate. -/
theorem germaneness_no_debate :
    ¬ MandatorySubmission.germanenessAppropriations.debateAllowed := by
  simp [MandatorySubmission.debateAllowed]

/-- Constitutional questions are debatable. -/
theorem constitutional_questions_debatable :
    MandatorySubmission.constitutionalQuestion.debateAllowed := by
  simp [MandatorySubmission.debateAllowed]

/-! ## Precedent Establishment

"Most precedents are established when the Senate votes on questions of order ...
or when the presiding officer decides a question of order and the ruling is not
appealed. ... Precedents may also be created when the presiding officer responds
to a parliamentary inquiry."

"precedents based on a vote of the Senate have more weight than those based on
rulings of the presiding officer"
-/

/-- A precedent is established by any of three mechanisms. -/
def establishes_precedent (e : RulingEvent) : Prop :=
  e.precedentOrigin = senateVote ∨
  e.precedentOrigin = presidingOfficerRule ∨
  e.precedentOrigin = parliamentaryInquiry

/-- Every ruling event establishes a precedent (by construction of our model). -/
theorem every_ruling_establishes_precedent (e : RulingEvent) :
    establishes_precedent e := by
  simp [establishes_precedent]
  cases e.precedentOrigin <;> simp

/-! ## Cloture and Dilatory Motions

"When the Senate is operating under cloture ... the presiding officer has the
authority to rule all dilatory motions out of order on his or her own initiative."

This is an exception to the general principle that the presiding officer does not
sua sponte enforce rules.
-/

/-- Whether the presiding officer can rule motions out of order on own initiative. -/
def presidingOfficerSuaSponte (underCloture : Bool) : Prop :=
  underCloture = true

/-- Under cloture, the presiding officer can act on own initiative. -/
theorem sua_sponte_under_cloture :
    presidingOfficerSuaSponte true := by
  simp [presidingOfficerSuaSponte]

/-- Without cloture, the presiding officer cannot act on own initiative
    (a Senator must raise a point of order). -/
theorem no_sua_sponte_without_cloture :
    ¬ presidingOfficerSuaSponte false := by
  simp [presidingOfficerSuaSponte]

