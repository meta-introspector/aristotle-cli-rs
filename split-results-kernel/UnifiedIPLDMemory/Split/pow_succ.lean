import Split.Monoid
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.MulOne_toMul
import Split.instOfNatNat
import Split.Monoid_toPow
import Split.instHAdd
import Split.MulOneClass_toMulOne
import Split.HPow_hPow
import Split.HAdd_hAdd
import Split.Nat
import Split.Monoid_npow_succ
import Split.instAddNat
import Split.instHPow
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- pow_succ from environment
-- theorem pow_succ : forall {M : Type.{u_2}} [inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4 : Monoid.{u_2} M] (a : M) (n : Nat), Eq.{succ u_2} M (HPow.hPow.{u_2, 0, u_2} M Nat M (instHPow.{u_2, 0} M Nat (Monoid.toPow.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4)) a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (HMul.hMul.{u_2, u_2, u_2} M M M (instHMul.{u_2} M (MulOne.toMul.{u_2} M (MulOneClass.toMulOne.{u_2} M (Monoid.toMulOneClass.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4)))) (HPow.hPow.{u_2, 0, u_2} M Nat M (instHPow.{u_2, 0} M Nat (Monoid.toPow.{u_2} M inst._@.Mathlib.Algebra.Group.Defs.2508248740._hygCtx._hyg.4)) a n) a)

-- Stub: this file represents the declaration `pow_succ`.
-- In a full split, the body would be extracted from the environment.
