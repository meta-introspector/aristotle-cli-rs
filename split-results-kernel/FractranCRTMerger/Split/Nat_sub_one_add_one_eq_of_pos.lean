import Split.HSub_hSub
import Split.instSubNat
import Split.instOfNatNat
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl

-- Nat.sub_one_add_one_eq_of_pos from environment
-- theorem Nat.sub_one_add_one_eq_of_pos : forall {n : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) -> (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) n)

-- Stub: this file represents the declaration `Nat.sub_one_add_one_eq_of_pos`.
-- In a full split, the body would be extracted from the environment.
