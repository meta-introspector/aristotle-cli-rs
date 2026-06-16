import Split.Eq_mpr
import Split.GroupWithZero_toMonoidWithZero
import Split.MulOne_toOne
import Split.DivInvMonoid_toInv
import Split.GroupWithZero_toDivisionMonoid
import Split.InvOneClass_toOne
import Split.HMul_hMul
import Split.GroupWithZero_toDivInvMonoid
import Split.eq_inv_of_mul_eq_one_left
import Split.DivInvOneMonoid_toInvOneClass
import Split.MulZeroClass_toMul
import Split.Monoid_toMulOneClass
import Split.congrArg
import Split.inv_zero
import Split.GroupWithZero
import Split.Classical_propDecidable
import Split.MonoidHomClass_toOneHomClass
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.map_zero
import Split.id
import Split.MulOne_toMul
import Split.DivInvMonoid_toMonoid
import Split.MonoidWithZeroHomClass_toMonoidHomClass
import Split.DivisionMonoid_toDivInvMonoid
import Split.dite
import Split.MonoidWithZeroHomClass
import Split.MulZeroOneClass_toMulOneClass
import Split.map_mul
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.MonoidWithZero_toMulZeroOneClass
import Split.map_one
import Split.congr
import Split.True
import Split.eq_self
import Split.MonoidHomClass_toMulHomClass
import Split.of_eq_true
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.InvOneClass_toInv
import Split.MulZeroOneClass_toMulZeroClass
import Split.MonoidWithZeroHomClass_toZeroHomClass
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.DFunLike_coe
import Split.inv_mul_cancel₀
import Split.Not
import Split.Eq_trans
import Split.FunLike
import Split.MulZeroClass_toZero
import Split.instHMul

-- map_inv₀ from environment
-- theorem map_inv₀ : forall {G₀ : Type.{u_3}} {G₀' : Type.{u_5}} {F : Type.{u_6}} [inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.12 : GroupWithZero.{u_3} G₀] [inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.15 : GroupWithZero.{u_5} G₀'] [inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.18 : FunLike.{succ u_6, succ u_3, succ u_5} F G₀ G₀'] [inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.23 : MonoidWithZeroHomClass.{u_6, u_3, u_5} F G₀ G₀' (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.12)) (MonoidWithZero.toMulZeroOneClass.{u_5} G₀' (GroupWithZero.toMonoidWithZero.{u_5} G₀' inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.15)) inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.18] (f : F) (a : G₀), Eq.{succ u_5} G₀' (DFunLike.coe.{succ u_6, succ u_3, succ u_5} F G₀ (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : G₀) => G₀') inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.18 f (Inv.inv.{u_3} G₀ (InvOneClass.toInv.{u_3} G₀ (DivInvOneMonoid.toInvOneClass.{u_3} G₀ (DivisionMonoid.toDivInvOneMonoid.{u_3} G₀ (GroupWithZero.toDivisionMonoid.{u_3} G₀ inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.12)))) a)) (Inv.inv.{u_5} G₀' (InvOneClass.toInv.{u_5} G₀' (DivInvOneMonoid.toInvOneClass.{u_5} G₀' (DivisionMonoid.toDivInvOneMonoid.{u_5} G₀' (GroupWithZero.toDivisionMonoid.{u_5} G₀' inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.15)))) (DFunLike.coe.{succ u_6, succ u_3, succ u_5} F G₀ (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : G₀) => G₀') inst._@.Mathlib.Algebra.GroupWithZero.Units.Lemmas.3869407185._hygCtx._hyg.18 f a))

-- Stub: this file represents the declaration `map_inv₀`.
-- In a full split, the body would be extracted from the environment.
