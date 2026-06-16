import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring
import Split.NonUnitalNonAssocSemiring
import Split.Eq
import Split.instHMul

-- NonUnitalSemiring.mk from environment
-- constructor NonUnitalSemiring.mk : forall {α : Type.{u}} [toNonUnitalNonAssocSemiring : NonUnitalNonAssocSemiring.{u} α], (forall (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) a b) c) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) a (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α toNonUnitalNonAssocSemiring)) b c))) -> (NonUnitalSemiring.{u} α)

-- Stub: this file represents the declaration `NonUnitalSemiring.mk`.
-- In a full split, the body would be extracted from the environment.
