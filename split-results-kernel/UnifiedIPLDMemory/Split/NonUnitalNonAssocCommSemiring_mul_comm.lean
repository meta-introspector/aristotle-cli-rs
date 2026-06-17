import Split.HMul_hMul
import Split.NonUnitalNonAssocCommSemiring
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalNonAssocCommSemiring_toNonUnitalNonAssocSemiring
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocCommSemiring.mul_comm from environment
-- theorem NonUnitalNonAssocCommSemiring.mul_comm : forall {α : Type.{u}} [self : NonUnitalNonAssocCommSemiring.{u} α] (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalNonAssocCommSemiring.toNonUnitalNonAssocSemiring.{u} α self))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalNonAssocCommSemiring.toNonUnitalNonAssocSemiring.{u} α self))) b a)

-- Stub: this file represents the declaration `NonUnitalNonAssocCommSemiring.mul_comm`.
-- In a full split, the body would be extracted from the environment.
