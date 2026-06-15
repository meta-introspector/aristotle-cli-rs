import Split.Exists
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.List_casesOn
import Split.List_instAppend
import Split.Eq
import Split.HAppend_hAppend
import Split.List_nil

-- List.forIn'.loop.match_5 from environment
-- def List.forIn'.loop.match_5 : forall {α : Type.{u_1}} {β : Type.{u_3}} (as : List.{u_1} α) (motive : forall (x._@.Init.Data.List.Control.4042975923._hygCtx.52.Init.Data.List.Control.4042975923._hygCtx._hyg.79 : List.{u_1} α), β -> (Exists.{succ u_1} (List.{u_1} α) (fun (bs : List.{u_1} α) => Eq.{succ u_1} (List.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) bs x._@.Init.Data.List.Control.4042975923._hygCtx.52.Init.Data.List.Control.4042975923._hygCtx._hyg.79) as)) -> Sort.{u_2}) (x._@.Init.Data.List.Control.4042975923._hygCtx.52.Init.Data.List.Control.4042975923._hygCtx._hyg.79 : List.{u_1} α) (x._@.Init.Data.List.Control.4042975923._hygCtx.53.Init.Data.List.Control.4042975923._hygCtx._hyg.82 : β) (x._@.Init.Data.List.Control.4042975923._hygCtx.54.Init.Data.List.Control.4042975923._hygCtx._hyg.85 : Exists.{succ u_1} (List.{u_1} α) (fun (bs : List.{u_1} α) => Eq.{succ u_1} (List.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) bs x._@.Init.Data.List.Control.4042975923._hygCtx.52.Init.Data.List.Control.4042975923._hygCtx._hyg.79) as)), (forall (b : β) (x._@.Init.Data.List.Control.4042975923._hygCtx._hyg.96 : Exists.{succ u_1} (List.{u_1} α) (fun (bs : List.{u_1} α) => Eq.{succ u_1} (List.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) bs (List.nil.{u_1} α)) as)), motive (List.nil.{u_1} α) b x._@.Init.Data.List.Control.4042975923._hygCtx._hyg.96) -> (forall (a : α) (as' : List.{u_1} α) (b : β) (h : Exists.{succ u_1} (List.{u_1} α) (fun (bs : List.{u_1} α) => Eq.{succ u_1} (List.{u_1} α) (HAppend.hAppend.{u_1, u_1, u_1} (List.{u_1} α) (List.{u_1} α) (List.{u_1} α) (instHAppendOfAppend.{u_1} (List.{u_1} α) (List.instAppend.{u_1} α)) bs (List.cons.{u_1} α a as')) as)), motive (List.cons.{u_1} α a as') b h) -> (motive x._@.Init.Data.List.Control.4042975923._hygCtx.52.Init.Data.List.Control.4042975923._hygCtx._hyg.79 x._@.Init.Data.List.Control.4042975923._hygCtx.53.Init.Data.List.Control.4042975923._hygCtx._hyg.82 x._@.Init.Data.List.Control.4042975923._hygCtx.54.Init.Data.List.Control.4042975923._hygCtx._hyg.85)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.forIn'.loop.match_5`.
-- In a full split, the body would be extracted from the environment.
