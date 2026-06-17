import Split.HMul_hMul
import Split.CommSemiring_toSemiring
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.CommSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.Eq
import Split.instHMul

-- CommSemiring.mul_comm from environment
-- theorem CommSemiring.mul_comm : forall {R : Type.{u}} [self : CommSemiring.{u} R] (a : R) (b : R), Eq.{succ u} R (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (NonUnitalNonAssocSemiring.toMul.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R (CommSemiring.toSemiring.{u} R self))))) a b) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (NonUnitalNonAssocSemiring.toMul.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R (CommSemiring.toSemiring.{u} R self))))) b a)

-- Stub: this file represents the declaration `CommSemiring.mul_comm`.
-- In a full split, the body would be extracted from the environment.
