import Mathlib
import RequestProject.Law.CodeStructure

/-!
# Article I of the United States Constitution — The Legislative Power

Article I is the structural heart of the federal lawmaking machinery, and it is
of exactly the *finite, rule-based* character that formalizes cleanly: vesting
of legislative power in a bicameral Congress (§ 1), quorum and voting rules
(§ 5), and the presentment / veto / override procedure by which a bill becomes
law (§ 7).

We model the **legislative journey** of a bill as a record of the discrete facts
the Constitution makes dispositive, then define `becomesLaw` and prove the core
structural guarantees:

* **Bicameralism** — a bill must pass *both* the House and the Senate (§ 1, § 7).
* **Presentment** — a bill signed by the President after bicameral passage
  becomes law (§ 7, cl. 2).
* **Veto override** — a vetoed bill becomes law only if *both* chambers repass it
  by a two-thirds vote (§ 7, cl. 2).
* **Pocket veto** — inaction for ten days while Congress is adjourned defeats the
  bill (§ 7, cl. 2).

We also formalize the **voting thresholds** (§ 5 quorum, ordinary majority, and
the two-thirds supermajority) as predicates on a tally, and the **Origination
Clause** (§ 7, cl. 1: revenue bills originate in the House).
-/

namespace Law.Constitution.Article1

open Law

/-! ## § 1 — Bicameralism: the two chambers of Congress

> All legislative Powers herein granted shall be vested in a Congress of the
> United States, which shall consist of a Senate and House of Representatives. -/

/-- The two chambers of the Congress (Art. I, § 1). -/
inductive Chamber
  | house
  | senate
deriving DecidableEq, Repr, Fintype

/-- There are exactly two chambers — the Congress is bicameral. -/
theorem two_chambers : Fintype.card Chamber = 2 := by decide

/-! ## § 5 — Quorum and voting thresholds

> a Majority of each [House] shall constitute a Quorum to do Business ...

A *tally* records the yeas and the total number of members present and voting.
Ordinary business requires a simple majority; certain actions (a veto override,
expulsion of a member, a treaty in the Senate) require two-thirds. -/

/-- A vote tally: `yeas` affirmative votes out of `total` cast. -/
structure Tally where
  /-- Number of affirmative ("yea") votes. -/
  yeas : Nat
  /-- Total number of votes cast. -/
  total : Nat
deriving DecidableEq, Repr

/-- A simple-majority threshold: strictly more than half vote yea. -/
def Tally.passesMajority (t : Tally) : Prop := 2 * t.yeas > t.total

/-- A two-thirds supermajority threshold (e.g. for a veto override). -/
def Tally.passesTwoThirds (t : Tally) : Prop := 3 * t.yeas ≥ 2 * t.total

/-- A two-thirds vote is a fortiori a majority (for a nonempty tally). -/
theorem twoThirds_imp_majority {t : Tally} (hpos : 0 < t.total)
    (h : t.passesTwoThirds) : t.passesMajority := by
  unfold Tally.passesTwoThirds Tally.passesMajority at *
  omega

/-! ## § 7 — Presentment, veto, and override

> Every Bill which shall have passed the House of Representatives and the Senate,
> shall, before it become a Law, be presented to the President of the United
> States; If he approve he shall sign it, but if not he shall return it ... If
> after such Reconsideration two thirds of that House shall agree to pass the
> Bill, it shall be sent ... and if approved by two thirds of that House, it
> shall become a Law ... If any Bill shall not be returned by the President
> within ten Days (Sundays excepted) after it shall have been presented to him,
> the Same shall be a Law, in like Manner as if he had signed it, unless the
> Congress by their Adjournment prevent its Return, in which Case it shall not be
> a Law. -/

/-- The President's disposition of a presented bill (Art. I, § 7, cl. 2). -/
inductive PresidentAction
  /-- The President signs the bill. -/
  | sign
  /-- The President returns the bill with objections (a veto). -/
  | veto
  /-- The President neither signs nor returns within ten days. -/
  | inaction
deriving DecidableEq, Repr

/-- The record of a bill's passage through the legislative process: the facts
Article I makes dispositive of whether it becomes law. -/
structure BillJourney where
  /-- Passed the House of Representatives. -/
  passedHouse : Bool
  /-- Passed the Senate. -/
  passedSenate : Bool
  /-- The President's action upon presentment. -/
  action : PresidentAction
  /-- On a veto, the House repassed by a two-thirds vote. -/
  houseOverride : Bool
  /-- On a veto, the Senate repassed by a two-thirds vote. -/
  senateOverride : Bool
  /-- Congress had adjourned, preventing the bill's return (pocket-veto setting). -/
  congressAdjourned : Bool
deriving DecidableEq, Repr

/-- Bicameral passage: a bill has passed *both* chambers. -/
def BillJourney.passedBothChambers (b : BillJourney) : Prop :=
  b.passedHouse = true ∧ b.passedSenate = true

/-- The President's disposition results in enactment, *given* bicameral passage:
signature enacts; a veto is overridden only by both chambers' two-thirds vote;
inaction enacts unless Congress's adjournment prevents return (pocket veto). -/
def BillJourney.presidentialOutcome (b : BillJourney) : Prop :=
  match b.action with
  | PresidentAction.sign => True
  | PresidentAction.veto => b.houseOverride = true ∧ b.senateOverride = true
  | PresidentAction.inaction => b.congressAdjourned = false

/-- A bill **becomes law** iff it passed both chambers (§ 1, § 7) *and* the
presidential stage resolves in enactment (§ 7, cl. 2). -/
def BillJourney.becomesLaw (b : BillJourney) : Prop :=
  b.passedBothChambers ∧ b.presidentialOutcome

/-! ### Structural guarantees -/

/-- **Bicameralism.** A bill that did not pass the House cannot become law. -/
theorem house_required (b : BillJourney) (h : b.passedHouse = false) :
    ¬ b.becomesLaw := by
  rintro ⟨⟨hH, _⟩, _⟩
  rw [h] at hH
  exact Bool.noConfusion hH

/-- **Bicameralism.** A bill that did not pass the Senate cannot become law. -/
theorem senate_required (b : BillJourney) (h : b.passedSenate = false) :
    ¬ b.becomesLaw := by
  rintro ⟨⟨_, hS⟩, _⟩
  rw [h] at hS
  exact Bool.noConfusion hS

/-- **Presentment.** A bill that passed both chambers and is signed by the
President becomes law. -/
theorem signed_becomes_law (b : BillJourney)
    (hH : b.passedHouse = true) (hS : b.passedSenate = true)
    (hsign : b.action = PresidentAction.sign) :
    b.becomesLaw := by
  refine ⟨⟨hH, hS⟩, ?_⟩
  unfold BillJourney.presidentialOutcome
  rw [hsign]
  exact trivial

/-- **Veto override requires both chambers.** A vetoed bill that the House fails
to repass by two-thirds does not become law (even if the Senate overrides). -/
theorem veto_not_overridden_by_one_chamber (b : BillJourney)
    (hveto : b.action = PresidentAction.veto)
    (hHouse : b.houseOverride = false) :
    ¬ b.becomesLaw := by
  rintro ⟨_, hout⟩
  unfold BillJourney.presidentialOutcome at hout
  rw [hveto] at hout
  rw [hHouse] at hout
  exact Bool.noConfusion hout.1

/-- **Successful veto override.** A vetoed bill that passed both chambers and is
repassed by a two-thirds vote in *both* chambers becomes law. -/
theorem override_becomes_law (b : BillJourney)
    (hH : b.passedHouse = true) (hS : b.passedSenate = true)
    (hveto : b.action = PresidentAction.veto)
    (hHouse : b.houseOverride = true) (hSenate : b.senateOverride = true) :
    b.becomesLaw := by
  refine ⟨⟨hH, hS⟩, ?_⟩
  unfold BillJourney.presidentialOutcome
  rw [hveto]
  exact ⟨hHouse, hSenate⟩

/-- **Pocket veto.** If the President takes no action and Congress has adjourned
so as to prevent the bill's return, the bill does not become law. -/
theorem pocket_veto (b : BillJourney)
    (hinaction : b.action = PresidentAction.inaction)
    (hadjourned : b.congressAdjourned = true) :
    ¬ b.becomesLaw := by
  rintro ⟨_, hout⟩
  unfold BillJourney.presidentialOutcome at hout
  rw [hinaction] at hout
  rw [hadjourned] at hout
  exact Bool.noConfusion hout

/-- **Ten-day rule.** If the President takes no action but Congress remains in
session (so the bill could be returned), a bicamerally-passed bill becomes law
"in like Manner as if he had signed it". -/
theorem inaction_in_session_becomes_law (b : BillJourney)
    (hH : b.passedHouse = true) (hS : b.passedSenate = true)
    (hinaction : b.action = PresidentAction.inaction)
    (hsession : b.congressAdjourned = false) :
    b.becomesLaw := by
  refine ⟨⟨hH, hS⟩, ?_⟩
  unfold BillJourney.presidentialOutcome
  rw [hinaction]
  exact hsession

/-! ## § 7, cl. 1 — The Origination Clause

> All Bills for raising Revenue shall originate in the House of Representatives;
> but the Senate may propose or concur with Amendments as on other Bills.

We attach to a revenue bill the chamber in which it originated; the clause is
satisfied exactly when that chamber is the House. -/

/-- A bill for raising revenue, tagged with its chamber of origination. -/
structure RevenueBill where
  /-- The chamber in which the revenue bill originated. -/
  origin : Chamber
deriving DecidableEq, Repr

/-- The Origination Clause is satisfied iff the revenue bill originated in the
House of Representatives. -/
def RevenueBill.originationValid (r : RevenueBill) : Prop :=
  r.origin = Chamber.house

theorem house_origin_valid : (RevenueBill.mk Chamber.house).originationValid := rfl

/-- A revenue bill originating in the Senate violates the Origination Clause. -/
theorem senate_origin_invalid : ¬ (RevenueBill.mk Chamber.senate).originationValid := by
  unfold RevenueBill.originationValid; decide

/-! ## Content addresses of the cited Article I sections

For uniformity with the statutory layer we give the cited clauses canonical
content addresses.  We place Article I at the reserved pseudo-title `0`
(constitutional layer), chapter = article number, section = clause. -/

/-- A citation to Article I, § `s`, modeled in the content-addressing spine with
the reserved constitutional pseudo-title `0` and chapter `1` (Article I). -/
def cite (s : Nat) : USCCitation := ⟨0, 1, s⟩

theorem article1_sections_distinct {m n : Nat} (h : m ≠ n) :
    (cite m).address ≠ (cite n).address := by
  intro habs
  exact h (congrArg USCCitation.«section» (USCCitation.address_injective habs))

end Law.Constitution.Article1
