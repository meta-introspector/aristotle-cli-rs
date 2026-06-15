import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.instHSub
import Split.Nat_sub_add_cancel
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.Eq
import Split.Nat_add_comm

-- Nat.add_sub_cancel' from environment
-- theorem Nat.add_sub_cancel' : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat m n) -> (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)) n)

-- Stub: this file represents the declaration `Nat.add_sub_cancel'`.
-- In a full split, the body would be extracted from the environment.
