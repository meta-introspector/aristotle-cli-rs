import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.CommSemiring
import Split.Semiring
import Split.Semiring_toNonUnitalSemiring
import Split.Eq
import Split.instHMul

-- CommSemiring.mk from environment
-- constructor CommSemiring.mk : forall {R : Type.{u}} [toSemiring : Semiring.{u} R], (forall (a : R) (b : R), Eq.{succ u} R (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (NonUnitalNonAssocSemiring.toMul.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R toSemiring)))) a b) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (NonUnitalNonAssocSemiring.toMul.{u} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonUnitalSemiring.{u} R toSemiring)))) b a)) -> (CommSemiring.{u} R)

-- Stub: this file represents the declaration `CommSemiring.mk`.
-- In a full split, the body would be extracted from the environment.
