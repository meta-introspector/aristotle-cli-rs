import Split.Semigroup_toMul
import Split.instHSMul
import Split.HMul_hMul
import Split.DivisionRing_toRatCast
import Split.Ring_toNonAssocRing
import Split.congrArg
import Split.SMulWithZero_toSMulZeroClass
import Split.IsScalarTower
import Split.AddMonoid_toAddZeroClass
import Split.Rat
import Split.mul_assoc
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.SemigroupWithZero_toSemigroup
import Split.DivisionRing_toDivisionSemiring
import Split.AddZeroClass_toAddZero
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DistribSMul_toSMulZeroClass
import Split.Rat_cast
import Split.DivisionRing_toRing
import Split.NonUnitalSemiring_toSemigroupWithZero
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.AddZero_toZero
import Split.Distrib_toMul
import Split.MulZeroClass_toSMulWithZero
import Split.congr
import Split.True
import Split.eq_self
import Split.Rat_instDistribSMul
import Split.DivisionSemiring_toSemiring
import Split.of_eq_true
import Split.Semiring_toNonUnitalSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.HSMul_hSMul
import Split.DivisionRing
import Split.SMulZeroClass_toSMul
import Split.congrFun'
import Split.IsScalarTower_mk
import Split.AddMonoidWithOne_toAddMonoid
import Split.Eq
import Split.Ring_toAddGroupWithOne
import Split.Rat_smul_def
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul

-- Rat.instIsScalarTowerRight from environment
-- theorem Rat.instIsScalarTowerRight : forall {R : Type.{u_1}} [inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3 : DivisionRing.{u_1} R], IsScalarTower.{0, u_1, u_1} Rat R R (SMulZeroClass.toSMul.{0, u_1} Rat R (AddZero.toZero.{u_1} R (AddZeroClass.toAddZero.{u_1} R (AddMonoid.toAddZeroClass.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3))))))) (DistribSMul.toSMulZeroClass.{0, u_1} Rat R (AddMonoid.toAddZeroClass.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3))))) (Rat.instDistribSMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3))) (SMulZeroClass.toSMul.{u_1, u_1} R R (MulZeroClass.toZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3)))))) (SMulWithZero.toSMulZeroClass.{u_1, u_1} R R (MulZeroClass.toZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3)))))) (MulZeroClass.toZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3)))))) (MulZeroClass.toSMulWithZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3)))))))) (SMulZeroClass.toSMul.{0, u_1} Rat R (AddZero.toZero.{u_1} R (AddZeroClass.toAddZero.{u_1} R (AddMonoid.toAddZeroClass.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3))))))) (DistribSMul.toSMulZeroClass.{0, u_1} Rat R (AddMonoid.toAddZeroClass.{u_1} R (AddMonoidWithOne.toAddMonoid.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R (DivisionRing.toRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3))))) (Rat.instDistribSMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Action.Rat.1491701321._hygCtx._hyg.3)))

-- Stub: this file represents the declaration `Rat.instIsScalarTowerRight`.
-- In a full split, the body would be extracted from the environment.
