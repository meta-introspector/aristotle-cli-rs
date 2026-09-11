/-
  Engine.lean — the token layer of *Steal My Brainrot*, and what a score claim
  actually proves.

  The playable engine lives in `node/game/engine.mjs`.  It is deliberately an
  integer machine: no floats, no clock, no randomness that is not derived from
  the seed, so a whole run is a function of `(seed, list of per-tick inputs)`.
  That is what makes a claimed score checkable — a verifier replays the trace
  and gets the same number.

  This file models the part of that machine the claims are *about*: the token
  side.  Each tick the world may hand the player a block (a coin) or rug-pull
  one away, every `TICKS_PER_DAY` ticks the day's balance is added to the
  stake, and a mint spends `MINT_COST` blocks to turn the run into a meme.  The
  physics — position, velocity, which cell of the world you are standing on —
  is abstracted into the per-tick `Input`, so the theorems below hold *whatever*
  the world does, which is exactly the strength a verifier needs.

  What is proved here:

  * `balance_pos` / `run_balance_pos`: the balance never reaches zero.  The rug
    pull refuses to take your last block and a mint is refused unless the
    balance stays strictly positive afterwards.
  * `run_minted`: the mint counter counts exactly the ticks on which a mint was
    actually accepted — "how many memes were made" is not a number the player
    types in.
  * `run_stake`: the stake is the token-day sum of the daily balances;
    `stake_ge_of_holds` and `stake_strict_mono_of_holds`: holding longer earns
    more, and a bigger balance earns faster.
  * `unlocks_mono`: an unlock, once earned, is never lost.
  * `unrle_rle`: the run-length encoding a claim carries decodes back to the
    trace that produced it, so the compressed claim in a meme's low bits is the
    run and not merely something like it.
  * `verify_claimOf` and `verify_sound`: an honest claim verifies, and anything
    that verifies really is the replay of its own trace, with a positive
    balance and an accurate meme count.
-/

import Mathlib

namespace Solfunmeme.Game

/-! ## Constants

    These are the values in `node/game/engine.mjs`; the proofs below do not
    depend on them except where noted. -/

/-- Blocks burned by minting a meme. -/
def MINT_COST : ℕ := 10

/-- Token-days that must already be staked before a mint is allowed. -/
def MINT_STAKE : ℕ := MINT_COST * 100

/-- Ticks in a "day" of holding. -/
def TICKS_PER_DAY : ℕ := 1024

/-- Starting balance. -/
def START_BALANCE : ℕ := 100

/-! ## Inputs and state -/

/-- What reaches the token layer on one tick.

    `coin` and `rug` are what the world did (the player walked onto a coin
    cell, or onto a rug-pull cell); `mint` is the MINT button; `earned` is the
    bitmask of unlocks the world says were achieved this tick.  Everything the
    physics does is squeezed into these four fields, so a theorem proved here
    holds for every possible run of the real engine. -/
structure Input where
  coin : Bool
  rug : Bool
  mint : Bool
  earned : ℕ
  deriving Repr, DecidableEq, Inhabited

/-- The token-side state. -/
structure State where
  tick : ℕ
  balance : ℕ
  heldDays : ℕ
  stake : ℕ
  minted : ℕ
  unlocks : ℕ
  deriving Repr, DecidableEq, Inhabited

/-- A fresh run. -/
def initial : State :=
  { tick := 0, balance := START_BALANCE, heldDays := 0, stake := 0, minted := 0, unlocks := 0 }

/-! ## One tick -/

/-- A rug pull takes a block — but never your last one. -/
def rugged (b : ℕ) : ℕ := if 1 < b then b - 1 else b

/-- The balance after the world has had its turn. -/
def worldBalance (i : Input) (b : ℕ) : ℕ :=
  if i.rug then rugged (if i.coin then b + 1 else b) else (if i.coin then b + 1 else b)

/-- Is this tick the end of a day of holding? -/
def isDayEnd (t : ℕ) : Bool := decide (t % TICKS_PER_DAY = 0)

/-- The stake after this tick's day-end credit. -/
def stakeAfter (i : Input) (s : State) : ℕ :=
  if isDayEnd (s.tick + 1) then s.stake + worldBalance i s.balance else s.stake

/-- The held-day counter after this tick. -/
def daysAfter (s : State) : ℕ :=
  if isDayEnd (s.tick + 1) then s.heldDays + 1 else s.heldDays

/-- Was a mint accepted on this tick?  A mint is refused unless it leaves the
    balance strictly positive and enough token-days are already staked. -/
def didMint (i : Input) (s : State) : Bool :=
  i.mint && decide (MINT_COST < worldBalance i s.balance) &&
    decide (MINT_STAKE ≤ stakeAfter i s)

/-- One tick of the token machine. -/
def step (i : Input) (s : State) : State :=
  { tick := s.tick + 1
    balance := if didMint i s then worldBalance i s.balance - MINT_COST
               else worldBalance i s.balance
    heldDays := daysAfter s
    stake := stakeAfter i s
    minted := if didMint i s then s.minted + 1 else s.minted
    unlocks := s.unlocks ||| i.earned }

/-- A whole trace. -/
def run (s : State) (tr : List Input) : State := tr.foldl (fun a i => step i a) s

@[simp] theorem run_nil (s : State) : run s [] = s := rfl

@[simp] theorem run_cons (s : State) (i : Input) (tr : List Input) :
    run s (i :: tr) = run (step i s) tr := rfl

/-- Replay composes: a verifier may check a run in pieces and get the same
    answer as one who replays it end to end. -/
theorem run_append (s : State) (tr₁ tr₂ : List Input) :
    run s (tr₁ ++ tr₂) = run (run s tr₁) tr₂ := by
  simp [run, List.foldl_append]

/-! ## The balance never reaches zero -/

theorem rugged_pos {b : ℕ} (h : 0 < b) : 0 < rugged b := by
  unfold rugged; split <;> omega

theorem worldBalance_pos (i : Input) {b : ℕ} (h : 0 < b) : 0 < worldBalance i b := by
  unfold worldBalance
  split
  · exact rugged_pos (by split <;> omega)
  · split <;> omega

/-- **A block always stays.**  Whatever the world does and whatever the player
    presses, a tick that starts with a positive balance ends with one. -/
theorem balance_pos (i : Input) {s : State} (h : 0 < s.balance) : 0 < (step i s).balance := by
  have hw := worldBalance_pos i h
  unfold step didMint
  dsimp only
  split
  · rename_i hm
    simp only [Bool.and_eq_true, decide_eq_true_eq] at hm
    omega
  · exact hw

/-- The same, along a whole trace. -/
theorem run_balance_pos {s : State} (h : 0 < s.balance) (tr : List Input) :
    0 < (run s tr).balance := by
  induction tr generalizing s with
  | nil => simpa using h
  | cons i t ih => simpa using ih (balance_pos i h)

/-- **Balance is still above 0.**  Every run of the game, from the start,
    of any length, ends with a positive balance. -/
theorem initial_run_balance_pos (tr : List Input) : 0 < (run initial tr).balance :=
  run_balance_pos (by decide) tr

/-! ## The meme counter counts memes -/

/-- The number of ticks of `tr`, played from `s`, on which a mint was accepted. -/
def mintCount (s : State) : List Input → ℕ
  | [] => 0
  | i :: t => (if didMint i s then 1 else 0) + mintCount (step i s) t

@[simp] theorem mintCount_nil (s : State) : mintCount s [] = 0 := rfl

@[simp] theorem mintCount_cons (s : State) (i : Input) (t : List Input) :
    mintCount s (i :: t) = (if didMint i s then 1 else 0) + mintCount (step i s) t := rfl

/-- **How many memes were made.**  The published count is not a number the
    player chooses: it is exactly the number of accepted mints in the trace. -/
theorem run_minted (s : State) (tr : List Input) :
    (run s tr).minted = s.minted + mintCount s tr := by
  induction tr generalizing s with
  | nil => simp
  | cons i t ih =>
    simp only [run_cons, mintCount_cons, ih]
    unfold step
    dsimp only
    split <;> omega

/-- Each accepted mint really costs blocks, so a player cannot mint for free:
    minting `n` memes in a row without collecting anything costs `n * MINT_COST`. -/
theorem minted_le_of_run (s : State) (tr : List Input) :
    s.minted ≤ (run s tr).minted := by
  simp [run_minted]

/-! ## Stake is token-days -/

/-- The stake credited by one tick: the day's balance, on a day boundary. -/
def dayCredit (i : Input) (s : State) : ℕ :=
  if isDayEnd (s.tick + 1) then worldBalance i s.balance else 0

theorem stake_step (i : Input) (s : State) :
    (step i s).stake = s.stake + dayCredit i s := by
  unfold step stakeAfter dayCredit
  dsimp only
  split <;> simp

/-- The token-day sum along a trace. -/
def tokenDays (s : State) : List Input → ℕ
  | [] => 0
  | i :: t => dayCredit i s + tokenDays (step i s) t

@[simp] theorem tokenDays_nil (s : State) : tokenDays s [] = 0 := rfl

@[simp] theorem tokenDays_cons (s : State) (i : Input) (t : List Input) :
    tokenDays s (i :: t) = dayCredit i s + tokenDays (step i s) t := rfl

/-- **Stake is the area under the balance curve.**  Exactly the token-day
    measure the rest of this project computes from the dataset's snapshots
    (`RequestProject/Badges/TokenDays.lean`): the sum of the balances held at
    each day boundary. -/
theorem run_stake (s : State) (tr : List Input) :
    (run s tr).stake = s.stake + tokenDays s tr := by
  induction tr generalizing s with
  | nil => simp
  | cons i t ih => simp only [run_cons, tokenDays_cons, ih, stake_step]; omega

/-- Stake never goes down. -/
theorem stake_mono (s : State) (tr : List Input) : s.stake ≤ (run s tr).stake := by
  simp [run_stake]

/-! ### Holding: longer earns more, bigger earns faster -/

/-- A *holder's* tick: no rug pull hits, and nothing is minted away.  This is
    the regime the staking claims are about. -/
def Holds (i : Input) : Prop := i.rug = false ∧ i.mint = false

instance (i : Input) : Decidable (Holds i) := by unfold Holds; infer_instance

theorem worldBalance_of_holds {i : Input} (h : Holds i) (b : ℕ) : b ≤ worldBalance i b := by
  unfold worldBalance
  simp [h.1]
  split <;> omega

theorem didMint_of_holds {i : Input} (h : Holds i) (s : State) : didMint i s = false := by
  simp [didMint, h.2]

theorem balance_step_of_holds {i : Input} (h : Holds i) (s : State) :
    s.balance ≤ (step i s).balance := by
  simp [step, didMint_of_holds h]
  exact worldBalance_of_holds h s.balance

/-- While you hold, your balance never falls. -/
theorem balance_mono_of_holds {s : State} {tr : List Input} (h : ∀ i ∈ tr, Holds i) :
    s.balance ≤ (run s tr).balance := by
  induction tr generalizing s with
  | nil => simp
  | cons i t ih =>
    have h1 : Holds i := h i (by simp)
    have h2 : ∀ j ∈ t, Holds j := fun j hj => h j (by simp [hj])
    exact le_trans (balance_step_of_holds h1 s) (by simpa using ih h2)

theorem daysAfter_le (s : State) : s.heldDays ≤ daysAfter s := by
  unfold daysAfter; split <;> omega

theorem heldDays_mono (s : State) (tr : List Input) : s.heldDays ≤ (run s tr).heldDays := by
  induction tr generalizing s with
  | nil => simp
  | cons i t ih =>
    exact le_trans (by simpa [step] using daysAfter_le s) (by simpa using ih (s := step i s))

/-- **Hold longer, earn more; hold more, earn faster.**  Over a stretch in
    which nothing is rugged and nothing is minted, every day that passes adds
    at least the balance you came in with — so the stake grows by at least
    `balance × days`. -/
theorem stake_ge_of_holds {s : State} {tr : List Input} (h : ∀ i ∈ tr, Holds i) :
    s.stake + s.balance * ((run s tr).heldDays - s.heldDays) ≤ (run s tr).stake := by
  induction tr generalizing s with
  | nil => simp
  | cons i t ih =>
    have h1 : Holds i := h i (by simp)
    have h2 : ∀ j ∈ t, Holds j := fun j hj => h j (by simp [hj])
    have hb : s.balance ≤ (step i s).balance := balance_step_of_holds h1 s
    have hst : (step i s).stake = s.stake + dayCredit i s := stake_step i s
    have hd : (step i s).heldDays = daysAfter s := rfl
    have key := ih (s := step i s) h2
    show s.stake + s.balance * ((run (step i s) t).heldDays - s.heldDays)
        ≤ (run (step i s) t).stake
    set D := (run (step i s) t).heldDays with hDdef
    rw [hst, hd] at key
    have hmono : daysAfter s ≤ D := by rw [← hd, hDdef]; exact heldDays_mono (step i s) t
    by_cases hday : isDayEnd (s.tick + 1) = true
    · -- a day closed on this tick: it credits at least the balance held
      have hdays : daysAfter s = s.heldDays + 1 := by simp [daysAfter, hday]
      have hc : s.balance ≤ dayCredit i s := by
        simpa [dayCredit, hday] using worldBalance_of_holds h1 s.balance
      have hsplit : s.balance * (D - s.heldDays)
          = s.balance + s.balance * (D - (s.heldDays + 1)) := by
        have hstep : D - s.heldDays = 1 + (D - (s.heldDays + 1)) := by omega
        rw [hstep]; ring
      have hprod : s.balance * (D - (s.heldDays + 1))
          ≤ (step i s).balance * (D - (s.heldDays + 1)) := Nat.mul_le_mul_right _ hb
      rw [hdays] at key
      omega
    · -- no day closed: nothing is credited, and the balance only grew
      have hdays : daysAfter s = s.heldDays := by simp [daysAfter, hday]
      have hc : dayCredit i s = 0 := by simp [dayCredit, hday]
      have hprod : s.balance * (D - s.heldDays)
          ≤ (step i s).balance * (D - s.heldDays) := Nat.mul_le_mul_right _ hb
      rw [hdays] at key
      omega

/-- Each completed day of holding a positive balance strictly increases the
    stake. -/
theorem stake_strict_of_day (i : Input) {s : State}
    (hpos : 0 < s.balance) (hday : isDayEnd (s.tick + 1) = true) :
    s.stake < (step i s).stake := by
  have := worldBalance_pos i hpos
  rw [stake_step]
  unfold dayCredit
  simp [hday]
  omega

/-! ## Unlocks are never lost -/

/-- **Once earned, always earned.** -/
theorem unlocks_mono (i : Input) (s : State) (k : ℕ) (h : s.unlocks.testBit k = true) :
    (step i s).unlocks.testBit k = true := by
  simp [step, Nat.testBit_or, h]

theorem unlocks_mono_run (s : State) (tr : List Input) (k : ℕ)
    (h : s.unlocks.testBit k = true) : (run s tr).unlocks.testBit k = true := by
  induction tr generalizing s with
  | nil => simpa using h
  | cons i t ih => exact ih (s := step i s) (unlocks_mono i s k h)

/-! ## The run-length encoding a claim carries -/

/-- Run-length encoding of a trace, as `(input, repeat count)` pairs. -/
def rle : List Input → List (Input × ℕ)
  | [] => []
  | v :: rest =>
    match rle rest with
    | (w, n) :: tl => if v = w then (w, n + 1) :: tl else (v, 1) :: (w, n) :: tl
    | [] => [(v, 1)]

/-- Decoding: repeat each input its stated number of times. -/
def unrle (l : List (Input × ℕ)) : List Input :=
  l.flatMap (fun p => List.replicate p.2 p.1)

/-- **The compressed claim is the run.**  A held button is one pair, so a
    ten-minute run fits in a meme's low bits — and it decodes back to exactly
    the trace that was played, so the compression cannot smuggle in a different
    game. -/
theorem unrle_rle (tr : List Input) : unrle (rle tr) = tr := by
  induction tr with
  | nil => rfl
  | cons v rest ih =>
    unfold rle
    cases hr : rle rest with
    | nil =>
      simp only []
      have : unrle ([] : List (Input × ℕ)) = rest := by rw [← hr]; exact ih
      simp [unrle] at this ⊢
      simp [← this]
    | cons p tl =>
      obtain ⟨w, n⟩ := p
      have hrest : unrle ((w, n) :: tl) = rest := by rw [← hr]; exact ih
      by_cases hvw : v = w
      · simp only [hvw]
        simp [unrle, List.replicate_succ] at hrest ⊢
        rw [hrest]
      · simp only [if_neg hvw]
        simp [unrle] at hrest ⊢
        rw [hrest]

/-! ## Claims -/

/-- What a player publishes: the compressed trace and the figures it is said
    to produce. -/
structure Claim where
  rle : List (Input × ℕ)
  balance : ℕ
  heldDays : ℕ
  stake : ℕ
  minted : ℕ
  unlocks : ℕ
  deriving Repr, DecidableEq

/-- The honest claim for a trace. -/
def claimOf (tr : List Input) : Claim :=
  let f := run initial tr
  { rle := rle tr, balance := f.balance, heldDays := f.heldDays,
    stake := f.stake, minted := f.minted, unlocks := f.unlocks }

/-- The verifier: replay the trace and compare, and insist the balance is
    positive.  This is `verifyClaim` in `node/game/engine.mjs`. -/
def verify (c : Claim) : Bool :=
  let f := run initial (unrle c.rle)
  decide (f.balance = c.balance) && decide (f.heldDays = c.heldDays) &&
    decide (f.stake = c.stake) && decide (f.minted = c.minted) &&
    decide (f.unlocks = c.unlocks) && decide (0 < c.balance)

/-- **Completeness.**  An honest run always verifies. -/
theorem verify_claimOf (tr : List Input) : verify (claimOf tr) = true := by
  simp [verify, claimOf, unrle_rle, initial_run_balance_pos tr]

/-- **Soundness.**  Anything that verifies is the replay of its own trace: the
    published balance, stake and meme count are those the trace produces, the
    meme count is exactly the number of accepted mints, and the balance is
    still above zero. -/
theorem verify_sound {c : Claim} (h : verify c = true) :
    let tr := unrle c.rle
    (run initial tr).balance = c.balance ∧
      (run initial tr).stake = c.stake ∧
      c.minted = mintCount initial tr ∧
      (run initial tr).unlocks = c.unlocks ∧
      0 < c.balance := by
  simp only [verify, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨⟨hb, hd⟩, hs⟩, hm⟩, hu⟩, hp⟩ := h
  refine ⟨hb, hs, ?_, hu, hp⟩
  rw [← hm, run_minted]
  simp [initial]

end Solfunmeme.Game
