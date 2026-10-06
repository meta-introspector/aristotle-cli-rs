import Mathlib

set_option pp.all true
-- spec: Dvd.dvd : forall {α : Type.{u_1}} [self : Dvd.{u_1} α], α -> α -> Prop
def Dvd.dvd : forall {α : Type.{u_1}} [self : Dvd.{u_1} α], α -> α -> Prop :=
  fun (α : Type.{u_1}) [self : Dvd.{u_1} α] => self.1
