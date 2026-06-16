import Split.HMul_hMul
import Split.NonUnitalNonAssocCommSemiring
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalNonAssocSemiring
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocCommSemiring.mk from environment
-- constructor NonUnitalNonAssocCommSemiring.mk : forall {α : Type.{u}} [toNonUnitalNonAssocSemiring : NonUnitalNonAssocSemiring.{u} α], (forall (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) b a)) -> (NonUnitalNonAssocCommSemiring.{u} α)

-- Stub: this file represents the declaration `NonUnitalNonAssocCommSemiring.mk`.
-- In a full split, the body would be extracted from the environment.
