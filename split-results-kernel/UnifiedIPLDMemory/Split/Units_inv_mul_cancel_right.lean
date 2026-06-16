import Split.Monoid
import Split.Units_val
import Split.Eq_mpr
import Split.MulOne_toOne
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.congrArg
import Split.mul_assoc
import Split.Units_inv_mul
import Split.Units
import Split.id
import Split.MulOne_toMul
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Eq_refl
import Split.mul_one
import Split.OfNat_ofNat
import Split.Eq
import Split.Units_instInv
import Split.instHMul

-- Units.inv_mul_cancel_right from environment
-- theorem Units.inv_mul_cancel_right : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3 : Monoid.{u} α] (a : α) (b : Units.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3)))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3)))) a (Units.val.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3 (Inv.inv.{u} (Units.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3) (Units.instInv.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3) b))) (Units.val.{u} α inst._@.Mathlib.Algebra.Group.Units.Basic.3833900851._hygCtx._hyg.3 b)) a

-- Stub: this file represents the declaration `Units.inv_mul_cancel_right`.
-- In a full split, the body would be extracted from the environment.
