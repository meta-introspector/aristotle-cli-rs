import Split.instHDiv
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.HDiv_hDiv
import Split.Div
import Split.Ne
import Split.MulDivCancelClass_mul_div_cancel
import Split.MulDivCancelClass
import Split.MonoidWithZero
import Split.MonoidWithZero_toMulZeroOneClass
import Split.Zero_toOfNat0
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_div_cancel_right₀ from environment
-- theorem mul_div_cancel_right₀ : forall {M₀ : Type.{u_1}} [inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.4 : MonoidWithZero.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.7 : Div.{u_1} M₀] [inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.10 : MulDivCancelClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.4 inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.7] (a : M₀) {b : M₀}, (Ne.{succ u_1} M₀ b (OfNat.ofNat.{u_1} M₀ 0 (Zero.toOfNat0.{u_1} M₀ (MulZeroClass.toZero.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ (MonoidWithZero.toMulZeroOneClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.4)))))) -> (Eq.{succ u_1} M₀ (HDiv.hDiv.{u_1, u_1, u_1} M₀ M₀ M₀ (instHDiv.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.7) (HMul.hMul.{u_1, u_1, u_1} M₀ M₀ M₀ (instHMul.{u_1} M₀ (MulZeroClass.toMul.{u_1} M₀ (MulZeroOneClass.toMulZeroClass.{u_1} M₀ (MonoidWithZero.toMulZeroOneClass.{u_1} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2760421076._hygCtx._hyg.4)))) a b) b) a)

-- Stub: this file represents the declaration `mul_div_cancel_right₀`.
-- In a full split, the body would be extracted from the environment.
