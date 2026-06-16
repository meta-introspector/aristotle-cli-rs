import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.congrArg
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.AddRightStrictMono
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.zero_add
import Split.SubNegMonoid_toSub
import Split.AddGroup_covconv_swap
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddGroup
import Split.Iff
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.LT_lt
import Split.neg_add_cancel_right
import Split.SubNegMonoid_toNeg
import Split.propext
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.NegZeroClass_toZero
import Split.Eq
import Split.add_lt_add_iff_right
import Split.Neg_neg
import Split.LT

-- sub_pos from environment
-- theorem sub_pos : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.3 : AddGroup.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.6 : LT.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.9 : AddRightStrictMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.3))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.6] {a : α} {b : α}, Iff (LT.lt.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.6 (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (NegZeroClass.toZero.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.3)))))) (HSub.hSub.{u, u, u} α α α (instHSub.{u} α (SubNegMonoid.toSub.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.3))) a b)) (LT.lt.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2302521188._hygCtx._hyg.6 b a)

-- Stub: this file represents the declaration `sub_pos`.
-- In a full split, the body would be extracted from the environment.
