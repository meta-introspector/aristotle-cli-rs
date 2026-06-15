import Split.List_cons
import Split.List
import Split.And
import Split.And_intro
import Split.eq_of_heq
import Split.HEq
import Split.Eq
import Split.List_cons_noConfusion

-- List.cons.inj from environment
-- theorem List.cons.inj : forall {α : Type.{u}} {head : α} {tail : List.{u} α} {head_1 : α} {tail_1 : List.{u} α}, (Eq.{succ u} (List.{u} α) (List.cons.{u} α head tail) (List.cons.{u} α head_1 tail_1)) -> (And (Eq.{succ u} α head head_1) (Eq.{succ u} (List.{u} α) tail tail_1))

-- Stub: this file represents the declaration `List.cons.inj`.
-- In a full split, the body would be extracted from the environment.
