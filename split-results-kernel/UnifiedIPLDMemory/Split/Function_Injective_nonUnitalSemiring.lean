import Split.SemigroupWithZero
import Split.instHSMul
import Split.HMul_hMul
import Split.SMul
import Split.AddMonoid_toNSMul
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Mul
import Split.Distrib_toAdd
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.NonUnitalSemiring_toSemigroupWithZero
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.NonUnitalSemiring
import Split.Nat
import Split.Function_Injective_semigroupWithZero
import Split.Function_Injective_nonUnitalNonAssocSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.AddCommMonoid_toAddMonoid
import Split.Function_Injective
import Split.NonUnitalSemiring_mk
import Split.NonUnitalNonAssocSemiring
import Split.OfNat_ofNat
import Split.Eq
import Split.Add
import Split.MulZeroClass_toZero
import Split.instHMul
import Split.Zero

-- Function.Injective.nonUnitalSemiring from environment
-- def Function.Injective.nonUnitalSemiring : forall {R : Type.{u_1}} {S : Type.{u_2}} (f : S -> R), (Function.Injective.{succ u_2, succ u_1} S R f) -> (forall [inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.9 : Add.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.12 : Mul.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.15 : Zero.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.27 : SMul.{0, u_2} Nat S] [inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.51 : NonUnitalSemiring.{u_1} R], (Eq.{succ u_1} R (f (OfNat.ofNat.{u_2} S 0 (Zero.toOfNat0.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.15))) (OfNat.ofNat.{u_1} R 0 (Zero.toOfNat0.{u_1} R (MulZeroClass.toZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.51)))))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HAdd.hAdd.{u_2, u_2, u_2} S S S (instHAdd.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.9) x y)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (Distrib.toAdd.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.51)))) (f x) (f y))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HMul.hMul.{u_2, u_2, u_2} S S S (instHMul.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.12) x y)) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.51)))) (f x) (f y))) -> (forall (n : Nat) (x : S), Eq.{succ u_1} R (f (HSMul.hSMul.{0, u_2, u_2} Nat S S (instHSMul.{0, u_2} Nat S inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.27) n x)) (HSMul.hSMul.{0, u_1, u_1} Nat R R (instHSMul.{0, u_1} Nat R (AddMonoid.toNSMul.{u_1} R (AddCommMonoid.toAddMonoid.{u_1} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.764197642._hygCtx._hyg.51))))) n (f x))) -> (NonUnitalSemiring.{u_2} S))
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.nonUnitalSemiring`.
-- In a full split, the body would be extracted from the environment.
