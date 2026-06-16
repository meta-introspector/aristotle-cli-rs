import Split.AddSemigroup_mk
import Split.AddSemigroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Function_Injective
import Split.Eq
import Split.Add

-- Function.Injective.addSemigroup from environment
-- def Function.Injective.addSemigroup : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.4 : Add.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.7 : AddSemigroup.{u_2} M₂] (f : M₁ -> M₂), (Function.Injective.{succ u_1, succ u_2} M₁ M₂ f) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HAdd.hAdd.{u_1, u_1, u_1} M₁ M₁ M₁ (instHAdd.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.4) x y)) (HAdd.hAdd.{u_2, u_2, u_2} M₂ M₂ M₂ (instHAdd.{u_2} M₂ (AddSemigroup.toAdd.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1657982427._hygCtx._hyg.7)) (f x) (f y))) -> (AddSemigroup.{u_1} M₁)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.addSemigroup`.
-- In a full split, the body would be extracted from the environment.
