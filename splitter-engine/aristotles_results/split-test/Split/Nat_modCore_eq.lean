import Split.Eq_mpr
import Split.False
import Split.Decidable_casesOn
import Split.eq_false
import Split.congrArg
import Split.and_self
import Split.HSub_hSub
import Split.Decidable
import Split.false_and
import Split.Nat_modCore_go_eq_1
import Split.dif_pos
import Split.Nat_lt_succ_self
import Split.id
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.ite_cond_eq_true
import Split.instLENat
import Split.dif_neg
import Split.dite
import Split.And
import Split.instHSub
import Split.Nat
import Split.congr
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.Nat_modCore
import Split.eq_true
import Split.Nat_div_rec_fuel_lemma
import Split.of_eq_true
import Split.Nat_decLt
import Split.Eq_refl
import Split.Nat_modCore_go
import Split.congrFun'
import Split.and_false
import Split.instLTNat
import Split.instDecidableAnd
import Split.ite_congr
import Split.OfNat_ofNat
import Split.ite_cond_eq_false
import Split.Nat_succ
import Split.Eq
import Split.Not
import Split.Nat_decLe
import Split.Eq_trans
import Split.ite

-- Nat.modCore_eq from environment
-- theorem Nat.modCore_eq : forall (x : Nat) (y : Nat), Eq.{1} Nat (Nat.modCore x y) (ite.{1} Nat (And (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (LE.le.{0} Nat instLENat y x)) (instDecidableAnd (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (LE.le.{0} Nat instLENat y x) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (Nat.decLe y x)) (Nat.modCore (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x y) y) x)

-- Stub: this file represents the declaration `Nat.modCore_eq`.
-- In a full split, the body would be extracted from the environment.
