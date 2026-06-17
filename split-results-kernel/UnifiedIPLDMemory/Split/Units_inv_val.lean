import Split.Monoid
import Split.Units_val
import Split.MulOne_toOne
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.Units
import Split.MulOne_toMul
import Split.MulOneClass_toMulOne
import Split.One_toOfNat1
import Split.Units_inv
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Units.inv_val from environment
-- theorem Units.inv_val : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Group.Units.Defs.805054321._hygCtx._hyg.5 : Monoid.{u} α] (self : Units.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.805054321._hygCtx._hyg.5), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.805054321._hygCtx._hyg.5)))) (Units.inv.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.805054321._hygCtx._hyg.5 self) (Units.val.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.805054321._hygCtx._hyg.5 self)) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α (MulOne.toOne.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.805054321._hygCtx._hyg.5)))))

-- Stub: this file represents the declaration `Units.inv_val`.
-- In a full split, the body would be extracted from the environment.
