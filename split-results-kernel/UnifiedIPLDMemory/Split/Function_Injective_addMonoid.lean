import Split.instHSMul
import Split.AddMonoid_toAddSemigroup
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.AddMonoid_toNSMul
import Split.AddMonoid_mk
import Split.AddZeroClass_toAddZero
import Split.AddZeroClass_zero_add
import Split.AddSemigroup
import Split.Function_Injective_addSemigroup
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.Nat
import Split.AddZeroClass_add_zero
import Split.AddMonoid
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.Function_Injective
import Split.Function_Injective_addZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.Add
import Split.Zero

-- Function.Injective.addMonoid from environment
-- def Function.Injective.addMonoid : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.4 : Add.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.7 : Zero.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.10 : SMul.{0, u_1} Nat M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16 : AddMonoid.{u_2} M₂] (f : M₁ -> M₂), (Function.Injective.{succ u_1, succ u_2} M₁ M₂ f) -> (Eq.{succ u_2} M₂ (f (OfNat.ofNat.{u_1} M₁ 0 (Zero.toOfNat0.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.7))) (OfNat.ofNat.{u_2} M₂ 0 (Zero.toOfNat0.{u_2} M₂ (AddZero.toZero.{u_2} M₂ (AddZeroClass.toAddZero.{u_2} M₂ (AddMonoid.toAddZeroClass.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16)))))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HAdd.hAdd.{u_1, u_1, u_1} M₁ M₁ M₁ (instHAdd.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.4) x y)) (HAdd.hAdd.{u_2, u_2, u_2} M₂ M₂ M₂ (instHAdd.{u_2} M₂ (AddZero.toAdd.{u_2} M₂ (AddZeroClass.toAddZero.{u_2} M₂ (AddMonoid.toAddZeroClass.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16)))) (f x) (f y))) -> (forall (x : M₁) (n : Nat), Eq.{succ u_2} M₂ (f (HSMul.hSMul.{0, u_1, u_1} Nat M₁ M₁ (instHSMul.{0, u_1} Nat M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.10) n x)) (HSMul.hSMul.{0, u_2, u_2} Nat M₂ M₂ (instHSMul.{0, u_2} Nat M₂ (AddMonoid.toNSMul.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1372201068._hygCtx._hyg.16)) n (f x))) -> (AddMonoid.{u_1} M₁)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.addMonoid`.
-- In a full split, the body would be extracted from the environment.
