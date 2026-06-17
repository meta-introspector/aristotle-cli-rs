import Split.HMul_hMul
import Split.Mul
import Split.IsLeftCancelMulZero_mul_left_cancel_of_ne_zero
import Split.Ne
import Split.IsLeftCancelMulZero
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul
import Split.Zero

-- mul_left_cancel₀ from environment
-- theorem mul_left_cancel₀ : forall {M₀ : Type.{u_1}} [inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.4 : Mul.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.7 : Zero.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.10 : IsLeftCancelMulZero.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.4 inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.7] {a : M₀} {b : M₀} {c : M₀}, (Ne.{succ u_1} M₀ a (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.7))) -> (Eq.{succ u_1} M₀ (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.4) a b) (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.3882253571._hygCtx._hyg.4) a c)) -> (Eq.{succ u_1} M₀ b c)

-- Stub: this file represents the declaration `mul_left_cancel₀`.
-- In a full split, the body would be extracted from the environment.
