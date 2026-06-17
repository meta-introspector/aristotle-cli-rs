import Split.HMul_hMul
import Split.Mul
import Split.InvolutiveNeg
import Split.HasDistribNeg
import Split.InvolutiveNeg_toNeg
import Split.Eq
import Split.Neg_neg
import Split.instHMul

-- HasDistribNeg.mk from environment
-- constructor HasDistribNeg.mk : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7 : Mul.{u_1} α] [toInvolutiveNeg : InvolutiveNeg.{u_1} α], (forall (x : α) (y : α), Eq.{succ u_1} α (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7) (Neg.neg.{u_1} α (InvolutiveNeg.toNeg.{u_1} α toInvolutiveNeg) x) y) (Neg.neg.{u_1} α (InvolutiveNeg.toNeg.{u_1} α toInvolutiveNeg) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7) x y))) -> (forall (x : α) (y : α), Eq.{succ u_1} α (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7) x (Neg.neg.{u_1} α (InvolutiveNeg.toNeg.{u_1} α toInvolutiveNeg) y)) (Neg.neg.{u_1} α (InvolutiveNeg.toNeg.{u_1} α toInvolutiveNeg) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7) x y))) -> (HasDistribNeg.{u_1} α inst._@.Mathlib.Algebra.Ring.Defs.3533514249._hygCtx._hyg.7)

-- Stub: this file represents the declaration `HasDistribNeg.mk`.
-- In a full split, the body would be extracted from the environment.
