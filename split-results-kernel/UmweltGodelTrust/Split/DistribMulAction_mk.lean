import Split.Monoid
import Split.instHSMul
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.MulAction
import Split.AddMonoid
import Split.Monoid_toSemigroup
import Split.DistribMulAction
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.SemigroupAction_toSMul
import Split.MulAction_toSemigroupAction
import Split.OfNat_ofNat
import Split.Eq

-- DistribMulAction.mk from environment
-- constructor DistribMulAction.mk : forall {M : Type.{u_12}} {A : Type.{u_13}} [inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 : Monoid.{u_12} M] [inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29 : AddMonoid.{u_13} A] [toMulAction : MulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26], (forall (a : M), Eq.{succ u_13} A (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 toMulAction))) a (OfNat.ofNat.{u_13} A 0 (Zero.toOfNat0.{u_13} A (AddZero.toZero.{u_13} A (AddZeroClass.toAddZero.{u_13} A (AddMonoid.toAddZeroClass.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29)))))) (OfNat.ofNat.{u_13} A 0 (Zero.toOfNat0.{u_13} A (AddZero.toZero.{u_13} A (AddZeroClass.toAddZero.{u_13} A (AddMonoid.toAddZeroClass.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29)))))) -> (forall (a : M) (x : A) (y : A), Eq.{succ u_13} A (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 toMulAction))) a (HAdd.hAdd.{u_13, u_13, u_13} A A A (instHAdd.{u_13} A (AddSemigroup.toAdd.{u_13} A (AddMonoid.toAddSemigroup.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29))) x y)) (HAdd.hAdd.{u_13, u_13, u_13} A A A (instHAdd.{u_13} A (AddSemigroup.toAdd.{u_13} A (AddMonoid.toAddSemigroup.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29))) (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 toMulAction))) a x) (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 toMulAction))) a y))) -> (DistribMulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29)

-- Stub: this file represents the declaration `DistribMulAction.mk`.
-- In a full split, the body would be extracted from the environment.
