import Mathlib

set_option pp.all true
-- spec: List.IsPrefix : forall {α : Type.{u}}, (List.{u} α) -> (List.{u} α) -> Prop
def List.IsPrefix : forall {α : Type.{u}}, (List.{u} α) -> (List.{u} α) -> Prop :=
  fun {α : Type.{u}} (l₁ : List.{u} α) (l₂ : List.{u} α) => Exists.{succ u} (List.{u} α) (fun (t : List.{u} α) => Eq.{succ u} (List.{u} α) (HAppend.hAppend.{u, u, u} (List.{u} α) (List.{u} α) (List.{u} α) (instHAppendOfAppend.{u} (List.{u} α) (List.instAppend.{u} α)) l₁ t) l₂)
