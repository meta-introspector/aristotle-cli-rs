import Split.GroupWithZero_toMonoidWithZero
import Split.Semigroup_toMul
import Split.GroupWithZero_toInv
import Split.HMul_hMul
import Split.GroupWithZero
import Split.Ne
import Split.Inv_inv
import Split.MonoidWithZero_toZero
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.Monoid_toOne
import Split.OfNat_ofNat
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.instHMul

-- GroupWithZero.mul_inv_cancel from environment
-- theorem GroupWithZero.mul_inv_cancel : forall {G₀ : Type.{u}} [self : GroupWithZero.{u} G₀] (a : G₀), (Ne.{succ u} G₀ a (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MonoidWithZero.toZero.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self))))) -> (Eq.{succ u} G₀ (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (Semigroup.toMul.{u} G₀ (Monoid.toSemigroup.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self))))) a (Inv.inv.{u} G₀ (GroupWithZero.toInv.{u} G₀ self) a)) (OfNat.ofNat.{u} G₀ 1 (One.toOfNat1.{u} G₀ (Monoid.toOne.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self))))))

-- Stub: this file represents the declaration `GroupWithZero.mul_inv_cancel`.
-- In a full split, the body would be extracted from the environment.
