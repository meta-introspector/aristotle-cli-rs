/-
  Stake.lean — the game's stake is the same token-day measure as the rest of
  the project.

  `RequestProject/Badges/TokenDays.lean` models the dataset's own proposal:
  loyalty is the *area under the holding curve*, tokens × time, so "held 1000
  tokens for 365 days" is 365 000 token-days.  The game charges the same
  meter: every `TICKS_PER_DAY` ticks it adds the day's balance to the stake.

  This file proves the two are literally the same number.  A run is turned
  into a holding history — one `(balance, 1)` segment per day boundary the run
  crossed — and the stake the engine accumulated is exactly `Badges.tokenDays`
  of that history.  Everything already proved about token-days therefore
  applies to the game: hold longer and earn more, hold more and earn faster,
  and the worked example from the dataset's own issue.
-/

import RequestProject.Solfunmeme.Game.Engine
import RequestProject.Solfunmeme.Badges.TokenDays

namespace Solfunmeme.Game

/-- The balance recorded at each day boundary the run crosses, oldest first. -/
def dailyBalances (s : State) : List Input → List ℕ
  | [] => []
  | i :: t =>
    (if isDayEnd (s.tick + 1) then [worldBalance i s.balance] else []) ++
      dailyBalances (step i s) t

@[simp] theorem dailyBalances_nil (s : State) : dailyBalances s [] = [] := rfl

theorem dailyBalances_cons (s : State) (i : Input) (t : List Input) :
    dailyBalances s (i :: t) =
      (if isDayEnd (s.tick + 1) then [worldBalance i s.balance] else []) ++
        dailyBalances (step i s) t := rfl

/-- **The stake is the sum of the daily balances.** -/
theorem run_stake_eq_sum (s : State) (tr : List Input) :
    (run s tr).stake = s.stake + (dailyBalances s tr).sum := by
  induction tr generalizing s with
  | nil => simp
  | cons i t ih =>
    rw [run_cons, ih, dailyBalances_cons]
    have hst : (step i s).stake = s.stake + dayCredit i s := stake_step i s
    unfold dayCredit at hst
    by_cases hday : isDayEnd (s.tick + 1) = true <;> simp [hday] at hst ⊢ <;> omega

/-- **The day counter counts day boundaries.** -/
theorem run_heldDays_eq (s : State) (tr : List Input) :
    (run s tr).heldDays = s.heldDays + (dailyBalances s tr).length := by
  induction tr generalizing s with
  | nil => simp
  | cons i t ih =>
    rw [run_cons, ih, dailyBalances_cons]
    have hd : (step i s).heldDays = daysAfter s := rfl
    unfold daysAfter at hd
    by_cases hday : isDayEnd (s.tick + 1) = true <;> simp [hday] at hd ⊢ <;> omega

/-! ## The bridge to the dataset's token-day model -/

/-- A list of daily balances, as a holding history, has that sum as its area. -/
theorem tokenDays_map_days (l : List ℕ) :
    Badges.tokenDays (l.map (fun b => (b, 1))) = l.sum := by
  induction l with
  | nil => rfl
  | cons b t ih => simp [Badges.tokenDays] at ih ⊢; omega

/-- ... and one day per entry as its duration. -/
theorem duration_map_days (l : List ℕ) :
    Badges.duration (l.map (fun b => (b, 1))) = l.length := by
  induction l with
  | nil => rfl
  | cons b t ih => simp [Badges.duration] at ih ⊢; omega

/-- The run, seen as a holding history: one day-long segment per day crossed. -/
def history (s : State) (tr : List Input) : Badges.History :=
  (dailyBalances s tr).map (fun b => (b, 1))

/-- **The game's stake is the area under the holding curve** — the very same
    `tokenDays` the dataset's loyalty proposal is written in terms of. -/
theorem stake_eq_tokenDays (s : State) (tr : List Input) :
    (run s tr).stake = s.stake + Badges.tokenDays (history s tr) := by
  rw [run_stake_eq_sum, history, tokenDays_map_days]

/-- And its duration is the number of days held. -/
theorem duration_eq_heldDays (s : State) (tr : List Input) :
    Badges.duration (history s tr) = (run s tr).heldDays - s.heldDays := by
  rw [run_heldDays_eq, history, duration_map_days]
  omega

/-! ## What that buys

    These are the loyalty claims, now as claims about the game. -/

/-- **Hold longer, earn more.**  Playing on can only add days, and each day
    adds its balance. -/
theorem stake_mono_append (s : State) (tr₁ tr₂ : List Input) :
    (run s tr₁).stake ≤ (run s (tr₁ ++ tr₂)).stake := by
  rw [run_append]
  exact stake_mono (run s tr₁) tr₂

/-- **A day of holding a positive balance is never free.**  If a run crosses a
    day boundary with a positive balance, the stake strictly grows. -/
theorem stake_lt_of_day (i : Input) {s : State} (hpos : 0 < s.balance)
    (hday : isDayEnd (s.tick + 1) = true) (tr : List Input) :
    s.stake < (run s (i :: tr)).stake :=
  lt_of_lt_of_le (stake_strict_of_day i hpos hday) (stake_mono (step i s) tr)

theorem sum_le_of_forall₂ : ∀ {l₁ l₂ : List ℕ}, List.Forall₂ (· ≤ ·) l₁ l₂ → l₁.sum ≤ l₂.sum := by
  intro l₁ l₂ h
  induction h with
  | nil => simp
  | cons hab _ ih => simp only [List.sum_cons]; omega

/-- **A bigger balance earns faster.**  Two runs that cross the same days, the
    second never poorer than the first, end with at least as much stake. -/
theorem stake_le_of_daily_le {s₁ s₂ : State} {tr₁ tr₂ : List Input}
    (hs : s₁.stake ≤ s₂.stake)
    (h : List.Forall₂ (· ≤ ·) (dailyBalances s₁ tr₁) (dailyBalances s₂ tr₂)) :
    (run s₁ tr₁).stake ≤ (run s₂ tr₂).stake := by
  rw [run_stake_eq_sum, run_stake_eq_sum]
  have hsum := sum_le_of_forall₂ h
  omega

/-- **The worked example, in the game.**  A player who holds `b` blocks
    through `d` day boundaries — never rugged, never minting — has staked at
    least `b * d` token-days. -/
theorem holder_stake_ge {s : State} {tr : List Input} (h : ∀ i ∈ tr, Holds i) :
    s.stake + s.balance * Badges.duration (history s tr) ≤ (run s tr).stake := by
  rw [duration_eq_heldDays]
  exact stake_ge_of_holds h

end Solfunmeme.Game
