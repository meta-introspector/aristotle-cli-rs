import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddCommMonoid_toAddMonoid
import Split.NonUnitalNonAssocSemiring
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocSemiring.left_distrib from environment
-- theorem NonUnitalNonAssocSemiring.left_distrib : forall {α : Type.{u}} [self : NonUnitalNonAssocSemiring.{u} α] (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α self)) a (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α self))))) b c)) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (AddCommMonoid.toAddMonoid.{u} α (NonUnitalNonAssocSemiring.toAddCommMonoid.{u} α self))))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α self)) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocSemiring.toMul.{u} α self)) a c))

-- Stub: this file represents the declaration `NonUnitalNonAssocSemiring.left_distrib`.
-- In a full split, the body would be extracted from the environment.
