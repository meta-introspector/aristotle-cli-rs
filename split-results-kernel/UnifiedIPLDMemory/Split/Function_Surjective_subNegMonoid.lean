import Split.instHSMul
import Split.SubNegMonoid_mk
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.AddMonoid_toNSMul
import Split.SubNegMonoid
import Split.Function_Surjective_addMonoid
import Split.AddZeroClass_toAddZero
import Split.Int
import Split.SubNegMonoid_toSub
import Split.AddZero_toZero
import Split.instHAdd
import Split.Neg
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.AddMonoid
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Function_Surjective
import Split.Neg_neg
import Split.Add
import Split.Sub
import Split.SubNegMonoid_toZSMul
import Split.Zero

-- Function.Surjective.subNegMonoid from environment
-- def Function.Surjective.subNegMonoid : forall {M₁ : Type.{u_1}} {M₂ : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.4 : Add.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.7 : Zero.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.10 : SMul.{0, u_2} Nat M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.16 : Neg.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.19 : Sub.{u_2} M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.22 : SMul.{0, u_2} Int M₂] [inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.28 : SubNegMonoid.{u_1} M₁] (f : M₁ -> M₂), (Function.Surjective.{succ u_1, succ u_2} M₁ M₂ f) -> (Eq.{succ u_2} M₂ (f (OfNat.ofNat.{u_1} M₁ 0 (Zero.toOfNat0.{u_1} M₁ (AddZero.toZero.{u_1} M₁ (AddZeroClass.toAddZero.{u_1} M₁ (AddMonoid.toAddZeroClass.{u_1} M₁ (SubNegMonoid.toAddMonoid.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.28))))))) (OfNat.ofNat.{u_2} M₂ 0 (Zero.toOfNat0.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.7))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HAdd.hAdd.{u_1, u_1, u_1} M₁ M₁ M₁ (instHAdd.{u_1} M₁ (AddZero.toAdd.{u_1} M₁ (AddZeroClass.toAddZero.{u_1} M₁ (AddMonoid.toAddZeroClass.{u_1} M₁ (SubNegMonoid.toAddMonoid.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.28))))) x y)) (HAdd.hAdd.{u_2, u_2, u_2} M₂ M₂ M₂ (instHAdd.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.4) (f x) (f y))) -> (forall (x : M₁), Eq.{succ u_2} M₂ (f (Neg.neg.{u_1} M₁ (SubNegMonoid.toNeg.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.28) x)) (Neg.neg.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.16 (f x))) -> (forall (x : M₁) (y : M₁), Eq.{succ u_2} M₂ (f (HSub.hSub.{u_1, u_1, u_1} M₁ M₁ M₁ (instHSub.{u_1} M₁ (SubNegMonoid.toSub.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.28)) x y)) (HSub.hSub.{u_2, u_2, u_2} M₂ M₂ M₂ (instHSub.{u_2} M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.19) (f x) (f y))) -> (forall (x : M₁) (n : Nat), Eq.{succ u_2} M₂ (f (HSMul.hSMul.{0, u_1, u_1} Nat M₁ M₁ (instHSMul.{0, u_1} Nat M₁ (AddMonoid.toNSMul.{u_1} M₁ (SubNegMonoid.toAddMonoid.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.28))) n x)) (HSMul.hSMul.{0, u_2, u_2} Nat M₂ M₂ (instHSMul.{0, u_2} Nat M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.10) n (f x))) -> (forall (x : M₁) (n : Int), Eq.{succ u_2} M₂ (f (HSMul.hSMul.{0, u_1, u_1} Int M₁ M₁ (instHSMul.{0, u_1} Int M₁ (SubNegMonoid.toZSMul.{u_1} M₁ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.28)) n x)) (HSMul.hSMul.{0, u_2, u_2} Int M₂ M₂ (instHSMul.{0, u_2} Int M₂ inst._@.Mathlib.Algebra.Group.InjSurj.1297685070._hygCtx._hyg.22) n (f x))) -> (SubNegMonoid.{u_2} M₂)
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Surjective.subNegMonoid`.
-- In a full split, the body would be extracted from the environment.
