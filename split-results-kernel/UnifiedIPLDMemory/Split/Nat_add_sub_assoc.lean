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
import Split.Exists_casesOn
import Split.HAdd_hAdd
import Split.Nat
import Split.Exists_intro
import Split.Nat_add_assoc
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_add_sub_cancel
import Split.Nat_le_dest
import Split.Eq_symm
import Split.Eq
import Split.Nat_add_comm

-- Nat.add_sub_assoc from environment
-- theorem Nat.add_sub_assoc : forall {m : Nat} {k : Nat}, (LE.le.{0} Nat instLENat k m) -> (forall (n : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m k)))

-- Stub: this file represents the declaration `Nat.add_sub_assoc`.
-- In a full split, the body would be extracted from the environment.
