import Split.Exists
import Split.And
import Split.LT_lt
import Split.DenselyOrdered
import Split.DenselyOrdered_dense
import Split.LT

-- exists_between from environment
-- theorem exists_between : forall {α : Type.{u_2}} [inst._@.Mathlib.Order.Basic.4092149451._hygCtx._hyg.8 : LT.{u_2} α] [inst._@.Mathlib.Order.Basic.4092149451._hygCtx._hyg.11 : DenselyOrdered.{u_2} α inst._@.Mathlib.Order.Basic.4092149451._hygCtx._hyg.8] {a₁ : α} {a₂ : α}, (LT.lt.{u_2} α inst._@.Mathlib.Order.Basic.4092149451._hygCtx._hyg.8 a₁ a₂) -> (Exists.{succ u_2} α (fun (a : α) => And (LT.lt.{u_2} α inst._@.Mathlib.Order.Basic.4092149451._hygCtx._hyg.8 a₁ a) (LT.lt.{u_2} α inst._@.Mathlib.Order.Basic.4092149451._hygCtx._hyg.8 a a₂)))

-- Stub: this file represents the declaration `exists_between`.
-- In a full split, the body would be extracted from the environment.
