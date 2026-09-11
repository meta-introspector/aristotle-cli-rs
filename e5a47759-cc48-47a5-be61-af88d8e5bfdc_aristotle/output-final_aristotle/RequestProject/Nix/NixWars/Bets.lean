import RequestProject.Nix.NixWars.Learn
import RequestProject.Nix.NixWars.WasmBinary

/-!
# The betting floor: a market on truth, size and speed

Punters back claims about the arcade. A claim is not a slogan — it carries the
Lean proposition it is about, and its verdict is that proposition's truth value
(`Claim.verdict`, tied to the proposition itself by `Claim.verdict_true_iff`).
So the market settles on what is actually the case in the development, not on
an oracle's say-so.

The book is parimutuel: everything staked on a claim goes into one pool, and
when the claim settles the pool is shared out among the backers of the winning
side in proportion to their stakes. Proved here:

* a punter on the losing side is paid nothing (`payout_loser`);
* **the book is solvent** — the payouts never exceed the pool
  (`payouts_le_pool`), and neither does the whole floor
  (`floor_payouts_le_floor_pool`): no credit is minted;
* a winning punter never gets back less than the stake (`payout_ge_stake`),
  and a sole backer of the winning side takes the whole pool
  (`sole_winner_takes_pool`);
* the implied percentages of the two sides never add to more than a hundred
  (`implied_add_le_hundred`);
* **backing what Lean refutes pays nothing** (`payout_false_claim`), and
  backing what Lean proves is what gets paid (`payout_true_claim`).

The floor itself is stocked with claims about this arcade: how the games end
(truth), how big the shipped module is (size), how quickly a cabinet can be
cleared (speed), and how well the trained agent plays.
-/

set_option maxRecDepth 40000
set_option maxHeartbeats 2000000

namespace NixWars

namespace Bets

/-! ## Claims -/

/-- What a claim is about. -/
inductive Attr
  /-- Something is or is not the case. -/
  | truth
  /-- How big an artefact is. -/
  | size
  /-- How few commands something takes. -/
  | speed
  /-- How well the agent plays. -/
  | skill
  deriving DecidableEq, Repr, Inhabited

/-- The name of an attribute, for the board. -/
def Attr.name : Attr → String
  | .truth => "TRUTH"
  | .size => "SIZE"
  | .speed => "SPEED"
  | .skill => "SKILL"

/-- A claim the floor takes bets on: a key, the attribute it is about, the line
as it is chalked up, and — the point of the whole thing — the Lean proposition
it stands for, together with a way to decide it. -/
structure Claim where
  /-- The key the page uses. -/
  key : String
  /-- What the claim is about. -/
  attr : Attr
  /-- The line as chalked on the board. -/
  line : String
  /-- The proposition the claim stands for. -/
  prop : Prop
  /-- The proposition is decidable, so the claim settles itself. -/
  dec : Decidable prop

/-- How a claim settles: the truth value of the proposition it stands for. -/
def Claim.verdict (c : Claim) : Bool := @decide c.prop c.dec

/-- **The verdict is the proposition.** Nothing else settles the market. -/
theorem Claim.verdict_true_iff (c : Claim) : c.verdict = true ↔ c.prop :=
  @decide_eq_true_iff c.prop c.dec

theorem Claim.verdict_false_iff (c : Claim) : c.verdict = false ↔ ¬ c.prop := by
  rw [← Bool.not_eq_true, c.verdict_true_iff]

/-! ## The book -/

/-- A punter's ticket: who, which side, how much. -/
structure Ticket where
  /-- The punter's handle. -/
  punter : String
  /-- The side backed: `true` for the claim, `false` against it. -/
  side : Bool
  /-- What is staked, in credits. -/
  stake : Nat
  deriving DecidableEq, Repr, Inhabited

/-- A book: one claim and the tickets written on it. -/
structure Book where
  /-- The claim being bet on. -/
  claim : Claim
  /-- The tickets. -/
  tickets : List Ticket

/-- The stakes on one side of a list of tickets. -/
def staked (ts : List Ticket) (side : Bool) : Nat :=
  ((ts.filter (fun t => t.side == side)).map (fun t => t.stake)).sum

/-- Everything staked on the book. -/
def pool (b : Book) : Nat := staked b.tickets true + staked b.tickets false

/-- What the winning side staked between them. -/
def winners (b : Book) : Nat := staked b.tickets b.claim.verdict

/-- What one ticket is paid when the book settles. -/
def payout (b : Book) (t : Ticket) : Nat :=
  if t.side = b.claim.verdict then
    (if winners b = 0 then 0 else t.stake * pool b / winners b)
  else 0

/-- Everything the book pays out. -/
def payouts (b : Book) : Nat := (b.tickets.map (payout b)).sum

/-! ### Solvency -/

/-- Sum of stakes, split by side, is the whole pool. -/
theorem staked_true_add_false (ts : List Ticket) :
    staked ts true + staked ts false = (ts.map (fun t => t.stake)).sum := by
  induction ts with
  | nil => rfl
  | cons t ts ih =>
      cases h : t.side <;>
        · simp only [staked, List.filter_cons, h] at *
          simp only [beq_iff_eq, List.map_cons, List.sum_cons] at *
          simp_all
          omega

/-- The winning side never staked more than the whole pool. -/
theorem winners_le_pool (b : Book) : winners b ≤ pool b := by
  unfold winners pool
  cases h : b.claim.verdict
  · omega
  · omega

/-- Floor division distributes over a sum, downwards. -/
theorem sum_div_le (xs : List Nat) (w : Nat) :
    (xs.map (fun x => x / w)).sum ≤ xs.sum / w := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
      simp only [List.map_cons, List.sum_cons]
      exact Nat.le_trans (Nat.add_le_add_left ih _) (Nat.add_div_le_add_div x xs.sum w)

/-- Multiplying a list of stakes through by the pool. -/
theorem sum_map_mul (xs : List Nat) (p : Nat) :
    (xs.map (fun x => x * p)).sum = xs.sum * p := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih, Nat.add_mul]

/-- The payouts of a list of tickets, bounded by what that list's winners
staked. -/
theorem payouts_aux (b : Book) (ts : List Ticket) :
    (ts.map (payout b)).sum ≤ staked ts b.claim.verdict * pool b / winners b := by
  by_cases hw : winners b = 0
  · have : ∀ t ∈ ts, payout b t = 0 := by
      intro t _
      simp [payout, hw]
    calc (ts.map (payout b)).sum = (ts.map (fun _ => 0)).sum := by
            rw [List.map_congr_left this]
      _ = 0 := by simp
      _ ≤ _ := Nat.zero_le _
  · induction ts with
    | nil => simp [staked]
    | cons t ts ih =>
        simp only [List.map_cons, List.sum_cons, staked, List.filter_cons]
        by_cases h : t.side = b.claim.verdict
        · simp only [payout, h, if_pos, beq_iff_eq, hw, if_false]
          simp only [List.map_cons, List.sum_cons]
          refine Nat.le_trans (Nat.add_le_add_left ih _) ?_
          have := Nat.add_div_le_add_div (t.stake * pool b)
            (staked ts b.claim.verdict * pool b) (winners b)
          refine Nat.le_trans this (Nat.le_of_eq ?_)
          rw [← Nat.add_mul]
          rfl
        · have hne : (t.side == b.claim.verdict) = false := by
            simp [h]
          simp only [payout, h, if_false, hne, Nat.zero_add]
          exact ih

/-- **The book is solvent.** However the claim settles, the punters between
them are paid no more than they staked: the market mints nothing. -/
theorem payouts_le_pool (b : Book) : payouts b ≤ pool b := by
  by_cases hw : winners b = 0
  · unfold payouts
    have : ∀ t ∈ b.tickets, payout b t = 0 := by
      intro t _; simp [payout, hw]
    rw [List.map_congr_left this]
    simp
  · refine Nat.le_trans (payouts_aux b b.tickets) ?_
    have hpos : 0 < winners b := Nat.pos_of_ne_zero hw
    have hcancel : staked b.tickets b.claim.verdict * pool b / winners b = pool b :=
      Nat.mul_div_cancel_left _ hpos
    exact Nat.le_of_eq hcancel

/-- A punter on the losing side is paid nothing. -/
theorem payout_loser (b : Book) (t : Ticket) (h : t.side ≠ b.claim.verdict) :
    payout b t = 0 := by
  simp [payout, h]

/-- **Backing what Lean refutes pays nothing.** -/
theorem payout_false_claim (b : Book) (t : Ticket) (hc : ¬ b.claim.prop) (h : t.side = true) :
    payout b t = 0 := by
  refine payout_loser b t ?_
  rw [h, b.claim.verdict_false_iff.mpr hc]
  simp

/-- **Backing what Lean proves is what gets paid**: when the claim holds, the
tickets that are paid are exactly the ones backing it. -/
theorem payout_true_claim (b : Book) (t : Ticket) (hc : b.claim.prop) (h : t.side = false) :
    payout b t = 0 := by
  refine payout_loser b t ?_
  rw [h, b.claim.verdict_true_iff.mpr hc]
  simp

/-- A winning punter gets back at least the stake. -/
theorem payout_ge_stake (b : Book) (t : Ticket) (h : t.side = b.claim.verdict)
    (hw : 0 < winners b) : t.stake ≤ payout b t := by
  have hne : winners b ≠ 0 := Nat.ne_of_gt hw
  rw [payout, if_pos h, if_neg hne, Nat.le_div_iff_mul_le hw]
  exact Nat.mul_le_mul_left t.stake (winners_le_pool b)

/-- A sole backer of the winning side takes the whole pool. -/
theorem sole_winner_takes_pool (b : Book) (t : Ticket) (h : t.side = b.claim.verdict)
    (hw : winners b = t.stake) (hs : 0 < t.stake) : payout b t = pool b := by
  have hw0 : winners b ≠ 0 := by omega
  rw [payout, if_pos h, if_neg hw0, hw, Nat.mul_comm, Nat.mul_div_cancel _ hs]

/-! ### The chalk board -/

/-- The percentage the book implies for a side: its share of the pool. -/
def implied (b : Book) (side : Bool) : Nat :=
  if pool b = 0 then 0 else staked b.tickets side * 100 / pool b

/-- **The board never adds up to more than a hundred.** Floor division loses a
point here and there, but the two implied percentages never overstate. -/
theorem implied_add_le_hundred (b : Book) : implied b true + implied b false ≤ 100 := by
  by_cases h : pool b = 0
  · simp [implied, h]
  · have hpos : 0 < pool b := Nat.pos_of_ne_zero h
    simp only [implied, h, if_false]
    refine Nat.le_trans (Nat.add_div_le_add_div _ _ _) ?_
    rw [← Nat.add_mul]
    have hsum : staked b.tickets true + staked b.tickets false = pool b := rfl
    rw [hsum, Nat.mul_comm, Nat.mul_div_cancel _ hpos]

/-! ### The whole floor -/

/-- Everything staked across a floor of books. -/
def floorPool (bs : List Book) : Nat := (bs.map pool).sum

/-- Everything paid out across a floor of books. -/
def floorPayouts (bs : List Book) : Nat := (bs.map payouts).sum

/-- **The floor as a whole is solvent.** -/
theorem floor_payouts_le_floor_pool (bs : List Book) : floorPayouts bs ≤ floorPool bs := by
  induction bs with
  | nil => exact Nat.le_refl 0
  | cons b bs ih =>
      simp only [floorPayouts, floorPool, List.map_cons, List.sum_cons]
      exact Nat.add_le_add (payouts_le_pool b) ih

end Bets

/-! ## The claims this arcade takes bets on -/

open Bets

/-- **Truth.** The pyramid can be cleared with every life still in hand: this
is the content of `qbert_run_score`. -/
def claimPyramidClean : Claim where
  key := "pyramid-clean"
  attr := .truth
  line := "MONSTER CUBES clears with all three lives"
  prop := qbertPainted (monsterCubes.run initialQbert qbertClearingRun) = 10 ∧
    (monsterCubes.run initialQbert qbertClearingRun).lives = 3
  dec := inferInstance

theorem claimPyramidClean_settles : claimPyramidClean.verdict = true :=
  (Claim.verdict_true_iff _).mpr qbert_run_score

/-- **Truth, the other way.** The trained agent does *not* throw a life away —
so this claim settles against its backers. -/
def claimAgentDies : Claim where
  key := "agent-dies"
  attr := .truth
  line := "the trained agent loses a life"
  prop := (Learn.outcome monsterCubes initialQbert qbertLearned).lives < 3
  dec := inferInstance

theorem claimAgentDies_settles : claimAgentDies.verdict = false := rfl

/-- **Size.** The shipped WebAssembly module fits in eight kilobytes. -/
def claimModuleUnder8k : Claim where
  key := "module-8k"
  attr := .size
  line := "the shipped module is under 8192 bytes"
  prop := Wasm.wasmBytes.length ≤ 8192
  dec := inferInstance

theorem claimModuleUnder8k_settles : claimModuleUnder8k.verdict = true := rfl

/-- **Size, the other way.** It does not fit in four. -/
def claimModuleUnder4k : Claim where
  key := "module-4k"
  attr := .size
  line := "the shipped module is under 4096 bytes"
  prop := Wasm.wasmBytes.length ≤ 4096
  dec := inferInstance

theorem claimModuleUnder4k_settles : claimModuleUnder4k.verdict = false := rfl

/-- **Speed.** The invader rank goes down in nine commands. -/
def claimInvadersNine : Claim where
  key := "invaders-9"
  attr := .speed
  line := "SHARD INVADERS clears in nine commands"
  prop := invadersClearingRun.length ≤ 9 ∧
    invadersAlive (shardInvaders.run initialInvaders invadersClearingRun) = 0
  dec := inferInstance

theorem claimInvadersNine_settles : claimInvadersNine.verdict = true := rfl

/-- **Speed, the other way.** Eight commands are not enough for the plan the
agent found. -/
def claimInvadersEight : Claim where
  key := "invaders-8"
  attr := .speed
  line := "the trained agent clears the rank in eight commands"
  prop := invadersLearned.length ≤ 8
  dec := inferInstance

theorem claimInvadersEight_settles : claimInvadersEight.verdict = false := rfl

/-- **Skill.** Watching a recorded game beats playing alone. -/
def claimLearningWins : Claim where
  key := "learning-wins"
  attr := .skill
  line := "the agent that watched a recorded game outscores the one that did not"
  prop := Learn.value monsterCubes qbertReward initialQbert qbertSelfPlayed <
    Learn.value monsterCubes qbertReward initialQbert qbertLearned
  dec := inferInstance

theorem claimLearningWins_settles : claimLearningWins.verdict = true :=
  (Claim.verdict_true_iff _).mpr qbert_library_beats_selfplay

/-! ## The floor as it stands -/

/-- The book on the pyramid: three punters for, one against. -/
def bookPyramid : Book where
  claim := claimPyramidClean
  tickets :=
    [ { punter := "jmikedupont2", side := true, stake := 47 },
      { punter := "nathan", side := true, stake := 12 },
      { punter := "nydiokar", side := false, stake := 59 },
      { punter := "kanebra", side := true, stake := 12 } ]

/-- The book on the size of the module. -/
def bookSize : Book where
  claim := claimModuleUnder8k
  tickets :=
    [ { punter := "nathan", side := true, stake := 71 },
      { punter := "kanebra", side := false, stake := 23 } ]

/-- The book on how fast the rank goes down. -/
def bookSpeed : Book where
  claim := claimInvadersNine
  tickets :=
    [ { punter := "nydiokar", side := true, stake := 31 },
      { punter := "jmikedupont2", side := false, stake := 31 } ]

/-- The book on the agent. -/
def bookSkill : Book where
  claim := claimLearningWins
  tickets :=
    [ { punter := "kanebra", side := true, stake := 59 },
      { punter := "nathan", side := false, stake := 47 },
      { punter := "nydiokar", side := true, stake := 11 } ]

/-- The floor: four books. -/
def bettingFloor : List Book := [bookPyramid, bookSize, bookSpeed, bookSkill]

/-- A hundred and thirty credits are on the pyramid. -/
theorem bookPyramid_pool : pool bookPyramid = 130 := rfl

/-- The pyramid settles for its backers: the punter who staked forty-seven of
the seventy-one on the winning side takes eighty-six of the hundred and thirty.
-/
theorem bookPyramid_payouts :
    bookPyramid.tickets.map (payout bookPyramid) = [86, 21, 0, 21] := rfl

/-- Nothing is minted on the pyramid: the dust of the division stays in the
pool. -/
theorem bookPyramid_solvent : payouts bookPyramid ≤ pool bookPyramid :=
  payouts_le_pool bookPyramid

/-- The whole floor holds two hundred and seventy-three credits. -/
theorem bettingFloor_pool : floorPool bettingFloor = 403 := rfl

/-- **The floor is solvent.** -/
theorem bettingFloor_solvent : floorPayouts bettingFloor ≤ floorPool bettingFloor :=
  floor_payouts_le_floor_pool bettingFloor

/-- The punter who bet against the pyramid backed something Lean refutes, and
is paid nothing. -/
theorem bookPyramid_against_pays_nothing (t : Ticket) (h : t.side = false) :
    payout bookPyramid t = 0 := by
  refine payout_loser bookPyramid t ?_
  rw [h, show bookPyramid.claim.verdict = true from claimPyramidClean_settles]
  simp

end NixWars
