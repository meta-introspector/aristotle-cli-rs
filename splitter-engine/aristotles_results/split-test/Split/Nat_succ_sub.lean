import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.Exists
import Split.Nat_add_sub_cancel_left
import Split.id
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat_add_succ
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_le_dest
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq

-- Nat.succ_sub from environment
-- theorem Nat.succ_sub : forall {m : Nat} {n : Nat}, (LE.le.{0} Nat instLENat n m) -> (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Nat.succ m) n) (Nat.succ (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m n)))

-- Stub: this file represents the declaration `Nat.succ_sub`.
-- In a full split, the body would be extracted from the environment.
