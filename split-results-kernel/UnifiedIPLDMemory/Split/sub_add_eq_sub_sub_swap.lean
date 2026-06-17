import Split.neg_add_rev
import Split.AddMonoid_toAddSemigroup
import Split.congrArg
import Split.add_assoc
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.SubtractionMonoid
import Split.congr
import Split.True
import Split.eq_self
import Split.SubNegMonoid_toNeg
import Split.of_eq_true
import Split.AddZero_toAdd
import Split.congrFun'
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans

-- sub_add_eq_sub_sub_swap from environment
-- theorem sub_add_eq_sub_sub_swap : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Basic.1895008692._hygCtx._hyg.6 : SubtractionMonoid.{u_1} α] (a : α) (b : α) (c : α), Eq.{succ u_1} α (HSub.hSub.{u_1, u_1, u_1} α α α (instHSub.{u_1} α (SubNegMonoid.toSub.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.1895008692._hygCtx._hyg.6))) a (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.1895008692._hygCtx._hyg.6)))))) b c)) (HSub.hSub.{u_1, u_1, u_1} α α α (instHSub.{u_1} α (SubNegMonoid.toSub.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.1895008692._hygCtx._hyg.6))) (HSub.hSub.{u_1, u_1, u_1} α α α (instHSub.{u_1} α (SubNegMonoid.toSub.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.1895008692._hygCtx._hyg.6))) a c) b)

-- Stub: this file represents the declaration `sub_add_eq_sub_sub_swap`.
-- In a full split, the body would be extracted from the environment.
