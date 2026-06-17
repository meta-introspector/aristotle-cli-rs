import Split.id
import Split.List_cons
import Split.List
import Split.heq_of_eq
import Split.List_noConfusion
import Split.Eq_refl
import Split.HEq
import Split.Eq

-- List.cons.noConfusion from environment
-- def List.cons.noConfusion : forall {α : Type.{u}} {P : Sort.{u_1}} {head : α} {tail : List.{u} α} {head' : α} {tail' : List.{u} α}, (Eq.{succ u} (List.{u} α) (List.cons.{u} α head tail) (List.cons.{u} α head' tail')) -> ((HEq.{succ u} α head α head') -> (HEq.{succ u} (List.{u} α) tail (List.{u} α) tail') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `List.cons.noConfusion`.
-- In a full split, the body would be extracted from the environment.
