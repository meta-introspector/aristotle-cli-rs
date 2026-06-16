import Split.Iff_mpr
import Split.HMul_hMul
import Split.Mul
import Split.mt
import Split.Ne
import Split.not_or
import Split.And
import Split.NoZeroDivisors
import Split.And_intro
import Split.Zero_toOfNat0
import Split.Or
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.NoZeroDivisors_eq_zero_or_eq_zero_of_mul_eq_zero
import Split.instHMul
import Split.Zero

-- mul_ne_zero from environment
-- theorem mul_ne_zero : forall {M₀ : Type.{u_1}} [inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.4 : Mul.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.7 : Zero.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.10 : NoZeroDivisors.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.4 inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.7] {a : M₀} {b : M₀}, (Ne.{succ u_1} M₀ a (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.7))) -> (Ne.{succ u_1} M₀ b (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.7))) -> (Ne.{succ u_1} M₀ (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.4) a b) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.430946186._hygCtx._hyg.7)))

-- Stub: this file represents the declaration `mul_ne_zero`.
-- In a full split, the body would be extracted from the environment.
