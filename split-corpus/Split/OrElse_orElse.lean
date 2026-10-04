import Mathlib

set_option pp.all true
-- spec: OrElse.orElse : forall {α : Type.{u}} [self : OrElse.{u} α], α -> (Unit -> α) -> α
def OrElse.orElse : forall {α : Type.{u}} [self : OrElse.{u} α], α -> (Unit -> α) -> α :=
  fun (α : Type.{u}) [self : OrElse.{u} α] => self.1
