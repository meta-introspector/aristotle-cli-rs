import Split.instHSMul
import Split.AddMonoid_toAddZeroClass
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.AddZeroClass_toAddZero
import Split.AddCommMonoid
import Split.AddZero_toZero
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Monoid_toSemigroup
import Split.Semiring
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.Module_toDistribMulAction
import Split.SemigroupAction_toSMul
import Split.AddCommMonoid_toAddMonoid
import Split.Module
import Split.MulAction_toSemigroupAction
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.MulZeroClass_toZero
import Split.DistribMulAction_toMulAction
import Split.Semiring_toMonoidWithZero

-- Module.zero_smul from environment
-- theorem Module.zero_smul : forall {R : Type.{u}} {M : Type.{v}} {inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 : Semiring.{u} R} {inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15 : AddCommMonoid.{v} M} [self : Module.{u, v} R M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15] (x : M), Eq.{succ v} M (HSMul.hSMul.{u, v, v} R M M (instHSMul.{u, v} R M (SemigroupAction.toSMul.{u, v} R M (Monoid.toSemigroup.{u} R (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12))) (MulAction.toSemigroupAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (DistribMulAction.toMulAction.{u, v} R M (MonoidWithZero.toMonoid.{u} R (Semiring.toMonoidWithZero.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)) (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15) (Module.toDistribMulAction.{u, v} R M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15 self))))) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (MulZeroClass.toZero.{u} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} R (Semiring.toNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.12)))))) x) (OfNat.ofNat.{v} M 0 (Zero.toOfNat0.{v} M (AddZero.toZero.{v} M (AddZeroClass.toAddZero.{v} M (AddMonoid.toAddZeroClass.{v} M (AddCommMonoid.toAddMonoid.{v} M inst._@.Mathlib.Algebra.Module.Defs.2274493915._hygCtx._hyg.15))))))

-- Stub: this file represents the declaration `Module.zero_smul`.
-- In a full split, the body would be extracted from the environment.
