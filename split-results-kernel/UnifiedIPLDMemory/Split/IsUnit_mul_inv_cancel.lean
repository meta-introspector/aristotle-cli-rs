import Split.Units_val
import Split.Eq_mpr
import Split.MulOne_toOne
import Split.DivInvMonoid_toInv
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.congrArg
import Split.Units_val_inv_eq_inv_val
import Split.IsUnit
import Split.Units
import Split.DivisionMonoid
import Split.id
import Split.MulOne_toMul
import Split.DivInvMonoid_toMonoid
import Split.Units_mul_inv
import Split.DivisionMonoid_toDivInvMonoid
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.Exists_casesOn
import Split.Eq_ndrec
import Split.One_toOfNat1
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Units_instInv
import Split.instHMul

-- IsUnit.mul_inv_cancel from environment
-- theorem IsUnit.mul_inv_cancel : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Group.Units.Defs.2232975342._hygCtx._hyg.5 : DivisionMonoid.{u} α] {a : α}, (IsUnit.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.2232975342._hygCtx._hyg.5)) a) -> (Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.2232975342._hygCtx._hyg.5)))))) a (Inv.inv.{u} α (DivInvMonoid.toInv.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.2232975342._hygCtx._hyg.5)) a)) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α (MulOne.toOne.{u} α (MulOneClass.toMulOne.{u} α (Monoid.toMulOneClass.{u} α (DivInvMonoid.toMonoid.{u} α (DivisionMonoid.toDivInvMonoid.{u} α inst._@.Mathlib.Algebra.Group.Units.Defs.2232975342._hygCtx._hyg.5))))))))

-- Stub: this file represents the declaration `IsUnit.mul_inv_cancel`.
-- In a full split, the body would be extracted from the environment.
