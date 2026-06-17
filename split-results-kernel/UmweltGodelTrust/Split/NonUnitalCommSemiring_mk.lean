import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.NonUnitalSemiring
import Split.NonUnitalCommSemiring
import Split.Eq
import Split.instHMul

-- NonUnitalCommSemiring.mk from environment
-- constructor NonUnitalCommSemiring.mk : forall {α : Type.{u}} [toNonUnitalSemiring : NonUnitalSemiring.{u} α], (forall (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α toNonUnitalSemiring))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α toNonUnitalSemiring))) b a)) -> (NonUnitalCommSemiring.{u} α)

-- Stub: this file represents the declaration `NonUnitalCommSemiring.mk`.
-- In a full split, the body would be extracted from the environment.
