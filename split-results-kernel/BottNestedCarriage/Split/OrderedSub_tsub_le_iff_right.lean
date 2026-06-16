import Split.HSub_hSub
import Split.OrderedSub
import Split.LE_le
import Split.LE
import Split.instHAdd
import Split.Iff
import Split.instHSub
import Split.HAdd_hAdd
import Split.Add
import Split.Sub

-- OrderedSub.tsub_le_iff_right from environment
-- theorem OrderedSub.tsub_le_iff_right : forall {α : Type.{u_2}} {inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.5 : LE.{u_2} α} {inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.8 : Add.{u_2} α} {inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.11 : Sub.{u_2} α} [self : OrderedSub.{u_2} α inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.5 inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.8 inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.11] (a : α) (b : α) (c : α), Iff (LE.le.{u_2} α inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.5 (HSub.hSub.{u_2, u_2, u_2} α α α (instHSub.{u_2} α inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.11) a b) c) (LE.le.{u_2} α inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.5 a (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α inst._@.Mathlib.Algebra.Order.Sub.Defs.1819901011._hygCtx._hyg.8) c b))

-- Stub: this file represents the declaration `OrderedSub.tsub_le_iff_right`.
-- In a full split, the body would be extracted from the environment.
