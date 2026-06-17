import Split.Semiring_toNatCast
import Split.Int_cast
import Split.Rat_num
import Split.instHDiv
import Split.DivisionRing_toRatCast
import Split.Rat
import Split.Rat_den
import Split.HDiv_hDiv
import Split.Rat_cast
import Split.DivisionRing_toRing
import Split.DivisionRing_toDiv
import Split.Nat_cast
import Split.DivisionRing
import Split.Ring_toIntCast
import Split.Ring_toSemiring
import Split.Eq

-- DivisionRing.ratCast_def from environment
-- theorem DivisionRing.ratCast_def : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (q : Rat), Eq.{succ u_2} K (Rat.cast.{u_2} K (DivisionRing.toRatCast.{u_2} K self) q) (HDiv.hDiv.{u_2, u_2, u_2} K K K (instHDiv.{u_2} K (DivisionRing.toDiv.{u_2} K self)) (Int.cast.{u_2} K (Ring.toIntCast.{u_2} K (DivisionRing.toRing.{u_2} K self)) (Rat.num q)) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self))) (Rat.den q)))

-- Stub: this file represents the declaration `DivisionRing.ratCast_def`.
-- In a full split, the body would be extracted from the environment.
