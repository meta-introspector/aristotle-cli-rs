import Split.NegZeroClass_toNeg
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.NegZeroClass
import Split.NegZeroClass_toZero
import Split.Eq
import Split.Neg_neg

-- NegZeroClass.neg_zero from environment
-- theorem NegZeroClass.neg_zero : forall {G : Type.{u_2}} [self : NegZeroClass.{u_2} G], Eq.{succ u_2} G (Neg.neg.{u_2} G (NegZeroClass.toNeg.{u_2} G self) (OfNat.ofNat.{u_2} G 0 (Zero.toOfNat0.{u_2} G (NegZeroClass.toZero.{u_2} G self)))) (OfNat.ofNat.{u_2} G 0 (Zero.toOfNat0.{u_2} G (NegZeroClass.toZero.{u_2} G self)))

-- Stub: this file represents the declaration `NegZeroClass.neg_zero`.
-- In a full split, the body would be extracted from the environment.
