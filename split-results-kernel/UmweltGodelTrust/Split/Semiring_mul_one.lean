import Split.Semiring_toOne
import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring
import Split.One_toOfNat1
import Split.Semiring_toNonUnitalSemiring
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Semiring.mul_one from environment
-- theorem Semiring.mul_one : forall {α : Type.{u}} [self : Semiring.{u} α] (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} α (Semiring.toNonUnitalSemiring.{u} α self)))) a (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α (Semiring.toOne.{u} α self)))) a

-- Stub: this file represents the declaration `Semiring.mul_one`.
-- In a full split, the body would be extracted from the environment.
