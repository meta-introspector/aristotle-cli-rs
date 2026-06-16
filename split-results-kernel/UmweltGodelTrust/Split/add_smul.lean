import Split.instHSMul
import Split.DistribMulAction_toDistribSMul
import Split.Module_add_smul
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.Distrib_toAdd
import Split.DistribSMul_toSMulZeroClass
import Split.AddCommMonoid
import Split.AddZero_toZero
import Split.instHAdd
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.HSMul_hSMul
import Split.Module_toDistribMulAction
import Split.SMulZeroClass_toSMul
import Split.AddCommMonoid_toAddMonoid
import Split.AddCommSemigroup_toAddCommMagma
import Split.Module
import Split.AddCommMonoid_toAddCommSemigroup
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.AddCommMagma_toAdd
import Split.Semiring_toMonoidWithZero

-- add_smul from environment
-- theorem add_smul : forall {R : Type.{u_1}} {M : Type.{u_3}} [inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6 : Semiring.{u_1} R] [inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9 : AddCommMonoid.{u_3} M] [inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.12 : Module.{u_1, u_3} R M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9] (r : R) (s : R) (x : M), Eq.{succ u_3} M (HSMul.hSMul.{u_1, u_3, u_3} R M M (instHSMul.{u_1, u_3} R M (SMulZeroClass.toSMul.{u_1, u_3} R M (AddZero.toZero.{u_3} M (AddZeroClass.toAddZero.{u_3} M (AddMonoid.toAddZeroClass.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9)))) (DistribSMul.toSMulZeroClass.{u_1, u_3} R M (AddMonoid.toAddZeroClass.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9)) (DistribMulAction.toDistribSMul.{u_1, u_3} R M (MonoidWithZero.toMonoid.{u_1} R (Semiring.toMonoidWithZero.{u_1} R inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6)) (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9) (Module.toDistribMulAction.{u_1, u_3} R M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9 inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.12))))) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (Distrib.toAdd.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} R (Semiring.toNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6))))) r s) x) (HAdd.hAdd.{u_3, u_3, u_3} M M M (instHAdd.{u_3} M (AddCommMagma.toAdd.{u_3} M (AddCommSemigroup.toAddCommMagma.{u_3} M (AddCommMonoid.toAddCommSemigroup.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9)))) (HSMul.hSMul.{u_1, u_3, u_3} R M M (instHSMul.{u_1, u_3} R M (SMulZeroClass.toSMul.{u_1, u_3} R M (AddZero.toZero.{u_3} M (AddZeroClass.toAddZero.{u_3} M (AddMonoid.toAddZeroClass.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9)))) (DistribSMul.toSMulZeroClass.{u_1, u_3} R M (AddMonoid.toAddZeroClass.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9)) (DistribMulAction.toDistribSMul.{u_1, u_3} R M (MonoidWithZero.toMonoid.{u_1} R (Semiring.toMonoidWithZero.{u_1} R inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6)) (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9) (Module.toDistribMulAction.{u_1, u_3} R M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9 inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.12))))) r x) (HSMul.hSMul.{u_1, u_3, u_3} R M M (instHSMul.{u_1, u_3} R M (SMulZeroClass.toSMul.{u_1, u_3} R M (AddZero.toZero.{u_3} M (AddZeroClass.toAddZero.{u_3} M (AddMonoid.toAddZeroClass.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9)))) (DistribSMul.toSMulZeroClass.{u_1, u_3} R M (AddMonoid.toAddZeroClass.{u_3} M (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9)) (DistribMulAction.toDistribSMul.{u_1, u_3} R M (MonoidWithZero.toMonoid.{u_1} R (Semiring.toMonoidWithZero.{u_1} R inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6)) (AddCommMonoid.toAddMonoid.{u_3} M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9) (Module.toDistribMulAction.{u_1, u_3} R M inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.9 inst._@.Mathlib.Algebra.Module.Defs.1263408075._hygCtx._hyg.12))))) s x))

-- Stub: this file represents the declaration `add_smul`.
-- In a full split, the body would be extracted from the environment.
