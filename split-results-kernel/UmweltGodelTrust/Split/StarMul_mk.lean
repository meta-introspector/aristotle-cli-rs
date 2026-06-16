import Split.HMul_hMul
import Split.InvolutiveStar
import Split.StarMul
import Split.Mul
import Split.InvolutiveStar_toStar
import Split.Eq
import Split.instHMul
import Split.Star_star

-- StarMul.mk from environment
-- constructor StarMul.mk : forall {R : Type.{u}} [inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5 : Mul.{u} R] [toInvolutiveStar : InvolutiveStar.{u} R], (forall (r : R) (s : R), Eq.{succ u} R (Star.star.{u} R (InvolutiveStar.toStar.{u} R toInvolutiveStar) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5) r s)) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5) (Star.star.{u} R (InvolutiveStar.toStar.{u} R toInvolutiveStar) s) (Star.star.{u} R (InvolutiveStar.toStar.{u} R toInvolutiveStar) r))) -> (StarMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5)

-- Stub: this file represents the declaration `StarMul.mk`.
-- In a full split, the body would be extracted from the environment.
