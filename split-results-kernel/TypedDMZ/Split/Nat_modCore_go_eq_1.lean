import Split.HSub_hSub
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.dite
import Split.instHSub
import Split.Nat
import Split.LT_lt
import Split.Nat_div_rec_fuel_lemma
import Split.Eq_refl
import Split.Nat_modCore_go
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Not
import Split.Nat_decLe

-- Nat.modCore.go.eq_1 from environment
-- theorem Nat.modCore.go.eq_1 : forall (y : Nat) (hy : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (x : Nat) (fuel_2 : Nat) (hfuel_2 : LT.lt.{0} Nat instLTNat x (Nat.succ fuel_2)), Eq.{1} Nat (Nat.modCore.go y hy (Nat.succ fuel_2) x hfuel_2) (dite.{1} Nat (LE.le.{0} Nat instLENat y x) (Nat.decLe y x) (fun (h : LE.le.{0} Nat instLENat y x) => Nat.modCore.go y hy fuel_2 (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x y) (Nat.div_rec_fuel_lemma x y fuel_2 hy h hfuel_2)) (fun (x._@.Init.Prelude.4249794159._hygCtx._hyg.63 : Not (LE.le.{0} Nat instLENat y x)) => x))

-- Stub: this file represents the declaration `Nat.modCore.go.eq_1`.
-- In a full split, the body would be extracted from the environment.
