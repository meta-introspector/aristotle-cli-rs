import Split.Monoid
import Split.instHSMul
import Split.AddMonoid_toAddSemigroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddMonoid
import Split.Monoid_toSemigroup
import Split.DistribMulAction
import Split.HSMul_hSMul
import Split.SemigroupAction_toSMul
import Split.MulAction_toSemigroupAction
import Split.Eq
import Split.DistribMulAction_toMulAction

-- DistribMulAction.smul_add from environment
-- theorem DistribMulAction.smul_add : forall {M : Type.{u_12}} {A : Type.{u_13}} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 : Monoid.{u_12} M} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29 : AddMonoid.{u_13} A} [self : DistribMulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29] (a : M) (x : A) (y : A), Eq.{succ u_13} A (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 (DistribMulAction.toMulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29 self)))) a (HAdd.hAdd.{u_13, u_13, u_13} A A A (instHAdd.{u_13} A (AddSemigroup.toAdd.{u_13} A (AddMonoid.toAddSemigroup.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29))) x y)) (HAdd.hAdd.{u_13, u_13, u_13} A A A (instHAdd.{u_13} A (AddSemigroup.toAdd.{u_13} A (AddMonoid.toAddSemigroup.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29))) (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 (DistribMulAction.toMulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29 self)))) a x) (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 (DistribMulAction.toMulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29 self)))) a y))

-- Stub: this file represents the declaration `DistribMulAction.smul_add`.
-- In a full split, the body would be extracted from the environment.
