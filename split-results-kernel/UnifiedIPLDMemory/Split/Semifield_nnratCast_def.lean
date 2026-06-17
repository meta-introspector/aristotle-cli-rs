import Split.Semiring_toNatCast
import Split.instHDiv
import Split.CommSemiring_toSemiring
import Split.Semifield
import Split.HDiv_hDiv
import Split.NNRat
import Split.Semifield_toDiv
import Split.NNRat_num
import Split.Nat_cast
import Split.NNRat_den
import Split.Semifield_toCommSemiring
import Split.NNRat_cast
import Split.Eq
import Split.Semifield_toNNRatCast

-- Semifield.nnratCast_def from environment
-- theorem Semifield.nnratCast_def : forall {K : Type.{u_2}} [self : Semifield.{u_2} K] (q : NNRat), Eq.{succ u_2} K (NNRat.cast.{u_2} K (Semifield.toNNRatCast.{u_2} K self) q) (HDiv.hDiv.{u_2, u_2, u_2} K K K (instHDiv.{u_2} K (Semifield.toDiv.{u_2} K self)) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (CommSemiring.toSemiring.{u_2} K (Semifield.toCommSemiring.{u_2} K self))) (NNRat.num q)) (Nat.cast.{u_2} K (Semiring.toNatCast.{u_2} K (CommSemiring.toSemiring.{u_2} K (Semifield.toCommSemiring.{u_2} K self))) (NNRat.den q)))

-- Stub: this file represents the declaration `Semifield.nnratCast_def`.
-- In a full split, the body would be extracted from the environment.
