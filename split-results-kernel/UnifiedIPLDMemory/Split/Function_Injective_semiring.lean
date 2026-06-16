import Split.NonAssocSemiring_toAddCommMonoidWithOne
import Split.Monoid_npow
import Split.instHSMul
import Split.One
import Split.HMul_hMul
import Split.Pow
import Split.Function_Injective_nonUnitalSemiring
import Split.Function_Injective_monoidWithZero
import Split.SMul
import Split.NonAssocSemiring_one_mul
import Split.AddMonoid_toNSMul
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Mul
import Split.NonAssocSemiring_toOne
import Split.NatCast
import Split.Distrib_toAdd
import Split.AddMonoidWithOne_toNatCast
import Split.AddCommMonoidWithOne_toAddMonoidWithOne
import Split.Nat_cast
import Split.Monoid_toPow
import Split.AddMonoidWithOne_toOne
import Split.instHAdd
import Split.MonoidWithZero
import Split.NonAssocSemiring
import Split.HPow_hPow
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.NonUnitalSemiring
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.NonAssocSemiring_mul_one
import Split.Nat
import Split.Function_Injective_nonAssocSemiring
import Split.Semiring
import Split.One_toOfNat1
import Split.Semiring_toNonUnitalSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.instHPow
import Split.Function_Injective
import Split.AddMonoidWithOne_toAddMonoid
import Split.NonAssocSemiring_toNatCast
import Split.Semiring_mk
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.NonAssocSemiring_natCast_zero
import Split.Add
import Split.MonoidWithZero_toMonoid
import Split.MulZeroClass_toZero
import Split.Semiring_toMonoidWithZero
import Split.instHMul
import Split.Zero
import Split.NonAssocSemiring_natCast_succ

-- Function.Injective.semiring from environment
-- def Function.Injective.semiring : forall {R : Type.{u_1}} {S : Type.{u_2}} (f : S -> R), (Function.Injective.{succ u_2, succ u_1} S R f) -> (forall [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.9 : Add.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.12 : Mul.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.15 : Zero.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.18 : One.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.27 : SMul.{0, u_2} Nat S] [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.39 : Pow.{u_2, 0} S Nat] [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.45 : NatCast.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51 : Semiring.{u_1} R], (Eq.{succ u_1} R (f (OfNat.ofNat.{u_2} S 0 (Zero.toOfNat0.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.15))) (OfNat.ofNat.{u_1} R 0 (Zero.toOfNat0.{u_1} R (MulZeroClass.toZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (Semiring.toNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51))))))) -> (Eq.{succ u_1} R (f (OfNat.ofNat.{u_2} S 1 (One.toOfNat1.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.18))) (OfNat.ofNat.{u_1} R 1 (One.toOfNat1.{u_1} R (AddMonoidWithOne.toOne.{u_1} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R (Semiring.toNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51))))))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HAdd.hAdd.{u_2, u_2, u_2} S S S (instHAdd.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.9) x y)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (Distrib.toAdd.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (Semiring.toNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51))))) (f x) (f y))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HMul.hMul.{u_2, u_2, u_2} S S S (instHMul.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.12) x y)) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (Semiring.toNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51))))) (f x) (f y))) -> (forall (n : Nat) (x : S), Eq.{succ u_1} R (f (HSMul.hSMul.{0, u_2, u_2} Nat S S (instHSMul.{0, u_2} Nat S inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.27) n x)) (HSMul.hSMul.{0, u_1, u_1} Nat R R (instHSMul.{0, u_1} Nat R (AddMonoid.toNSMul.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R (Semiring.toNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51)))))) n (f x))) -> (forall (x : S) (n : Nat), Eq.{succ u_1} R (f (HPow.hPow.{u_2, 0, u_2} S Nat S (instHPow.{u_2, 0} S Nat inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.39) x n)) (HPow.hPow.{u_1, 0, u_1} R Nat R (instHPow.{u_1, 0} R Nat (Monoid.toPow.{u_1} R (MonoidWithZero.toMonoid.{u_1} R (Semiring.toMonoidWithZero.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51)))) (f x) n)) -> (forall (n : Nat), Eq.{succ u_1} R (f (Nat.cast.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.45 n)) (Nat.cast.{u_1} R (AddMonoidWithOne.toNatCast.{u_1} R (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} R (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} R (Semiring.toNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.1225801007._hygCtx._hyg.51)))) n)) -> (Semiring.{u_2} S))
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.semiring`.
-- In a full split, the body would be extracted from the environment.
