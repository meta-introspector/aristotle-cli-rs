import Split.HMul_hMul
import Split.Mul
import Split.HasDistribNeg
import Split.HasDistribNeg_toInvolutiveNeg
import Split.InvolutiveNeg_toNeg
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg
import Split.mul_neg
import Split.instHMul

-- neg_mul_eq_mul_neg from environment
-- theorem neg_mul_eq_mul_neg : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.4 : Mul.{u} α] [inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.7 : HasDistribNeg.{u} α inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.4] (a : α) (b : α), Eq.{succ u} α (Neg.neg.{u} α (InvolutiveNeg.toNeg.{u} α (HasDistribNeg.toInvolutiveNeg.{u} α inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.7)) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.4) a b)) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.4) a (Neg.neg.{u} α (InvolutiveNeg.toNeg.{u} α (HasDistribNeg.toInvolutiveNeg.{u} α inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Ring.Defs.3841758585._hygCtx._hyg.7)) b))

-- Stub: this file represents the declaration `neg_mul_eq_mul_neg`.
-- In a full split, the body would be extracted from the environment.
