import Mathlib

set_option pp.all true
-- spec: Std.Rio.upper : forall {α : Type.{u}}, (Std.Rio.{u} α) -> α
def Std.Rio.upper : forall {α : Type.{u}}, (Std.Rio.{u} α) -> α :=
  fun (α : Type.{u}) (self : Std.Rio.{u} α) => self.1
