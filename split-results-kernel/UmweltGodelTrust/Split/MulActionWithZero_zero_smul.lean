import Split.instHSMul
import Split.MulActionWithZero
import Split.MonoidWithZero
import Split.MonoidWithZero_toMulZeroOneClass
import Split.Monoid_toSemigroup
import Split.MulActionWithZero_toMulAction
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.SemigroupAction_toSMul
import Split.MulZeroOneClass_toMulZeroClass
import Split.MulAction_toSemigroupAction
import Split.OfNat_ofNat
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.MulZeroClass_toZero
import Split.Zero

-- MulActionWithZero.zero_smul from environment
-- theorem MulActionWithZero.zero_smul : forall {M₀ : Type.{u_2}} {A : Type.{u_7}} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33 : MonoidWithZero.{u_2} M₀} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39 : Zero.{u_7} A} [self : MulActionWithZero.{u_2, u_7} M₀ A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39] (m : A), Eq.{succ u_7} A (HSMul.hSMul.{u_2, u_7, u_7} M₀ A A (instHSMul.{u_2, u_7} M₀ A (SemigroupAction.toSMul.{u_2, u_7} M₀ A (Monoid.toSemigroup.{u_2} M₀ (MonoidWithZero.toMonoid.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33)) (MulAction.toSemigroupAction.{u_2, u_7} M₀ A (MonoidWithZero.toMonoid.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33) (MulActionWithZero.toMulAction.{u_2, u_7} M₀ A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39 self)))) (OfNat.ofNat.{u_2} M₀ 0 (Zero.toOfNat0.{u_2} M₀ (MulZeroClass.toZero.{u_2} M₀ (MulZeroOneClass.toMulZeroClass.{u_2} M₀ (MonoidWithZero.toMulZeroOneClass.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33))))) m) (OfNat.ofNat.{u_7} A 0 (Zero.toOfNat0.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39))

-- Stub: this file represents the declaration `MulActionWithZero.zero_smul`.
-- In a full split, the body would be extracted from the environment.
