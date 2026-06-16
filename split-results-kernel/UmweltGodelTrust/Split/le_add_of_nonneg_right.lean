import Split.Trans_trans
import Split.AddLeftMono
import Split.AddZeroClass_toAddZero
import Split.add_le_add_right
import Split.LE_le
import Split.LE
import Split.instTransEq
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddZeroClass
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.add_zero
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq

-- le_add_of_nonneg_right from environment
-- theorem le_add_of_nonneg_right : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.4 : AddZeroClass.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.7 : LE.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.10 : AddLeftMono.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.4)) inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.7] {a : α} {b : α}, (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.7 (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (AddZero.toZero.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.4)))) b) -> (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.7 a (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1292438938._hygCtx._hyg.4))) a b))

-- Stub: this file represents the declaration `le_add_of_nonneg_right`.
-- In a full split, the body would be extracted from the environment.
