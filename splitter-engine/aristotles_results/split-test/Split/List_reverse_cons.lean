import Split.Eq_mpr
import Split.congrArg
import Split.List_reverseAux
import Split.id
import Split.List_cons
import Split.instHAppendOfAppend
import Split.List
import Split.List_reverse
import Split.Eq_refl
import Split.List_instAppend
import Split.Eq_symm
import Split.Eq
import Split.List_reverseAux_eq_append
import Split.HAppend_hAppend
import Split.List_nil

-- List.reverse_cons from environment
-- theorem List.reverse_cons : forall {α : Type.{u}} {a : α} {as : List.{u} α}, Eq.{succ u} (List.{u} α) (List.reverse.{u} α (List.cons.{u} α a as)) (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) (List.reverse.{u} α as) (List.cons.{u} α a (List.nil.{u} α)))

-- Stub: this file represents the declaration `List.reverse_cons`.
-- In a full split, the body would be extracted from the environment.
