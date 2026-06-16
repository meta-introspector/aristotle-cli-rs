import Split.DivisionSemiring_toInv
import Split.AddMonoid_toZero
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.DivisionSemiring
import Split.Inv_inv
import Split.DivisionSemiring_toSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq

-- DivisionSemiring.inv_zero from environment
-- theorem DivisionSemiring.inv_zero : forall {K : Type.{u_2}} [self : DivisionSemiring.{u_2} K], Eq.{succ u_2} K (Inv.inv.{u_2} K (DivisionSemiring.toInv.{u_2} K self) (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (DivisionSemiring.toSemiring.{u_2} K self))))))))) (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (DivisionSemiring.toSemiring.{u_2} K self))))))))

-- Stub: this file represents the declaration `DivisionSemiring.inv_zero`.
-- In a full split, the body would be extracted from the environment.
