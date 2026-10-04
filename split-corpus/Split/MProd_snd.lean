import Mathlib

set_option pp.all true
-- spec: MProd.snd : forall {α : Type.{u}} {β : Type.{u}}, (MProd.{u} α β) -> β
def MProd.snd : forall {α : Type.{u}} {β : Type.{u}}, (MProd.{u} α β) -> β :=
  fun (α : Type.{u}) (β : Type.{u}) (self : MProd.{u} α β) => self.2
