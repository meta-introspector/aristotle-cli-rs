import Split.instHSMul
import Split.MulActionWithZero
import Split.MonoidWithZero
import Split.Monoid_toSemigroup
import Split.MulActionWithZero_toMulAction
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.SemigroupAction_toSMul
import Split.MulAction_toSemigroupAction
import Split.OfNat_ofNat
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.Zero

-- MulActionWithZero.smul_zero from environment
-- theorem MulActionWithZero.smul_zero : forall {M₀ : Type.{u_2}} {A : Type.{u_7}} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33 : MonoidWithZero.{u_2} M₀} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39 : Zero.{u_7} A} [self : MulActionWithZero.{u_2, u_7} M₀ A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39] (r : M₀), Eq.{succ u_7} A (HSMul.hSMul.{u_2, u_7, u_7} M₀ A A (instHSMul.{u_2, u_7} M₀ A (SemigroupAction.toSMul.{u_2, u_7} M₀ A (Monoid.toSemigroup.{u_2} M₀ (MonoidWithZero.toMonoid.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33)) (MulAction.toSemigroupAction.{u_2, u_7} M₀ A (MonoidWithZero.toMonoid.{u_2} M₀ inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33) (MulActionWithZero.toMulAction.{u_2, u_7} M₀ A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.33 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39 self)))) r (OfNat.ofNat.{u_7} A 0 (Zero.toOfNat0.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39))) (OfNat.ofNat.{u_7} A 0 (Zero.toOfNat0.{u_7} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.1186469257._hygCtx._hyg.39))

-- Stub: this file represents the declaration `MulActionWithZero.smul_zero`.
-- In a full split, the body would be extracted from the environment.
