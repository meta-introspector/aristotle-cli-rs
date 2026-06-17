import Split.Semiring_toNatCast
import Split.instHDiv
import Split.Field_toNNRatCast
import Split.Field_toDiv
import Split.HDiv_hDiv
import Split.NNRat
import Split.NNRat_num
import Split.Nat_cast
import Split.Field_toCommRing
import Split.NNRat_den
import Split.CommRing_toRing
import Split.NNRat_cast
import Split.Ring_toSemiring
import Split.Eq
import Split.Field

-- Field.nnratCast_def from environment
-- theorem Field.nnratCast_def : forall {K : Type.{u}} [self : Field.{u} K] (q : NNRat), Eq.{succ u} K (NNRat.cast.{u} K (Field.toNNRatCast.{u} K self) q) (HDiv.hDiv.{u, u, u} K K K (instHDiv.{u} K (Field.toDiv.{u} K self)) (Nat.cast.{u} K (Semiring.toNatCast.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self)))) (NNRat.num q)) (Nat.cast.{u} K (Semiring.toNatCast.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self)))) (NNRat.den q)))

-- Stub: this file represents the declaration `Field.nnratCast_def`.
-- In a full split, the body would be extracted from the environment.
