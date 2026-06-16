import Split.CommRing
import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.CommRing_toRing
import Split.Ring_toSemiring
import Split.Eq
import Split.instHMul

-- CommRing.mul_comm from environment
-- theorem CommRing.mul_comm : forall {α : Type.{u}} [self : CommRing.{u} α] (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α (Ring.toSemiring.{u} α (CommRing.toRing.{u} α self)))))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α (Ring.toSemiring.{u} α (CommRing.toRing.{u} α self)))))) b a)

-- Stub: this file represents the declaration `CommRing.mul_comm`.
-- In a full split, the body would be extracted from the environment.
