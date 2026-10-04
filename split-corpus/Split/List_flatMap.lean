import Mathlib

set_option pp.all true
-- spec: List.flatMap : forall {α : Type.{u}} {β : Type.{v}}, (α -> (List.{v} β)) -> (List.{u} α) -> (List.{v} β)
def List.flatMap : forall {α : Type.{u}} {β : Type.{v}}, (α -> (List.{v} β)) -> (List.{u} α) -> (List.{v} β) :=
  fun {α : Type.{u}} {β : Type.{v}} (b : α -> (List.{v} β)) (as : List.{u} α) => List.flatten.{v} β (List.map.{u, v} α (List.{v} β) b as)
