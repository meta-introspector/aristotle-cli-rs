import Split.Monoid
import Split.instHSMul
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.AddZero_toZero
import Split.AddMonoid
import Split.Monoid_toSemigroup
import Split.DistribMulAction
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.SemigroupAction_toSMul
import Split.MulAction_toSemigroupAction
import Split.OfNat_ofNat
import Split.Eq
import Split.DistribMulAction_toMulAction

-- DistribMulAction.smul_zero from environment
-- theorem DistribMulAction.smul_zero : forall {M : Type.{u_12}} {A : Type.{u_13}} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 : Monoid.{u_12} M} {inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29 : AddMonoid.{u_13} A} [self : DistribMulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29] (a : M), Eq.{succ u_13} A (HSMul.hSMul.{u_12, u_13, u_13} M A A (instHSMul.{u_12, u_13} M A (SemigroupAction.toSMul.{u_12, u_13} M A (Monoid.toSemigroup.{u_12} M inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26) (MulAction.toSemigroupAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 (DistribMulAction.toMulAction.{u_12, u_13} M A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.26 inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29 self)))) a (OfNat.ofNat.{u_13} A 0 (Zero.toOfNat0.{u_13} A (AddZero.toZero.{u_13} A (AddZeroClass.toAddZero.{u_13} A (AddMonoid.toAddZeroClass.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29)))))) (OfNat.ofNat.{u_13} A 0 (Zero.toOfNat0.{u_13} A (AddZero.toZero.{u_13} A (AddZeroClass.toAddZero.{u_13} A (AddMonoid.toAddZeroClass.{u_13} A inst._@.Mathlib.Algebra.GroupWithZero.Action.Defs.998956751._hygCtx._hyg.29)))))

-- Stub: this file represents the declaration `DistribMulAction.smul_zero`.
-- In a full split, the body would be extracted from the environment.
