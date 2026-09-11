/-
  Congress.lean — the two chambers, and what it takes to enact a bill.

  The dataset's own government (`RequestProject/Upstream/FederalGov.lean`) is
  bicameral too, but `RequestProject/Review/` proves it can never act: its
  quorum is a majority of the *nominal* chamber (100 and 500 seats) while only
  42 and 145 credentials were ever issued, so `resolveBill` returns `noQuorum`
  for every possible vote and no bill can be enacted.

  The model here makes the one repair that removes that dead end: a quorum is a
  majority of the members actually *seated*, and a chamber's seats are filled
  from people who exist — in `RequestProject/Federal/Facts.lean`, from the 100
  addresses on the senators' roster.  Everything else is the familiar shape:

      quorum          a majority of the sitting members must be present
      passage         among those voting, more ayes than nays
      enactment       passage in both chambers, and no veto
      override        two thirds of the sitting members of *both* chambers

  What is proved:

    * `enacted_iff`, `overridden_iff`, `resolve_cases` — exactly what each
      outcome means, so no reading of the rule is left implicit;
    * `quorum_attainable`, `enactment_attainable` — unlike the dataset's rule,
      this one can be satisfied: a seated chamber has a passing vote, and a
      seated Congress can enact and can override;
    * `supermajority_implies_passage` — an override is never weaker than an
      ordinary majority;
    * `contested_passage_needs_majority_of_seats` — on a vote where everybody
      seated votes, a bloc carries the chamber only if it holds more than half
      the seats;
    * `one_division_cannot_carry_the_senate` — and since the Senate gives every
      division the same number of seats, no single division ever holds half of
      it: with two or more divisions, no division can carry a contested Senate
      vote alone.  That is the federal check, as a theorem.
-/

import RequestProject.Solfunmeme.Federal.Apportion

namespace Federal

/-! ### Chambers and tallies -/

/-- A chamber: the seats its constitution creates, and the seats actually
filled.  `seated ≤ seats` is a hypothesis where it is needed, not a field, so
that a chamber is still plain data. -/
structure Chamber where
  /-- The chamber's name. -/
  name : String
  /-- Seats the constitution creates. -/
  seats : Nat
  /-- Seats actually filled by a member who can vote. -/
  seated : Nat
  deriving DecidableEq, Repr, Inhabited

/-- A recorded vote in one chamber. -/
structure Tally where
  /-- Members voting for. -/
  aye : Nat
  /-- Members voting against. -/
  nay : Nat
  /-- Members present and abstaining. -/
  abstain : Nat
  deriving DecidableEq, Repr, Inhabited

/-- Members taking part. -/
def Tally.cast (t : Tally) : Nat := t.aye + t.nay + t.abstain

/-- The quorum: a majority of the members actually seated. -/
def quorum (c : Chamber) : Nat := c.seated / 2 + 1

/-- Enough members took part, and no more than the chamber has. -/
def hasQuorum (c : Chamber) (t : Tally) : Bool :=
  decide (quorum c ≤ t.cast) && decide (t.cast ≤ c.seated)

/-- Passage: quorum, and more ayes than nays among those voting. -/
def passes (c : Chamber) (t : Tally) : Bool :=
  hasQuorum c t && decide (t.nay < t.aye)

/-- A two-thirds supermajority of the sitting members. -/
def supermajority (c : Chamber) (t : Tally) : Bool :=
  hasQuorum c t && decide (2 * c.seated ≤ 3 * t.aye)

/-! ### The Congress -/

/-- The legislature: the chamber of equal representation and the chamber of
proportional representation. -/
structure Congress where
  /-- The Senate: the same delegation from every division. -/
  senate : Chamber
  /-- The House: seats apportioned to the divisions by population. -/
  house : Chamber
  deriving DecidableEq, Repr, Inhabited

/-- One bill's journey: the two recorded votes, and whether the executive
vetoed it. -/
structure FederalVote where
  /-- The Senate's tally. -/
  senate : Tally
  /-- The House's tally. -/
  house : Tally
  /-- Whether the executive vetoed the bill. -/
  vetoed : Bool
  deriving DecidableEq, Repr, Inhabited

/-- What became of a bill. -/
inductive Outcome where
  /-- One of the chambers was not quorate. -/
  | noQuorum
  /-- A quorate Congress said no. -/
  | rejected
  /-- Passed both chambers, not vetoed. -/
  | enacted
  /-- Vetoed, and the veto stood. -/
  | vetoSustained
  /-- Vetoed, and two thirds of both chambers overrode the veto. -/
  | overridden
  deriving DecidableEq, Repr, Inhabited

/-- **The rule.** -/
def resolve (g : Congress) (v : FederalVote) : Outcome :=
  if !(hasQuorum g.senate v.senate && hasQuorum g.house v.house) then .noQuorum
  else if !(decide (v.senate.nay < v.senate.aye) && decide (v.house.nay < v.house.aye)) then
    .rejected
  else if !v.vetoed then .enacted
  else if supermajority g.senate v.senate && supermajority g.house v.house then .overridden
  else .vetoSustained

/-! ### What the rule says -/

/-- **Enactment means both chambers, and no veto.** -/
theorem enacted_iff {g : Congress} {v : FederalVote} :
    resolve g v = .enacted ↔
      passes g.senate v.senate = true ∧ passes g.house v.house = true ∧ v.vetoed = false := by
  unfold resolve passes
  cases hq : hasQuorum g.senate v.senate <;> cases hq' : hasQuorum g.house v.house <;>
    cases hs : decide (v.senate.nay < v.senate.aye) <;>
      cases hh : decide (v.house.nay < v.house.aye) <;> cases hv : v.vetoed <;>
        simp_all
  all_goals (split <;> simp_all)

/-- **An override means two thirds of both chambers, over a veto.** -/
theorem overridden_iff {g : Congress} {v : FederalVote} :
    resolve g v = .overridden ↔
      passes g.senate v.senate = true ∧ passes g.house v.house = true ∧ v.vetoed = true ∧
        supermajority g.senate v.senate = true ∧ supermajority g.house v.house = true := by
  unfold resolve passes
  cases hq : hasQuorum g.senate v.senate <;> cases hq' : hasQuorum g.house v.house <;>
    cases hs : decide (v.senate.nay < v.senate.aye) <;>
      cases hh : decide (v.house.nay < v.house.aye) <;> cases hv : v.vetoed <;>
        simp_all

/-- **Nothing becomes law without both chambers.** -/
theorem enacted_needs_both_chambers {g : Congress} {v : FederalVote}
    (h : resolve g v = .enacted) :
    passes g.senate v.senate = true ∧ passes g.house v.house = true :=
  ⟨(enacted_iff.mp h).1, (enacted_iff.mp h).2.1⟩

/-- **Nothing becomes law over a veto without two thirds of both chambers.** -/
theorem overridden_needs_supermajority {g : Congress} {v : FederalVote}
    (h : resolve g v = .overridden) :
    supermajority g.senate v.senate = true ∧ supermajority g.house v.house = true :=
  ⟨(overridden_iff.mp h).2.2.2.1, (overridden_iff.mp h).2.2.2.2⟩

/-- A vetoed bill that neither chamber can override does not become law. -/
theorem veto_sustained_of_not_super {g : Congress} {v : FederalVote}
    (hp : passes g.senate v.senate = true) (hq : passes g.house v.house = true)
    (hv : v.vetoed = true) (hs : supermajority g.senate v.senate = false) :
    resolve g v = .vetoSustained := by
  unfold passes at hp hq
  simp only [Bool.and_eq_true, decide_eq_true_eq] at hp hq
  unfold resolve
  simp [hp.1, hp.2, hq.1, hq.2, hv, hs]

/-! ### The rule can actually be satisfied -/

/-- Unpacked form of quorum. -/
theorem hasQuorum_iff {c : Chamber} {t : Tally} :
    hasQuorum c t = true ↔ quorum c ≤ t.cast ∧ t.cast ≤ c.seated := by
  simp [hasQuorum]

/-- **A seated chamber is not paralysed.**  If a single member is seated, some
tally passes the chamber — indeed the one where every member votes aye. -/
theorem quorum_attainable (c : Chamber) (hc : 0 < c.seated) :
    passes c ⟨c.seated, 0, 0⟩ = true := by
  have : quorum c ≤ c.seated := by unfold quorum; omega
  simp [passes, hasQuorum, Tally.cast, quorum, hc]
  omega

/-- The unanimous vote is also a two-thirds supermajority. -/
theorem unanimous_supermajority (c : Chamber) (hc : 0 < c.seated) :
    supermajority c ⟨c.seated, 0, 0⟩ = true := by
  simp [supermajority, hasQuorum, Tally.cast, quorum]
  omega

/-- **A seated Congress can legislate.**  With both chambers seated there is a
vote that enacts, and a vote that overrides a veto — in contrast with the
dataset's own rule, which `Review.no_bill_can_be_enacted` shows admits
neither. -/
theorem enactment_attainable (g : Congress) (hs : 0 < g.senate.seated)
    (hh : 0 < g.house.seated) :
    resolve g ⟨⟨g.senate.seated, 0, 0⟩, ⟨g.house.seated, 0, 0⟩, false⟩ = .enacted :=
  enacted_iff.mpr ⟨quorum_attainable _ hs, quorum_attainable _ hh, rfl⟩

theorem override_attainable (g : Congress) (hs : 0 < g.senate.seated)
    (hh : 0 < g.house.seated) :
    resolve g ⟨⟨g.senate.seated, 0, 0⟩, ⟨g.house.seated, 0, 0⟩, true⟩ = .overridden :=
  overridden_iff.mpr ⟨quorum_attainable _ hs, quorum_attainable _ hh, rfl,
    unanimous_supermajority _ hs, unanimous_supermajority _ hh⟩

/-- **An override is never weaker than a majority.**  Two thirds of a seated
chamber, with no more votes cast than there are seats, already beats the
nays. -/
theorem supermajority_implies_passage {c : Chamber} {t : Tally} (hc : 0 < c.seated)
    (h : supermajority c t = true) : passes c t = true := by
  simp only [supermajority, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨hq, hsuper⟩ := h
  obtain ⟨-, hcast⟩ := hasQuorum_iff.mp hq
  simp only [passes, hq, Bool.true_and, decide_eq_true_eq]
  unfold Tally.cast at hcast
  omega

/-! ### The federal check -/

/-- Everybody seated votes, and nobody abstains. -/
def Contested (c : Chamber) (t : Tally) : Prop := t.abstain = 0 ∧ t.aye + t.nay = c.seated

/-- **On a contested vote a bloc must hold more than half the seats.**  If the
ayes all come from a bloc of `m` members and everybody else votes nay, the
chamber passes the bill only if the bloc is more than half of it. -/
theorem contested_passage_needs_majority_of_seats {c : Chamber} {t : Tally} {m : Nat}
    (hcon : Contested c t) (hbloc : t.aye ≤ m) (hpass : passes c t = true) :
    c.seated < 2 * m := by
  obtain ⟨-, hsum⟩ := hcon
  simp only [passes, Bool.and_eq_true, decide_eq_true_eq] at hpass
  omega

/-- **No division can carry the Senate on its own.**  The Senate seats
`perDivision` members from each of `n` divisions; with two or more divisions,
the delegation of one division is never a majority, so a contested Senate vote
that a single delegation supports cannot pass. -/
theorem one_division_cannot_carry_the_senate {c : Chamber} {t : Tally}
    {n perDivision : Nat} (hseated : c.seated = n * perDivision) (hn : 2 ≤ n)
    (hcon : Contested c t) (hbloc : t.aye ≤ perDivision) :
    passes c t = false := by
  by_contra h
  have hpass : passes c t = true := by simpa using h
  have hlt := contested_passage_needs_majority_of_seats hcon hbloc hpass
  rw [hseated] at hlt
  have : 2 * perDivision ≤ n * perDivision := Nat.mul_le_mul_right _ hn
  omega

/-- **And therefore no division can enact on its own.**  A bill supported, in a
contested Senate, only by one division's delegation never becomes law. -/
theorem one_division_cannot_enact {g : Congress} {v : FederalVote} {n perDivision : Nat}
    (hseated : g.senate.seated = n * perDivision) (hn : 2 ≤ n)
    (hcon : Contested g.senate v.senate) (hbloc : v.senate.aye ≤ perDivision) :
    resolve g v ≠ .enacted ∧ resolve g v ≠ .overridden := by
  have hfail := one_division_cannot_carry_the_senate hseated hn hcon hbloc
  constructor
  · intro h
    rw [(enacted_iff.mp h).1] at hfail
    exact Bool.noConfusion hfail
  · intro h
    rw [(overridden_iff.mp h).1] at hfail
    exact Bool.noConfusion hfail

/-- **A division with no more than half the people gets no more than half the
House, give or take the one seat the quota rule allows.** -/
theorem house_bloc_bounded (ds : List Division) (H : Nat) {nm : String} {n : Nat}
    (h : (nm, n) ∈ houseSeats ds H) {d : Division} (hd : d ∈ ds) (hname : d.name = nm)
    (hnodup : (ds.map Division.name).Nodup) (hhalf : 2 * d.pop ≤ totalPop ds)
    (hP : 0 < totalPop ds) : 2 * n ≤ H + 2 := by
  obtain ⟨e, he, hename, hquota⟩ := seats_le_upper_quota ds H h
  have hde : d = e := by
    have := List.inj_on_of_nodup_map hnodup hd he (by rw [hname, hename])
    exact this
  subst hde
  have hq : d.pop * H / totalPop ds * (2 * totalPop ds) ≤ 2 * (d.pop * H) :=
    calc d.pop * H / totalPop ds * (2 * totalPop ds)
        = 2 * (d.pop * H / totalPop ds * totalPop ds) := by ring
      _ ≤ 2 * (d.pop * H) := by
          have := Nat.div_mul_le_self (d.pop * H) (totalPop ds)
          omega
  have hpop : 2 * (d.pop * H) ≤ totalPop ds * H := by
    calc 2 * (d.pop * H) = (2 * d.pop) * H := by ring
      _ ≤ totalPop ds * H := Nat.mul_le_mul_right _ hhalf
  have hmul : (2 * (d.pop * H / totalPop ds)) * totalPop ds ≤ H * totalPop ds := by
    calc (2 * (d.pop * H / totalPop ds)) * totalPop ds
        = d.pop * H / totalPop ds * (2 * totalPop ds) := by ring
      _ ≤ 2 * (d.pop * H) := hq
      _ ≤ totalPop ds * H := hpop
      _ = H * totalPop ds := Nat.mul_comm _ _
  have : 2 * (d.pop * H / totalPop ds) ≤ H := Nat.le_of_mul_le_mul_right hmul hP
  omega

end Federal
