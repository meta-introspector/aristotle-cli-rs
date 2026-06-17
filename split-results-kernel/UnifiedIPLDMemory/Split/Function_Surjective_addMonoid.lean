import Split.instHSMul
import Split.AddMonoid_toAddSemigroup
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.AddMonoid_toNSMul
import Split.AddMonoid_mk
import Split.AddZeroClass_toAddZero
import Split.AddZeroClass_zero_add
import Split.AddSemigroup
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.Nat
import Split.Function_Surjective_addZeroClass
import Split.AddZeroClass_add_zero
import Split.AddMonoid
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.OfNat_ofNat
import Split.Eq
import Split.Function_Surjective
import Split.Add
import Split.Function_Surjective_addSemigroup
import Split.Zero

-- Function.Surjective.addMonoid from environment
-- def Function.Surjective.addMonoid : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.4 : Add.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.7 : Zero.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.10 : SMul.{0, u_2} Nat M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.16 : AddMonoid.{u_1} M₁] (f : M₁ -> M₂), (Function.Surjective.{succ u_1, succ u_2} M₁ M₂ f) -> (Eq.{succ u_2} M₂ (f (OfNat.ofNat.{u_1} M₁ 0 (Zero.toOfNat0.{u_1} M₁ (AddZero.toZero.{u_1} M₁ (AddZeroClass.toAddZero.{u_1} M₁ (AddMonoid.toAddZeroClass.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.16)))))) (OfNat.ofNat.{u_2} M₂ 0 (Zero.toOfNat0.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.7))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HAdd.hAdd.{u_1, u_1, u_1} M₁ M₁ M₁ (instHAdd.{u_1} M₁ (AddZero.toAdd.{u_1} M₁ (AddZeroClass.toAddZero.{u_1} M₁ (AddMonoid.toAddZeroClass.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.16)))) x y)) (HAdd.hAdd.{u_2, u_2, u_2} M₂ M₂ M₂ (instHAdd.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.4) (f x) (f y))) -> (forall (x : M₁) (n : Nat), Eq.{succ u_2} M₂ (f (HSMul.hSMul.{0, u_1, u_1} Nat M₁ M₁ (instHSMul.{0, u_1} Nat M₁ (AddMonoid.toNSMul.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.16)) n x)) (HSMul.hSMul.{0, u_2, u_2} Nat M₂ M₂ (instHSMul.{0, u_2} Nat M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201069._hygCtx._hyg.10) n (f x))) -> (AddMonoid.{u_2} M₂)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Surjective.addMonoid`.
-- In a full split, the body would be extracted from the environment.
