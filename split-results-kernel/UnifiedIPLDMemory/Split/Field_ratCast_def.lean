import Split.Semiring_toNatCast
import Split.Int_cast
import Split.Rat_num
import Split.instHDiv
import Split.Field_toRatCast
import Split.Field_toDiv
import Split.Rat
import Split.Rat_den
import Split.HDiv_hDiv
import Split.Rat_cast
import Split.Nat_cast
import Split.Field_toCommRing
import Split.CommRing_toRing
import Split.Ring_toIntCast
import Split.Ring_toSemiring
import Split.Eq
import Split.Field

-- Field.ratCast_def from environment
-- theorem Field.ratCast_def : forall {K : Type.{u}} [self : Field.{u} K] (q : Rat), Eq.{succ u} K (Rat.cast.{u} K (Field.toRatCast.{u} K self) q) (HDiv.hDiv.{u, u, u} K K K (instHDiv.{u} K (Field.toDiv.{u} K self)) (Int.cast.{u} K (Ring.toIntCast.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))) (Rat.num q)) (Nat.cast.{u} K (Semiring.toNatCast.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self)))) (Rat.den q)))

-- Stub: this file represents the declaration `Field.ratCast_def`.
-- In a full split, the body would be extracted from the environment.
