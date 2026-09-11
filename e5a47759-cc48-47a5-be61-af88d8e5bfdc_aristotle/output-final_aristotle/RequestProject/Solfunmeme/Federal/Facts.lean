/-
  Facts.lean — the federal model, built out of the dataset's own senators.

  The union's thirteen states are the *accession blocks* of the Senate: the
  dataset records 52 snapshots, and `RequestProject/Badges/Data/Claims.lean`
  gives, for each of the 100 sitting senators, the snapshot at which their
  unbroken run of Senate-tier standing begins.  Grouping those 52 snapshots into
  thirteen blocks of four puts every senator in exactly one state — and every
  one of the thirteen blocks turns out to contain at least two senators, which
  is what makes the model work:

      Senate    two seats per state, filled by the state's two highest-ranked
                senators — 26 seats, every one of them held by an address whose
                key someone can prove they hold;
      House     500 seats apportioned to the states by stake (their senators'
                closing balances, in whole tokens) by the largest-remainder
                rule of `RequestProject/Federal/Apportion.lean`.

  All the figures below are checked by `decide`, so the kernel recomputes them
  from the claims table; nothing is asserted by hand and nothing is left to the
  compiler.

  The headline facts:

    * `states_length`, `every_state_has_two_senators`, `seated_length` — thirteen
      states, 26 seats, all filled;
    * `seated_nodup`, `seated_subset_roster` — by 26 distinct senators, every one
      of them on the dataset's roster;
    * `house_apportionment`, `house_total` — the House of 500, state by state;
    * `no_state_has_a_senate_majority`, `no_state_has_a_house_majority` — no
      state controls either chamber: the largest state holds 2 of 26 senators
      and 238 of 500 representatives;
    * `largest_state_overrepresented_in_the_house`,
      `smallest_state_overrepresented_in_the_senate` — the two chambers pull in
      opposite directions, which is the point of a federal legislature;
    * `congress_can_legislate` — and, unlike the dataset's own government, this
      one can act: `RequestProject/Review/` proves every bill under the
      published rules resolves to "no quorum", whereas here a seated Congress
      has votes that enact and votes that override a veto;
    * `senate_passage_needs_fourteen_signatures` — passing the federal Senate
      takes signed desk ballots from at least 14 distinct senators, each of whom
      holds the key to their address.
-/

import RequestProject.Solfunmeme.Federal.Roll
import RequestProject.Solfunmeme.Badges.Data.Claims

namespace Federal.Union

open Badges.Claim Federal Federal.Roll

/-! ### The thirteen states -/

/-- The 52 snapshots in blocks of four: a senator's state is the block in which
their unbroken Senate standing began. -/
def stateIndex (c : ClaimPage) : Nat := c.sinceIndex / 4

/-- The states, named by the first snapshot of their accession block. -/
def stateNames : List String :=
  ["since-00", "since-04", "since-08", "since-12", "since-16", "since-20", "since-24",
   "since-28", "since-32", "since-36", "since-40", "since-44", "since-48"]

/-- The senators of one state, in rank order. -/
def cohort (j : Nat) : List ClaimPage := claims.filter (fun c => stateIndex c == j)

/-- A state's stake: its senators' closing balances, in whole tokens (the mint
has six decimals). -/
def stateTokens (j : Nat) : Nat := ((cohort j).map (fun c => c.finalBalance / 1000000)).sum

/-- The union. -/
def states : List Division :=
  List.zipWith (fun nm j => Division.mk nm (stateTokens j)) stateNames (List.range 13)

theorem states_length : states.length = 13 := by decide

theorem state_names_nodup : (states.map Division.name).Nodup := by decide

/-- Every senator belongs to exactly one state, and the states account for all
100 of them. -/
theorem states_partition_the_roster :
    ((List.range 13).map (fun j => (cohort j).length)).sum = 100 ∧
      ((List.range 13).map (fun j => (cohort j).length)) =
        [48, 12, 4, 2, 9, 3, 2, 4, 3, 3, 2, 5, 3] := by decide

/-- The union's stake, in whole tokens. -/
theorem total_stake : totalPop states = 564653915 := by decide

theorem total_stake_pos : 0 < totalPop states := by decide

/-! ### The Senate: two seats per state -/

/-- A state's delegation: its two highest-ranked senators. -/
def delegation (j : Nat) : List String := ((cohort j).take 2).map (fun c => c.address)

/-- The senators seated in the federal Senate. -/
def seated : List String := ((List.range 13).map delegation).flatten

/-- **Every state can fill its two seats.** -/
theorem every_state_has_two_senators :
    ∀ j ∈ List.range 13, (delegation j).length = 2 := by decide

theorem seated_length : seated.length = 26 := by decide

/-- **Twenty-six different senators.** -/
theorem seated_nodup : seated.Nodup := by decide

/-- **All of them sit in the dataset's Senate**, so each of them has a badge
proving they hold the key to their address. -/
theorem seated_subset_roster : ∀ a ∈ seated, a ∈ Senate.Desk.roster := by decide

theorem seated_sub_roster : seated ⊆ Senate.Desk.roster := fun _ ha => seated_subset_roster _ ha

/-- The Senate seats, as the equal-representation rule hands them out. -/
theorem senate_apportionment :
    senateSeats states 2 =
      [("since-00", 2), ("since-04", 2), ("since-08", 2), ("since-12", 2), ("since-16", 2),
       ("since-20", 2), ("since-24", 2), ("since-28", 2), ("since-32", 2), ("since-36", 2),
       ("since-40", 2), ("since-44", 2), ("since-48", 2)] := by decide

theorem senate_total : ((senateSeats states 2).map Prod.snd).sum = 26 := by decide

/-! ### The House: 500 seats by stake -/

/-- **The apportionment**, largest remainders and all. -/
theorem house_apportionment :
    houseSeats states 500 =
      [("since-00", 238), ("since-36", 17), ("since-40", 8), ("since-28", 17),
       ("since-32", 11), ("since-24", 13), ("since-48", 25), ("since-08", 40),
       ("since-16", 42), ("since-04", 38), ("since-20", 15), ("since-12", 11),
       ("since-44", 25)] := by decide

/-- The House is exactly 500 seats — here by computation, and by
`apportion_total` for any union whatever. -/
theorem house_total : ((houseSeats states 500).map Prod.snd).sum = 500 := by decide

theorem house_total_general : ((houseSeats states 500).map Prod.snd).sum = 500 :=
  apportion_total states 500 total_stake_pos

/-! ### Neither chamber is controlled by one state -/

/-- **No state holds a majority of the House.**  The largest state, with 47.6%
of the stake, holds 238 seats of 500. -/
theorem no_state_has_a_house_majority :
    ∀ p ∈ houseSeats states 500, 2 * p.2 < 500 := by decide

/-- **No state holds a majority of the Senate**: two seats out of 26. -/
theorem no_state_has_a_senate_majority :
    ∀ p ∈ senateSeats states 2, 2 * p.2 < 26 := by decide

/-! ### The two chambers pull in opposite directions -/

/-- The largest state's share of the House is larger than its share of the
Senate: 238/500 against 2/26. -/
theorem largest_state_overrepresented_in_the_house :
    (2 : ℚ) / 26 < 238 / 500 := by norm_num

/-- The smallest state's share of the Senate is larger than its share of the
stake — this is the general theorem `small_division_overrepresented`, for the
state that entered at snapshot 40. -/
theorem smallest_state_overrepresented_in_the_senate :
    ((8918497 : ℚ)) / totalPop states < 1 / (states.length : ℚ) := by
  have hmem : (⟨"since-40", 8918497⟩ : Division) ∈ states := by decide
  have hsmall : (8918497 : Nat) * states.length < totalPop states := by decide
  have := small_division_overrepresented states hmem hsmall
  simpa using this

/-! ### The Congress -/

/-- The Senate of the union: 26 seats, all of them filled. -/
def senate : Chamber := ⟨"Senate", 26, 26⟩

/-- The House of the union: 500 seats, all of them filled. -/
def house : Chamber := ⟨"House", 500, 500⟩

/-- The federal legislature of SOLFUNMEME. -/
def congress : Congress := ⟨senate, house⟩

theorem senate_seats_are_two_per_state : senate.seats = 13 * 2 := by decide

theorem senate_quorum_is_fourteen : quorum senate = 14 := by decide

theorem house_quorum_is_251 : quorum house = 251 := by decide

/-- **The federal Congress can legislate.**  With both chambers seated there is
a vote that enacts a bill and a vote that overrides a veto.  The dataset's own
government cannot do either: under its rules every bill resolves to "no
quorum". -/
theorem congress_can_legislate :
    resolve congress ⟨⟨26, 0, 0⟩, ⟨500, 0, 0⟩, false⟩ = .enacted ∧
      resolve congress ⟨⟨26, 0, 0⟩, ⟨500, 0, 0⟩, true⟩ = .overridden := by
  exact ⟨enactment_attainable congress (by decide) (by decide),
    override_attainable congress (by decide) (by decide)⟩

/-- **No state can carry the Senate on its own.**  A state's delegation is two
senators of 26; on a vote where every senator votes, two ayes never pass the
chamber. -/
theorem no_state_can_carry_the_senate {t : Tally} (hcon : Contested senate t)
    (hbloc : t.aye ≤ 2) : passes senate t = false :=
  one_division_cannot_carry_the_senate (n := 13) (perDivision := 2) rfl (by decide) hcon hbloc

/-! ### The Senate votes at the senators' desk -/

/-- **Passing the federal Senate takes fourteen signed ballots.**  The tally is
read off the senators' own desk, so a bill carries the chamber only if at least
14 of the 26 seated senators posted a signed ballot on it. -/
theorem senate_passage_needs_fourteen_signatures {billId : String} {f : Senate.Desk.Feed}
    (h : passes senate (chamberTally seated billId f) = true) :
    14 ≤ (rollCall seated billId f).length := by
  have := passage_needs_quorum_of_ballots h
  rwa [senate_quorum_is_fourteen] at this

/-- **And those fourteen are distinct senators of the dataset**, each holding
the key to their own address — the only assumption being the desk's
unforgeability assumption about the signature scheme. -/
theorem senate_passage_needs_fourteen_senators {V H} {HasKey : String → Prop}
    (hV : Senate.Desk.OnlyKeyHolderSigns V HasKey) {f : Senate.Desk.Feed}
    (hf : Senate.Desk.Valid V H f) {billId : String}
    (h : passes senate (chamberTally seated billId f) = true) :
    ∃ voters : List String, voters.Nodup ∧ 14 ≤ voters.length ∧
      ∀ a ∈ voters, HasKey a ∧ a ∈ Senate.Desk.roster := by
  obtain ⟨voters, hnd, hlen, hall⟩ :=
    passage_needs_quorum_of_senators hV hf seated_sub_roster h
  exact ⟨voters, hnd, by rwa [senate_quorum_is_fourteen] at hlen, hall⟩

/-- **The roll call never exceeds the chamber.** -/
theorem senate_roll_le_26 (billId : String) (f : Senate.Desk.Feed) :
    (rollCall seated billId f).length ≤ 26 := by
  have := rollCall_le_seats seated billId f
  rwa [seated_length] at this

end Federal.Union
