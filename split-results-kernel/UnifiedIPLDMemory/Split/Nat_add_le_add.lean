import Split.Nat_add_le_add_right
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_le_trans
import Split.Nat
import Split.instAddNat
import Split.Nat_add_le_add_left

-- Nat.add_le_add from environment
-- theorem Nat.add_le_add : forall {a : Nat} {b : Nat} {c : Nat} {d : Nat}, (LE.le.{0} Nat instLENat a b) -> (LE.le.{0} Nat instLENat c d) -> (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a c) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) b d))

-- Stub: this file represents the declaration `Nat.add_le_add`.
-- In a full split, the body would be extracted from the environment.
