import RequestProject.Solfunmeme.Ledger.Data.Population
import RequestProject.Solfunmeme.Ledger.SampleFacts
import RequestProject.Solfunmeme.Ledger.Verdicts

/-!
# All 1 154 fee payers at once

`Ledger.Verdicts` looks closely at twenty-two wallets.  This file looks, less
closely, at every wallet: `Ledger.Data.population` carries one summary row per
distinct fee payer of the sample, and the verdict of `Ledger.Behaviour` is
re-run on each of those rows.

The summary table is not a second, independent measurement to be taken on
trust.  Its column sums are proved equal to the transaction-level totals of
`Ledger.SampleFacts`, and the rows of the twenty-two analysed wallets are
proved equal to the summaries computed from their raw transactions — so a
transcription error in the table would have to be a conspiracy of errors.
-/

set_option maxRecDepth 4000000
set_option maxHeartbeats 1000000

namespace Ledger.PopulationFacts

open Ledger Ledger.Data Ledger.Verdicts

/-! ## The table, and its agreement with the transactions -/

/-- The sample was paid for by 1 154 distinct wallets. -/
theorem population_size : population.length = 1154 := by decide

theorem population_nTx : (population.map (fun s => s.nTx)).sum = 14996 := by decide
theorem population_nOk : (population.map (fun s => s.nOk)).sum = 5715 := by decide
theorem population_nMoves : (population.map (fun s => s.nMoves)).sum = 967 := by decide
theorem population_nBuys : (population.map (fun s => s.nBuys)).sum = 709 := by decide
theorem population_nSells : (population.map (fun s => s.nSells)).sum = 258 := by decide
theorem population_nExits : (population.map (fun s => s.nExits)).sum = 170 := by decide

/-- The rows add up to the sample: the table is a partition of the same
    transactions counted in `Ledger.SampleFacts`. -/
theorem population_agrees_with_sample :
    (population.map (fun s => s.nTx)).sum = nTx sample ∧
    (population.map (fun s => s.nOk)).sum = nOk sample ∧
    (population.map (fun s => s.nMoves)).sum = nMoves sample ∧
    (population.map (fun s => s.nBuys)).sum = nBuys sample ∧
    (population.map (fun s => s.nSells)).sum = nSells sample ∧
    (population.map (fun s => s.nExits)).sum = nExits sample := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · rw [population_nTx, SampleFacts.sample_size]
  · have h := nOk_add_nFail sample
    rw [SampleFacts.sample_size, SampleFacts.sample_failed] at h
    rw [population_nOk]; omega
  · rw [population_nMoves, SampleFacts.sample_moves]
  · rw [population_nBuys, SampleFacts.sample_buys]
  · rw [population_nSells, SampleFacts.sample_sells]
  · rw [population_nExits, SampleFacts.sample_exits]

/-! ### The analysed wallets are in the table, with the counts their transactions have -/
theorem summaryOf_w_J3Z1AfTD : summaryOf w_J3Z1AfTD = s_J3Z1AfTD := by decide
theorem mem_population_s_J3Z1AfTD : s_J3Z1AfTD ∈ population := by decide
theorem verdictS_s_J3Z1AfTD : verdictS s_J3Z1AfTD = verdict w_J3Z1AfTD := by
  rw [← summaryOf_w_J3Z1AfTD, verdictS_summaryOf]

theorem summaryOf_w_7QeRHULB : summaryOf w_7QeRHULB = s_7QeRHULB := by decide
theorem mem_population_s_7QeRHULB : s_7QeRHULB ∈ population := by decide
theorem verdictS_s_7QeRHULB : verdictS s_7QeRHULB = verdict w_7QeRHULB := by
  rw [← summaryOf_w_7QeRHULB, verdictS_summaryOf]

theorem summaryOf_w_4AnrXS8H : summaryOf w_4AnrXS8H = s_4AnrXS8H := by decide
theorem mem_population_s_4AnrXS8H : s_4AnrXS8H ∈ population := by decide
theorem verdictS_s_4AnrXS8H : verdictS s_4AnrXS8H = verdict w_4AnrXS8H := by
  rw [← summaryOf_w_4AnrXS8H, verdictS_summaryOf]

theorem summaryOf_w_9XvBYSKe : summaryOf w_9XvBYSKe = s_9XvBYSKe := by decide
theorem mem_population_s_9XvBYSKe : s_9XvBYSKe ∈ population := by decide
theorem verdictS_s_9XvBYSKe : verdictS s_9XvBYSKe = verdict w_9XvBYSKe := by
  rw [← summaryOf_w_9XvBYSKe, verdictS_summaryOf]

theorem summaryOf_w_C9YvTztk : summaryOf w_C9YvTztk = s_C9YvTztk := by decide
theorem mem_population_s_C9YvTztk : s_C9YvTztk ∈ population := by decide
theorem verdictS_s_C9YvTztk : verdictS s_C9YvTztk = verdict w_C9YvTztk := by
  rw [← summaryOf_w_C9YvTztk, verdictS_summaryOf]

theorem summaryOf_w_7dGrdJRY : summaryOf w_7dGrdJRY = s_7dGrdJRY := by decide
theorem mem_population_s_7dGrdJRY : s_7dGrdJRY ∈ population := by decide
theorem verdictS_s_7dGrdJRY : verdictS s_7dGrdJRY = verdict w_7dGrdJRY := by
  rw [← summaryOf_w_7dGrdJRY, verdictS_summaryOf]

theorem summaryOf_w_HxkTYMtx : summaryOf w_HxkTYMtx = s_HxkTYMtx := by decide
theorem mem_population_s_HxkTYMtx : s_HxkTYMtx ∈ population := by decide
theorem verdictS_s_HxkTYMtx : verdictS s_HxkTYMtx = verdict w_HxkTYMtx := by
  rw [← summaryOf_w_HxkTYMtx, verdictS_summaryOf]

theorem summaryOf_w_EN4kMnNm : summaryOf w_EN4kMnNm = s_EN4kMnNm := by decide
theorem mem_population_s_EN4kMnNm : s_EN4kMnNm ∈ population := by decide
theorem verdictS_s_EN4kMnNm : verdictS s_EN4kMnNm = verdict w_EN4kMnNm := by
  rw [← summaryOf_w_EN4kMnNm, verdictS_summaryOf]

theorem summaryOf_w_686oaTQa : summaryOf w_686oaTQa = s_686oaTQa := by decide
theorem mem_population_s_686oaTQa : s_686oaTQa ∈ population := by decide
theorem verdictS_s_686oaTQa : verdictS s_686oaTQa = verdict w_686oaTQa := by
  rw [← summaryOf_w_686oaTQa, verdictS_summaryOf]

theorem summaryOf_w_6VzidcFh : summaryOf w_6VzidcFh = s_6VzidcFh := by decide
theorem mem_population_s_6VzidcFh : s_6VzidcFh ∈ population := by decide
theorem verdictS_s_6VzidcFh : verdictS s_6VzidcFh = verdict w_6VzidcFh := by
  rw [← summaryOf_w_6VzidcFh, verdictS_summaryOf]

theorem summaryOf_w_27XHsdyK : summaryOf w_27XHsdyK = s_27XHsdyK := by decide
theorem mem_population_s_27XHsdyK : s_27XHsdyK ∈ population := by decide
theorem verdictS_s_27XHsdyK : verdictS s_27XHsdyK = verdict w_27XHsdyK := by
  rw [← summaryOf_w_27XHsdyK, verdictS_summaryOf]

theorem summaryOf_w_5ssQGkUG : summaryOf w_5ssQGkUG = s_5ssQGkUG := by decide
theorem mem_population_s_5ssQGkUG : s_5ssQGkUG ∈ population := by decide
theorem verdictS_s_5ssQGkUG : verdictS s_5ssQGkUG = verdict w_5ssQGkUG := by
  rw [← summaryOf_w_5ssQGkUG, verdictS_summaryOf]

theorem summaryOf_w_F4oEKU8a : summaryOf w_F4oEKU8a = s_F4oEKU8a := by decide
theorem mem_population_s_F4oEKU8a : s_F4oEKU8a ∈ population := by decide
theorem verdictS_s_F4oEKU8a : verdictS s_F4oEKU8a = verdict w_F4oEKU8a := by
  rw [← summaryOf_w_F4oEKU8a, verdictS_summaryOf]

theorem summaryOf_w_G1uSQxpf : summaryOf w_G1uSQxpf = s_G1uSQxpf := by decide
theorem mem_population_s_G1uSQxpf : s_G1uSQxpf ∈ population := by decide
theorem verdictS_s_G1uSQxpf : verdictS s_G1uSQxpf = verdict w_G1uSQxpf := by
  rw [← summaryOf_w_G1uSQxpf, verdictS_summaryOf]

theorem summaryOf_w_DLp2YLYc : summaryOf w_DLp2YLYc = s_DLp2YLYc := by decide
theorem mem_population_s_DLp2YLYc : s_DLp2YLYc ∈ population := by decide
theorem verdictS_s_DLp2YLYc : verdictS s_DLp2YLYc = verdict w_DLp2YLYc := by
  rw [← summaryOf_w_DLp2YLYc, verdictS_summaryOf]

theorem summaryOf_w_HCb7hLss : summaryOf w_HCb7hLss = s_HCb7hLss := by decide
theorem mem_population_s_HCb7hLss : s_HCb7hLss ∈ population := by decide
theorem verdictS_s_HCb7hLss : verdictS s_HCb7hLss = verdict w_HCb7hLss := by
  rw [← summaryOf_w_HCb7hLss, verdictS_summaryOf]

theorem summaryOf_w_FTotzvz1 : summaryOf w_FTotzvz1 = s_FTotzvz1 := by decide
theorem mem_population_s_FTotzvz1 : s_FTotzvz1 ∈ population := by decide
theorem verdictS_s_FTotzvz1 : verdictS s_FTotzvz1 = verdict w_FTotzvz1 := by
  rw [← summaryOf_w_FTotzvz1, verdictS_summaryOf]

theorem summaryOf_w_6DAHh1hH : summaryOf w_6DAHh1hH = s_6DAHh1hH := by decide
theorem mem_population_s_6DAHh1hH : s_6DAHh1hH ∈ population := by decide
theorem verdictS_s_6DAHh1hH : verdictS s_6DAHh1hH = verdict w_6DAHh1hH := by
  rw [← summaryOf_w_6DAHh1hH, verdictS_summaryOf]

theorem summaryOf_w_x3pJA2jG : summaryOf w_x3pJA2jG = s_x3pJA2jG := by decide
theorem mem_population_s_x3pJA2jG : s_x3pJA2jG ∈ population := by decide
theorem verdictS_s_x3pJA2jG : verdictS s_x3pJA2jG = verdict w_x3pJA2jG := by
  rw [← summaryOf_w_x3pJA2jG, verdictS_summaryOf]

theorem summaryOf_w_CMbBM2BW : summaryOf w_CMbBM2BW = s_CMbBM2BW := by decide
theorem mem_population_s_CMbBM2BW : s_CMbBM2BW ∈ population := by decide
theorem verdictS_s_CMbBM2BW : verdictS s_CMbBM2BW = verdict w_CMbBM2BW := by
  rw [← summaryOf_w_CMbBM2BW, verdictS_summaryOf]

theorem summaryOf_w_FwqxwTYu : summaryOf w_FwqxwTYu = s_FwqxwTYu := by decide
theorem mem_population_s_FwqxwTYu : s_FwqxwTYu ∈ population := by decide
theorem verdictS_s_FwqxwTYu : verdictS s_FwqxwTYu = verdict w_FwqxwTYu := by
  rw [← summaryOf_w_FwqxwTYu, verdictS_summaryOf]

theorem summaryOf_w_21nALQTX : summaryOf w_21nALQTX = s_21nALQTX := by decide
theorem mem_population_s_21nALQTX : s_21nALQTX ∈ population := by decide
theorem verdictS_s_21nALQTX : verdictS s_21nALQTX = verdict w_21nALQTX := by
  rw [← summaryOf_w_21nALQTX, verdictS_summaryOf]

/-! ## The distribution of verdicts

    Read across all 1 154 payers the picture looks benign: most wallets are
    `good`.  That is an artefact of the long tail — 841 of the payers appear
    exactly once in the sample, and a single settled purchase meets every norm.
-/

theorem population_good : countVerdict .good population = 590 := by decide
theorem population_mixed : countVerdict .mixed population = 220 := by decide
theorem population_bad : countVerdict .bad population = 344 := by decide

theorem population_verdicts_partition :
    countVerdict .good population + countVerdict .mixed population
      + countVerdict .bad population = 1154 := by
  have h := countVerdict_total population
  rwa [population_size] at h

/-! ### Weighted by activity, the picture reverses -/

/-- The wallets judged `bad` paid for 11 617 of the 14 996 sampled transactions:
    more than three quarters of the index. -/
theorem txs_of_bad :
    ((population.filter (fun s => decide (verdictS s = .bad))).map (fun s => s.nTx)).sum
      = 11617 := by decide

/-- The wallets judged `good` paid for 812 of them. -/
theorem txs_of_good :
    ((population.filter (fun s => decide (verdictS s = .good))).map (fun s => s.nTx)).sum
      = 812 := by decide

theorem bad_txs_dominate :
    14 * (((population.filter (fun s => decide (verdictS s = .good))).map
            (fun s => s.nTx)).sum)
      < ((population.filter (fun s => decide (verdictS s = .bad))).map (fun s => s.nTx)).sum := by
  rw [txs_of_bad, txs_of_good]; norm_num

/-! ## Busy wallets

    Restricted to the wallets that appear at least ten times in the sample, the
    verdicts invert: 99 bad, 12 mixed, one single wallet that meets all four
    norms. -/

/-- The wallets with at least ten sampled transactions. -/
def busy : List Summary := population.filter (fun s => decide (10 ≤ s.nTx))

theorem busy_size : busy.length = 112 := by decide

theorem busy_good : countVerdict .good busy = 1 := by decide
theorem busy_mixed : countVerdict .mixed busy = 12 := by decide
theorem busy_bad : countVerdict .bad busy = 99 := by decide

theorem busy_mostly_bad : busy.length < 2 * countVerdict .bad busy := by
  rw [busy_size, busy_bad]; norm_num

/-- The one busy wallet that meets every norm is `6VzidcFh…`. -/
theorem busy_good_is_6VzidcFh :
    busy.filter (fun s => decide (verdictS s = .good)) = [s_6VzidcFh] := by decide

/-- Nobody with two hundred or more sampled transactions meets all four norms. -/
theorem no_good_heavy :
    ∀ s ∈ population, 200 ≤ s.nTx → verdictS s ≠ .good := by decide

end Ledger.PopulationFacts
