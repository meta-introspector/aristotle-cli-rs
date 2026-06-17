import Split.AddMonoid_toZero
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Field_toCommRing
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.Inv_inv
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.Field_toInv
import Split.CommRing_toRing
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq
import Split.Field

-- Field.inv_zero from environment
-- theorem Field.inv_zero : forall {K : Type.{u}} [self : Field.{u} K], Eq.{succ u} K (Inv.inv.{u} K (Field.toInv.{u} K self) (OfNat.ofNat.{u} K 0 (Zero.toOfNat0.{u} K (AddMonoid.toZero.{u} K (AddCommMonoid.toAddMonoid.{u} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))))))) (OfNat.ofNat.{u} K 0 (Zero.toOfNat0.{u} K (AddMonoid.toZero.{u} K (AddCommMonoid.toAddMonoid.{u} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))))))

-- Stub: this file represents the declaration `Field.inv_zero`.
-- In a full split, the body would be extracted from the environment.
