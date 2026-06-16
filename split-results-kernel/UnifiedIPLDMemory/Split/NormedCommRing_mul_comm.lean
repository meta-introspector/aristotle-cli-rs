import Split.NormedCommRing_toNormedRing
import Split.NormedRing_toRing
import Split.HMul_hMul
import Split.NormedCommRing
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.instHMul

-- NormedCommRing.mul_comm from environment
-- theorem NormedCommRing.mul_comm : forall {α : Type.{u_5}} [self : NormedCommRing.{u_5} α] (a : α) (b : α), Eq.{succ u_5} α (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocSemiring.toMul.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α (NormedRing.toRing.{u_5} α (NormedCommRing.toNormedRing.{u_5} α self))))))) a b) (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocSemiring.toMul.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α (NormedRing.toRing.{u_5} α (NormedCommRing.toNormedRing.{u_5} α self))))))) b a)

-- Stub: this file represents the declaration `NormedCommRing.mul_comm`.
-- In a full split, the body would be extracted from the environment.
