import Split.LE_le
import Split.Std_LawfulOrderLT
import Split.LE
import Split.And
import Split.Iff
import Split.LT_lt
import Split.Std_LawfulOrderLT_mk
import Split.Not
import Split.LT

-- Std.LawfulOrderLT.of_le from environment
-- theorem Std.LawfulOrderLT.of_le : forall {α : Type.{u}} [inst._@.Init.Data.Order.Factories.819826713._hygCtx._hyg.3 : LT.{u} α] [inst._@.Init.Data.Order.Factories.819826713._hygCtx._hyg.6 : LE.{u} α], (forall (a : α) (b : α), Iff (LT.lt.{u} α inst._@.Init.Data.Order.Factories.819826713._hygCtx._hyg.3 a b) (And (LE.le.{u} α inst._@.Init.Data.Order.Factories.819826713._hygCtx._hyg.6 a b) (Not (LE.le.{u} α inst._@.Init.Data.Order.Factories.819826713._hygCtx._hyg.6 b a)))) -> (Std.LawfulOrderLT.{u} α inst._@.Init.Data.Order.Factories.819826713._hygCtx._hyg.3 inst._@.Init.Data.Order.Factories.819826713._hygCtx._hyg.6)

-- Stub: this file represents the declaration `Std.LawfulOrderLT.of_le`.
-- In a full split, the body would be extracted from the environment.
