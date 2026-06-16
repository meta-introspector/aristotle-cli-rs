import Split.instHSMul
import Split.Distrib_toAdd
import Split.AddCommMonoid
import Split.instHAdd
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Monoid_toSemigroup
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.HSMul_hSMul
import Split.Module_toDistribMulAction
import Split.SemigroupAction_toSMul
import Split.AddCommMonoid_toAddMonoid
import Split.AddCommSemigroup_toAddCommMagma
import Split.Module
import Split.MulAction_toSemigroupAction
import Split.AddCommMonoid_toAddCommSemigroup
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.AddCommMagma_toAdd
import Split.DistribMulAction_toMulAction
import Split.Semiring_toMonoidWithZero

-- Module.add_smul from environment
-- theorem Module.add_smul : forall {R : Type.{u}} {M : Type.{v}} {inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 : Semiring.{u} R} {inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15 : AddCommMonoid.{v} M} [self : Module.{u, v} R M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15] (r : R) (s : R) (x : M), Eq.{succ v} M (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) (Module.toDistribMulAction.{u, v} R M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15 self))))) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (Distrib.toAdd.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))))) r s) x) (HAdd.hAdd.{v, v, v} M M M (instHAdd.{v} M (AddCommMagma.toAdd.{v} M (AddCommSemigroup.toAddCommMagma.{v} M (AddCommMonoid.toAddCommSemigroup.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15)))) (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) (Module.toDistribMulAction.{u, v} R M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15 self))))) r x) (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) (Module.toDistribMulAction.{u, v} R M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15 self))))) s x))

-- Stub: this file represents the declaration `Module.add_smul`.
-- In a full split, the body would be extracted from the environment.
