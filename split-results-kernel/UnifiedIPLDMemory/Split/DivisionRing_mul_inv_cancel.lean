import Split.Semiring_toOne
import Split.HMul_hMul
import Split.AddMonoid_toZero
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Ne
import Split.DivisionRing_toRing
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.Inv_inv
import Split.One_toOfNat1
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.DivisionRing
import Split.AddCommMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.DivisionRing_toInv
import Split.Ring_toSemiring
import Split.Eq
import Split.instHMul

-- DivisionRing.mul_inv_cancel from environment
-- theorem DivisionRing.mul_inv_cancel : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (a : K), (Ne.{succ u_2} K a (OfNat.ofNat.{u_2} K 0 (Zero.toOfNat0.{u_2} K (AddMonoid.toZero.{u_2} K (AddCommMonoid.toAddMonoid.{u_2} K (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self)))))))))) -> (Eq.{succ u_2} K (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self)))))) a (Inv.inv.{u_2} K (DivisionRing.toInv.{u_2} K self) a)) (OfNat.ofNat.{u_2} K 1 (One.toOfNat1.{u_2} K (Semiring.toOne.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self))))))

-- Stub: this file represents the declaration `DivisionRing.mul_inv_cancel`.
-- In a full split, the body would be extracted from the environment.
