/-
  Roster.lean — the new chamber, seated from the dataset.

  `RequestProject/Chamber/Model.lean` is the theory; this file is the chamber
  the project actually has.  Its hundred seats are the hundred addresses that
  hold a Senate badge at the last of the dataset's 52 snapshots
  (`RequestProject/Badges/Data/Claims.lean`, proved to be what the snapshots
  yield in `RequestProject/Badges/ClaimFacts.lean`), each seat carrying:

      holder   the address, so a seat can only be voted by whoever can open
               that address's badge;
      klass    the rotation class, the badge rank modulo three, so the three
               classes are as near equal as a hundred allows and rank order
               is spread across them rather than concentrated;
      weight   the closing balance in whole tokens.

  Every concrete figure below is checked by `decide`, so the kernel recomputes
  it from the dataset's own table.
-/

import RequestProject.Solfunmeme.Chamber.Model
import RequestProject.Solfunmeme.Badges.Data.Claims
import RequestProject.Solfunmeme.Senate.Roster

namespace Chamber.Seated

open Badges.Claim

/-- One seat per badge holder. -/
def seatOf (c : ClaimPage) : Chamber.Seat :=
  { holder := c.address, klass := c.rank % 3, weight := c.finalBalance / 1000000 }

/-- **The chamber.** -/
def chamber : Chamber.Roll := ⟨claims.map seatOf⟩

theorem chamber_size : chamber.size = 100 := by
  simp [chamber, Chamber.Roll.size, Badges.Claim.claims_length]

/-- The seats are held by a hundred different addresses. -/
theorem chamber_holders_nodup : chamber.holders.Nodup := by
  have : chamber.holders = claims.map (fun p => p.address) := by
    simp [chamber, Chamber.Roll.holders, seatOf, List.map_map, Function.comp]
  rw [this]
  exact Badges.Claim.addresses_nodup

/-- Every seat is held by an address on the senators' roster, so every seat is
held by somebody who can prove they hold its key. -/
theorem chamber_holders_are_senators : ∀ a ∈ chamber.holders, a ∈ Senate.Desk.roster := by
  intro a ha
  have : chamber.holders = claims.map (fun p => p.address) := by
    simp [chamber, Chamber.Roll.holders, seatOf, List.map_map, Function.comp]
  rw [this] at ha
  simpa [Senate.Desk.roster] using ha

/-! ### The rotation classes -/

/-- The seats of one rotation class. -/
def classSeats (k : Nat) : List Chamber.Seat :=
  chamber.seats.filter (fun s => s.klass == k)

/-- **The three classes are as near equal as a hundred allows**: 34, 33, 33. -/
theorem class_sizes :
    ((classSeats 0).length, (classSeats 1).length, (classSeats 2).length) = (33, 34, 33) := by
  decide

theorem classes_cover : (classSeats 0).length + (classSeats 1).length
    + (classSeats 2).length = chamber.size := by
  decide

/-- **A rotation never touches more than 34 of the 100 seats**: two thirds of
the chamber carries over, whatever happens in the class that turns over. -/
theorem rotation_retains_two_thirds (k : Nat) (hk : k < 3) :
    66 ≤ (Chamber.retained chamber k).length := by
  interval_cases k <;> decide

/-! ### The chamber can act -/

/-- Fifty-one of the hundred. -/
theorem chamber_quorum : Chamber.quorumOf chamber = 51 := by
  simp [Chamber.quorumOf, chamber_size]

/-- **The chamber can reach a quorum**, and can carry a motion at every
threshold.  Contrast `RequestProject/Review/PublishedData.lean`, where the
dataset's own rule is unsatisfiable for the electorate that exists. -/
theorem chamber_can_act (t : Chamber.Threshold) :
    Chamber.carries chamber t (Chamber.unanimous chamber) = true :=
  Chamber.unanimous_carries chamber t (by simp [chamber_size])

/-- **The stake standing behind the chamber**, in whole tokens: the same
564 653 915 the federal model apportions by. -/
theorem chamber_stake :
    (chamber.seats.map (fun s => s.weight)).foldl (· + ·) 0 = 564653915 := by
  decide

end Chamber.Seated
