import Split.Eq_mpr
import Split.DivInvMonoid_toInv
import Split.instHDiv
import Split.HMul_hMul
import Split.DivInvOneMonoid_toInvOneClass
import Split.Monoid_toMulOneClass
import Split.congrArg
import Split.IsUnit
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.DivisionMonoid
import Split.id
import Split.MulOne_toMul
import Split.HDiv_hDiv
import Split.DivInvMonoid_toMonoid
import Split.div_eq_mul_inv
import Split.DivisionMonoid_toDivInvMonoid
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.DivInvMonoid_toDiv
import Split.Eq_refl
import Split.InvOneClass_toInv
import Split.Eq
import Split.IsUnit_inv_mul_cancel_right
import Split.instHMul

-- IsUnit.div_mul_cancel from environment
-- theorem IsUnit.div_mul_cancel : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Group.Units.Basic.4159268353._hygCtx._hyg.4 : DivisionMonoid.{u} α] {b : α}, (IsUnit.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.4159268353._hygCtx._hyg.4)) b) -> (forall (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.4159268353._hygCtx._hyg.4)))))) (HDiv.hDiv.{u, u, u} α α α (instHDiv.{u} α (DivInvMonoid.toDiv.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.4159268353._hygCtx._hyg.4))) a b) b) a)

-- Stub: this file represents the declaration `IsUnit.div_mul_cancel`.
-- In a full split, the body would be extracted from the environment.
