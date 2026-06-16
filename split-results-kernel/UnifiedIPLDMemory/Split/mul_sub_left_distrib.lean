import Split.NonUnitalNonAssocRing
import Split.Distrib_leftDistribClass
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.HMul_hMul
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.AddCommGroup_toAddGroup
import Split.AddZeroClass_toAddZero
import Split.id
import Split.Distrib_toAdd
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.NonUnitalNonAssocRing_toHasDistribNeg
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.neg_mul_eq_mul_neg
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.congr
import Split.MulZeroClass_negZeroClass
import Split.SubNegMonoid_toNeg
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.AddZero_toAdd
import Split.mul_add
import Split.HasDistribNeg_toInvolutiveNeg
import Split.SubNegMonoid_toAddMonoid
import Split.InvolutiveNeg_toNeg
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans
import Split.instHMul

-- mul_sub_left_distrib from environment
-- theorem mul_sub_left_distrib : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4 : NonUnitalNonAssocRing.{u} α] (a : α) (b : α) (c : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (Distrib.toMul.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4)))) a (HSub.hSub.{u, u, u} α α α (instHSub.{u} α (SubNegMonoid.toSub.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4))))) b c)) (HSub.hSub.{u, u, u} α α α (instHSub.{u} α (SubNegMonoid.toSub.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α (NonUnitalNonAssocRing.toAddCommGroup.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4))))) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (Distrib.toMul.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4)))) a b) (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (Distrib.toMul.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.56107099._hygCtx._hyg.4)))) a c))

-- Stub: this file represents the declaration `mul_sub_left_distrib`.
-- In a full split, the body would be extracted from the environment.
