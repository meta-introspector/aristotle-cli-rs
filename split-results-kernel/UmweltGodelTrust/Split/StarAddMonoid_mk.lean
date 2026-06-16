import Split.AddMonoid_toAddSemigroup
import Split.InvolutiveStar
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddMonoid
import Split.StarAddMonoid
import Split.InvolutiveStar_toStar
import Split.Eq
import Split.Star_star

-- StarAddMonoid.mk from environment
-- constructor StarAddMonoid.mk : forall {R : Type.{u}} [inst._@.Mathlib.Algebra.Star.Basic.560286440._hygCtx._hyg.5 : AddMonoid.{u} R] [toInvolutiveStar : InvolutiveStar.{u} R], (forall (r : R) (s : R), Eq.{succ u} R (Star.star.{u} R (InvolutiveStar.toStar.{u} R toInvolutiveStar) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R inst._@.Mathlib.Algebra.Star.Basic.560286440._hygCtx._hyg.5))) r s)) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R inst._@.Mathlib.Algebra.Star.Basic.560286440._hygCtx._hyg.5))) (Star.star.{u} R (InvolutiveStar.toStar.{u} R toInvolutiveStar) r) (Star.star.{u} R (InvolutiveStar.toStar.{u} R toInvolutiveStar) s))) -> (StarAddMonoid.{u} R inst._@.Mathlib.Algebra.Star.Basic.560286440._hygCtx._hyg.5)

-- Stub: this file represents the declaration `StarAddMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
