import Split.List_cons
import Split.List
import Split.List_nil

-- List.rec from environment
-- recursor List.rec : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}}, (motive (List.nil.{u} α)) -> (forall (head : α) (tail : List.{u} α), (motive tail) -> (motive (List.cons.{u} α head tail))) -> (forall (t : List.{u} α), motive t)

-- Stub: this file represents the declaration `List.rec`.
-- In a full split, the body would be extracted from the environment.
