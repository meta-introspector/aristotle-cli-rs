import Mathlib

set_option pp.all true
-- spec: Option.noConfusionType : Sort.{u_1} -> (forall {α : Type.{u}}, (Option.{u} α) -> (forall {α' : Type.{u}}, (Option.{u} α') -> Sort.{u_1}))
def Option.noConfusionType : Sort.{u_1} -> (forall {α : Type.{u}}, (Option.{u} α) -> (forall {α' : Type.{u}}, (Option.{u} α') -> Sort.{u_1})) :=
  fun (P : Sort.{u_1}) {α : Type.{u}} (t : Option.{u} α) {α' : Type.{u}} (t' : Option.{u} α') => Option.casesOn.{succ u_1, u} α (fun (t : Option.{u} α) => Sort.{u_1}) t (Option.casesOn.{succ u_1, u} α' (fun (t : Option.{u} α') => Sort.{u_1}) t' (P -> P) (fun (val : α') => P)) (fun (val : α) => Option.casesOn.{succ u_1, u} α' (fun (t : Option.{u} α') => Sort.{u_1}) t' P (fun (val_1 : α') => ((HEq.{succ u} α val α' val_1) -> P) -> P))
