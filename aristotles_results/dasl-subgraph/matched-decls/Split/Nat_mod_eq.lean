import Split.Eq_mpr
import Split.Nat_modCore_eq_mod
import Split.congrArg
import Split.Nat_modCore_eq
import Split.HSub_hSub
import Split.id
import Split.Nat_instMod
import Split.instHMod
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.HMod_hMod
import Split.And
import Split.instHSub
import Split.Nat
import Split.LT_lt
import Split.Nat_modCore
import Split.Nat_decLt
import Split.Eq_refl
import Split.instLTNat
import Split.instDecidableAnd
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Nat_decLe
import Split.ite

-- Nat.mod_eq from environment
-- theorem Nat.mod_eq : forall (x : Nat) (y : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) x y) (ite.{1} Nat (And (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (LE.le.{0} Nat instLENat y x)) (instDecidableAnd (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (LE.le.{0} Nat instLENat y x) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) (Nat.decLe y x)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x y) y) x)

-- Stub: this file represents the declaration `Nat.mod_eq`.
-- In a full split, the body would be extracted from the environment.
