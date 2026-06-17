import Split.NonAssocSemiring_mk
import Split.NonAssocSemiring_toAddCommMonoidWithOne
import Split.MulOne_toOne
import Split.instHSMul
import Split.AddMonoidWithOne_natCast_zero
import Split.One
import Split.HMul_hMul
import Split.SMul
import Split.AddMonoid_toNSMul
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Mul
import Split.NatCast
import Split.Distrib_toAdd
import Split.Function_Injective_mulZeroOneClass
import Split.Function_Injective_addMonoidWithOne
import Split.AddMonoidWithOne_toNatCast
import Split.NonAssocSemiring_toMulZeroOneClass
import Split.AddCommMonoidWithOne_toAddMonoidWithOne
import Split.AddMonoidWithOne_natCast_succ
import Split.MulZeroOneClass
import Split.Nat_cast
import Split.MulZeroOneClass_toMulOneClass
import Split.AddMonoidWithOne_toOne
import Split.instHAdd
import Split.MulOneClass_toMulOne
import Split.NonAssocSemiring
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.Function_Injective_nonUnitalNonAssocSemiring
import Split.One_toOfNat1
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.Function_Injective
import Split.AddMonoidWithOne_toAddMonoid
import Split.NonUnitalNonAssocSemiring
import Split.OfNat_ofNat
import Split.Eq
import Split.Add
import Split.MulZeroClass_toZero
import Split.AddMonoidWithOne
import Split.instHMul
import Split.Zero

-- Function.Injective.nonAssocSemiring from environment
-- def Function.Injective.nonAssocSemiring : forall {R : Type.{u_1}} {S : Type.{u_2}} (f : S -> R), (Function.Injective.{succ u_2, succ u_1} S R f) -> (forall [inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.9 : Add.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.12 : Mul.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.15 : Zero.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.18 : One.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.27 : SMul.{0, u_2} Nat S] [inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.45 : NatCast.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.51 : NonAssocSemiring.{u_1} R], (Eq.{succ u_1} R (f (OfNat.ofNat.{u_2} S 0 (Zero.toOfNat0.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.15))) (OfNat.ofNat.{u_1} R 0 (Zero.toOfNat0.{u_1} R (MulZeroClass.toZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.51)))))) -> (Eq.{succ u_1} R (f (OfNat.ofNat.{u_2} S 1 (One.toOfNat1.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.18))) (OfNat.ofNat.{u_1} R 1 (One.toOfNat1.{u_1} R (AddMonoidWithOne.toOne.{u_1} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.51)))))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HAdd.hAdd.{u_2, u_2, u_2} S S S (instHAdd.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.9) x y)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (Distrib.toAdd.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.51)))) (f x) (f y))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HMul.hMul.{u_2, u_2, u_2} S S S (instHMul.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.12) x y)) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.51)))) (f x) (f y))) -> (forall (n : Nat) (x : S), Eq.{succ u_1} R (f (HSMul.hSMul.{0, u_2, u_2} Nat S S (instHSMul.{0, u_2} Nat S inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.27) n x)) (HSMul.hSMul.{0, u_1, u_1} Nat R R (instHSMul.{0, u_1} Nat R (AddMonoid.toNSMul.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.51))))) n (f x))) -> (forall (n : Nat), Eq.{succ u_1} R (f (Nat.cast.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.45 n)) (Nat.cast.{u_1} R (AddMonoidWithOne.toNatCast.{u_1} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.4143978964._hygCtx._hyg.51))) n)) -> (NonAssocSemiring.{u_2} S))
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.nonAssocSemiring`.
-- In a full split, the body would be extracted from the environment.
