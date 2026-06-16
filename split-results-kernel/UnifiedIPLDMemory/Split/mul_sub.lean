import Split.NonUnitalNonAssocRing
import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.HSub_hSub
import Split.AddCommGroup_toAddGroup
import Split.mul_sub_left_distrib
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.SubNegMonoid_toSub
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Distrib_toMul
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Eq
import Split.instHMul

-- mul_sub from environment
-- theorem mul_sub : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4 : NonUnitalNonAssocRing.{u} α] (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (Distrib.toMul.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4)))) a (HSub.hSub.{u, u, u} α α α (instHSub.{u} α (SubNegMonoid.toSub.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4))))) b c)) (HSub.hSub.{u, u, u} α α α (instHSub.{u} α (SubNegMonoid.toSub.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4))))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (Distrib.toMul.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4)))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (Distrib.toMul.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4)))) a c))

-- Stub: this file represents the declaration `mul_sub`.
-- In a full split, the body would be extracted from the environment.
