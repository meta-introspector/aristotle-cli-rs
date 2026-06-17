import Split.HMul_hMul
import Split.StarMul
import Split.CommMagma_toMul
import Split.CommMagma
import Split.StarMul_toInvolutiveStar
import Split.mul_comm
import Split.StarMul_star_mul
import Split.InvolutiveStar_toStar
import Split.Eq
import Split.Eq_trans
import Split.instHMul
import Split.Star_star

-- star_mul' from environment
-- theorem star_mul' : forall {R : Type.{u}} [inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.3 : CommMagma.{u} R] [inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.6 : StarMul.{u} R (CommMagma.toMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.3)] (x : R) (y : R), Eq.{succ u} R (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (CommMagma.toMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.3) inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.6)) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (CommMagma.toMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.3)) x y)) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (CommMagma.toMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.3)) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (CommMagma.toMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.3) inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.6)) x) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (CommMagma.toMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.3) inst._@.Mathlib.Algebra.Star.Basic.1262882799._hygCtx._hyg.6)) y))

-- Stub: this file represents the declaration `star_mul'`.
-- In a full split, the body would be extracted from the environment.
