import Split.Eq_mpr
import Split.congrArg
import Split.Nat_le_add_right
import Split.HSub_hSub
import Split.id
import Split.Nat_sub_eq_iff_eq_add
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.instHSub
import Split.Nat_sub_add_cancel
import Split.HAdd_hAdd
import Split.Nat_le_trans
import Split.Nat
import Split.propext
import Split.instAddNat
import Split.Eq_refl
import Split.Eq
import Split.Nat_add_right_comm

-- Nat.sub_add_comm from environment
-- theorem Nat.sub_add_comm : forall {n : Nat} {m : Nat} {k : Nat}, (LE.le.{0} Nat instLENat k n) -> (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n k) m))

-- Stub: this file represents the declaration `Nat.sub_add_comm`.
-- In a full split, the body would be extracted from the environment.
