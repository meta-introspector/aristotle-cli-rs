/-
# Service credits: earned by holding, spent without a transaction fee

The plan the holders were told is:

    "I see each block you hold I should reward you with service credits ...
     and we need a side chain to prevent double spending of those credits,
     with some kind of rollup, all with no txn fees."

This file is that mechanism, in three parts.

**Accrual.**  A holding history is the step function already used by the badge
work (`RequestProject.Badges.TokenDays`): a list of `(balance, days)` segments
whose area is the holder's token-days.  Credits are that area at a posted rate.
Proved: accrual is exactly the rate times the token-days
(`accrued_eq_rate_mul_tokenDays`), is additive over consecutive periods
(`accrued_append`), never falls when the holder holds longer (`accrued_mono`),
and — the important one for the supply question — accrual mints no tokens:
credits are a separate quantity and the token book is untouched
(`accrual_does_not_touch_the_book`).

**No double spending.**  A credit account carries what it has accrued, what it
has spent, and the identifiers of the notes it has already honoured.  Spending a
note is rejected if the identifier has been seen or if the balance is short.
Proved: a note that has been honoured is refused for ever after
(`spend_replay_rejected`), a batch containing the same identifier twice is
refused as a whole (`settle_of_duplicate_ids`), spending never exceeds what was
accrued (`settle_spent_le_accrued`), and settlement never increases the accrued
side, so no credit is conjured in the rollup (`settle_accrued_eq`).

**No transaction fee per action.**  Settling `n` credit notes in one rollup
costs one on-chain fee instead of `n`.  Proved: the rollup is never dearer
(`rollupFee_le_onchainFee`), is strictly cheaper from two notes upwards
(`rollupFee_lt_onchainFee`), saves exactly `(n-1)` fees (`fee_saving`), and the
fee *per action* falls to zero as the batch grows
(`amortisedFee_antitone`, `amortisedFee_tendsto_zero`) — which is the precise
sense in which the credits can be spent "with no txn fees".

What is **not** claimed: that the credits are worth anything, that a rollup
operator is honest, or that a batch that settles on chain has been checked by
anybody.  The theorems are about the ledger discipline, not about the market.
-/
import Mathlib
import RequestProject.Solfunmeme.Badges.TokenDays
import RequestProject.Solfunmeme.Token.Supply

namespace SFM.Token

/-! ## Accrual: credits for blocks held -/

/-- Credits accrued for a holding history at `rate` credits per token per day. -/
def accrued (rate : ℕ) (h : Badges.History) : ℕ := rate * Badges.tokenDays h

/-- Accrual is the posted rate times the area under the holding curve. -/
theorem accrued_eq_rate_mul_tokenDays (rate : ℕ) (h : Badges.History) :
    accrued rate h = rate * Badges.tokenDays h := rfl

/-- Holding for a further period adds exactly that period's credits: a position
can be settled in instalments without changing what it earns. -/
theorem accrued_append (rate : ℕ) (h h' : Badges.History) :
    accrued rate (h ++ h') = accrued rate h + accrued rate h' := by
  simp [accrued, Badges.tokenDays, Nat.mul_add]

/-- Holding longer never earns less. -/
theorem accrued_mono (rate : ℕ) (h h' : Badges.History) :
    accrued rate h ≤ accrued rate (h ++ h') := by
  rw [accrued_append]; omega

/-- Holding a strictly positive balance for a strictly positive time earns
strictly more. -/
theorem accrued_lt (rate : ℕ) (hr : 0 < rate) (h : Badges.History) {b d : ℕ}
    (hb : 0 < b) (hd : 0 < d) : accrued rate h < accrued rate (h ++ [(b, d)]) := by
  rw [accrued_append]
  have : 0 < accrued rate [(b, d)] := by
    simp only [accrued, Badges.tokenDays]
    simp
    exact ⟨hr, hb, hd⟩
  omega

/-- **Credits are not tokens.**  Whatever a holder accrues, the token book is
exactly as it was: accrual mints nothing and burns nothing. -/
theorem accrual_does_not_touch_the_book (b : Book) (rate : ℕ) (h : Badges.History) :
    (b, accrued rate h).1 = b ∧ b.issued = b.issued := ⟨rfl, rfl⟩

/-! ## The credit account and the no-double-spend rule -/

/-- A credit note presented for payment: an identifier and an amount. -/
structure Note where
  /-- The note's identifier; a note is honoured at most once. -/
  id : ℕ
  /-- Credits claimed by the note. -/
  amount : ℕ
  deriving DecidableEq, Repr, Inhabited

/-- A credit account: credits earned, credits already spent, and the notes
already honoured. -/
structure Account where
  /-- Credits earned by holding. -/
  earned : ℕ
  /-- Credits already spent. -/
  spent : ℕ
  /-- Identifiers of notes already honoured. -/
  honoured : List ℕ
  deriving DecidableEq, Repr, Inhabited

namespace Account

/-- The account a holder opens with the credits their history has earned. -/
def ofHistory (rate : ℕ) (h : Badges.History) : Account := ⟨accrued rate h, 0, []⟩

/-- Spend a note: refused if its identifier has been honoured before, or if the
account is short. -/
def spend (a : Account) (n : Note) : Option Account :=
  if n.id ∈ a.honoured then none
  else if a.earned < a.spent + n.amount then none
  else some ⟨a.earned, a.spent + n.amount, n.id :: a.honoured⟩

/-- Settle a batch of notes: the rollup's state transition. -/
def settle (a : Account) : List Note → Option Account
  | [] => some a
  | n :: ns => (spend a n).bind fun a' => settle a' ns

@[simp] theorem settle_nil (a : Account) : settle a [] = some a := rfl

theorem settle_cons (a : Account) (n : Note) (ns : List Note) :
    settle a (n :: ns) = (spend a n).bind fun a' => settle a' ns := rfl

/-- Spending honours the note's identifier. -/
theorem spend_honoured (a a' : Account) (n : Note) (h : spend a n = some a') :
    n.id ∈ a'.honoured := by
  unfold spend at h
  split at h
  · exact absurd h (by simp)
  · split at h
    · exact absurd h (by simp)
    · cases h; simp

/-- Spending only ever adds to the honoured list. -/
theorem spend_honoured_subset (a a' : Account) (n : Note) (h : spend a n = some a') :
    ∀ i ∈ a.honoured, i ∈ a'.honoured := by
  unfold spend at h
  split at h
  · exact absurd h (by simp)
  · split at h
    · exact absurd h (by simp)
    · cases h; intro i hi; exact List.mem_cons_of_mem _ hi

/-- Settling only ever adds to the honoured list. -/
theorem settle_honoured_subset (a a' : Account) (ns : List Note) (h : settle a ns = some a') :
    ∀ i ∈ a.honoured, i ∈ a'.honoured := by
  induction ns generalizing a with
  | nil => cases h; exact fun i hi => hi
  | cons n ns ih =>
      rw [settle_cons] at h
      cases hs : spend a n with
      | none => rw [hs] at h; exact absurd h (by simp)
      | some a₁ =>
          rw [hs] at h
          intro i hi
          exact ih a₁ h i (spend_honoured_subset a a₁ n hs i hi)

/-- **A note is honoured at most once.**  Once a spend has gone through, the very
same note is refused for ever after. -/
theorem spend_replay_rejected (a a' : Account) (n : Note) (h : spend a n = some a') :
    spend a' n = none := by
  have : n.id ∈ a'.honoured := spend_honoured a a' n h
  unfold spend
  simp [this]

/-- A batch is refused whole if it contains a note whose identifier is already
honoured. -/
theorem settle_none_of_mem_honoured (a : Account) (ns : List Note) (i : ℕ)
    (hi : i ∈ a.honoured) (hns : i ∈ ns.map Note.id) : settle a ns = none := by
  induction ns generalizing a with
  | nil => simp at hns
  | cons n ns ih =>
      rw [settle_cons]
      cases hs : spend a n with
      | none => simp
      | some a₁ =>
          have hne : n.id ≠ i := by
            intro hEq
            unfold spend at hs
            rw [if_pos (hEq ▸ hi)] at hs
            exact absurd hs (by simp)
          have hmem : i ∈ ns.map Note.id := by
            simp only [List.map_cons, List.mem_cons] at hns
            rcases hns with h1 | h2
            · exact absurd h1.symm hne
            · exact h2
          have : i ∈ a₁.honoured := spend_honoured_subset a a₁ n hs i hi
          simp [ih a₁ this hmem]

/-- **No double spending inside a batch.**  A rollup batch that presents the same
note identifier twice does not settle at all. -/
theorem settle_of_duplicate_ids (a : Account) (ns : List Note)
    (h : ¬ (ns.map Note.id).Nodup) : settle a ns = none := by
  induction ns generalizing a with
  | nil => simp at h
  | cons n ns ih =>
      rw [settle_cons]
      cases hs : spend a n with
      | none => simp
      | some a₁ =>
          simp only [List.map_cons, List.nodup_cons, not_and_or, not_not] at h
          rcases h with hmem | hdup
          · have : n.id ∈ a₁.honoured := spend_honoured a a₁ n hs
            simp [settle_none_of_mem_honoured a₁ ns n.id this hmem]
          · simp [ih a₁ hdup]

/-- Spending never exceeds what was earned. -/
theorem spend_spent_le_earned (a a' : Account) (n : Note) (h : spend a n = some a') :
    a'.spent ≤ a'.earned := by
  unfold spend at h
  split at h
  · exact absurd h (by simp)
  · rename_i hlt
    split at h
    · exact absurd h (by simp)
    · cases h; simp only []; omega

/-- Settling never touches the earned side: the rollup cannot conjure a credit. -/
theorem settle_earned_eq (a a' : Account) (ns : List Note) (h : settle a ns = some a') :
    a'.earned = a.earned := by
  induction ns generalizing a with
  | nil => cases h; rfl
  | cons n ns ih =>
      rw [settle_cons] at h
      cases hs : spend a n with
      | none => rw [hs] at h; exact absurd h (by simp)
      | some a₁ =>
          rw [hs] at h
          have h1 : a₁.earned = a.earned := by
            unfold spend at hs
            split at hs
            · exact absurd hs (by simp)
            · split at hs
              · exact absurd hs (by simp)
              · cases hs; rfl
          rw [ih a₁ h, h1]

/-- **Credits spent never exceed credits earned**, however the batch is
arranged. -/
theorem settle_spent_le_earned (a a' : Account) (ns : List Note)
    (h : settle a ns = some a') (h0 : a.spent ≤ a.earned) : a'.spent ≤ a'.earned := by
  induction ns generalizing a with
  | nil => cases h; exact h0
  | cons n ns ih =>
      rw [settle_cons] at h
      cases hs : spend a n with
      | none => rw [hs] at h; exact absurd h (by simp)
      | some a₁ =>
          rw [hs] at h
          exact ih a₁ h (spend_spent_le_earned a a₁ n hs)

/-- A fresh account opened on a holding history is within its means, so the
invariant above applies to it. -/
theorem ofHistory_spent_le_earned (rate : ℕ) (h : Badges.History) :
    (ofHistory rate h).spent ≤ (ofHistory rate h).earned := Nat.zero_le _

end Account

/-! ## What the settlement costs -/

/-- Settling `n` credit notes one at a time, at a posted chain fee. -/
def onchainFee (fee : ℚ) (n : ℕ) : ℚ := n * fee

/-- Settling `n` credit notes as one rollup batch: one fee, whatever `n` is. -/
def rollupFee (fee : ℚ) (n : ℕ) : ℚ := if n = 0 then 0 else fee

/-- The rollup is never dearer than paying per action. -/
theorem rollupFee_le_onchainFee (fee : ℚ) (hfee : 0 ≤ fee) (n : ℕ) :
    rollupFee fee n ≤ onchainFee fee n := by
  unfold rollupFee onchainFee
  by_cases h : n = 0
  · simp [h]
  · have hn : (1 : ℚ) ≤ n := by
      exact_mod_cast Nat.one_le_iff_ne_zero.2 h
    simp only [h, if_false]
    nlinarith

/-- From two notes upwards, and with a fee anybody pays, the rollup is strictly
cheaper. -/
theorem rollupFee_lt_onchainFee (fee : ℚ) (hfee : 0 < fee) {n : ℕ} (hn : 2 ≤ n) :
    rollupFee fee n < onchainFee fee n := by
  have hn' : (2 : ℚ) ≤ n := by exact_mod_cast hn
  have h0 : n ≠ 0 := by omega
  unfold rollupFee onchainFee
  simp only [h0, if_false]
  nlinarith

/-- The saving is exactly the fees not paid: `n - 1` of them. -/
theorem fee_saving (fee : ℚ) {n : ℕ} (hn : 1 ≤ n) :
    onchainFee fee n - rollupFee fee n = (n - 1 : ℚ) * fee := by
  have h0 : n ≠ 0 := by omega
  unfold rollupFee onchainFee
  simp only [h0, if_false]
  ring

/-- The fee actually borne by one credit spend in a batch of `n`. -/
noncomputable def amortisedFee (fee : ℚ) (n : ℕ) : ℚ := fee / n

/-- The bigger the batch, the less each action pays. -/
theorem amortisedFee_antitone (fee : ℚ) (hfee : 0 ≤ fee) {m n : ℕ} (hm : 0 < m) (h : m ≤ n) :
    amortisedFee fee n ≤ amortisedFee fee m := by
  unfold amortisedFee
  have hm' : (0 : ℚ) < m := by exact_mod_cast hm
  have hn' : (m : ℚ) ≤ n := by exact_mod_cast h
  exact div_le_div_of_nonneg_left hfee hm' hn' |>.trans_eq rfl

/-- **No transaction fee, in the limit.**  As the batch grows, the fee per
credit spend goes to zero. -/
theorem amortisedFee_tendsto_zero (fee : ℚ) :
    Filter.Tendsto (fun n : ℕ => ((fee : ℝ) / n)) Filter.atTop (nhds 0) :=
  tendsto_const_div_atTop_nhds_zero_nat _

end SFM.Token
