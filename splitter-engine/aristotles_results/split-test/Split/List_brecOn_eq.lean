import Split.List_brecOn
import Split.List_brecOn_go
import Split.List_cons
import Split.List
import Split.List_casesOn
import Split.List_below
import Split.Eq_refl
import Split.Eq
import Split.List_nil

-- List.brecOn.eq from environment
-- theorem List.brecOn.eq : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}} (t : List.{u} α) (F_1 : forall (t : List.{u} α), (List.below.{u_1, u} α motive t) -> (motive t)), Eq.{u_1} (motive t) (List.brecOn.{u_1, u} α motive t F_1) (F_1 t ((List.brecOn.go.{u_1, u} α motive t F_1).2))

-- Stub: this file represents the declaration `List.brecOn.eq`.
-- In a full split, the body would be extracted from the environment.
