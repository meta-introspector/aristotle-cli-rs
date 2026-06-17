import Split.Eq_rec
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_add_lt_add_left
import Split.instAddNat
import Split.instLTNat
import Split.Eq
import Split.Nat_add_comm

-- Nat.add_lt_add_right from environment
-- theorem Nat.add_lt_add_right : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (forall (k : Nat), LT.lt.{0} Nat instLTNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m k))

-- Stub: this file represents the declaration `Nat.add_lt_add_right`.
-- In a full split, the body would be extracted from the environment.
