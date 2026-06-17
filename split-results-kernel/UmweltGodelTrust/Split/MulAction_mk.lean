import Split.Monoid
import Split.MulOne_toOne
import Split.instHSMul
import Split.Monoid_toMulOneClass
import Split.SemigroupAction
import Split.MulOneClass_toMulOne
import Split.MulAction
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.HSMul_hSMul
import Split.SemigroupAction_toSMul
import Split.OfNat_ofNat
import Split.Eq

-- MulAction.mk from environment
-- constructor MulAction.mk : forall {α : Type.{u_9}} {β : Type.{u_10}} [inst._@.Mathlib.Algebra.Group.Action.Defs.2534685468._hygCtx._hyg.20 : Monoid.{u_9} α] [toSemigroupAction : SemigroupAction.{u_9, u_10} α β (Monoid.toSemigroup.{u_9} α inst._@.Mathlib.Algebra.Group.Action.Defs.2534685468._hygCtx._hyg.20)], (forall (b : β), Eq.{succ u_10} β (HSMul.hSMul.{u_9, u_10, u_10} α β β (instHSMul.{u_9, u_10} α β (SemigroupAction.toSMul.{u_9, u_10} α β (Monoid.toSemigroup.{u_9} α inst._@.Mathlib.Algebra.Group.Action.Defs.2534685468._hygCtx._hyg.20) toSemigroupAction)) (OfNat.ofNat.{u_9} α 1 (One.toOfNat1.{u_9} α (MulOne.toOne.{u_9} α (MulOneClass.toMulOne.{u_9} α (Monoid.toMulOneClass.{u_9} α inst._@.Mathlib.Algebra.Group.Action.Defs.2534685468._hygCtx._hyg.20))))) b) b) -> (MulAction.{u_9, u_10} α β inst._@.Mathlib.Algebra.Group.Action.Defs.2534685468._hygCtx._hyg.20)

-- Stub: this file represents the declaration `MulAction.mk`.
-- In a full split, the body would be extracted from the environment.
