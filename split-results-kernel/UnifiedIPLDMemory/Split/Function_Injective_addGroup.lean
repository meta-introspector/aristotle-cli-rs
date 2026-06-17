import Split.instHSMul
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.AddMonoid_toNSMul
import Split.SubNegMonoid
import Split.AddZeroClass_toAddZero
import Split.Int
import Split.SubNegMonoid_toSub
import Split.AddZero_toZero
import Split.instHAdd
import Split.Neg
import Split.Function_Injective_subNegMonoid
import Split.AddGroup
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.Nat
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.Function_Injective
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg
import Split.Add
import Split.AddGroup_mk
import Split.Sub
import Split.SubNegMonoid_toZSMul
import Split.Zero

-- Function.Injective.addGroup from environment
-- def Function.Injective.addGroup : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.4 : Add.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.7 : Zero.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.10 : SMul.{0, u_1} Nat M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.16 : Neg.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.19 : Sub.{u_1} M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.22 : SMul.{0, u_1} Int M₁] [inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.28 : AddGroup.{u_2} M₂] (f : M₁ -> M₂), (Function.Injective.{succ u_1, succ u_2} M₁ M₂ f) -> (Eq.{succ u_2} M₂ (f (OfNat.ofNat.{u_1} M₁ 0 (Zero.toOfNat0.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.7))) (OfNat.ofNat.{u_2} M₂ 0 (Zero.toOfNat0.{u_2} M₂ (AddZero.toZero.{u_2} M₂ (AddZeroClass.toAddZero.{u_2} M₂ (AddMonoid.toAddZeroClass.{u_2} M₂ (SubNegMonoid.toAddMonoid.{u_2} M₂ (AddGroup.toSubNegMonoid.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.28)))))))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HAdd.hAdd.{u_1, u_1, u_1} M₁ M₁ M₁ (instHAdd.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.4) x y)) (HAdd.hAdd.{u_2, u_2, u_2} M₂ M₂ M₂ (instHAdd.{u_2} M₂ (AddZero.toAdd.{u_2} M₂ (AddZeroClass.toAddZero.{u_2} M₂ (AddMonoid.toAddZeroClass.{u_2} M₂ (SubNegMonoid.toAddMonoid.{u_2} M₂ (AddGroup.toSubNegMonoid.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.28)))))) (f x) (f y))) -> (forall (x : M₁), Eq.{succ u_2} M₂ (f (Neg.neg.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.16 x)) (Neg.neg.{u_2} M₂ (SubNegMonoid.toNeg.{u_2} M₂ (AddGroup.toSubNegMonoid.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.28)) (f x))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HSub.hSub.{u_1, u_1, u_1} M₁ M₁ M₁ (instHSub.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.19) x y)) (HSub.hSub.{u_2, u_2, u_2} M₂ M₂ M₂ (instHSub.{u_2} M₂ (SubNegMonoid.toSub.{u_2} M₂ (AddGroup.toSubNegMonoid.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.28))) (f x) (f y))) -> (forall (x : M₁) (n : Nat), Eq.{succ u_2} M₂ (f (HSMul.hSMul.{0, u_1, u_1} Nat M₁ M₁ (instHSMul.{0, u_1} Nat M₁ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.10) n x)) (HSMul.hSMul.{0, u_2, u_2} Nat M₂ M₂ (instHSMul.{0, u_2} Nat M₂ (AddMonoid.toNSMul.{u_2} M₂ (SubNegMonoid.toAddMonoid.{u_2} M₂ (AddGroup.toSubNegMonoid.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.28)))) n (f x))) -> (forall (x : M₁) (n : Int), Eq.{succ u_2} M₂ (f (HSMul.hSMul.{0, u_1, u_1} Int M₁ M₁ (instHSMul.{0, u_1} Int M₁ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.22) n x)) (HSMul.hSMul.{0, u_2, u_2} Int M₂ M₂ (instHSMul.{0, u_2} Int M₂ (SubNegMonoid.toZSMul.{u_2} M₂ (AddGroup.toSubNegMonoid.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.74875168._hygCtx._hyg.28))) n (f x))) -> (AddGroup.{u_1} M₁)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.addGroup`.
-- In a full split, the body would be extracted from the environment.
