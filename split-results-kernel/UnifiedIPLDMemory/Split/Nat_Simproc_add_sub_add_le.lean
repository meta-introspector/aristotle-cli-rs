import Split.Eq_mpr
import Split.False
import Split.Nat_recAux
import Split.congrArg
import Split.HEq_refl
import Split.False_elim
import Split.HSub_hSub
import Split.noConfusion_of_Nat
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Nat_le_step
import Split.instHAdd
import Split.instHSub
import Split.Nat_le_of_succ_le_succ
import Split.HAdd_hAdd
import Split.Nat_le
import Split.Nat_add_succ
import Split.Nat
import Split.eq_self
import Split.of_eq_true
import Split.Nat_ctorIdx
import Split.instAddNat
import Split.Eq_refl
import Split.HEq
import Split.Nat_le_refl
import Split.Nat_succ_sub_succ
import Split.Nat_le_casesOn
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_add

-- Nat.Simproc.add_sub_add_le from environment
-- theorem Nat.Simproc.add_sub_add_le : forall (a : Nat) (c : Nat) {b : Nat} {d : Nat}, (LE.le.{0} Nat instLENat b d) -> (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a b) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) c d)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) c (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) d b))))

-- Stub: this file represents the declaration `Nat.Simproc.add_sub_add_le`.
-- In a full split, the body would be extracted from the environment.
