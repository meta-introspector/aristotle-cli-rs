import Split.LE_le
import Split.Std_LawfulOrderLT
import Split.LE
import Split.And
import Split.Iff
import Split.LT_lt
import Split.Not
import Split.LT

-- Std.LawfulOrderLT.lt_iff from environment
-- theorem Std.LawfulOrderLT.lt_iff : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.1606021098._hygCtx._hyg.3 : LT.{u} α} {inst._@.Init.Data.Order.Classes.1606021098._hygCtx._hyg.6 : LE.{u} α} [self : Std.LawfulOrderLT.{u} α inst._@.Init.Data.Order.Classes.1606021098._hygCtx._hyg.3 inst._@.Init.Data.Order.Classes.1606021098._hygCtx._hyg.6] (a : α) (b : α), Iff (LT.lt.{u} α inst._@.Init.Data.Order.Classes.1606021098._hygCtx._hyg.3 a b) (And (LE.le.{u} α inst._@.Init.Data.Order.Classes.1606021098._hygCtx._hyg.6 a b) (Not (LE.le.{u} α inst._@.Init.Data.Order.Classes.1606021098._hygCtx._hyg.6 b a)))

-- Stub: this file represents the declaration `Std.LawfulOrderLT.lt_iff`.
-- In a full split, the body would be extracted from the environment.
