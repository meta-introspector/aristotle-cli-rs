import Split.Field_toRatCast
import Split.HMul_hMul
import Split.Rat
import Split.NonUnitalNonAssocSemiring_toMul
import Split.Rat_cast
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Field_qsmul
import Split.Field_toCommRing
import Split.Semiring_toNonUnitalSemiring
import Split.CommRing_toRing
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.instHMul

-- Field.qsmul_def from environment
-- theorem Field.qsmul_def : forall {K : Type.{u}} [self : Field.{u} K] (a : Rat) (x : K), Eq.{succ u} K (Field.qsmul.{u} K self a x) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))) (Rat.cast.{u} K (Field.toRatCast.{u} K self) a) x)

-- Stub: this file represents the declaration `Field.qsmul_def`.
-- In a full split, the body would be extracted from the environment.
