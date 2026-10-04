import Mathlib

set_option pp.all true
-- spec: Pow.pow : forall {α : Type.{u}} {β : Type.{v}} [self : Pow.{u, v} α β], α -> β -> α
def Pow.pow : forall {α : Type.{u}} {β : Type.{v}} [self : Pow.{u, v} α β], α -> β -> α :=
  fun (α : Type.{u}) (β : Type.{v}) [self : Pow.{u, v} α β] => self.1
