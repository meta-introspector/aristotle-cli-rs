import Split.List_sum
import Split.List_cons
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Eq
import Split.Add
import Split.rfl
import Split.Zero

-- List.sum_cons from environment
-- theorem List.sum_cons : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.1872549848._hygCtx._hyg.5 : Add.{u} α] [inst._@.Init.Data.List.Basic.1872549848._hygCtx._hyg.8 : Zero.{u} α] {a : α} {l : List.{u} α}, Eq.{succ u} α (List.sum.{u} α inst._@.Init.Data.List.Basic.1872549848._hygCtx._hyg.5 inst._@.Init.Data.List.Basic.1872549848._hygCtx._hyg.8 (List.cons.{u} α a l)) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α inst._@.Init.Data.List.Basic.1872549848._hygCtx._hyg.5) a (List.sum.{u} α inst._@.Init.Data.List.Basic.1872549848._hygCtx._hyg.5 inst._@.Init.Data.List.Basic.1872549848._hygCtx._hyg.8 l))

-- Stub: this file represents the declaration `List.sum_cons`.
-- In a full split, the body would be extracted from the environment.
