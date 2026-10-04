import Mathlib

-- spec: recursor List.rec : forall {α : Type.{u}} {motive : (List.{u} α) -> Sort.{u_1}}, (motive (List.nil.{u} α)) -> (forall (head : α) (tail : List.{u} α), (motive tail) -> (motive (List.cons.{u} α head tail))) -> (forall (t : List.{u} α), motive t)
