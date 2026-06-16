import Split.Monoid
import Split.Semigroup_toMul
import Split.instHDiv
import Split.Inv
import Split.HMul_hMul
import Split.HDiv_hDiv
import Split.Div
import Split.Int
import Split.Nat_cast
import Split.autoParam
import Split.DivInvMonoid
import Split.Inv_inv
import Split.instOfNat
import Split.Nat
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Monoid_toOne
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- DivInvMonoid.mk from environment
-- constructor DivInvMonoid.mk : forall {G : Type.{u}} [toMonoid : Monoid.{u} G] [toInv : Inv.{u} G] [toDiv : Div.{u} G], (autoParam.{0} (forall (a : G) (b : G), Eq.{succ u} G (HDiv.hDiv.{u, u, u} G G G (instHDiv.{u} G toDiv) a b) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G toMonoid))) a (Inv.inv.{u} G toInv b))) DivInvMonoid.div_eq_mul_inv._autoParam) -> (forall (zpow : Int -> G -> G), (autoParam.{0} (forall (a : G), Eq.{succ u} G (zpow (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} G 1 (One.toOfNat1.{u} G (Monoid.toOne.{u} G toMonoid)))) DivInvMonoid.zpow_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G), Eq.{succ u} G (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G toMonoid))) (zpow (Nat.cast.{0} Int instNatCastInt n) a) a)) DivInvMonoid.zpow_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G), Eq.{succ u} G (zpow (Int.negSucc n) a) (Inv.inv.{u} G toInv (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) DivInvMonoid.zpow_neg'._autoParam) -> (DivInvMonoid.{u} G))

-- Stub: this file represents the declaration `DivInvMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
