import Split.GroupWithZero_toMonoidWithZero
import Split.GroupWithZero_toDivisionMonoid
import Split.InvOneClass_toOne
import Split.HMul_hMul
import Split.DivInvOneMonoid_toInvOneClass
import Split.Ring_toNonAssocRing
import Split.MulZeroClass_toMul
import Split.AddGroupWithOne_toAddGroup
import Split.HSub_hSub
import Split.DivisionSemiring_toGroupWithZero
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.invOf_sub_invOf
import Split.DivisionRing_toDivisionSemiring
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.Ne
import Split.DivisionRing_toRing
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.SubNegMonoid_toSub
import Split.instHSub
import Split.Inv_inv
import Split.AddGroup_toSubNegMonoid
import Split.MonoidWithZero_toMulZeroOneClass
import Split.Distrib_toMul
import Split.Invertible
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.DivisionRing
import Split.InvOneClass_toInv
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.invertibleOfNonzero
import Split.Ring_toAddGroupWithOne
import Split.MulZeroClass_toZero
import Split.instHMul

-- inv_sub_inv' from environment
-- theorem inv_sub_inv' : forall {K : Type.{u_1}} [inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4 : DivisionRing.{u_1} K] {a : K} {b : K}, (Ne.{succ u_1} K a (OfNat.ofNat.{u_1} K 0 (Zero.toOfNat0.{u_1} K (MulZeroClass.toZero.{u_1} K (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} K (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} K (NonAssocRing.toNonUnitalNonAssocRing.{u_1} K (Ring.toNonAssocRing.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4))))))))) -> (Ne.{succ u_1} K b (OfNat.ofNat.{u_1} K 0 (Zero.toOfNat0.{u_1} K (MulZeroClass.toZero.{u_1} K (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} K (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} K (NonAssocRing.toNonUnitalNonAssocRing.{u_1} K (Ring.toNonAssocRing.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4))))))))) -> (Eq.{succ u_1} K (HSub.hSub.{u_1, u_1, u_1} K K K (instHSub.{u_1} K (SubNegMonoid.toSub.{u_1} K (AddGroup.toSubNegMonoid.{u_1} K (AddGroupWithOne.toAddGroup.{u_1} K (Ring.toAddGroupWithOne.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4)))))) (Inv.inv.{u_1} K (InvOneClass.toInv.{u_1} K (DivInvOneMonoid.toInvOneClass.{u_1} K (DivisionMonoid.toDivInvOneMonoid.{u_1} K (GroupWithZero.toDivisionMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K (DivisionRing.toDivisionSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4)))))) a) (Inv.inv.{u_1} K (InvOneClass.toInv.{u_1} K (DivInvOneMonoid.toInvOneClass.{u_1} K (DivisionMonoid.toDivInvOneMonoid.{u_1} K (GroupWithZero.toDivisionMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K (DivisionRing.toDivisionSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4)))))) b)) (HMul.hMul.{u_1, u_1, u_1} K K K (instHMul.{u_1} K (Distrib.toMul.{u_1} K (NonUnitalNonAssocSemiring.toDistrib.{u_1} K (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} K (NonAssocRing.toNonUnitalNonAssocRing.{u_1} K (Ring.toNonAssocRing.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4))))))) (HMul.hMul.{u_1, u_1, u_1} K K K (instHMul.{u_1} K (Distrib.toMul.{u_1} K (NonUnitalNonAssocSemiring.toDistrib.{u_1} K (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} K (NonAssocRing.toNonUnitalNonAssocRing.{u_1} K (Ring.toNonAssocRing.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4))))))) (Inv.inv.{u_1} K (InvOneClass.toInv.{u_1} K (DivInvOneMonoid.toInvOneClass.{u_1} K (DivisionMonoid.toDivInvOneMonoid.{u_1} K (GroupWithZero.toDivisionMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K (DivisionRing.toDivisionSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4)))))) a) (HSub.hSub.{u_1, u_1, u_1} K K K (instHSub.{u_1} K (SubNegMonoid.toSub.{u_1} K (AddGroup.toSubNegMonoid.{u_1} K (AddGroupWithOne.toAddGroup.{u_1} K (Ring.toAddGroupWithOne.{u_1} K (DivisionRing.toRing.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4)))))) b a)) (Inv.inv.{u_1} K (InvOneClass.toInv.{u_1} K (DivInvOneMonoid.toInvOneClass.{u_1} K (DivisionMonoid.toDivInvOneMonoid.{u_1} K (GroupWithZero.toDivisionMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K (DivisionRing.toDivisionSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.1121235955._hygCtx._hyg.4)))))) b)))

-- Stub: this file represents the declaration `inv_sub_inv'`.
-- In a full split, the body would be extracted from the environment.
