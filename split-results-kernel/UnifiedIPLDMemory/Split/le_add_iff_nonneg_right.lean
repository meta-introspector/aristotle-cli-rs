import Split.Eq_mpr
import Split.congrArg
import Split.Iff_rfl
import Split.add_le_add_iff_left
import Split.AddLeftMono
import Split.AddZeroClass_toAddZero
import Split.id
import Split.LE_le
import Split.LE
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.Iff
import Split.HAdd_hAdd
import Split.Iff_trans
import Split.AddLeftReflectLE
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.add_zero
import Split.OfNat_ofNat
import Split.Eq

-- le_add_iff_nonneg_right from environment
-- theorem le_add_iff_nonneg_right : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.4 : AddZeroClass.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.7 : LE.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.10 : AddLeftMono.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.4)) inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.7] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.13 : AddLeftReflectLE.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.4)) inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.7] (a : α) {b : α}, Iff (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.7 a (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.4))) a b)) (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.7 (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (AddZero.toZero.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3816281102._hygCtx._hyg.4)))) b)

-- Stub: this file represents the declaration `le_add_iff_nonneg_right`.
-- In a full split, the body would be extracted from the environment.
