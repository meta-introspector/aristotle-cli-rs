import Split.Eq_mpr
import Split.instHDiv
import Split.congrArg
import Split.HSub_hSub
import Split.Nat_le_add_left
import Split.id
import Split.HDiv_hDiv
import Split.instSubNat
import Split.instOfNatNat
import Split.Nat_div_eq_sub_div
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_add_sub_cancel
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq

-- Nat.add_div_right from environment
-- theorem Nat.add_div_right : forall (x : Nat) {z : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) z) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) x z) z) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x z) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Nat.add_div_right`.
-- In a full split, the body would be extracted from the environment.
