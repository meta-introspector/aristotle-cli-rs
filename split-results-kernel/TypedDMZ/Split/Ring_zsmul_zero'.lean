import Split.AddMonoid_toZero
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Int
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instOfNat
import Split.Semiring_toNonUnitalSemiring
import Split.Zero_toOfNat0
import Split.AddCommMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring_zsmul
import Split.Ring

-- Ring.zsmul_zero' from environment
-- theorem Ring.zsmul_zero' : forall {R : Type.{u}} [self : Ring.{u} R] (a : R), Eq.{succ u} R (Ring.zsmul.{u} R self (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddCommMonoid.toAddMonoid.{u} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R (Ring.toSemiring.{u} R self))))))))

-- Stub: this file represents the declaration `Ring.zsmul_zero'`.
-- In a full split, the body would be extracted from the environment.
