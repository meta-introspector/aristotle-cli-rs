import Mathlib

-- spec: theorem List.flatMap_nil : forall {α : Type.{u}} {β : Type.{v}} {f : α -> (List.{v} β)}, Eq.{succ v} (List.{v} β) (List.flatMap.{u, v} α β f (List.nil.{u} α)) (List.nil.{v} β)
theorem List.flatMap_nil : forall {α : Type.{u}} {β : Type.{v}} {f : α -> (List.{v} β)}, Eq.{succ v} (List.{v} β) (List.flatMap.{u, v} α β f (List.nil.{u} α)) (List.nil.{v} β) :=
  fun {α : Type.{u}} {β : Type.{v}} {f : α -> (List.{v} β)} => of_eq_true (Eq.{succ v} (List.{v} β) (List.nil.{v} β) (List.nil.{v} β)) (eq_self.{succ v} (List.{v} β) (List.nil.{v} β))
