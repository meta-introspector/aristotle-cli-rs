import Split.NonUnitalNonAssocRing
import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.NonUnitalNonAssocRing_toMul
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.AddCommGroup_toAddGroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.instHMul

-- NonUnitalNonAssocRing.right_distrib from environment
-- theorem NonUnitalNonAssocRing.right_distrib : forall {α : Type.{u}} [self : NonUnitalNonAssocRing.{u} α] (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α self)) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α self))))))) a b) c) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddSemigroup.toAdd.{u} α (AddMonoid.toAddSemigroup.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α self))))))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α self)) a c) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (NonUnitalNonAssocRing.toMul.{u} α self)) b c))

-- Stub: this file represents the declaration `NonUnitalNonAssocRing.right_distrib`.
-- In a full split, the body would be extracted from the environment.
