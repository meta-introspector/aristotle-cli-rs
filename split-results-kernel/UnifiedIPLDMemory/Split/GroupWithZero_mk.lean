import Split.Nontrivial
import Split.Semigroup_toMul
import Split.instHDiv
import Split.Inv
import Split.HMul_hMul
import Split.GroupWithZero
import Split.HDiv_hDiv
import Split.Div
import Split.Ne
import Split.Int
import Split.Nat_cast
import Split.autoParam
import Split.MonoidWithZero
import Split.Inv_inv
import Split.MonoidWithZero_toZero
import Split.instOfNat
import Split.Nat
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.Monoid_toOne
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.instHMul

-- GroupWithZero.mk from environment
-- constructor GroupWithZero.mk : forall {G₀ : Type.{u}} [toMonoidWithZero : MonoidWithZero.{u} G₀] [toInv : Inv.{u} G₀] [toDiv : Div.{u} G₀], (autoParam.{0} (forall (a : G₀) (b : G₀), Eq.{succ u} G₀ (HDiv.hDiv.{u, u, u} G₀ G₀ G₀ (instHDiv.{u} G₀ toDiv) a b) (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (Semigroup.toMul.{u} G₀ (Monoid.toSemigroup.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ toMonoidWithZero)))) a (Inv.inv.{u} G₀ toInv b))) DivInvMonoid.div_eq_mul_inv._autoParam) -> (forall (zpow : Int -> G₀ -> G₀), (autoParam.{0} (forall (a : G₀), Eq.{succ u} G₀ (zpow (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} G₀ 1 (One.toOfNat1.{u} G₀ (Monoid.toOne.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ toMonoidWithZero))))) DivInvMonoid.zpow_zero'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G₀), Eq.{succ u} G₀ (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (Semigroup.toMul.{u} G₀ (Monoid.toSemigroup.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ toMonoidWithZero)))) (zpow (Nat.cast.{0} Int instNatCastInt n) a) a)) DivInvMonoid.zpow_succ'._autoParam) -> (autoParam.{0} (forall (n : Nat) (a : G₀), Eq.{succ u} G₀ (zpow (Int.negSucc n) a) (Inv.inv.{u} G₀ toInv (zpow (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))) DivInvMonoid.zpow_neg'._autoParam) -> (forall [toNontrivial : Nontrivial.{u} G₀], (Eq.{succ u} G₀ (Inv.inv.{u} G₀ toInv (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MonoidWithZero.toZero.{u} G₀ toMonoidWithZero)))) (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MonoidWithZero.toZero.{u} G₀ toMonoidWithZero)))) -> (forall (a : G₀), (Ne.{succ u} G₀ a (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MonoidWithZero.toZero.{u} G₀ toMonoidWithZero)))) -> (Eq.{succ u} G₀ (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (Semigroup.toMul.{u} G₀ (Monoid.toSemigroup.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ toMonoidWithZero)))) a (Inv.inv.{u} G₀ toInv a)) (OfNat.ofNat.{u} G₀ 1 (One.toOfNat1.{u} G₀ (Monoid.toOne.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ toMonoidWithZero)))))) -> (GroupWithZero.{u} G₀)))

-- Stub: this file represents the declaration `GroupWithZero.mk`.
-- In a full split, the body would be extracted from the environment.
