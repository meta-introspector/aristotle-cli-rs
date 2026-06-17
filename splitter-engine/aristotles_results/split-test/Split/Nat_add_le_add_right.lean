import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq
import Split.Nat_add_le_add_left
import Split.Nat_add_comm

-- Nat.add_le_add_right from environment
-- theorem Nat.add_le_add_right : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (forall (k : Nat), LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m k))

-- Stub: this file represents the declaration `Nat.add_le_add_right`.
-- In a full split, the body would be extracted from the environment.
