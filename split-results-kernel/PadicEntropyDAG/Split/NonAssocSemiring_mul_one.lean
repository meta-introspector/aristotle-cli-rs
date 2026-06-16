import Split.HMul_hMul
import Split.NonAssocSemiring_toOne
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonAssocSemiring
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.One_toOfNat1
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- NonAssocSemiring.mul_one from environment
-- theorem NonAssocSemiring.mul_one : forall {α : Type.{u}} [self : NonAssocSemiring.{u} α] (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} α self))) a (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α (NonAssocSemiring.toOne.{u} α self)))) a

-- Stub: this file represents the declaration `NonAssocSemiring.mul_one`.
-- In a full split, the body would be extracted from the environment.
