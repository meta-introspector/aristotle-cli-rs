import Split.instHDiv
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.HDiv_hDiv
import Split.Div
import Split.Ne
import Split.MulDivCancelClass
import Split.MonoidWithZero
import Split.MonoidWithZero_toMulZeroOneClass
import Split.Zero_toOfNat0
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- MulDivCancelClass.mul_div_cancel from environment
-- theorem MulDivCancelClass.mul_div_cancel : forall {M₀ : Type.{u_2}} {inst._@.Mathlib.Algebra.GroupWithZero.Defs.4081171952._hygCtx._hyg.7 : MonoidWithZero.{u_2} M₀} {inst._@.Mathlib.Algebra.GroupWithZero.Defs.4081171952._hygCtx._hyg.10 : Div.{u_2} M₀} [self : MulDivCancelClass.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.4081171952._hygCtx._hyg.7 inst._@.Mathlib.Algebra.GroupWithZero.Defs.4081171952._hygCtx._hyg.10] (a : M₀) (b : M₀), (Ne.{succ u_2} M₀ b (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ (MulZeroClass.toZero.{u_2} M₀ (MulZeroOneClass.toMulZeroClass.{u_2} M₀ (MonoidWithZero.toMulZeroOneClass.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.4081171952._hygCtx._hyg.7)))))) -> (Eq.{succ u_2} M₀ (HDiv.hDiv.{u_2, u_2, u_2} M₀ M₀ M₀ (instHDiv.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.4081171952._hygCtx._hyg.10) (HMul.hMul.{u_2, u_2, u_2} M₀ M₀ M₀ (instHMul.{u_2} M₀ (MulZeroClass.toMul.{u_2} M₀ (MulZeroOneClass.toMulZeroClass.{u_2} M₀ (MonoidWithZero.toMulZeroOneClass.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.4081171952._hygCtx._hyg.7)))) a b) b) a)

-- Stub: this file represents the declaration `MulDivCancelClass.mul_div_cancel`.
-- In a full split, the body would be extracted from the environment.
