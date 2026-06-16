import Split.NonUnitalNonAssocRing
import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toMul
import Split.AddMonoid_toZero
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.AddCommGroup_toAddGroup
import Split.AddGroup_toSubNegMonoid
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocRing.zero_mul from environment
-- theorem NonUnitalNonAssocRing.zero_mul : forall {α : Type.{u}} [self : NonUnitalNonAssocRing.{u} α] (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α self)) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α self))))))) a) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (AddMonoid.toZero.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α self)))))))

-- Stub: this file represents the declaration `NonUnitalNonAssocRing.zero_mul`.
-- In a full split, the body would be extracted from the environment.
