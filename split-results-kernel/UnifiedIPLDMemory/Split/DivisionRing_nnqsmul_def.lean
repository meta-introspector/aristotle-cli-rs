import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NNRat
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.DivisionRing_toRing
import Split.DivisionRing_nnqsmul
import Split.Semiring_toNonUnitalSemiring
import Split.DivisionRing
import Split.NNRat_cast
import Split.Ring_toSemiring
import Split.Eq
import Split.DivisionRing_toNNRatCast
import Split.instHMul

-- DivisionRing.nnqsmul_def from environment
-- theorem DivisionRing.nnqsmul_def : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (q : NNRat) (a : K), Eq.{succ u_2} K (DivisionRing.nnqsmul.{u_2} K self q a) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self)))))) (NNRat.cast.{u_2} K (DivisionRing.toNNRatCast.{u_2} K self) q) a)

-- Stub: this file represents the declaration `DivisionRing.nnqsmul_def`.
-- In a full split, the body would be extracted from the environment.
