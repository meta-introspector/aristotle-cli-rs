import Split.GroupWithZero_toMonoidWithZero
import Split.GroupWithZero_toInv
import Split.GroupWithZero
import Split.Inv_inv
import Split.MonoidWithZero_toZero
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq

-- GroupWithZero.inv_zero from environment
-- theorem GroupWithZero.inv_zero : forall {G₀ : Type.{u}} [self : GroupWithZero.{u} G₀], Eq.{succ u} G₀ (Inv.inv.{u} G₀ (GroupWithZero.toInv.{u} G₀ self) (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MonoidWithZero.toZero.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self))))) (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MonoidWithZero.toZero.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self))))

-- Stub: this file represents the declaration `GroupWithZero.inv_zero`.
-- In a full split, the body would be extracted from the environment.
