import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.congrArg
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddGroup
import Split.Iff
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.propext
import Split.AddZero_toAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.add_neg_eq_iff_eq_add
import Split.Neg_neg

-- sub_eq_iff_eq_add from environment
-- theorem sub_eq_iff_eq_add : forall {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Group.Basic.4098405997._hygCtx._hyg.6 : AddGroup.{u_3} G] {a : G} {b : G} {c : G}, Iff (Eq.{succ u_3} G (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.4098405997._hygCtx._hyg.6))) a b) c) (Eq.{succ u_3} G a (HAdd.hAdd.{u_3, u_3, u_3} G G G (instHAdd.{u_3} G (AddZero.toAdd.{u_3} G (AddZeroClass.toAddZero.{u_3} G (AddMonoid.toAddZeroClass.{u_3} G (SubNegMonoid.toAddMonoid.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.4098405997._hygCtx._hyg.6)))))) c b))

-- Stub: this file represents the declaration `sub_eq_iff_eq_add`.
-- In a full split, the body would be extracted from the environment.
