import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_add_sub_add_right
import Split.Eq_refl
import Split.Eq
import Split.Nat_add_comm

-- Nat.add_sub_add_left from environment
-- theorem Nat.add_sub_add_left : forall (k : Nat) (n : Nat) (m : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k n) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k m)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)

-- Stub: this file represents the declaration `Nat.add_sub_add_left`.
-- In a full split, the body would be extracted from the environment.
