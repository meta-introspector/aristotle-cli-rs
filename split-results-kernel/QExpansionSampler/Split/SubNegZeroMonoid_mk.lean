import Split.AddMonoid_toZero
import Split.SubNegMonoid
import Split.SubNegZeroMonoid
import Split.SubNegMonoid_toNeg
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- SubNegZeroMonoid.mk from environment
-- constructor SubNegZeroMonoid.mk : forall {G : Type.{u_2}} [toSubNegMonoid : SubNegMonoid.{u_2} G], (Eq.{succ u_2} G (Neg.neg.{u_2} G (SubNegMonoid.toNeg.{u_2} G toSubNegMonoid) (OfNat.ofNat.{u_2} G 0 (Zero.toOfNat0.{u_2} G (AddMonoid.toZero.{u_2} G (SubNegMonoid.toAddMonoid.{u_2} G toSubNegMonoid))))) (OfNat.ofNat.{u_2} G 0 (Zero.toOfNat0.{u_2} G (AddMonoid.toZero.{u_2} G (SubNegMonoid.toAddMonoid.{u_2} G toSubNegMonoid))))) -> (SubNegZeroMonoid.{u_2} G)

-- Stub: this file represents the declaration `SubNegZeroMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
