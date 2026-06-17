import Split.NormedRing_toRing
import Split.HMul_hMul
import Split.NormedCommRing
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.NormedRing
import Split.instHMul

-- NormedCommRing.mk from environment
-- constructor NormedCommRing.mk : forall {α : Type.{u_5}} [toNormedRing : NormedRing.{u_5} α], (forall (a : α) (b : α), Eq.{succ u_5} α (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocSemiring.toMul.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α (NormedRing.toRing.{u_5} α toNormedRing)))))) a b) (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α (NonUnitalNonAssocSemiring.toMul.{u_5} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_5} α (Semiring.toNonUnitalSemiring.{u_5} α (Ring.toSemiring.{u_5} α (NormedRing.toRing.{u_5} α toNormedRing)))))) b a)) -> (NormedCommRing.{u_5} α)

-- Stub: this file represents the declaration `NormedCommRing.mk`.
-- In a full split, the body would be extracted from the environment.
