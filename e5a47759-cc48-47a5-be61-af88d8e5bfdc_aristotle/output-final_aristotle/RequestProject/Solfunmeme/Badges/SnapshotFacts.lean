/-
  SnapshotFacts.lean — the badge of issue #86, computed from the dataset.

  `proofs/tier_snapshots.json` records 52 datestamped holder rankings between
  15 January and 28 April 2025.  That is exactly the time series the badge's
  "token-days" figure needs, and this file computes it: for each of the 100
  addresses in the last snapshot's Senate tier, the area under its balance
  curve across the recorded window.

  Because a snapshot lists only the ranked holders, an address a snapshot omits
  has an unrecorded balance; every area below is therefore given as a pair of
  bounds — `tokenSecondsLower` charges the omitted days at 0, and
  `tokenSecondsUpper` charges them at the smallest balance the snapshot records
  at all (which is 1 raw unit, a millionth of a token, in every snapshot).  The
  conclusions are stated so that they hold for the whole interval.

  What comes out:

    * only 39 of the 100 sitting senators held a Senate-tier balance at every
      one of the 52 snapshots, so at most 39 "Genesis Senator" badges can be
      minted — fewer than the 42 senate credentials the dataset issued, and far
      fewer than the 100 seats;
    * token-day weighting really does reorder the Senate: the third-largest
      holder has at most 24 686 525 token-days while the fourth-largest, with
      2.4 million fewer tokens, has at least 138 864 040;
    * the largest holder leads on both measures, by a wide margin.
-/

import Mathlib.Tactic
import RequestProject.Solfunmeme.Badges.Data.Snapshots
import RequestProject.Solfunmeme.Badges.Tiers
import RequestProject.Solfunmeme.Review.PublishedData

namespace Badges.Snapshot

/-! ### The area under each holder's balance curve -/

/-- The 51 gaps between consecutive snapshots, in seconds. -/
def gaps : List Nat := (times.zip times.tail).map (fun p => p.2 - p.1)

/-- Token-seconds accumulated, charging every unrecorded day at 0. -/
def tokenSecondsLower (bs : List Nat) : Nat :=
  ((bs.zip gaps).map (fun p => p.1 * p.2)).sum

/-- Token-seconds accumulated, charging every unrecorded day at the smallest
balance the snapshot records at all. -/
def tokenSecondsUpper (bs : List Nat) : Nat :=
  (((bs.zip floors).zip gaps).map (fun p => max p.1.1 p.1.2 * p.2)).sum

/-- Whole token-days, from raw token-seconds (the token has six decimals). -/
def toTokenDays (ts : Nat) : Nat := ts / (86400 * 1000000)

/-- The balances recorded for an address, or `[]` if it is not a sitting
senator. -/
def rowOf (a : String) : List Nat :=
  ((senate.find? (fun r => r.1 = a)).map Prod.snd).getD []

/-- The balance an address held at the last snapshot. -/
def finalBalance (a : String) : Nat := (rowOf a).getLast!

/-! ### Shape of the data -/

theorem snapshot_count : times.length = 52 := by rfl

theorem cutoffs_count : cutoffs.length = 52 := by rfl

theorem senate_recorded : senate.length = 100 := by rfl

theorem gaps_count : gaps.length = 51 := by rfl

/-- The snapshots are in chronological order. -/
theorem times_increasing : (times.zip times.tail).all (fun p => p.1 < p.2) = true := by rfl

/-- The recorded window is 8 859 084 seconds — 102 days. -/
theorem window_seconds : times.getLast! - times.head! = 8859084 := by rfl

theorem window_days : (times.getLast! - times.head!) / 86400 = 102 := by rfl

/-! ### Genesis senators -/

/-- An address qualifies as *genesis* when its recorded balance met the Senate
cutoff at every one of the 52 snapshots. -/
def qualifies (bs : List Nat) : Bool := (bs.zip cutoffs).all (fun p => p.2 ≤ p.1)

/-- The sitting senators who were in the Senate tier throughout. -/
def genesisSenate : List (String × List Nat) := senate.filter (fun r => qualifies r.2)

/-- **Only 39 Genesis Senator badges exist in the data.**  Of the 100 addresses
holding a Senate seat at the last snapshot, 39 held a Senate-tier balance at
every snapshot in the window. -/
theorem genesis_count : genesisSenate.length = 39 := by rfl

/-- Fewer genesis senators than the senate credentials the dataset issued. -/
theorem genesis_fewer_than_credentials :
    genesisSenate.length < Review.PublishedData.senateCredentials := by decide

/-- And far fewer than the 100 Senate seats of the proposal. -/
theorem genesis_fewer_than_seats : genesisSenate.length < senateSeats := by decide

/-- 61 of the 100 sitting senators arrived during the window, so their badges
could not carry a genesis flag. -/
theorem senate_churn : senate.length - genesisSenate.length = 61 := by rfl

/-! ### Token-day weighting reorders the Senate -/

/-- Third by balance at the last snapshot. -/
def addrThird : String := "9gcF4nfaaYJtqA8MTnLDcsSDXRDDiBez4tdxBQCXHQou"

/-- Fourth by balance at the last snapshot. -/
def addrFourth : String := "Hy6vVMLqSzKdEjfxsUKQuYipKPpBqS4abquMA5YeWabv"

theorem third_balance : finalBalance addrThird = 14752759215932 := by rfl

theorem fourth_balance : finalBalance addrFourth = 12370737951535 := by rfl

theorem fourth_holds_less : finalBalance addrFourth < finalBalance addrThird := by
  rw [third_balance, fourth_balance]; norm_num

/-- Even charging every unrecorded day at the highest rate the data allows, the
third-largest holder has at most 24 686 525 token-days. -/
theorem third_tokenDays_upper :
    toTokenDays (tokenSecondsUpper (rowOf addrThird)) = 24686525 := by rfl

/-- Charging every unrecorded day at 0, the fourth-largest holder still has at
least 138 864 040 token-days. -/
theorem fourth_tokenDays_lower :
    toTokenDays (tokenSecondsLower (rowOf addrFourth)) = 138864040 := by rfl

/-- **The badge's own measure overturns the balance ranking.**  The fourth
holder outranks the third by token-days — by a factor of more than five —
although it holds 2.4 million fewer tokens. -/
theorem tokenDays_reorders_senate :
    finalBalance addrFourth < finalBalance addrThird ∧
      toTokenDays (tokenSecondsUpper (rowOf addrThird))
        < toTokenDays (tokenSecondsLower (rowOf addrFourth)) := by
  refine ⟨fourth_holds_less, ?_⟩
  rw [third_tokenDays_upper, fourth_tokenDays_lower]
  norm_num

/-! ### The leader -/

/-- The largest holder at the last snapshot. -/
def addrLeader : String := "AtTjQKXo1CYTa2MuxPARtr382ZyhPU5YX4wMMpvaa1oy"

theorem leader_balance : finalBalance addrLeader = 89484824995506 := by rfl

theorem leader_tokenDays :
    toTokenDays (tokenSecondsLower (rowOf addrLeader)) = 8787467393 := by rfl

/-- The leader also leads on token-days: every other sitting senator has fewer,
even given the most generous reading of the gaps in the record. -/
theorem leader_dominates :
    (senate.drop 1).all
      (fun r => decide (tokenSecondsUpper r.2 < tokenSecondsLower (rowOf addrLeader)))
      = true := by
  set_option maxRecDepth 100000 in decide +kernel

end Badges.Snapshot
