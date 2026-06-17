import Split.HMul_hMul
import Split.Mul
import Split.HasDistribNeg
import Split.HasDistribNeg_toInvolutiveNeg
import Split.InvolutiveNeg_toNeg
import Split.Eq
import Split.Neg_neg
import Split.instHMul

-- HasDistribNeg.mul_neg from environment
-- theorem HasDistribNeg.mul_neg : forall {α : Type.{u_1}} {inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7 : Mul.{u_1} α} [self : HasDistribNeg.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7] (x : α) (y : α), Eq.{succ u_1} α (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7) x (Neg.neg.{u_1} α (InvolutiveNeg.toNeg.{u_1} α (HasDistribNeg.toInvolutiveNeg.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7 self)) y)) (Neg.neg.{u_1} α (InvolutiveNeg.toNeg.{u_1} α (HasDistribNeg.toInvolutiveNeg.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7 self)) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7) x y))

-- Stub: this file represents the declaration `HasDistribNeg.mul_neg`.
-- In a full split, the body would be extracted from the environment.
