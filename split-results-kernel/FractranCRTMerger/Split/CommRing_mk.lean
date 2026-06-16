import Split.CommRing
import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.instHMul

-- CommRing.mk from environment
-- constructor CommRing.mk : forall {α : Type.{u}} [toRing : Ring.{u} α], (forall (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α (Ring.toSemiring.{u} α toRing))))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α (Ring.toSemiring.{u} α toRing))))) b a)) -> (CommRing.{u} α)

-- Stub: this file represents the declaration `CommRing.mk`.
-- In a full split, the body would be extracted from the environment.
