import Split.instHSMul
import Split.AddMonoid_toAddZeroClass
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.AddZeroClass_toAddZero
import Split.Distrib_toAdd
import Split.AddCommMonoid
import Split.AddZero_toZero
import Split.instHAdd
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Monoid_toSemigroup
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.DistribMulAction
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.SemigroupAction_toSMul
import Split.AddCommMonoid_toAddMonoid
import Split.AddCommSemigroup_toAddCommMagma
import Split.Module
import Split.MulAction_toSemigroupAction
import Split.OfNat_ofNat
import Split.AddCommMonoid_toAddCommSemigroup
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.MulZeroClass_toZero
import Split.AddCommMagma_toAdd
import Split.DistribMulAction_toMulAction
import Split.Semiring_toMonoidWithZero

-- Module.mk from environment
-- constructor Module.mk : forall {R : Type.{u}} {M : Type.{v}} [inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 : Semiring.{u} R] [inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15 : AddCommMonoid.{v} M] [toDistribMulAction : DistribMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15)], (forall (r : R) (s : R) (x : M), Eq.{succ v} M (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) toDistribMulAction)))) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (Distrib.toAdd.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))))) r s) x) (HAdd.hAdd.{v, v, v} M M M (instHAdd.{v} M (AddCommMagma.toAdd.{v} M (AddCommSemigroup.toAddCommMagma.{v} M (AddCommMonoid.toAddCommSemigroup.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15)))) (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) toDistribMulAction)))) r x) (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) toDistribMulAction)))) s x))) -> (forall (x : M), Eq.{succ v} M (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) toDistribMulAction)))) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (MulZeroClass.toZero.{u} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)))))) x) (OfNat.ofNat.{v} M 0 (Zero.toOfNat0.{v} M (AddZero.toZero.{v} M (AddZeroClass.toAddZero.{v} M (AddMonoid.toAddZeroClass.{v} M (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15))))))) -> (Module.{u, v} R M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15)

-- Stub: this file represents the declaration `Module.mk`.
-- In a full split, the body would be extracted from the environment.
