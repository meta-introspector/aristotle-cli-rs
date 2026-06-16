import Split.InvolutiveNeg
import Split.InvolutiveNeg_toNeg
import Split.Eq
import Split.Neg_neg

-- InvolutiveNeg.neg_neg from environment
-- theorem InvolutiveNeg.neg_neg : forall {A : Type.{u_2}} [self : InvolutiveNeg.{u_2} A] (x : A), Eq.{succ u_2} A (Neg.neg.{u_2} A (InvolutiveNeg.toNeg.{u_2} A self) (Neg.neg.{u_2} A (InvolutiveNeg.toNeg.{u_2} A self) x)) x

-- Stub: this file represents the declaration `InvolutiveNeg.neg_neg`.
-- In a full split, the body would be extracted from the environment.
