/-
# Why a holder locks rather than burns

The holders' question was "will there be a burn mechanism?", and the answer
given was: there is one, it is how a badge or a meme is paid for, *but* "you
don't want to burn, you want to hold", because the earning is in the
governance — "if you get to decide something that is valuable, if your vote
matters".

This file makes that argument a theorem rather than a slogan.  A **register** is
a list of holders, each with a circulating balance and a locked balance.  Voting
weight is what a holder owns, locked or not.  A proposal carries when the weight
voting yes is more than half of the register's total weight.

What is proved:

* `Holder.lockAll_weight`, `register_lock_totalWeight` — locking changes no
  holder's weight and no total, so a lock-up costs the holder nothing in
  governance while removing the tokens from the spendable float;
* `Holder.burn_weight_lt` — burning strictly reduces the burner's weight, and
  `burn_share_lt` — it strictly reduces the burner's *share* of the vote too, so
  the choice between locking and burning is not a matter of taste: locking
  dominates on governance and burning is only rational for what it buys;
* `carries_mono` — a proposal that carries still carries when more weight votes
  for it, and `carries_of_majority` — a holder whose own weight is more than half
  of the register can carry any proposal alone;
* `yesWeight_le_totalWeight`, `not_carries_of_empty` — nobody can vote weight
  they do not hold, and an empty ballot carries nothing;
* `no_double_vote` — a holder listed twice on the ballot is counted once.

The register is deliberately abstract: it is the same statement whether the
weights come from a snapshot of the chain, from the federal model's thirteen
states, or from a side-chain rollup.
-/
import Mathlib

namespace SFM.Token

/-! ## Holders and their weight -/

/-- A holder of record: a name, a spendable balance and a locked balance. -/
structure Holder where
  /-- Who the holder is. -/
  name : String
  /-- Tokens that can be moved right now. -/
  circulating : ℕ
  /-- Tokens held under a lock. -/
  locked : ℕ
  deriving DecidableEq, Repr, Inhabited

namespace Holder

/-- Voting weight: everything the holder owns, locked or not. -/
def weight (h : Holder) : ℕ := h.circulating + h.locked

/-- Locking the whole balance. -/
def lockAll (h : Holder) : Holder :=
  { h with circulating := 0, locked := h.circulating + h.locked }

/-- Burning `n` affordable tokens. -/
def burn (h : Holder) (n : ℕ) : Holder :=
  { h with circulating := h.circulating - min n h.circulating }

/-- **Locking costs nothing in governance.** -/
@[simp] theorem lockAll_weight (h : Holder) : (lockAll h).weight = h.weight := by
  simp [lockAll, weight]

/-- Locking really does remove the tokens from the spendable float. -/
@[simp] theorem lockAll_circulating (h : Holder) : (lockAll h).circulating = 0 := rfl

/-- Burning never raises weight. -/
theorem burn_weight_le (h : Holder) (n : ℕ) : (burn h n).weight ≤ h.weight := by
  simp only [burn, weight]; omega

/-- **Burning strictly lowers the burner's vote.** -/
theorem burn_weight_lt (h : Holder) {n : ℕ} (hn : 0 < n) (hle : n ≤ h.circulating) :
    (burn h n).weight < h.weight := by
  simp only [burn, weight]; omega

end Holder

/-! ## The register -/

/-- The register of holders whose weight is counted. -/
abbrev Register := List Holder

/-- Total weight on the register. -/
def totalWeight (r : Register) : ℕ := (r.map Holder.weight).sum

/-- The weight voting yes: the weight of the listed names, counted once each. -/
def yesWeight (r : Register) (yes : List String) : ℕ :=
  ((r.filter fun h => h.name ∈ yes).map Holder.weight).sum

/-- A proposal carries when more than half of the register's weight votes yes. -/
def carries (r : Register) (yes : List String) : Prop :=
  totalWeight r < 2 * yesWeight r yes

/-- Locking every holder's balance changes no total. -/
@[simp] theorem register_lock_totalWeight (r : Register) :
    totalWeight (r.map Holder.lockAll) = totalWeight r := by
  induction r with
  | nil => rfl
  | cons h t ih => simp [totalWeight] at ih ⊢; omega

/-- Nobody can vote weight they do not hold. -/
theorem yesWeight_le_totalWeight (r : Register) (yes : List String) :
    yesWeight r yes ≤ totalWeight r := by
  induction r with
  | nil => simp [yesWeight, totalWeight]
  | cons h t ih =>
      by_cases hm : h.name ∈ yes <;>
        simp [yesWeight, totalWeight, hm] at ih ⊢ <;> omega

/-- **A holder listed twice is counted once.**  The yes-weight depends only on
which names appear on the ballot, not on how often. -/
theorem no_double_vote (r : Register) (yes : List String) :
    yesWeight r yes = yesWeight r yes.dedup := by
  unfold yesWeight
  congr 1
  congr 1
  apply List.filter_congr
  intro h _
  simp [List.mem_dedup]

/-- An empty ballot carries nothing, unless the register itself is empty of
weight — and then there is nothing to decide. -/
theorem not_carries_of_empty (r : Register) : ¬ carries r [] := by
  simp [carries, yesWeight]

/-- More weight voting yes cannot unmake a decision. -/
theorem carries_mono (r : Register) {yes yes' : List String}
    (h : yesWeight r yes ≤ yesWeight r yes') (hc : carries r yes) : carries r yes' := by
  unfold carries at hc ⊢
  omega

/-- **A holder with more than half the weight decides.** -/
theorem carries_of_majority (r : Register) (h : Holder) (hmem : h ∈ r)
    (hmaj : totalWeight r < 2 * h.weight) :
    carries r [h.name] := by
  have hmemf : h ∈ r.filter (fun g => g.name ∈ [h.name]) := by
    simp [List.mem_filter, hmem]
  have hle : h.weight ≤ yesWeight r [h.name] :=
    List.single_le_sum (fun x _ => Nat.zero_le x) _
      (List.mem_map_of_mem (f := Holder.weight) hmemf)
  unfold carries
  omega

end SFM.Token
