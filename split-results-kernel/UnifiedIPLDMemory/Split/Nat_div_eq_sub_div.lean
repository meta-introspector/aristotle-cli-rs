import Split.Eq_mpr
import Split.instHDiv
import Split.Nat_div_eq
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.HDiv_hDiv
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.if_pos
import Split.instHAdd
import Split.And
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.And_intro
import Split.LT_lt
import Split.Nat_instDiv
import Split.Nat_decLt
import Split.instAddNat
import Split.Eq_refl
import Split.instLTNat
import Split.instDecidableAnd
import Split.OfNat_ofNat
import Split.Eq
import Split.Nat_decLe
import Split.ite

-- Nat.div_eq_sub_div from environment
-- theorem Nat.div_eq_sub_div : forall {b : Nat} {a : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) b) -> (LE.le.{0} Nat instLENat b a) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) a b) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) a b) b) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Nat.div_eq_sub_div`.
-- In a full split, the body would be extracted from the environment.
