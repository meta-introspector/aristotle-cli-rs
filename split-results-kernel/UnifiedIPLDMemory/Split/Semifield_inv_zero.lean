import Split.CommSemiring_toSemiring
import Split.AddMonoid_toZero
import Split.Semifield_toInv
import Split.Semifield
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.Inv_inv
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.Semifield_toCommSemiring
import Split.OfNat_ofNat
import Split.Eq

-- Semifield.inv_zero from environment
-- theorem Semifield.inv_zero : forall {K : Type.{u_2}} [self : Semifield.{u_2} K], Eq.{succ u_2} K (Inv.inv.{u_2} K (Semifield.toInv.{u_2} K self) (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (CommSemiring.toSemiring.{u_2} K (Semifield.toCommSemiring.{u_2} K self)))))))))) (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (CommSemiring.toSemiring.{u_2} K (Semifield.toCommSemiring.{u_2} K self)))))))))

-- Stub: this file represents the declaration `Semifield.inv_zero`.
-- In a full split, the body would be extracted from the environment.
