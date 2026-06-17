import Split.Eq_mpr
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.congrArg
import Split.MulZeroClass
import Split.id
import Split.Ne
import Split.Iff
import Split.NoZeroDivisors
import Split.implies_congr
import Split.Iff_intro
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.congrFun'
import Split.Or
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul
import Split.forall_congr

-- noZeroDivisors_iff_right_eq_zero_of_mul from environment
-- theorem noZeroDivisors_iff_right_eq_zero_of_mul : forall {M₀ : Type.{u_1}} [inst._@.Mathlib.Algebra.GroupWithZero.Defs.2793932860._hygCtx._hyg.4 : MulZeroClass.{u_1} M₀], Iff (NoZeroDivisors.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2793932860._hygCtx._hyg.4) (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2793932860._hygCtx._hyg.4)) (forall (x : M₀), (Ne.{succ u_1} M₀ x (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2793932860._hygCtx._hyg.4)))) -> (forall (y : M₀), (Eq.{succ u_1} M₀ (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2793932860._hygCtx._hyg.4)) x y) (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2793932860._hygCtx._hyg.4)))) -> (Eq.{succ u_1} M₀ y (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2793932860._hygCtx._hyg.4))))))

-- Stub: this file represents the declaration `noZeroDivisors_iff_right_eq_zero_of_mul`.
-- In a full split, the body would be extracted from the environment.
