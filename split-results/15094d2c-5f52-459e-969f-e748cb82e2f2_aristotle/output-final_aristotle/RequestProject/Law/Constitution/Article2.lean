import Mathlib
import RequestProject.Law.CodeStructure
import RequestProject.Law.Constitution.Article1

/-!
# Article II of the United States Constitution — The Executive Power

Article II vests the executive power in a President and fixes the procedural
preconditions for the principal executive acts that interact with the
legislative branch: **appointments** (§ 2, cl. 2 — nomination plus the Senate's
advice and consent) and **treaties** (§ 2, cl. 2 — two-thirds of the Senators
concurring).  It also fixes the **eligibility** requirements for the office
(§ 1, cl. 5).

As in Article I we model the dispositive facts as records and prove the
structural guarantees.  We reuse the `Tally` voting machinery from
`Article1`.
-/

namespace Law.Constitution.Article2

open Law
open Law.Constitution.Article1 (Tally)

/-! ## § 1 — Executive vesting and eligibility

> The executive Power shall be vested in a President of the United States of
> America. ... No Person except a natural born Citizen ... shall be eligible to
> the Office of President; neither shall any Person be eligible to that Office who
> shall not have attained to the Age of thirty five Years, and been fourteen
> Years a Resident within the United States. -/

/-- The facts § 1, cl. 5 makes dispositive of eligibility for the Presidency. -/
structure Candidate where
  /-- Whether the person is a natural born citizen. -/
  naturalBornCitizen : Bool
  /-- The person's age in years. -/
  age : Nat
  /-- Years the person has been a resident within the United States. -/
  yearsResident : Nat
deriving DecidableEq, Repr

/-- § 1, cl. 5: a candidate is eligible to be President iff a natural born
citizen, at least 35 years of age, and a resident for at least 14 years. -/
def Candidate.eligible (c : Candidate) : Prop :=
  c.naturalBornCitizen = true ∧ c.age ≥ 35 ∧ c.yearsResident ≥ 14

/-- A 50-year-old natural born citizen resident for 20 years is eligible. -/
theorem eligible_example : (Candidate.mk true 50 20).eligible :=
  ⟨rfl, by norm_num, by norm_num⟩

/-- A candidate under 35 is ineligible, whatever the other facts. -/
theorem underage_ineligible (c : Candidate) (h : c.age < 35) : ¬ c.eligible := by
  rintro ⟨_, hage, _⟩
  omega

/-- A candidate who is not a natural born citizen is ineligible. -/
theorem not_natural_born_ineligible (c : Candidate)
    (h : c.naturalBornCitizen = false) : ¬ c.eligible := by
  rintro ⟨hnb, _, _⟩
  rw [h] at hnb
  exact Bool.noConfusion hnb

/-! ## § 2, cl. 2 — Appointments: advice and consent of the Senate

> [The President] shall nominate, and by and with the Advice and Consent of the
> Senate, shall appoint ... Officers of the United States ...

An officer is validly appointed only after a Presidential nomination *and* the
Senate's consent, the latter expressed by a majority vote. -/

/-- The record of an attempted appointment of a principal officer. -/
structure Appointment where
  /-- Whether the President nominated the person. -/
  nominated : Bool
  /-- The Senate's confirmation vote. -/
  senateVote : Tally
deriving DecidableEq, Repr

/-- § 2, cl. 2: an appointment is valid iff the President nominated the person and
the Senate consented by majority vote. -/
def Appointment.valid (a : Appointment) : Prop :=
  a.nominated = true ∧ a.senateVote.passesMajority

/-- An appointment without a Presidential nomination is invalid (no recess here):
the appointments process is initiated by the President alone. -/
theorem appointment_requires_nomination (a : Appointment)
    (h : a.nominated = false) : ¬ a.valid := by
  rintro ⟨hn, _⟩
  rw [h] at hn
  exact Bool.noConfusion hn

/-- An appointment the Senate does not confirm by majority is invalid. -/
theorem appointment_requires_consent (a : Appointment)
    (h : ¬ a.senateVote.passesMajority) : ¬ a.valid := by
  rintro ⟨_, hc⟩
  exact h hc

/-- A nominated officer confirmed by a Senate majority is validly appointed. -/
theorem appointment_valid_of_nomination_and_majority (a : Appointment)
    (hn : a.nominated = true) (hc : a.senateVote.passesMajority) : a.valid :=
  ⟨hn, hc⟩

/-! ## § 2, cl. 2 — The Treaty Power: two-thirds of the Senate

> [The President] shall have Power, by and with the Advice and Consent of the
> Senate, to make Treaties, provided two thirds of the Senators present
> concur ... -/

/-- The record of an attempted treaty ratification. -/
structure Treaty where
  /-- Whether the President negotiated and submitted the treaty. -/
  negotiated : Bool
  /-- The Senate's ratification vote. -/
  senateVote : Tally
deriving DecidableEq, Repr

/-- § 2, cl. 2: a treaty is ratified iff the President submitted it and two-thirds
of the Senate concur. -/
def Treaty.ratified (t : Treaty) : Prop :=
  t.negotiated = true ∧ t.senateVote.passesTwoThirds

/-- A treaty supported only by a bare majority (short of two-thirds) is not
ratified.  We exhibit this with a concrete 60–40 Senate vote. -/
theorem bare_majority_treaty_fails :
    ¬ (Treaty.mk true (Tally.mk 60 100)).ratified := by
  rintro ⟨_, h2⟩
  unfold Tally.passesTwoThirds at h2
  norm_num at h2

/-- A treaty submitted by the President and approved by two-thirds of the Senate
is ratified.  We exhibit this with a concrete 67–33 Senate vote. -/
theorem twoThirds_treaty_ratified :
    (Treaty.mk true (Tally.mk 67 100)).ratified := by
  refine ⟨rfl, ?_⟩
  unfold Tally.passesTwoThirds
  norm_num

/-! ## Content addresses of the cited Article II sections

Article II is placed at the constitutional pseudo-title `0`, chapter `2`. -/

/-- A citation to Article II, § `s`, in the content-addressing spine. -/
def cite (s : Nat) : USCCitation := ⟨0, 2, s⟩

theorem article2_sections_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  intro habs
  exact h (congrArg USCCitation.«section» (USCCitation.address_injective habs))

end Law.Constitution.Article2
