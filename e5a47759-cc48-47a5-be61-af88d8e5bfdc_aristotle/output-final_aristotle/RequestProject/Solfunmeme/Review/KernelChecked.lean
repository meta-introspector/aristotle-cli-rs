/-
  KernelChecked.lean — kernel-checked (`decide`) restatements of every fact that the
  upstream `lean4/` modules prove with `native_decide`.

  `native_decide` discharges a goal by running compiled code, which adds
  `Lean.ofReduceBool` and `Lean.trustCompiler` to the trusted base of the result.
  Every one of those 85 goals is small enough for the kernel to evaluate directly,
  so nothing is gained by it.  Each statement below is verbatim the upstream one,
  re-proved with `decide`, and therefore depends only on the standard axioms —
  several of them on none at all.
-/

import RequestProject.Solfunmeme.Upstream.FederalModel
import RequestProject.Solfunmeme.Upstream.Governance
import RequestProject.Solfunmeme.Upstream.FederalGov
import RequestProject.Solfunmeme.Upstream.Bills
import RequestProject.Solfunmeme.Upstream.VotingProtocol

namespace Review.KernelChecked

/-! ### FederalModel.lean -/

theorem tier_count : tierBoundaries.length = 12 := by decide

theorem tier_sorted : tierBoundaries.Pairwise (· < ·) := by decide

theorem fib_at_3 : 1000 + 500 = 1500 := by decide

theorem fib_at_4 : 1500 + 1000 = 2500 := by decide

theorem fib_at_5 : 2500 + 1500 = 4000 := by decide

theorem fib_at_6 : 4000 + 2500 = 6500 := by decide

theorem fib_at_7 : 6500 + 4000 = 10500 := by decide

theorem fib_at_8 : 10500 + 6500 = 17000 := by decide

theorem fib_at_9 : 17000 + 10500 = 27500 := by decide

theorem fib_at_10 : 27500 + 17000 = 44500 := by decide

theorem fib_at_11 : 44500 + 27500 = 72000 := by decide

theorem diamond_boundary : tierBoundaries.head! = 100 := by decide

theorem gold_size : tierBoundaries[1]! - tierBoundaries[0]! = 400 := by decide

theorem silver_size : tierBoundaries[2]! - tierBoundaries[1]! = 500 := by decide

theorem monster_product : 47 * 59 * 71 = 196883 := by decide

theorem shem_216 : 72 * 3 = 216 := by decide

/-! ### Governance.lean -/

theorem diamond_gt_gold : Tier.diamond.weight > Tier.gold.weight := by decide

theorem gold_gt_silver : Tier.gold.weight > Tier.silver.weight := by decide

theorem silver_gt_fib : Tier.silver.weight > Tier.fib3.weight := by decide

theorem unanimous_yes_1 : resolve ⟨1, 0, 0, 1⟩ defaultQuorum = .passed := by decide

theorem unanimous_yes_100 : resolve ⟨100, 0, 0, 100⟩ defaultQuorum = .passed := by decide

theorem unanimous_yes_3277 : resolve ⟨3277, 0, 0, 3277⟩ defaultQuorum = .passed := by decide

theorem unanimous_no_1 : resolve ⟨0, 1, 0, 1⟩ defaultQuorum = .failed := by decide

theorem unanimous_no_100 : resolve ⟨0, 100, 0, 100⟩ defaultQuorum = .failed := by decide

theorem unanimous_no_3277 : resolve ⟨0, 3277, 0, 3277⟩ defaultQuorum = .failed := by decide

theorem tie_fails_100 : resolve ⟨100, 100, 0, 200⟩ defaultQuorum = .failed := by decide

theorem tie_fails_1000 : resolve ⟨1000, 1000, 0, 2000⟩ defaultQuorum = .failed := by decide

theorem dao_weight_val : daoWeight = 3277 := by decide

theorem diamond_alone_no_quorum :
    resolve ⟨800, 0, 0, daoWeight⟩ defaultQuorum = .noQuorum := by decide

theorem diamond_gold_passes :
    resolve ⟨2800, 0, 0, daoWeight⟩ defaultQuorum = .passed := by decide

theorem gold_outvotes_diamond :
    resolve ⟨800, 2000, 0, daoWeight⟩ defaultQuorum = .failed := by decide

theorem gold_beats_diamond_silver :
    resolve ⟨1277, 2000, 0, daoWeight⟩ defaultQuorum = .failed := by decide

theorem full_consensus :
    resolve ⟨3277, 0, 0, daoWeight⟩ defaultQuorum = .passed := by decide

theorem minimum_coalition :
    resolve ⟨1640, 1637, 0, daoWeight⟩ defaultQuorum = .passed := by decide

theorem minimum_coalition_minus_one :
    resolve ⟨1639, 1639, 0, daoWeight⟩ defaultQuorum = .failed := by decide

/-! ### FederalGov.lean -/

theorem total_gov : senateSize + houseSize + lobbySize = 1600 := by decide

theorem senate_majority : senateSize / 2 + 1 = 51 := by decide

theorem house_majority : houseSize / 2 + 1 = 251 := by decide

theorem senate_super : (senateSize * 2 + 2) / 3 = 67 := by decide

theorem house_super : (houseSize * 2 + 2) / 3 = 334 := by decide

theorem senate_alone_fails :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨0, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .noQuorum := by decide

theorem house_alone_fails :
    resolveBill ⟨⟨0, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .noQuorum := by decide

theorem both_pass_enacted :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .enacted := by decide

theorem senate_blocks :
    resolveBill ⟨⟨49, 51, 100⟩, ⟨400, 100, 500⟩, ⟨0, 0, 1000⟩⟩ = .senateFailed := by decide

theorem house_blocks :
    resolveBill ⟨⟨51, 49, 100⟩, ⟨249, 251, 500⟩, ⟨0, 0, 1000⟩⟩ = .houseFailed := by decide

theorem minimum_passage :
    resolveBill ⟨⟨51, 49, 100⟩, ⟨251, 249, 500⟩, ⟨0, 0, 1000⟩⟩ = .enacted := by decide

theorem one_less_senate :
    resolveBill ⟨⟨50, 50, 100⟩, ⟨251, 249, 500⟩, ⟨0, 0, 1000⟩⟩ = .senateFailed := by decide

theorem one_less_house :
    resolveBill ⟨⟨51, 49, 100⟩, ⟨250, 250, 500⟩, ⟨0, 0, 1000⟩⟩ = .houseFailed := by decide

theorem lobby_irrelevant_pass :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 1000, 1000⟩⟩ = .enacted := by decide

theorem lobby_irrelevant_fail :
    resolveBill ⟨⟨49, 51, 100⟩, ⟨249, 251, 500⟩, ⟨1000, 0, 1000⟩⟩ = .bothFailed := by decide

theorem veto_override_minimum :
    vetoOverride ⟨⟨67, 33, 100⟩, ⟨334, 166, 500⟩, ⟨0, 0, 1000⟩⟩ = .overridden := by decide

theorem veto_sustained_senate :
    vetoOverride ⟨⟨66, 34, 100⟩, ⟨334, 166, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by decide

theorem veto_sustained_house :
    vetoOverride ⟨⟨67, 33, 100⟩, ⟨333, 167, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by decide

theorem veto_override_unanimous :
    vetoOverride ⟨⟨100, 0, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .overridden := by decide

theorem senate_quorum_met :
    chamberQuorum ⟨26, 25, 100⟩ = true := by decide

theorem senate_quorum_not_met :
    chamberQuorum ⟨25, 25, 100⟩ = false := by decide

theorem house_quorum_met :
    chamberQuorum ⟨126, 125, 500⟩ = true := by decide

theorem house_quorum_not_met :
    chamberQuorum ⟨125, 125, 500⟩ = false := by decide

theorem senate_minority_veto :
    resolveBill ⟨⟨49, 51, 100⟩, ⟨500, 0, 500⟩, ⟨1000, 0, 1000⟩⟩ = .senateFailed := by decide

theorem house_popular_veto :
    resolveBill ⟨⟨100, 0, 100⟩, ⟨249, 251, 500⟩, ⟨1000, 0, 1000⟩⟩ = .houseFailed := by decide

theorem senate_cant_override_alone :
    vetoOverride ⟨⟨100, 0, 100⟩, ⟨0, 500, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by decide

theorem house_cant_override_alone :
    vetoOverride ⟨⟨0, 100, 100⟩, ⟨500, 0, 500⟩, ⟨0, 0, 1000⟩⟩ = .sustained := by decide

/-! ### Bills.lean -/

theorem standard_bill_passes :
    billPasses ⟨51, 49, 251, 249, 500, 500⟩ = true := by decide

theorem senate_tie_fails :
    billPasses ⟨50, 50, 300, 200, 500, 500⟩ = false := by decide

theorem house_tie_fails :
    billPasses ⟨60, 40, 250, 250, 500, 500⟩ = false := by decide

theorem no_senate_quorum :
    billPasses ⟨25, 25, 300, 200, 500, 500⟩ = false := by decide

theorem lobby_irrelevant :
    billPasses ⟨51, 49, 251, 249, 0, 1000⟩ = true := by decide

theorem avg_tx : avgTxPerDay = 203 := by decide

theorem typical_day_passes :
    billPasses ⟨80, 20, 400, 100, 800, 200⟩ = true := by decide

theorem contentious_day :
    billPasses ⟨52, 48, 260, 240, 300, 700⟩ = true := by decide

theorem blocked_day :
    billPasses ⟨40, 60, 400, 100, 900, 100⟩ = false := by decide

/-! ### VotingProtocol.lean -/

theorem senate_min_pos : tierMinBalance .senate > 0 := by decide

theorem house_min_pos : tierMinBalance .house > 0 := by decide

theorem lobby_min_pos : tierMinBalance .lobby > 0 := by decide

theorem senate_gt_house : tierMinBalance .senate > tierMinBalance .house := by decide

theorem house_gt_lobby : tierMinBalance .house > tierMinBalance .lobby := by decide

theorem senator_vote_valid : voteValid exampleSenatorVote = true := by decide

theorem sold_senator_invalid : voteValid soldSenatorVote = false := by decide

theorem expired_vote_invalid : voteValid expiredVote = false := by decide

theorem stolen_nft_invalid : voteValid stolenNftVote = false := by decide

theorem stale_vote_invalid : voteValid staleVote = false := by decide

theorem telegram_valid : voteValid voteOnTelegram = true := by decide

theorem discord_valid  : voteValid voteOnDiscord = true := by decide

theorem wg_valid       : voteValid voteOnWg = true := by decide

theorem direct_valid   : voteValid voteDirect = true := by decide

end Review.KernelChecked
