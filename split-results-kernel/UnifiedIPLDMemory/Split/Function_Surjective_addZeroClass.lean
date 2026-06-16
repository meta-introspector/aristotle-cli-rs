import Split.AddZeroClass_mk
import Split.AddZeroClass_toAddZero
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.AddZero_mk
import Split.Eq
import Split.Function_Surjective
import Split.Add
import Split.Zero

-- Function.Surjective.addZeroClass from environment
-- def Function.Surjective.addZeroClass : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.4 : Add.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.7 : Zero.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.10 : AddZeroClass.{u_1} M₁] (f : M₁ -> M₂), (Function.Surjective.{succ u_1, succ u_2} M₁ M₂ f) -> (Eq.{succ u_2} M₂ (f (OfNat.ofNat.{u_1} M₁ 0 (Zero.toOfNat0.{u_1} M₁ (AddZero.toZero.{u_1} M₁ (AddZeroClass.toAddZero.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.10))))) (OfNat.ofNat.{u_2} M₂ 0 (Zero.toOfNat0.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.7))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HAdd.hAdd.{u_1, u_1, u_1} M₁ M₁ M₁ (instHAdd.{u_1} M₁ (AddZero.toAdd.{u_1} M₁ (AddZeroClass.toAddZero.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.10))) x y)) (HAdd.hAdd.{u_2, u_2, u_2} M₂ M₂ M₂ (instHAdd.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.4120732672._hygCtx._hyg.4) (f x) (f y))) -> (AddZeroClass.{u_2} M₂)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Surjective.addZeroClass`.
-- In a full split, the body would be extracted from the environment.
