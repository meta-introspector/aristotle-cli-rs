import Split.instHDiv
import Split.HMul_hMul
import Split.Field_toDiv
import Split.NonUnitalNonAssocSemiring_toMul
import Split.HDiv_hDiv
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Field_toCommRing
import Split.Inv_inv
import Split.Semiring_toNonUnitalSemiring
import Split.Field_toInv
import Split.CommRing_toRing
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.instHMul

-- Field.div_eq_mul_inv from environment
-- theorem Field.div_eq_mul_inv : forall {K : Type.{u}} [self : Field.{u} K] (a : K) (b : K), Eq.{succ u} K (HDiv.hDiv.{u, u, u} K K K (instHDiv.{u} K (Field.toDiv.{u} K self)) a b) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))) a (Inv.inv.{u} K (Field.toInv.{u} K self) b))

-- Stub: this file represents the declaration `Field.div_eq_mul_inv`.
-- In a full split, the body would be extracted from the environment.
