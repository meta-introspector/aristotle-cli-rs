import Split.HMul_hMul
import Split.DivInvOneMonoid_toInvOneClass
import Split.Monoid_toMulOneClass
import Split.IsUnit_unit'
import Split.IsUnit
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.DivisionMonoid
import Split.MulOne_toMul
import Split.DivInvMonoid_toMonoid
import Split.DivisionMonoid_toDivInvMonoid
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.Units_inv_mul_cancel_right
import Split.InvOneClass_toInv
import Split.Eq
import Split.instHMul

-- IsUnit.inv_mul_cancel_right from environment
-- theorem IsUnit.inv_mul_cancel_right : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Group.Units.Basic.3833900852._hygCtx._hyg.4 : DivisionMonoid.{u} α] {b : α}, (IsUnit.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900852._hygCtx._hyg.4)) b) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900852._hygCtx._hyg.4)))))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900852._hygCtx._hyg.4)))))) a (Inv.inv.{u} α (InvOneClass.toInv.{u} α (DivInvOneMonoid.toInvOneClass.{u} α (DivisionMonoid.toDivInvOneMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900852._hygCtx._hyg.4))) b)) b) a)

-- Stub: this file represents the declaration `IsUnit.inv_mul_cancel_right`.
-- In a full split, the body would be extracted from the environment.
