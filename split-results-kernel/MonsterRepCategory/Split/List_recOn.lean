import Split.List_rec
import Split.List_cons
import Split.List
import Split.List_nil

-- List.recOn from environment
-- def List.recOn : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α), (motive (List.nil.{u} α)) -> (forall (head : α) (tail : List.{u} α), (motive tail) -> (motive (List.cons.{u} α head tail))) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.recOn`.
-- In a full split, the body would be extracted from the environment.
