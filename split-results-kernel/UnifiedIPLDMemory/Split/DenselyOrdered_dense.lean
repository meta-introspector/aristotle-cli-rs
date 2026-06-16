import Split.Exists
import Split.And
import Split.LT_lt
import Split.DenselyOrdered
import Split.LT

-- DenselyOrdered.dense from environment
-- theorem DenselyOrdered.dense : forall {α : Type.{u_5}} {inst._@.Mathlib.Order.Basic.1728271617._hygCtx._hyg.15 : LT.{u_5} α} [self : DenselyOrdered.{u_5} α inst._@.Mathlib.Order.Basic.1728271617._hygCtx._hyg.15] (a₁ : α) (a₂ : α), (LT.lt.{u_5} α inst._@.Mathlib.Order.Basic.1728271617._hygCtx._hyg.15 a₁ a₂) -> (Exists.{succ u_5} α (fun (a : α) => And (LT.lt.{u_5} α inst._@.Mathlib.Order.Basic.1728271617._hygCtx._hyg.15 a₁ a) (LT.lt.{u_5} α inst._@.Mathlib.Order.Basic.1728271617._hygCtx._hyg.15 a a₂)))

-- Stub: this file represents the declaration `DenselyOrdered.dense`.
-- In a full split, the body would be extracted from the environment.
