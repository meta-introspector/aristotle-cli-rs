import Split.List_Mem_tail
import Split.List_Mem_rec
import Split.List_cons
import Split.List
import Split.List_Mem_head
import Split.List_Mem

-- List.Mem.casesOn from environment
-- def List.Mem.casesOn : forall {α : Type.{u}} {a : α} {motive : forall (a._@._internal._hyg.0 : List.{u} α), (List.Mem.{u} α a a._@._internal._hyg.0) -> Prop} {a._@._internal._hyg.0 : List.{u} α} (t : List.Mem.{u} α a a._@._internal._hyg.0), (forall (as : List.{u} α), motive (List.cons.{u} α a as) (List.Mem.head.{u} α a as)) -> (forall (b : α) {as : List.{u} α} (a._@._internal._hyg.0 : List.Mem.{u} α a as), motive (List.cons.{u} α b as) (List.Mem.tail.{u} α a b as a._@._internal._hyg.0)) -> (motive a._@._internal._hyg.0 t)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.Mem.casesOn`.
-- In a full split, the body would be extracted from the environment.
