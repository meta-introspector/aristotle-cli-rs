import Split.Semifield_nnqsmul
import Split.HMul_hMul
import Split.CommSemiring_toSemiring
import Split.NonUnitalNonAssocSemiring_toMul
import Split.Semifield
import Split.NNRat
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.Semifield_toCommSemiring
import Split.NNRat_cast
import Split.Eq
import Split.instHMul
import Split.Semifield_toNNRatCast

-- Semifield.nnqsmul_def from environment
-- theorem Semifield.nnqsmul_def : forall {K : Type.{u_2}} [self : Semifield.{u_2} K] (q : NNRat) (a : K), Eq.{succ u_2} K (Semifield.nnqsmul.{u_2} K self q a) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (CommSemiring.toSemiring.{u_2} K (Semifield.toCommSemiring.{u_2} K self)))))) (NNRat.cast.{u_2} K (Semifield.toNNRatCast.{u_2} K self) q) a)

-- Stub: this file represents the declaration `Semifield.nnqsmul_def`.
-- In a full split, the body would be extracted from the environment.
