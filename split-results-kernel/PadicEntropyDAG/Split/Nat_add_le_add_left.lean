import Split.congrArg
import Split.Exists
import Split.Nat_le_intro
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Nat_add_assoc
import Split.instAddNat
import Split.Nat_le_dest
import Split.Eq
import Split.Eq_trans

-- Nat.add_le_add_left from environment
-- theorem Nat.add_le_add_left : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (forall (k : Nat), LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k n) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k m))

-- Stub: this file represents the declaration `Nat.add_le_add_left`.
-- In a full split, the body would be extracted from the environment.
