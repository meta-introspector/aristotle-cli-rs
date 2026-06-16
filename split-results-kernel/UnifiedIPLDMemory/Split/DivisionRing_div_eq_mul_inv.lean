import Split.instHDiv
import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.HDiv_hDiv
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.DivisionRing_toRing
import Split.DivisionRing_toDiv
import Split.Inv_inv
import Split.Semiring_toNonUnitalSemiring
import Split.DivisionRing
import Split.DivisionRing_toInv
import Split.Ring_toSemiring
import Split.Eq
import Split.instHMul

-- DivisionRing.div_eq_mul_inv from environment
-- theorem DivisionRing.div_eq_mul_inv : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (a : K) (b : K), Eq.{succ u_2} K (HDiv.hDiv.{u_2, u_2, u_2} K K K (instHDiv.{u_2} K (DivisionRing.toDiv.{u_2} K self)) a b) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self)))))) a (Inv.inv.{u_2} K (DivisionRing.toInv.{u_2} K self) b))

-- Stub: this file represents the declaration `DivisionRing.div_eq_mul_inv`.
-- In a full split, the body would be extracted from the environment.
