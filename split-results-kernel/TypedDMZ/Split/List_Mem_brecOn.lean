import Split.List_Mem_below_head
import Split.List_Mem_rec
import Split.List
import Split.List_Mem_below_tail
import Split.List_Mem_below
import Split.List_Mem

-- List.Mem.brecOn from environment
-- theorem List.Mem.brecOn : forall {α : Type.{u}} {a : α} {motive : forall (a._@._internal._hyg.0 : List.{u} α), (List.Mem.{u} α a a._@._internal._hyg.0) -> Prop} {a._@._internal._hyg.0 : List.{u} α} (t : List.Mem.{u} α a a._@._internal._hyg.0), (forall (a._@._internal._hyg.0 : List.{u} α) (t : List.Mem.{u} α a a._@._internal._hyg.0), (List.Mem.below.{u} α a motive a._@._internal._hyg.0 t) -> (motive a._@._internal._hyg.0 t)) -> (motive a._@._internal._hyg.0 t)

-- Stub: this file represents the declaration `List.Mem.brecOn`.
-- In a full split, the body would be extracted from the environment.
