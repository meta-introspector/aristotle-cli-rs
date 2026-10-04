import Mathlib

set_option pp.all true
-- spec: Prod.snd : forall {α : Type.{u}} {β : Type.{v}}, (Prod.{u, v} α β) -> β
def Prod.snd : forall {α : Type.{u}} {β : Type.{v}}, (Prod.{u, v} α β) -> β :=
  fun (α : Type.{u}) (β : Type.{v}) (self : Prod.{u, v} α β) => self.2
