import Split.Semiring_toOne
import Split.HMul_hMul
import Split.AddMonoid_toZero
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Ne
import Split.Field_toCommRing
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.Inv_inv
import Split.One_toOfNat1
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.Field_toInv
import Split.CommRing_toRing
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.instHMul

-- Field.mul_inv_cancel from environment
-- theorem Field.mul_inv_cancel : forall {K : Type.{u}} [self : Field.{u} K] (a : K), (Ne.{succ u} K a (OfNat.ofNat.{u} K 0 (Zero.toOfNat0.{u} K (AddMonoid.toZero.{u} K (AddCommMonoid.toAddMonoid.{u} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))))))) -> (Eq.{succ u} K (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))) a (Inv.inv.{u} K (Field.toInv.{u} K self) a)) (OfNat.ofNat.{u} K 1 (One.toOfNat1.{u} K (Semiring.toOne.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self)))))))

-- Stub: this file represents the declaration `Field.mul_inv_cancel`.
-- In a full split, the body would be extracted from the environment.
