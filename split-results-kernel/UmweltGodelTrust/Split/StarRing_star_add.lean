import Split.Distrib_toAdd
import Split.instHAdd
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.StarRing
import Split.StarMul_toInvolutiveStar
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.InvolutiveStar_toStar
import Split.StarRing_toStarMul
import Split.NonUnitalNonAssocSemiring
import Split.Eq
import Split.Star_star

-- StarRing.star_add from environment
-- theorem StarRing.star_add : forall {R : Type.{u}} {inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5 : NonUnitalNonAssocSemiring.{u} R} [self : StarRing.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5] (r : R) (s : R), Eq.{succ u} R (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5)) (StarRing.toStarMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5 self))) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (Distrib.toAdd.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5))) r s)) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (Distrib.toAdd.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5))) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5)) (StarRing.toStarMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5 self))) r) (Star.star.{u} R (InvolutiveStar.toStar.{u} R (StarMul.toInvolutiveStar.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5)) (StarRing.toStarMul.{u} R inst._@.Mathlib.Algebra.Star.Basic.2725050839._hygCtx._hyg.5 self))) s))

-- Stub: this file represents the declaration `StarRing.star_add`.
-- In a full split, the body would be extracted from the environment.
