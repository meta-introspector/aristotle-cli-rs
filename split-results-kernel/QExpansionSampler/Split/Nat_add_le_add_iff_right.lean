import Split.Nat_add_le_add_right
import Split.Nat_le_of_add_le_add_right
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.Iff
import Split.HAdd_hAdd
import Split.Nat
import Split.Iff_intro
import Split.instAddNat

-- Nat.add_le_add_iff_right from environment
-- theorem Nat.add_le_add_iff_right : forall {m : Nat} {k : Nat} {n : Nat}, Iff (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k n)) (LE.le.{0} Nat instLENat m k)

-- Stub: this file represents the declaration `Nat.add_le_add_iff_right`.
-- In a full split, the body would be extracted from the environment.
