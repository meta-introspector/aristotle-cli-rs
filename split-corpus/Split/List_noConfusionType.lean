import Mathlib

set_option pp.all true
-- spec: List.noConfusionType : Sort.{u_1} -> (forall {α : Type.{u}}, (List.{u} α) -> (forall {α' : Type.{u}}, (List.{u} α') -> Sort.{u_1}))
def List.noConfusionType : Sort.{u_1} -> (forall {α : Type.{u}}, (List.{u} α) -> (forall {α' : Type.{u}}, (List.{u} α') -> Sort.{u_1})) :=
  fun (P : Sort.{u_1}) {α : Type.{u}} (t : List.{u} α) {α' : Type.{u}} (t' : List.{u} α') => List.casesOn.{succ u_1, u} α (fun (t : List.{u} α) => Sort.{u_1}) t (List.casesOn.{succ u_1, u} α' (fun (t : List.{u} α') => Sort.{u_1}) t' (P -> P) (fun (head : α') (tail : List.{u} α') => P)) (fun (head : α) (tail : List.{u} α) => List.casesOn.{succ u_1, u} α' (fun (t : List.{u} α') => Sort.{u_1}) t' P (fun (head_1 : α') (tail_1 : List.{u} α') => ((HEq.{succ u} α head α' head_1) -> (HEq.{succ u} (List.{u} α) tail (List.{u} α') tail_1) -> P) -> P))
