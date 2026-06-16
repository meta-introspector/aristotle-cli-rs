import Split.HMul_hMul
import Split.congrArg
import Split.Mul
import Split.neg_neg
import Split.True
import Split.eq_self
import Split.HasDistribNeg
import Split.of_eq_true
import Split.neg_mul
import Split.congrFun'
import Split.HasDistribNeg_toInvolutiveNeg
import Split.InvolutiveNeg_toNeg
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans
import Split.mul_neg
import Split.instHMul

-- neg_mul_neg from environment
-- theorem neg_mul_neg : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.4 : Mul.{u} α] [inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.7 : HasDistribNeg.{u} α inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.4] (a : α) (b : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.4) (Neg.neg.{u} α (InvolutiveNeg.toNeg.{u} α (HasDistribNeg.toInvolutiveNeg.{u} α inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.7)) a) (Neg.neg.{u} α (InvolutiveNeg.toNeg.{u} α (HasDistribNeg.toInvolutiveNeg.{u} α inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.7)) b)) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α inst._@.Mathlib.Algebra.Ring.Defs.653849981._hygCtx._hyg.4) a b)

-- Stub: this file represents the declaration `neg_mul_neg`.
-- In a full split, the body would be extracted from the environment.
