import Mathlib

-- spec: recursor Prod.rec : forall {α : Type.{u}} {β : Type.{v}} {motive : (Prod.{u, v} α β) -> Sort.{u_1}}, (forall (fst : α) (snd : β), motive (Prod.mk.{u, v} α β fst snd)) -> (forall (t : Prod.{u, v} α β), motive t)
