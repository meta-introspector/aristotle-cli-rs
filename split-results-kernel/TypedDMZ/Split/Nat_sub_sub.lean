import Split.Eq_mpr
import Split.Nat_recAux
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.instHAdd
import Split.instHSub
import Split.Nat_sub_succ
import Split.HAdd_hAdd
import Split.Nat_add_succ
import Split.Nat
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_pred

-- Nat.sub_sub from environment
-- theorem Nat.sub_sub : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m k))

-- Stub: this file represents the declaration `Nat.sub_sub`.
-- In a full split, the body would be extracted from the environment.
