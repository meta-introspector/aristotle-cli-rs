import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.MulZeroClass_zero_mul
import Split.MulZeroClass
import Split.Eq_rec
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_eq_zero_of_left from environment
-- theorem mul_eq_zero_of_left : forall {M₀ : Type.{u_1}} [inst._@.Mathlib.Algebra.GroupWithZero.Defs.3637365406._hygCtx._hyg.4 : MulZeroClass.{u_1} M₀] {a : M₀}, (Eq.{succ u_1} M₀ a (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.3637365406._hygCtx._hyg.4)))) -> (forall (b : M₀), Eq.{succ u_1} M₀ (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.3637365406._hygCtx._hyg.4)) a b) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.3637365406._hygCtx._hyg.4))))

-- Stub: this file represents the declaration `mul_eq_zero_of_left`.
-- In a full split, the body would be extracted from the environment.
