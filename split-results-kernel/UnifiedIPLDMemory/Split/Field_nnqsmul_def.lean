import Split.Field_nnqsmul
import Split.HMul_hMul
import Split.Field_toNNRatCast
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NNRat
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Field_toCommRing
import Split.Semiring_toNonUnitalSemiring
import Split.CommRing_toRing
import Split.NNRat_cast
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.instHMul

-- Field.nnqsmul_def from environment
-- theorem Field.nnqsmul_def : forall {K : Type.{u}} [self : Field.{u} K] (q : NNRat) (a : K), Eq.{succ u} K (Field.nnqsmul.{u} K self q a) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))) (NNRat.cast.{u} K (Field.toNNRatCast.{u} K self) q) a)

-- Stub: this file represents the declaration `Field.nnqsmul_def`.
-- In a full split, the body would be extracted from the environment.
