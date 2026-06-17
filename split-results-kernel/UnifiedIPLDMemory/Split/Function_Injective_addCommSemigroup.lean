import Split.AddCommMagma
import Split.AddCommMagma_add_comm
import Split.AddCommSemigroup_mk
import Split.AddSemigroup
import Split.AddCommSemigroup_toAddSemigroup
import Split.Function_Injective_addSemigroup
import Split.Function_Injective_addCommMagma
import Split.instHAdd
import Split.HAdd_hAdd
import Split.AddCommSemigroup_toAddCommMagma
import Split.Function_Injective
import Split.AddCommSemigroup
import Split.Eq
import Split.Add
import Split.AddCommMagma_toAdd

-- Function.Injective.addCommSemigroup from environment
-- def Function.Injective.addCommSemigroup : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.1465783772._hygCtx._hyg.4 : Add.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1465783772._hygCtx._hyg.7 : AddCommSemigroup.{u_2} M₂] (f : M₁ -> M₂), (Function.Injective.{succ u_1, succ u_2} M₁ M₂ f) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HAdd.hAdd.{u_1, u_1, u_1} M₁ M₁ M₁ (instHAdd.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1465783772._hygCtx._hyg.4) x y)) (HAdd.hAdd.{u_2, u_2, u_2} M₂ M₂ M₂ (instHAdd.{u_2} M₂ (AddCommMagma.toAdd.{u_2} M₂ (AddCommSemigroup.toAddCommMagma.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1465783772._hygCtx._hyg.7))) (f x) (f y))) -> (AddCommSemigroup.{u_1} M₁)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.addCommSemigroup`.
-- In a full split, the body would be extracted from the environment.
