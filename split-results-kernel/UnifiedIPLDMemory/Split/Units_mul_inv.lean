import Split.Monoid
import Split.Units_val
import Split.MulOne_toOne
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.Units
import Split.MulOne_toMul
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.One_toOfNat1
import Split.OfNat_ofNat
import Split.Units_val_inv
import Split.Eq
import Split.Units_instInv
import Split.instHMul

-- Units.mul_inv from environment
-- theorem Units.mul_inv : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3 : Monoid.{u} α] (a : Units.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3)))) (Units.val.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3 a) (Units.val.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3 (Inv.inv.{u} (Units.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3) (Units.instInv.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3) a))) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α (MulOne.toOne.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.951690345._hygCtx._hyg.3)))))

-- Stub: this file represents the declaration `Units.mul_inv`.
-- In a full split, the body would be extracted from the environment.
