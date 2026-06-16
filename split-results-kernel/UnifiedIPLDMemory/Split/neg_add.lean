import Split.neg_add_rev
import Split.NegZeroClass_toNeg
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.add_comm
import Split.SubtractionCommMonoid_toAddCommMonoid
import Split.instHAdd
import Split.HAdd_hAdd
import Split.True
import Split.eq_self
import Split.SubNegMonoid_toNeg
import Split.of_eq_true
import Split.AddZero_toAdd
import Split.congrFun'
import Split.AddCommSemigroup_toAddCommMagma
import Split.SubNegMonoid_toAddMonoid
import Split.SubtractionCommMonoid
import Split.AddCommMonoid_toAddCommSemigroup
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans
import Split.AddCommMagma_toAdd

-- neg_add from environment
-- theorem neg_add : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Basic.951690345._hygCtx._hyg.6 : SubtractionCommMonoid.{u_1} α] (a : α) (b : α), Eq.{succ u_1} α (Neg.neg.{u_1} α (NegZeroClass.toNeg.{u_1} α (SubNegZeroMonoid.toNegZeroClass.{u_1} α (SubtractionMonoid.toSubNegZeroMonoid.{u_1} α (SubtractionCommMonoid.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.951690345._hygCtx._hyg.6)))) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α (SubtractionCommMonoid.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.951690345._hygCtx._hyg.6))))))) a b)) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α (SubtractionCommMonoid.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.951690345._hygCtx._hyg.6))))))) (Neg.neg.{u_1} α (NegZeroClass.toNeg.{u_1} α (SubNegZeroMonoid.toNegZeroClass.{u_1} α (SubtractionMonoid.toSubNegZeroMonoid.{u_1} α (SubtractionCommMonoid.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.951690345._hygCtx._hyg.6)))) a) (Neg.neg.{u_1} α (NegZeroClass.toNeg.{u_1} α (SubNegZeroMonoid.toNegZeroClass.{u_1} α (SubtractionMonoid.toSubNegZeroMonoid.{u_1} α (SubtractionCommMonoid.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.951690345._hygCtx._hyg.6)))) b))

-- Stub: this file represents the declaration `neg_add`.
-- In a full split, the body would be extracted from the environment.
