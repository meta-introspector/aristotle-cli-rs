import Split.HSub_hSub
import Split.OrderedSub
import Split.LE_le
import Split.LE
import Split.instHAdd
import Split.Iff
import Split.instHSub
import Split.HAdd_hAdd
import Split.OrderedSub_tsub_le_iff_right
import Split.Add
import Split.Sub

-- tsub_le_iff_right from environment
-- theorem tsub_le_iff_right : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.3 : LE.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.6 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.9 : Sub.{u_1} α] [inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.12 : OrderedSub.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.9] {a : α} {b : α} {c : α}, Iff (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.3 (HSub.hSub.{u_1, u_1, u_1} α α α (instHSub.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.9) a b) c) (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.3 a (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Sub.Defs.3276953686._hygCtx._hyg.6) c b))

-- Stub: this file represents the declaration `tsub_le_iff_right`.
-- In a full split, the body would be extracted from the environment.
