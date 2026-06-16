import Split.MulOne_toOne
import Split.HMul_hMul
import Split.congrArg
import Split.MulOne_toMul
import Split.MulOneClass_toMulOne
import Split.True
import Split.eq_self
import Split.HasDistribNeg
import Split.of_eq_true
import Split.One_toOfNat1
import Split.neg_mul
import Split.congrFun'
import Split.HasDistribNeg_toInvolutiveNeg
import Split.MulOneClass
import Split.InvolutiveNeg_toNeg
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg
import Split.one_mul
import Split.Eq_trans
import Split.instHMul

-- neg_one_mul from environment
-- theorem neg_one_mul : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.4 : MulOneClass.{u} α] [inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.7 : HasDistribNeg.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.4))] (a : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.4))) (Neg.neg.{u} α (InvolutiveNeg.toNeg.{u} α (HasDistribNeg.toInvolutiveNeg.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.4)) inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.7)) (OfNat.ofNat.{u} α 1 (One.toOfNat1.{u} α (MulOne.toOne.{u} α (MulOneClass.toMulOne.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.4))))) a) (Neg.neg.{u} α (InvolutiveNeg.toNeg.{u} α (HasDistribNeg.toInvolutiveNeg.{u} α (MulOne.toMul.{u} α (MulOneClass.toMulOne.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.4)) inst._@.Mathlib.Algebra.Ring.Defs.2455946936._hygCtx._hyg.7)) a)

-- Stub: this file represents the declaration `neg_one_mul`.
-- In a full split, the body would be extracted from the environment.
