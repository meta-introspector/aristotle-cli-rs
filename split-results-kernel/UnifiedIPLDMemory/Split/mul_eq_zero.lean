import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.MulZeroClass
import Split.mul_eq_zero_of_right
import Split.mul_eq_zero_of_left
import Split.Iff
import Split.NoZeroDivisors
import Split.Iff_intro
import Split.Zero_toOfNat0
import Split.Or
import Split.Or_elim
import Split.OfNat_ofNat
import Split.Eq
import Split.NoZeroDivisors_eq_zero_or_eq_zero_of_mul_eq_zero
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_eq_zero from environment
-- theorem mul_eq_zero : forall {M₀ : Type.{u_1}} [inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.4 : MulZeroClass.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.7 : NoZeroDivisors.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.4) (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.4)] {a : M₀} {b : M₀}, Iff (Eq.{succ u_1} M₀ (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.4)) a b) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.4)))) (Or (Eq.{succ u_1} M₀ a (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.4)))) (Eq.{succ u_1} M₀ b (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.1984644472._hygCtx._hyg.4)))))

-- Stub: this file represents the declaration `mul_eq_zero`.
-- In a full split, the body would be extracted from the environment.
