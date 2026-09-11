/-
  PublishedData.lean — the numbers published in the dataset's README and in
  `proofs/*.json`, recorded as definitions and cross-checked against each other
  and against the governance rules of the Lean modules.

  All figures below are transcribed from the dataset as of the reviewed revision:

    README.md                  TX signatures indexed 2,668,036;
                               TX details cached 135,563 (5.1%);
                               unique actors 5,119; active wallets 659;
                               outstanding bounty ("buy order") 2,532,473.
    proofs/completeness_proof.json
                               total_sigs_in_dataset 2,668,036;
                               tx_files_analyzed 135,563;
                               tx_with_token_changes 10,564; block_snapshots 52;
                               holders_with_positive_balance 3,610;
                               holders_with_zero_balance 158;
                               total_unique_actors 5,119;
                               total_inflow 2,395,222,254,492,595;
                               total_outflow 2,395,278,103,879,739;
                               net_balance −55,849,387,144;
                               inflow_equals_outflow false.
    proofs/holder_identities.json
                               total_holders 1,976 = 659 wallets + 8 contract
                               accounts + 1,309 closed accounts.
    proofs/credentials.json    652 credentials = 42 senate + 145 house + 465 lobby,
                               snapshot_day 20537.
    proofs/tally.json          senate 1 yea, house 1 yea, quorum_met false.

  The theorems record which of these are arithmetically consistent, which
  disagree with each other, and — the substantive point — that the electorate
  actually issued credentials is too small to satisfy the quorum rules that the
  Lean modules enforce, so under the published rules no bill can ever be enacted
  and no veto can ever be overridden.
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Upstream.FederalGov
import RequestProject.Solfunmeme.Upstream.Bills
import RequestProject.Solfunmeme.Upstream.Governance

namespace Review.PublishedData

/-! ### Transcribed figures -/

def txSignaturesIndexed : Nat := 2668036
def txDetailsCached : Nat := 135563
def txWithTokenChanges : Nat := 10564
def blockSnapshots : Nat := 52
def readmeBuyOrder : Nat := 2532473

def totalInflow : Int := 2395222254492595
def totalOutflow : Int := 2395278103879739
def reportedNetBalance : Int := -55849387144

def holdersPositiveBalance : Nat := 3610
def holdersZeroBalance : Nat := 158
def totalUniqueActors : Nat := 5119

def identifiedHolders : Nat := 1976
def walletAccounts : Nat := 659
def contractAccounts : Nat := 8
def closedAccounts : Nat := 1309

def senateCredentials : Nat := 42
def houseCredentials : Nat := 145
def lobbyCredentials : Nat := 465
def totalCredentials : Nat := 652

/-! ### Cross-checks that pass -/

/-- The README's outstanding bounty is exactly the uncached remainder. -/
theorem buyOrder_correct : txSignaturesIndexed - txDetailsCached = readmeBuyOrder := by decide

/-- Coverage is 5.08%, matching the reported 5.081% and the README's "5.1%"
    (expressed here in hundredths of a percent to stay in `Nat`). -/
theorem coverage_pct : txDetailsCached * 10000 / txSignaturesIndexed = 508 := by decide

/-- The reported net balance is indeed inflow − outflow. -/
theorem net_balance_correct : totalInflow - totalOutflow = reportedNetBalance := by decide

/-- …but the ledger does not balance: the artifact's own
    `inflow_equals_outflow : false` is justified. -/
theorem inflow_ne_outflow : totalInflow ≠ totalOutflow := by decide

/-- The account classification of `holder_identities.json` is a partition. -/
theorem holder_classification_partition :
    walletAccounts + contractAccounts + closedAccounts = identifiedHolders := by decide

/-- The credential counts add up, and every credential belongs to a wallet. -/
theorem credentials_partition :
    senateCredentials + houseCredentials + lobbyCredentials = totalCredentials := by decide

theorem credentials_fit_in_wallets : totalCredentials ≤ walletAccounts := by decide

/-- Upstream's `avg_tx` figure, and what it is an average of: 10,564 is the number
    of *cached* transactions that touch the token, i.e. a lower bound coming from a
    5% sample, not the daily on-chain volume. -/
theorem avg_tx_per_snapshot : txWithTokenChanges / blockSnapshots = 203 := by decide

/-! ### Cross-checks that fail -/

/-- The two artifacts count holders differently: `completeness_proof.json` reports
    3,610 holders with a positive balance while `holder_identities.json` ranks and
    classifies only 1,976 holders, all of them with a positive balance. -/
theorem holder_counts_disagree : holdersPositiveBalance ≠ identifiedHolders := by decide

/-- Neither holder count is the actor count: 3,610 + 158 ≠ 5,119, so 1,351 of the
    "unique actors" are neither current nor zeroed holders. -/
theorem actor_count_not_holder_count :
    holdersPositiveBalance + holdersZeroBalance ≠ totalUniqueActors := by decide

theorem actors_minus_holders :
    totalUniqueActors - (holdersPositiveBalance + holdersZeroBalance) = 1351 := by decide

/-! ### The chambers are far below their nominal sizes -/

/-- Only 42 of the top-100 ranks belong to accounts that received a credential;
    the other 58 nominal senate seats are held by 56 closed accounts and
    2 contract accounts. -/
theorem senate_seats_unfilled : senateCredentials + 58 = senateSize := by decide

theorem house_seats_unfilled : houseCredentials + 355 = houseSize := by decide

theorem lobby_seats_unfilled : lobbyCredentials + 535 = lobbySize := by decide

/-! ### Consequence: the published rules cannot be satisfied

    `chamberQuorum` demands strictly more than half of the *nominal* chamber size
    to participate: 51 senators of 100 and 251 representatives of 500.  With 42 and
    145 credentials in existence, neither is reachable. -/

theorem senate_quorum_needs_51 (v : ChamberVote) (hsize : v.size = senateSize)
    (hq : chamberQuorum v = true) : 51 ≤ v.yea + v.nay := by
  simp only [chamberQuorum, decide_eq_true_eq, gt_iff_lt, hsize, senateSize] at hq
  omega

theorem house_quorum_needs_251 (v : ChamberVote) (hsize : v.size = houseSize)
    (hq : chamberQuorum v = true) : 251 ≤ v.yea + v.nay := by
  simp only [chamberQuorum, decide_eq_true_eq, gt_iff_lt, hsize, houseSize] at hq
  omega

/-- No senate vote drawn from the 42 existing senate credentials reaches quorum. -/
theorem senate_quorum_unreachable (v : ChamberVote) (hsize : v.size = senateSize)
    (hcred : v.yea + v.nay ≤ senateCredentials) : chamberQuorum v = false := by
  cases hq : chamberQuorum v with
  | false => rfl
  | true =>
      have := senate_quorum_needs_51 v hsize hq
      simp only [senateCredentials] at hcred
      omega

theorem house_quorum_unreachable (v : ChamberVote) (hsize : v.size = houseSize)
    (hcred : v.yea + v.nay ≤ houseCredentials) : chamberQuorum v = false := by
  cases hq : chamberQuorum v with
  | false => rfl
  | true =>
      have := house_quorum_needs_251 v hsize hq
      simp only [houseCredentials] at hcred
      omega

/-- **No bill can be enacted.**  Every bicameral vote cast by the published
    electorate resolves to `noQuorum`. -/
theorem no_bill_can_be_enacted (b : BicameralVote)
    (hsize : b.senate.size = senateSize)
    (hcred : b.senate.yea + b.senate.nay ≤ senateCredentials) :
    resolveBill b = .noQuorum := by
  have h := senate_quorum_unreachable b.senate hsize hcred
  unfold resolveBill
  rw [if_pos]
  simp [h]

/-- **No veto can be overridden**: two thirds of 100 senators is 67, and only 42
    senate credentials exist. -/
theorem no_veto_override (b : BicameralVote)
    (hsize : b.senate.size = senateSize) (hcred : b.senate.yea ≤ senateCredentials) :
    vetoOverride b = .sustained := by
  simp only [vetoOverride, hsize, senateSize] at *
  simp only [senateCredentials] at hcred
  rw [if_neg]
  simp only [ge_iff_le, Bool.and_eq_true, decide_eq_true_eq, not_and]
  omega

/-- The same holds for `Bills.billPasses`, which hard-codes the two chamber
    sizes. -/
theorem no_bill_passes (v : BillVote) (hcred : v.senateYea + v.senateNay ≤ senateCredentials) :
    billPasses v = false := by
  simp only [billPasses, senateCredentials] at *
  simp only [Bool.and_eq_false_iff, decide_eq_false_iff_not, gt_iff_lt, not_lt]
  omega

/-- The published tally (`proofs/tally.json`: one yea in each chamber) is
    `noQuorum`, consistent with its own `quorum_met: false`. -/
theorem published_tally_noQuorum :
    resolveBill ⟨⟨1, 0, senateSize⟩, ⟨1, 0, houseSize⟩, ⟨0, 0, lobbySize⟩⟩ = .noQuorum := by
  decide

/-! ### The weighted-governance scenario uses a different electorate again

    `Governance.daoWeight` assumes 100 diamond, 400 gold and 159 silver voters.
    The credentials actually issued are 42 diamond, 145 gold, 153 silver, 156 fib-3
    and 156 fib-4, which under the same weight table gives 2,144, not 3,277. -/

def credentialWeight : Nat := 42 * 8 + 145 * 5 + 153 * 3 + 156 * 2 + 156 * 2

theorem credentialWeight_val : credentialWeight = 2144 := by decide

theorem daoWeight_overstates : daoWeight ≠ credentialWeight := by decide

/-- Taking the published electorate as the eligible weight, a proposal supported
    by every credential holder does pass — the weighted rule is satisfiable even
    though the chamber rule is not. -/
theorem weighted_rule_still_satisfiable :
    resolve ⟨credentialWeight, 0, 0, credentialWeight⟩ defaultQuorum = .passed := by decide

end Review.PublishedData
