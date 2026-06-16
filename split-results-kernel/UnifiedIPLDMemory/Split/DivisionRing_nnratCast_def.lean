import Split.Semiring_toNatCast
import Split.instHDiv
import Split.HDiv_hDiv
import Split.NNRat
import Split.DivisionRing_toRing
import Split.DivisionRing_toDiv
import Split.NNRat_num
import Split.Nat_cast
import Split.NNRat_den
import Split.DivisionRing
import Split.NNRat_cast
import Split.Ring_toSemiring
import Split.Eq
import Split.DivisionRing_toNNRatCast

-- DivisionRing.nnratCast_def from environment
-- theorem DivisionRing.nnratCast_def : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (q : NNRat), Eq.{succ u_2} K (NNRat.cast.{u_2} K (DivisionRing.toNNRatCast.{u_2} K self) q) (HDiv.hDiv.{u_2, u_2, u_2} K K K (instHDiv.{u_2} K (DivisionRing.toDiv.{u_2} K self)) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self))) (NNRat.num q)) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self))) (NNRat.den q)))

-- Stub: this file represents the declaration `DivisionRing.nnratCast_def`.
-- In a full split, the body would be extracted from the environment.
