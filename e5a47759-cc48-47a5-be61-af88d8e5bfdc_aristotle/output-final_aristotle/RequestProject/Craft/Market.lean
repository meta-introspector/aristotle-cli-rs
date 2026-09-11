import RequestProject.Craft.Broadcast

/-!
# A betting market on the games

The last piece of the broadcast is the market the audience bets into.  A
**book** is one attribute of one game — will it finish above two thousand? will
the factory be at least twenty parts? will it get to a thousand inside sixty
moves? is the model's game really free of blunders? — together with the bets
laid on it.

The market is parimutuel: everybody's stake goes into one pool, and when the
game is over the pool is divided among the people who called it right, in
proportion to what they staked.  If nobody called it right, everybody is
refunded.

Two things make this market unusual, and both are theorems rather than
promises.

*The market settles on the game record itself.*  `settle` reads the answer off
the recording — the same recording the clip is cut from — so an attribute is
not a matter of opinion, and `payout_congr` says the money depends on the game
in no other way.

*The book cannot pay out more than it took in.*  `total_payout_le_pool` is
proved for every book, every game and every set of bets.

Proved here:

* `sideSum_add` — the two sides of a book add up to the pool;
* `total_payout_le_pool` — **the book never pays out more than the pool**;
* `refund_total` — when nobody called it right, everybody gets exactly their
  stake back, and that is the whole pool;
* `payout_ge_stake_of_win` — **a winner never loses money**;
* `payout_loser_zero` — and a loser is paid nothing;
* `payout_congr` — the payouts depend on the game only through the attribute's
  settled value;
* `settle_score_iff`, `settle_size_iff`, `settle_speed_iff`, `settle_clean_iff`
  — what each attribute means, exactly;
* `settle_speed_frame` — **a speed bet is settled by the frame the audience
  watched**: the position at ply `k` of the replay;
* `settle_clean_witness` — a "clean game" bet that settles *no* has a witness:
  the critic's own flag, backed by a real better line;
* `prices_coherent` — the implied yes and no prices never add to more than one;
* `market_report` — a worked market on the trained model's game, with its
  settlements and payouts, checked by evaluation.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon
namespace Market

/-! ## What can be bet on -/

/-- The attributes of a game a punter can bet on. -/
inductive Attr where
  /-- The game finishes with at least this much cash. -/
  | score (n : Nat)
  /-- At least this many parts are standing at the end. -/
  | size (n : Nat)
  /-- Cash reaches the target within this many moves. -/
  | speed (target ply : Nat)
  /-- The critic, reading the game back against this database, flags nothing. -/
  | clean (db : DB)
  /-- Any other decidable claim about the game record. -/
  | truth (p : Recording → Bool)

/-- **Settlement.** Every attribute is decided by the recorded game — the same
record the clip is cut from — and by nothing else. -/
def settle : Attr → Recording → Bool
  | .score n, r => decide (n ≤ r.final.cash)
  | .size n, r => decide (n ≤ r.final.scene.length)
  | .speed target ply, r => decide (target ≤ (GameState.run r.init (r.moves.take ply)).cash)
  | .clean db, r => (critique db r).isEmpty
  | .truth p, r => p r

theorem settle_score_iff (n : Nat) (r : Recording) :
    settle (.score n) r = true ↔ n ≤ r.final.cash := by simp [settle]

theorem settle_size_iff (n : Nat) (r : Recording) :
    settle (.size n) r = true ↔ n ≤ r.final.scene.length := by simp [settle]

theorem settle_speed_iff (target ply : Nat) (r : Recording) :
    settle (.speed target ply) r = true ↔
      target ≤ (GameState.run r.init (r.moves.take ply)).cash := by simp [settle]

theorem settle_clean_iff (db : DB) (r : Recording) :
    settle (.clean db) r = true ↔ critique db r = [] := by
  simp [settle, List.isEmpty_iff]

/-- **A speed bet is settled by the frame the audience watched.** -/
theorem settle_speed_frame (target ply : Nat) (r : Recording) (h : ply < r.frames.length) :
    settle (.speed target ply) r = true ↔ target ≤ (r.frames[ply]).cash := by
  rw [settle_speed_iff, Recording.frames_getElem r ply h]

/-- **A lost "clean game" bet has a witness.** If the critic flags the game, the
flag names a position, the move played there, and a strictly better move on
record — and, in a sound database, a real line that proves it. -/
theorem settle_clean_witness {db : DB} (hs : Sound db) {r : Recording}
    (h : settle (.clean db) r = false) :
    ∃ b ∈ critique db r, ∃ rest : List Action,
      (GameState.run (b.key.step b.better) rest).cash = b.bestResult ∧
      moveScore db b.key b.played < b.bestResult := by
  have hne : critique db r ≠ [] := by
    intro hnil
    rw [settle, hnil] at h
    simp at h
  obtain ⟨b, hb⟩ := List.exists_mem_of_ne_nil _ hne
  obtain ⟨hlt, hres, hbest, _⟩ := critique_sound db r.moves r.init 0 b hb
  obtain ⟨rest, hrest, _⟩ := critique_improvable hs hbest hres hlt
  exact ⟨b, hb, rest, hrest, hlt⟩

/-! ## The book -/

/-- One bet: who laid it, which way, and how much. -/
structure Bet where
  /-- Who laid the bet. -/
  punter : Nat
  /-- `true` for yes, `false` for no. -/
  yes : Bool
  /-- What was staked. -/
  stake : Nat
deriving DecidableEq, Repr, Inhabited

/-- The total staked. -/
def stakeSum (l : List Bet) : Nat := (l.map Bet.stake).sum

/-- The total staked on one side. -/
def sideSum (side : Bool) (l : List Bet) : Nat :=
  stakeSum (l.filter (fun x => x.yes == side))

/-- The pool, one bet at a time. -/
theorem stakeSum_cons (x : Bet) (t : List Bet) : stakeSum (x :: t) = x.stake + stakeSum t := rfl

/-- One side's pool, one bet at a time. -/
theorem sideSum_cons (side : Bool) (x : Bet) (t : List Bet) :
    sideSum side (x :: t) = (if x.yes = side then x.stake else 0) + sideSum side t := by
  by_cases hx : x.yes = side <;> simp [sideSum, stakeSum, hx]

/-- **The two sides add up to the pool.** -/
theorem sideSum_add : ∀ l : List Bet, sideSum true l + sideSum false l = stakeSum l := by
  intro l
  induction l with
  | nil => rfl
  | cons x t ih =>
      rw [sideSum_cons, sideSum_cons, stakeSum_cons]
      cases hx : x.yes <;> simp <;> omega

theorem sideSum_le (side : Bool) : ∀ l : List Bet, sideSum side l ≤ stakeSum l := by
  intro l
  have := sideSum_add l
  cases side <;> omega

/-! ## Payouts -/

/-- What one bet is paid, given the settled outcome, the pool and the winning
side's pool.  If nobody backed the winning side, every bet is refunded. -/
def payoutIn (out : Bool) (P W : Nat) (x : Bet) : Nat :=
  if W = 0 then x.stake
  else if x.yes = out then x.stake * P / W else 0

/-- The whole payout of a list of bets. -/
def totalPayoutIn (out : Bool) (P W : Nat) (l : List Bet) : Nat :=
  (l.map (payoutIn out P W)).sum

/-! ### Two arithmetic lemmas -/

theorem sum_div_le {c : Nat} (hc : 0 < c) :
    ∀ l : List Nat, ((l.map (fun x => x / c)).sum) ≤ (l.sum) / c := by
  intro l
  induction l with
  | nil => simp
  | cons a t ih =>
      simp only [List.map_cons, List.sum_cons]
      rw [Nat.le_div_iff_mul_le hc, Nat.add_mul]
      have h1 : a / c * c ≤ a := Nat.div_mul_le_self a c
      have h2 : (t.map (fun x => x / c)).sum * c ≤ t.sum := by
        have h3 := ih
        rw [Nat.le_div_iff_mul_le hc] at h3
        exact h3
      omega

theorem add_div_le {c : Nat} (hc : 0 < c) (a b : Nat) : a / c + b / c ≤ (a + b) / c := by
  rw [Nat.le_div_iff_mul_le hc, Nat.add_mul]
  have h1 : a / c * c ≤ a := Nat.div_mul_le_self a c
  have h2 : b / c * c ≤ b := Nat.div_mul_le_self b c
  omega

/-- What the winning side is owed, before division: its pool times the whole
pool. -/
theorem winners_stake_mul (out : Bool) (P : Nat) :
    ∀ l : List Bet,
      (l.map (fun x => if x.yes = out then x.stake * P else 0)).sum = sideSum out l * P := by
  intro l
  induction l with
  | nil => simp [sideSum, stakeSum]
  | cons x t ih =>
      rw [List.map_cons, List.sum_cons, ih, sideSum_cons, Nat.add_mul]
      by_cases hx : x.yes = out <;> simp [hx]

/-! ### The book is solvent -/

/-- **Nobody called it right**: everybody is refunded exactly their stake, and
that is the whole pool. -/
theorem totalPayoutIn_zero (out : Bool) (P : Nat) :
    ∀ l : List Bet, totalPayoutIn out P 0 l = stakeSum l := by
  intro l
  induction l with
  | nil => rfl
  | cons x t ih =>
      simp only [totalPayoutIn, List.map_cons, List.sum_cons, payoutIn] at ih ⊢
      rw [stakeSum_cons, ih]
      simp

theorem refund_total (out : Bool) (l : List Bet) (h : sideSum out l = 0) :
    totalPayoutIn out (stakeSum l) (sideSum out l) l = stakeSum l := by
  rw [h]
  exact totalPayoutIn_zero out _ l

/-- **The book never pays out more than the pool.** -/
theorem total_payout_le_pool (out : Bool) (l : List Bet) :
    totalPayoutIn out (stakeSum l) (sideSum out l) l ≤ stakeSum l := by
  by_cases hw : sideSum out l = 0
  · exact le_of_eq (refund_total out l hw)
  · have hwpos : 0 < sideSum out l := Nat.pos_of_ne_zero hw
    have hstep : ∀ x : Bet,
        payoutIn out (stakeSum l) (sideSum out l) x
          = (if x.yes = out then x.stake * stakeSum l else 0) / sideSum out l := by
      intro x
      simp only [payoutIn, if_neg hw]
      by_cases hx : x.yes = out <;> simp [hx]
    have hmap : totalPayoutIn out (stakeSum l) (sideSum out l) l
        = (l.map (fun x => (if x.yes = out then x.stake * stakeSum l else 0)
            / sideSum out l)).sum := by
      simp only [totalPayoutIn]
      congr 1
      exact List.map_congr_left (fun x _ => hstep x)
    rw [hmap]
    have h1 := sum_div_le hwpos (l.map (fun x => if x.yes = out then x.stake * stakeSum l else 0))
    rw [winners_stake_mul out (stakeSum l) l] at h1
    refine le_trans (by simpa [List.map_map, Function.comp] using h1) ?_
    exact le_of_eq (Nat.mul_div_cancel_left _ hwpos)

/-- **A winner never loses money.** -/
theorem payout_ge_stake_of_win {out : Bool} {l : List Bet} {x : Bet}
    (hw : 0 < sideSum out l) (hx : x.yes = out) :
    x.stake ≤ payoutIn out (stakeSum l) (sideSum out l) x := by
  have hwne : ¬ sideSum out l = 0 := by omega
  simp only [payoutIn, if_neg hwne, if_pos hx]
  have hPW : sideSum out l ≤ stakeSum l := sideSum_le out l
  have h1 : x.stake * sideSum out l ≤ x.stake * stakeSum l := Nat.mul_le_mul_left _ hPW
  have h2 : x.stake * sideSum out l / sideSum out l = x.stake := Nat.mul_div_cancel _ hw
  calc x.stake = x.stake * sideSum out l / sideSum out l := h2.symm
    _ ≤ x.stake * stakeSum l / sideSum out l := Nat.div_le_div_right h1

/-- A loser is paid nothing. -/
theorem payout_loser_zero {out : Bool} {P W : Nat} {x : Bet}
    (hw : 0 < W) (hx : x.yes ≠ out) : payoutIn out P W x = 0 := by
  have hwne : ¬ W = 0 := by omega
  simp [payoutIn, hwne, hx]

/-! ## The market -/

/-- A book: one attribute of one game, and the bets laid on it. -/
structure Book where
  /-- What is being bet on. -/
  attr : Attr
  /-- The bets. -/
  bets : List Bet

namespace Book

/-- Everything staked into the book. -/
def pool (b : Book) : Nat := stakeSum b.bets

/-- How the game settled the attribute. -/
def outcome (b : Book) (r : Recording) : Bool := settle b.attr r

/-- What the winning side staked. -/
def winPool (b : Book) (r : Recording) : Nat := sideSum (b.outcome r) b.bets

/-- What one bet is paid once the game is in. -/
def payout (b : Book) (r : Recording) (x : Bet) : Nat :=
  payoutIn (b.outcome r) b.pool (b.winPool r) x

/-- What the book pays out in total. -/
def totalPayout (b : Book) (r : Recording) : Nat :=
  (b.bets.map (b.payout r)).sum

/-- **The book is solvent**: whatever the game does, it never pays out more
than it took in. -/
theorem totalPayout_le_pool (b : Book) (r : Recording) : b.totalPayout r ≤ b.pool :=
  total_payout_le_pool (b.outcome r) b.bets

/-- **The market depends on the game only through the settled attribute.**  Two
games the attribute settles the same way pay exactly the same money. -/
theorem payout_congr (b : Book) (r₁ r₂ : Recording) (h : settle b.attr r₁ = settle b.attr r₂)
    (x : Bet) : b.payout r₁ x = b.payout r₂ x := by
  simp only [payout, outcome, winPool, h]

/-- A winner never loses money. -/
theorem payout_ge_stake {b : Book} {r : Recording} {x : Bet}
    (hw : 0 < b.winPool r) (hx : x.yes = b.outcome r) : x.stake ≤ b.payout r x :=
  payout_ge_stake_of_win hw hx

/-- A loser is paid nothing. -/
theorem payout_zero {b : Book} {r : Recording} {x : Bet}
    (hw : 0 < b.winPool r) (hx : x.yes ≠ b.outcome r) : b.payout r x = 0 :=
  payout_loser_zero hw hx

/-- Nobody on the winning side: everybody is refunded. -/
theorem refund (b : Book) (r : Recording) (h : b.winPool r = 0) :
    b.totalPayout r = b.pool :=
  refund_total (b.outcome r) b.bets h

/-! ### Prices -/

/-- The implied price of a side, in basis points of the pool. -/
def price (b : Book) (side : Bool) : Nat := sideSum side b.bets * 10000 / b.pool

/-- **The prices are coherent**: yes and no never add up to more than one. -/
theorem prices_coherent (b : Book) (h : 0 < b.pool) :
    b.price true + b.price false ≤ 10000 := by
  have hsum := sideSum_add b.bets
  have h1 := add_div_le h (sideSum true b.bets * 10000) (sideSum false b.bets * 10000)
  have h2 : sideSum true b.bets * 10000 + sideSum false b.bets * 10000 = b.pool * 10000 := by
    rw [← Nat.add_mul, hsum]
    rfl
  rw [h2] at h1
  have h3 : b.pool * 10000 / b.pool = 10000 := Nat.mul_div_cancel_left 10000 h
  simp only [price]
  omega

end Book

/-! ## A worked market on the trained model's game -/

/-- Will the trained model's game finish above two thousand? -/
def scoreBook : Book :=
  { attr := .score 2000, bets := [⟨1, true, 100⟩, ⟨2, false, 300⟩, ⟨3, true, 100⟩] }

/-- Will the factory be twenty parts or more? -/
def sizeBook : Book :=
  { attr := .size 20, bets := [⟨1, true, 50⟩, ⟨2, false, 50⟩] }

/-- Will it reach a thousand inside sixty moves? -/
def speedBook : Book :=
  { attr := .speed 1000 60, bets := [⟨1, true, 200⟩, ⟨2, false, 100⟩, ⟨3, false, 100⟩] }

/-- Is the game free of blunders, as the model claims? -/
def cleanBook : Book :=
  { attr := .clean coachedDB, bets := [⟨1, true, 10⟩, ⟨2, false, 90⟩] }

/-- The four books that go out with the broadcast. -/
def demoBooks : List Book := [scoreBook, sizeBook, speedBook, cleanBook]

/-- **The market, settled** (checked by evaluation).  The trained model's game
finished on 2095 with twenty-three parts, so the score and size books settle
yes; it had only sixty cash after sixty moves, so the speed book settles no; and
the critic flags nothing in it, so the clean book settles yes.  In every book
the money paid out is exactly the pool, and the two backers of the score book
turn 100 into 250 apiece while the layer of 300 gets nothing. -/
theorem market_report :
    (demoBooks.map (fun b => b.outcome trainedGame)) = [true, true, false, true] ∧
    (demoBooks.map (fun b => b.totalPayout trainedGame)) = [500, 100, 400, 100] ∧
    (demoBooks.map Book.pool) = [500, 100, 400, 100] ∧
    (demoBooks.map (fun b => b.winPool trainedGame)) = [200, 50, 200, 10] ∧
    scoreBook.payout trainedGame ⟨1, true, 100⟩ = 250 ∧
    scoreBook.payout trainedGame ⟨2, false, 300⟩ = 0 ∧
    (demoBooks.map (fun b => b.price true)) = [4000, 5000, 5000, 1000] := by
  native_decide

/-- Every one of the demo books is solvent — as every book is. -/
theorem demoBooks_solvent :
    ∀ b ∈ demoBooks, b.totalPayout trainedGame ≤ b.pool :=
  fun b _ => b.totalPayout_le_pool trainedGame

/-- The prices quoted on the demo books are coherent. -/
theorem demoBooks_prices_coherent :
    ∀ b ∈ demoBooks, 0 < b.pool → b.price true + b.price false ≤ 10000 :=
  fun b _ h => b.prices_coherent h

end Market
end Tycoon
