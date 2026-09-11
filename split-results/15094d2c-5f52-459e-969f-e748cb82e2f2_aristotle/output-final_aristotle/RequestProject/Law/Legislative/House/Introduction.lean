import Mathlib
import RequestProject.Law.Legislative.CodeStructure

/-!
# Introduction and Referral of Bills in the U.S. House of Representatives

This module models, **details-first**, the first procedural gate in the life of a
bill: its introduction by a Member and its referral by the Speaker to one or more
committees of jurisdiction.  The governing authorities are:

* **Rule XII (Receipt and Referral of Measures and Matters).**  A measure is
  *introduced* by a Member (or Delegate / Resident Commissioner) by delivering it
  to the Clerk (placing it "in the hopper"); the Speaker thereupon refers each
  measure to the standing committee(s) having jurisdiction.
* **Rule X (Organization of Committees).**  Establishes the standing committees
  and fixes their subject-matter jurisdiction, against which the Speaker's
  referral is made.

The constitutional backdrop is Art. I, § 5, cl. 2 (each House "may determine the
Rules of its Proceedings"): the Speaker's referral is an internal exercise of the
House's rulemaking power and is **non-justiciable** — a court will not review the
correctness of a committee assignment.  We capture this exactly: a referral made
by the Speaker is procedurally effective *regardless* of whether the chosen
committee was, in some external sense, the "right" one.

We model the dispositive facts (`Member`, `Bill`, `Referral`) and prove the
structural guarantees: only a Member may introduce a bill, only the Speaker may
refer it, and the Speaker's referral is final and unreviewable.
-/

namespace Law.Legislative.House.Introduction

open Law.Legislative

/-! ## Members and bills (Rule XII)

A *Member* of the House (including Delegates and the Resident Commissioner) is the
only actor who may introduce a measure.  A *bill* records the facts the Rules make
dispositive of proper introduction: its sponsor, its text, and the legislative day
on which it was placed in the hopper. -/

/-- A person who may participate in House proceedings.  `isMember` records whether
the person is a Member entitled to introduce measures (a Representative, Delegate,
or the Resident Commissioner). -/
structure Person where
  /-- The person's identifier. -/
  name : String
  /-- Whether the person is a Member of the House entitled to introduce measures. -/
  isMember : Bool
deriving DecidableEq, Repr

/-- A bill, with the facts dispositive of proper introduction under Rule XII. -/
structure Bill where
  /-- The Member sponsoring the bill. -/
  sponsor : Person
  /-- The legislative text of the bill. -/
  text : String
  /-- The legislative day on which the bill was placed in the hopper. -/
  introducedDate : Nat
  /-- Whether the bill was actually delivered to the Clerk ("dropped in the hopper"). -/
  deliveredToClerk : Bool
deriving DecidableEq, Repr

/-- **Rule XII introduction.**  A bill is properly *introduced* iff a Member
sponsors it, it carries legislative text, and it was delivered to the Clerk. -/
def Bill.introduced (b : Bill) : Prop :=
  b.sponsor.isMember = true ∧ b.text ≠ "" ∧ b.deliveredToClerk = true

/-- **Only a Member may introduce a bill.**  A bill whose sponsor is not a Member
is not properly introduced. -/
theorem not_introduced_if_sponsor_not_member (b : Bill)
    (h : b.sponsor.isMember = false) : ¬ b.introduced := by
  rintro ⟨hm, _, _⟩
  rw [h] at hm
  exact Bool.noConfusion hm

/-- A bill never delivered to the Clerk is not introduced. -/
theorem not_introduced_if_not_delivered (b : Bill)
    (h : b.deliveredToClerk = false) : ¬ b.introduced := by
  rintro ⟨_, _, hd⟩
  rw [h] at hd
  exact Bool.noConfusion hd

/-! ## Standing committees and their jurisdiction (Rule X)

Rule X establishes the standing committees and fixes each one's subject-matter
jurisdiction.  We model a representative slice of the standing committees as an
enumeration. -/

/-- A representative slice of the standing committees of the House (Rule X). -/
inductive Committee
  /-- Committee on Ways and Means (revenue). -/
  | waysAndMeans
  /-- Committee on the Judiciary. -/
  | judiciary
  /-- Committee on Appropriations. -/
  | appropriations
  /-- Committee on Armed Services. -/
  | armedServices
  /-- Committee on Rules. -/
  | rules
deriving DecidableEq, Repr, Fintype

/-! ## Referral by the Speaker (Rule XII, cl. 2)

After introduction, the Speaker refers the bill to a committee.  The dispositive
facts are *who* made the referral (it must be the Speaker) and *whether* the bill
had been introduced.  We deliberately do **not** condition effectiveness on the
"correctness" of the committee chosen — that is the non-justiciable content. -/

/-- A referral of a bill to a committee. -/
structure Referral where
  /-- The bill being referred. -/
  bill : Bill
  /-- The committee to which the bill is referred. -/
  committee : Committee
  /-- Whether the referral was made by the Speaker (the exclusive referring authority). -/
  bySpeaker : Bool
deriving DecidableEq, Repr

/-- **Rule XII referral.**  A referral is *effective* iff the underlying bill was
properly introduced and the referral was made by the Speaker.  Note: effectiveness
does **not** depend on which committee was chosen — that discretion is the
Speaker's alone and is not reviewable. -/
def Referral.effective (r : Referral) : Prop :=
  r.bill.introduced ∧ r.bySpeaker = true

/-- **Referral presupposes introduction.**  A measure that was not introduced
cannot be effectively referred. -/
theorem no_referral_without_introduction (r : Referral)
    (h : ¬ r.bill.introduced) : ¬ r.effective := by
  rintro ⟨hi, _⟩
  exact h hi

/-- **Only the Speaker may refer.**  A purported referral not made by the Speaker
is ineffective. -/
theorem no_referral_without_speaker (r : Referral)
    (h : r.bySpeaker = false) : ¬ r.effective := by
  rintro ⟨_, hs⟩
  rw [h] at hs
  exact Bool.noConfusion hs

/-- **Non-justiciability of the committee choice.**  The Speaker's referral of an
introduced bill is effective *whatever* committee is named: two referrals of the
same introduced bill that differ only in the committee chosen are both effective.
This captures the rule that a court will not second-guess the jurisdictional
assignment. -/
theorem referral_committee_choice_nonjusticiable
    (b : Bill) (c₁ c₂ : Committee)
    (hi : b.introduced) :
    (Referral.mk b c₁ true).effective ∧ (Referral.mk b c₂ true).effective :=
  ⟨⟨hi, rfl⟩, ⟨hi, rfl⟩⟩

/-- An introduced bill referred by the Speaker is effectively referred, to any
committee the Speaker selects. -/
theorem speaker_referral_effective (b : Bill) (c : Committee)
    (hi : b.introduced) : (Referral.mk b c true).effective :=
  ⟨hi, rfl⟩

/-! ## A worked example

A Representative sponsors a revenue bill, drops it in the hopper, and the Speaker
refers it to Ways and Means.  The referral is effective. -/

/-- A properly introduced revenue bill sponsored by a Member. -/
def exampleBill : Bill :=
  { sponsor := { name := "Rep. Doe", isMember := true }
    text := "A Bill to amend the Internal Revenue Code."
    introducedDate := 1
    deliveredToClerk := true }

theorem exampleBill_introduced : exampleBill.introduced := by
  refine ⟨rfl, ?_, rfl⟩
  decide

/-- The Speaker's referral of the example bill to Ways and Means is effective. -/
def exampleReferral : Referral :=
  { bill := exampleBill, committee := Committee.waysAndMeans, bySpeaker := true }

theorem exampleReferral_effective : exampleReferral.effective :=
  ⟨exampleBill_introduced, rfl⟩

/-! ## Content addresses

We anchor the introduction-and-referral mechanics at Rule XII (referral) and
Rule X (committee organization). -/

/-- Citation to Rule XII (Receipt and Referral of Measures and Matters). -/
def citeRuleXII : HouseRuleCitation := ⟨12, 2⟩

/-- Citation to Rule X (Organization of Committees). -/
def citeRuleX : HouseRuleCitation := ⟨10, 1⟩

theorem introduction_citations_distinct : citeRuleXII.address ≠ citeRuleX.address := by
  decide

end Law.Legislative.House.Introduction
