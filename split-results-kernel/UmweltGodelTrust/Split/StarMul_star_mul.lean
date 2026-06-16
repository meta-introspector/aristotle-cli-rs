import Split.HMul_hMul
import Split.StarMul
import Split.Mul
import Split.StarMul_toInvolutiveStar
import Split.InvolutiveStar_toStar
import Split.Eq
import Split.instHMul
import Split.Star_star

-- StarMul.star_mul from environment
-- theorem StarMul.star_mul : forall {R : Type.{u}} {inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5 : Mul.{u} R} [self : StarMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5] (r : R) (s : R), Eq.{succ u} R (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5 self)) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5) r s)) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5 self)) s) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R inst._@.Mathlib.Algebra.Star.Basic.2420141393._hygCtx._hyg.5 self)) r))

-- Stub: this file represents the declaration `StarMul.star_mul`.
-- In a full split, the body would be extracted from the environment.
