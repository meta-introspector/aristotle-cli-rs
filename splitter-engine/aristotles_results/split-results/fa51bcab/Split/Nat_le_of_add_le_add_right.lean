import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.Nat_le_of_add_le_add_left
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq
import Split.Nat_add_comm

-- Nat.le_of_add_le_add_right from environment
-- theorem Nat.le_of_add_le_add_right : forall {a : Nat} {b : Nat} {c : Nat}, (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a b) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) c b)) -> (LE.le.{0} Nat instLENat a c)

-- Stub: this file represents the declaration `Nat.le_of_add_le_add_right`.
-- In a full split, the body would be extracted from the environment.
