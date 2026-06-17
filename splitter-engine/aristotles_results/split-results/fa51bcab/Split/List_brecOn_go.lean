import Split.PProd_mk
import Split.List_rec
import Split.List_cons
import Split.List
import Split.PProd
import Split.PUnit
import Split.List_below
import Split.PUnit_unit
import Split.List_nil

-- List.brecOn.go from environment
-- def List.brecOn.go : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α), (forall (t : List.{u} α), (List.below.{u_1, u} α motive t) -> (motive t)) -> (PProd.{u_1, max (succ u) u_1} (motive t) (List.below.{u_1, u} α motive t))
-- (definition body omitted)

-- Stub: this file represents the declaration `List.brecOn.go`.
-- In a full split, the body would be extracted from the environment.
