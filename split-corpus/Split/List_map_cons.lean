import Mathlib

-- spec: theorem List.map_cons : forall {α : Type.{u}} {β : Type.{v}} {f : α -> β} {a : α} {l : List.{u} α}, Eq.{succ v} (List.{v} β) (List.map.{u, v} α β f (List.cons.{u} α a l)) (List.cons.{v} β (f a) (List.map.{u, v} α β f l))
theorem List.map_cons : forall {α : Type.{u}} {β : Type.{v}} {f : α -> β} {a : α} {l : List.{u} α}, Eq.{succ v} (List.{v} β) (List.map.{u, v} α β f (List.cons.{u} α a l)) (List.cons.{v} β (f a) (List.map.{u, v} α β f l)) :=
  fun {α : Type.{u}} {β : Type.{v}} {f : α -> β} {a : α} {l : List.{u} α} => rfl.{succ v} (List.{v} β) (List.map.{u, v} α β f (List.cons.{u} α a l))
