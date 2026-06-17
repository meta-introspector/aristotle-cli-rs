import Split.GroupWithZero_toMonoidWithZero
import Split.MulOne_toOne
import Split.False
import Split.DivInvMonoid_toInv
import Split.Trans_trans
import Split.HMul_hMul
import Split.GroupWithZero_toDivInvMonoid
import Split.eq_false
import Split.mul_inv_cancel₀
import Split.MulZeroClass_toMul
import Split.congrArg
import Split.mul_assoc
import Split.GroupWithZero
import Split.SemigroupWithZero_toSemigroup
import Split.Ne
import Split.MulZeroOneClass_toMulOneClass
import Split.instTransEq
import Split.MonoidWithZero_toSemigroupWithZero
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.MonoidWithZero_toMulZeroOneClass
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.congrFun'
import Split.MulZeroOneClass_toMulZeroClass
import Split.mul_one
import Split.OfNat_ofNat
import Split.not_false_eq_true
import Split.Eq
import Split.Not
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_inv_cancel_right₀ from environment
-- theorem mul_inv_cancel_right₀ : forall {G₀ : Type.{u}} [inst._@.Mathlib.Algebra.GroupWithZero.Defs.2270217239._hygCtx._hyg.4 : GroupWithZero.{u} G₀] {b : G₀}, (Ne.{succ u} G₀ b (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MulZeroClass.toZero.{u} G₀ (MulZeroOneClass.toMulZeroClass.{u} G₀ (MonoidWithZero.toMulZeroOneClass.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2270217239._hygCtx._hyg.4))))))) -> (forall (a : G₀), Eq.{succ u} G₀ (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (MulZeroClass.toMul.{u} G₀ (MulZeroOneClass.toMulZeroClass.{u} G₀ (MonoidWithZero.toMulZeroOneClass.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2270217239._hygCtx._hyg.4))))) (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (MulZeroClass.toMul.{u} G₀ (MulZeroOneClass.toMulZeroClass.{u} G₀ (MonoidWithZero.toMulZeroOneClass.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2270217239._hygCtx._hyg.4))))) a b) (Inv.inv.{u} G₀ (DivInvMonoid.toInv.{u} G₀ (GroupWithZero.toDivInvMonoid.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.2270217239._hygCtx._hyg.4)) b)) a)

-- Stub: this file represents the declaration `mul_inv_cancel_right₀`.
-- In a full split, the body would be extracted from the environment.
