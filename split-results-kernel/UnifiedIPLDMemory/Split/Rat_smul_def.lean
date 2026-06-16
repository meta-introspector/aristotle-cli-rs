import Split.instHSMul
import Split.HMul_hMul
import Split.DivisionRing_toRatCast
import Split.Ring_toNonAssocRing
import Split.Rat_smulDivisionRing
import Split.Rat
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.Rat_cast
import Split.DivisionRing_toRing
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.Distrib_toMul
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.HSMul_hSMul
import Split.DivisionRing
import Split.DivisionRing_qsmul_def
import Split.Eq
import Split.instHMul

-- Rat.smul_def from environment
-- theorem Rat.smul_def : forall {K : Type.{u_1}} [inst._@.Mathlib.Algebra.Field.Defs.1925582910._hygCtx._hyg.3 : DivisionRing.{u_1} K] (a : Rat) (x : K), Eq.{succ u_1} K (HSMul.hSMul.{0, u_1, u_1} Rat K K (instHSMul.{0, u_1} Rat K (Rat.smulDivisionRing.{u_1} K inst._@.Mathlib.Algebra.Field.Defs.1925582910._hygCtx._hyg.3)) a x) (HMul.hMul.{u_1, u_1, u_1} K K K (instHMul.{u_1} K (Distrib.toMul.{u_1} K (NonUnitalNonAssocSemiring.toDistrib.{u_1} K (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} K (NonAssocRing.toNonUnitalNonAssocRing.{u_1} K (Ring.toNonAssocRing.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Defs.1925582910._hygCtx._hyg.3))))))) (Rat.cast.{u_1} K (DivisionRing.toRatCast.{u_1} K inst._@.Mathlib.Algebra.Field.Defs.1925582910._hygCtx._hyg.3) a) x)

-- Stub: this file represents the declaration `Rat.smul_def`.
-- In a full split, the body would be extracted from the environment.
