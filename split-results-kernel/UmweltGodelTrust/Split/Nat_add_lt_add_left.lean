import Split.Nat_succ_le_of_lt
import Split.Nat_lt_of_succ_le
import Split.Eq_rec
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_add_succ
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_add_le_add_left

-- Nat.add_lt_add_left from environment
-- theorem Nat.add_lt_add_left : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (forall (k : Nat), LT.lt.{0} Nat instLTNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k n) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k m))

-- Stub: this file represents the declaration `Nat.add_lt_add_left`.
-- In a full split, the body would be extracted from the environment.
