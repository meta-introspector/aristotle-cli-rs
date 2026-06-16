import Split.StarMul
import Split.Distrib_toAdd
import Split.instHAdd
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.StarRing
import Split.StarMul_toInvolutiveStar
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.InvolutiveStar_toStar
import Split.NonUnitalNonAssocSemiring
import Split.Eq
import Split.Star_star

-- StarRing.mk from environment
-- constructor StarRing.mk : forall {R : Type.{u}} [inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5 : NonUnitalNonAssocSemiring.{u} R] [toStarMul : StarMul.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5))], (forall (r : R) (s : R), Eq.{succ u} R (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5)) toStarMul)) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (Distrib.toAdd.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5))) r s)) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (Distrib.toAdd.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5))) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5)) toStarMul)) r) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5)) toStarMul)) s))) -> (StarRing.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5)

-- Stub: this file represents the declaration `StarRing.mk`.
-- In a full split, the body would be extracted from the environment.
