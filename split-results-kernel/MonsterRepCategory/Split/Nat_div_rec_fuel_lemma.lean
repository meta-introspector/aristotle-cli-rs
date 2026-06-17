import Split.HSub_hSub
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.instHSub
import Split.Nat_div_rec_lemma
import Split.HAdd_hAdd
import Split.Nat_le_of_lt_succ
import Split.Nat
import Split.And_intro
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_lt_of_lt_of_le

-- Nat.div_rec_fuel_lemma from environment
-- theorem Nat.div_rec_fuel_lemma : forall {x : Nat} {y : Nat} {fuel : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) -> (LE.le.{0} Nat instLENat y x) -> (LT.lt.{0} Nat instLTNat x (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) fuel (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> (LT.lt.{0} Nat instLTNat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x y) fuel)

-- Stub: this file represents the declaration `Nat.div_rec_fuel_lemma`.
-- In a full split, the body would be extracted from the environment.
