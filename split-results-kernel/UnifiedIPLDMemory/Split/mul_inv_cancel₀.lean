import Split.GroupWithZero_toMonoidWithZero
import Split.MulOne_toOne
import Split.DivInvMonoid_toInv
import Split.HMul_hMul
import Split.GroupWithZero_toDivInvMonoid
import Split.MulZeroClass_toMul
import Split.GroupWithZero_mul_inv_cancel
import Split.GroupWithZero
import Split.Ne
import Split.MulZeroOneClass_toMulOneClass
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.MonoidWithZero_toMulZeroOneClass
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_inv_cancel₀ from environment
-- theorem mul_inv_cancel₀ : forall {G₀ : Type.{u}} [inst._@.Mathlib.Algebra.GroupWithZero.Defs.419229688._hygCtx._hyg.4 : GroupWithZero.{u} G₀] {a : G₀}, (Ne.{succ u} G₀ a (OfNat.ofNat.{u} G₀ 0 (Zero.toOfNat0.{u} G₀ (MulZeroClass.toZero.{u} G₀ (MulZeroOneClass.toMulZeroClass.{u} G₀ (MonoidWithZero.toMulZeroOneClass.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.419229688._hygCtx._hyg.4))))))) -> (Eq.{succ u} G₀ (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (MulZeroClass.toMul.{u} G₀ (MulZeroOneClass.toMulZeroClass.{u} G₀ (MonoidWithZero.toMulZeroOneClass.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.419229688._hygCtx._hyg.4))))) a (Inv.inv.{u} G₀ (DivInvMonoid.toInv.{u} G₀ (GroupWithZero.toDivInvMonoid.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.419229688._hygCtx._hyg.4)) a)) (OfNat.ofNat.{u} G₀ 1 (One.toOfNat1.{u} G₀ (MulOne.toOne.{u} G₀ (MulOneClass.toMulOne.{u} G₀ (MulZeroOneClass.toMulOneClass.{u} G₀ (MonoidWithZero.toMulZeroOneClass.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Defs.419229688._hygCtx._hyg.4))))))))

-- Stub: this file represents the declaration `mul_inv_cancel₀`.
-- In a full split, the body would be extracted from the environment.
