import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.Exists
import Split.id
import Split.instSubNat
import Split.Nat_le_intro
import Split.LE_le
import Split.Nat_add_left_comm
import Split.instLENat
import Split.instHAdd
import Split.instHSub
import Split.Nat_eq_add_of_sub_eq
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.Nat_le_dest
import Split.Eq_symm
import Split.Eq
import Split.Eq_trans
import Split.Nat_add_comm

-- Nat.add_le_of_le_sub from environment
-- theorem Nat.add_le_of_le_sub : forall {a : Nat} {b : Nat} {c : Nat}, (LE.le.{0} Nat instLENat b c) -> (LE.le.{0} Nat instLENat a (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) c b)) -> (LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a b) c)

-- Stub: this file represents the declaration `Nat.add_le_of_le_sub`.
-- In a full split, the body would be extracted from the environment.
