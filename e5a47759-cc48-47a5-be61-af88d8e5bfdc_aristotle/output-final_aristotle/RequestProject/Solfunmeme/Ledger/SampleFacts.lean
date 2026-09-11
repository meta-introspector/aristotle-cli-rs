import RequestProject.Solfunmeme.Ledger.Data.Sample

/-!
# What the token's own transaction index actually contains

`Ledger.Data.sample` is a seeded random sample of 15 000 of the 85 203 cached
`getTransaction` responses that the dataset `introspector/solfunmeme` ships under
`tx/`; four of the sampled files carry no `result`, leaving **14 996** transactions.
Every one of them is a transaction whose signature the dataset obtained from
`getSignaturesForAddress` on the SOLFUNMEME mint, so every one of them mentions
that mint.

The theorems below are all decided by the kernel from the recorded rows.  They say
what that index is made of, and they are the background against which the
individual wallets of `Ledger.Verdicts` are judged.
-/

set_option maxRecDepth 4000000

namespace Ledger.SampleFacts

open Ledger Ledger.Data

/-! ## The chunks

    The sample is stored in fifteen chunks so that each kernel computation stays
    small; the statistics are additive (`nTx_append` and friends), so the totals
    follow from the chunkwise counts. -/

/-- The size of the sample. -/
theorem sample_size : nTx sample = 14996 := by
  unfold sample; simp only [nTx_append]; decide

/-- **Three transactions in five failed.**  9 281 of the 14 996 sampled
    transactions did not settle. -/
theorem sample_failed : nFail sample = 9281 := by
  unfold sample; simp only [nFail_append]; decide

/-- 6 604 of them failed with the AMM slippage error (`Custom 6001`) — a bot
    that lost the race for a price it had already committed to. -/
theorem sample_slippage : nSlip sample = 6604 := by
  unfold sample; simp only [nSlip_append]; decide

/-- The failures are the majority: strictly more than half of the index is
    transactions that did nothing. -/
theorem majority_failed : nTx sample < nFail sample * 2 := by
  rw [sample_size, sample_failed]; norm_num

/-- **The token itself moves in fewer than one transaction in twelve.**  Of the
    14 996 transactions indexed under the mint, only 1 169 change anybody's
    balance of it. -/
theorem sample_live : nLive sample = 1169 := by
  unfold sample; simp only [nLive_append]; decide

theorem live_under_one_twelfth : nLive sample * 12 < nTx sample := by
  rw [sample_size, sample_live]; norm_num

/-- Fewer still — 967 — change the balance of the wallet that paid for them. -/
theorem sample_moves : nMoves sample = 967 := by
  unfold sample; simp only [nMoves_append]; decide

/-- 709 acquisitions against 258 disposals. -/
theorem sample_buys : nBuys sample = 709 := by
  unfold sample; simp only [nBuys_append]; decide

theorem sample_sells : nSells sample = 258 := by
  unfold sample; simp only [nSells_append]; decide

/-- Two out of every three disposals empty the wallet's position completely. -/
theorem sample_exits : nExits sample = 170 := by
  unfold sample; simp only [nExits_append]; decide

/-- Total fees paid across the sample, in lamports (≈ 2.198 SOL). -/
theorem sample_fees : fees sample = 2198355728 := by
  unfold sample; simp only [fees_append]; decide

/-- Of which 640 726 783 lamports (≈ 0.641 SOL) bought nothing at all: they paid
    for transactions that failed. -/
theorem sample_burnt : burnt sample = 640726783 := by
  unfold sample; simp only [burnt_append]; decide

/-- Deadweight is more than a quarter of everything spent. -/
theorem burnt_over_a_quarter : fees sample < burnt sample * 4 := by
  rw [sample_fees, sample_burnt]; norm_num

/-! ## Well-formedness of the record

    A transaction that fails is rolled back, so it can move no tokens.  That the
    extraction respects this is not an assumption here: it is checked, row by row,
    over the whole sample. -/

/-- The Boolean form of the well-formedness condition. -/
def wfTx (t : Tx) : Bool := t.ok || (!t.moves && !t.live)

theorem sample_wf_sound : Sound wfTx sample := by
  unfold sample
  simp only [sound_append]
  repeat' constructor
  all_goals decide

/-- Hence every failed transaction in the sample is inert, as it must be. -/
theorem sample_failuresAreInert : FailuresAreInert sample := by
  intro t ht hfail
  have h := sample_wf_sound t ht
  simp only [wfTx, hfail, Bool.false_or, Bool.and_eq_true, Bool.not_eq_eq_eq_not,
    Bool.not_true] at h
  exact ⟨h.1, h.2⟩

/-! ## The verdict on the index as a whole

    Read as a single record, the sample violates the settlement norm and — since
    the great majority of it does not touch the token — it is a long way from the
    picture of an "active" electorate that the dataset's own headline figures
    ("unique actors 5 119, active wallets 659") suggest. -/

theorem sample_fails_settlement : ¬ meets .settlement sample := by
  simp only [meets, Nat.not_le]
  rw [sample_size, sample_failed]; norm_num

theorem sample_verdict : verdict sample = .bad :=
  (verdict_bad_iff sample).2 (Or.inl sample_fails_settlement)

end Ledger.SampleFacts
