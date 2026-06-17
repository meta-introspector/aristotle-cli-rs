import Split.GroupWithZero_toMonoidWithZero
import Split.MulOne_toOne
import Split.False
import Split.Semigroup_toMul
import Split.DivInvMonoid_toInv
import Split.Trans_trans
import Split.HMul_hMul
import Split.GroupWithZero_toDivInvMonoid
import Split.eq_false
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
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.not_false_eq_true
import Split.Eq
import Split.inv_mul_cancel₀
import Split.Not
import Split.one_mul
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul

-- inv_mul_cancel_left₀ from environment
-- theorem inv_mul_cancel_left₀ : forall {G₀ : Type.{u_2}} [inst._@.Mathlib.Algebra.GroupWithZero.Basic.2641191993._hygCtx._hyg.4 : GroupWithZero.{u_2} G₀] {a : G₀}, (Ne.{succ u_2} G₀ a (OfNat.ofNat.{u_2} G₀ 0 (Zero.toOfNat0.{u_2} G₀ (MulZeroClass.toZero.{u_2} G₀ (MulZeroOneClass.toMulZeroClass.{u_2} G₀ (MonoidWithZero.toMulZeroOneClass.{u_2} G₀ (GroupWithZero.toMonoidWithZero.{u_2} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.2641191993._hygCtx._hyg.4))))))) -> (forall (b : G₀), Eq.{succ u_2} G₀ (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (MulZeroClass.toMul.{u_2} G₀ (MulZeroOneClass.toMulZeroClass.{u_2} G₀ (MonoidWithZero.toMulZeroOneClass.{u_2} G₀ (GroupWithZero.toMonoidWithZero.{u_2} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.2641191993._hygCtx._hyg.4))))) (Inv.inv.{u_2} G₀ (DivInvMonoid.toInv.{u_2} G₀ (GroupWithZero.toDivInvMonoid.{u_2} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.2641191993._hygCtx._hyg.4)) a) (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (MulZeroClass.toMul.{u_2} G₀ (MulZeroOneClass.toMulZeroClass.{u_2} G₀ (MonoidWithZero.toMulZeroOneClass.{u_2} G₀ (GroupWithZero.toMonoidWithZero.{u_2} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Basic.2641191993._hygCtx._hyg.4))))) a b)) b)

-- Stub: this file represents the declaration `inv_mul_cancel_left₀`.
-- In a full split, the body would be extracted from the environment.
