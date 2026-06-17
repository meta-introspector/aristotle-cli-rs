import Split.HMul_hMul
import Split.DivisionRing_toRatCast
import Split.Rat
import Split.DivisionRing_qsmul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.Rat_cast
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.DivisionRing_toRing
import Split.Semiring_toNonUnitalSemiring
import Split.DivisionRing
import Split.Ring_toSemiring
import Split.Eq
import Split.instHMul

-- DivisionRing.qsmul_def from environment
-- theorem DivisionRing.qsmul_def : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (a : Rat) (x : K), Eq.{succ u_2} K (DivisionRing.qsmul.{u_2} K self a x) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self)))))) (Rat.cast.{u_2} K (DivisionRing.toRatCast.{u_2} K self) a) x)

-- Stub: this file represents the declaration `DivisionRing.qsmul_def`.
-- In a full split, the body would be extracted from the environment.
