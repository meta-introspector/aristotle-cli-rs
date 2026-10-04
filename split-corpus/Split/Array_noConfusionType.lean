import Mathlib

set_option pp.all true
-- spec: Array.noConfusionType : Sort.{u_1} -> (forall {α : Type.{u}}, (Array.{u} α) -> (forall {α' : Type.{u}}, (Array.{u} α') -> Sort.{u_1}))
def Array.noConfusionType : Sort.{u_1} -> (forall {α : Type.{u}}, (Array.{u} α) -> (forall {α' : Type.{u}}, (Array.{u} α') -> Sort.{u_1})) :=
  fun (P : Sort.{u_1}) {α : Type.{u}} (t : Array.{u} α) {α' : Type.{u}} (t' : Array.{u} α') => Array.casesOn.{succ u_1, u} α (fun (t : Array.{u} α) => Sort.{u_1}) t (fun (toList : List.{u} α) => Array.casesOn.{succ u_1, u} α' (fun (t : Array.{u} α') => Sort.{u_1}) t' (fun (toList_1 : List.{u} α') => ((HEq.{succ u} (List.{u} α) toList (List.{u} α') toList_1) -> P) -> P))
