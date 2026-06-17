import Split.id
import Split.Array
import Split.List
import Split.heq_of_eq
import Split.Array_noConfusion
import Split.Eq_refl
import Split.HEq
import Split.Array_mk
import Split.Eq

-- Array.mk.noConfusion from environment
-- def Array.mk.noConfusion : forall {α : Type.{u}} {P : Sort.{u_1}} {toList : List.{u} α} {toList' : List.{u} α}, (Eq.{succ u} (Array.{u} α) (Array.mk.{u} α toList) (Array.mk.{u} α toList')) -> ((HEq.{succ u} (List.{u} α) toList (List.{u} α) toList') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
