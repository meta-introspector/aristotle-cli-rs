import Split.Nontrivial
import Split.CommMonoidWithZero_toCommMonoid
import Split.Semigroup_toMul
import Split.instHDiv
import Split.Inv
import Split.HMul_hMul
import Split.HDiv_hDiv
import Split.Div
import Split.Ne
import Split.Int
import Split.Nat_cast
import Split.autoParam
import Split.Inv_inv
import Split.instOfNat
import Split.CommMonoid_toMonoid
import Split.CommMonoidWithZero_toZero
import Split.CommMonoidWithZero
import Split.Nat
import Split.CommGroupWithZero
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.Monoid_toOne
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- CommGroupWithZero.mk from environment
-- constructor CommGroupWithZero.mk : forall {G₀ : Type.{u_2}} [toCommMonoidWithZero : CommMonoidWithZero.{u_2} G₀] [toInv : Inv.{u_2} G₀] [toDiv : Div.{u_2} G₀], (autoParam.{0} (forall (a : G₀) (b : G₀), Eq.{succ u_2} G₀ (HDiv.hDiv.{u_2, u_2, u_2} G₀ G₀ G₀ (instHDiv.{u_2} G₀ toDiv) a b) (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (Semigroup.toMul.{u_2} G₀ (Monoid.toSemigroup.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ toCommMonoidWithZero))))) a (Inv.inv.{u_2} G₀ toInv b))) DivInvMonoid.div_eq_mul_inv._autoParam) -> (forall (zpow : Int -> G₀ -> G₀), (autoParam.{0} (forall (a : G₀), Eq.{succ u_2} G₀ (zpow (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u_2} G₀ 1 (One.toOfNat1.{u_2} G₀ (Monoid.toOne.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ toCommMonoidWithZero)))))) DivInvMonoid.zpow_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G₀), Eq.{succ u_2} G₀ (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (Semigroup.toMul.{u_2} G₀ (Monoid.toSemigroup.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ toCommMonoidWithZero))))) (zpow (Nat.cast.{0} Int instNatCastInt n) a) a)) DivInvMonoid.zpow_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G₀), Eq.{succ u_2} G₀ (zpow (Int.negSucc n) a) (Inv.inv.{u_2} G₀ toInv (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) DivInvMonoid.zpow_neg'._autoParam) -> (forall [toNontrivial : Nontrivial.{u_2} G₀], (Eq.{succ u_2} G₀ (Inv.inv.{u_2} G₀ toInv (OfNat.ofNat.{u_2} G₀ 0 (Zero.toOfNat0.{u_2} G₀ (CommMonoidWithZero.toZero.{u_2} G₀ toCommMonoidWithZero)))) (OfNat.ofNat.{u_2} G₀ 0 (Zero.toOfNat0.{u_2} G₀ (CommMonoidWithZero.toZero.{u_2} G₀ toCommMonoidWithZero)))) -> (forall (a : G₀), (Ne.{succ u_2} G₀ a (OfNat.ofNat.{u_2} G₀ 0 (Zero.toOfNat0.{u_2} G₀ (CommMonoidWithZero.toZero.{u_2} G₀ toCommMonoidWithZero)))) -> (Eq.{succ u_2} G₀ (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (Semigroup.toMul.{u_2} G₀ (Monoid.toSemigroup.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ toCommMonoidWithZero))))) a (Inv.inv.{u_2} G₀ toInv a)) (OfNat.ofNat.{u_2} G₀ 1 (One.toOfNat1.{u_2} G₀ (Monoid.toOne.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ toCommMonoidWithZero))))))) -> (CommGroupWithZero.{u_2} G₀)))

-- Stub: this file represents the declaration `CommGroupWithZero.mk`.
-- In a full split, the body would be extracted from the environment.
