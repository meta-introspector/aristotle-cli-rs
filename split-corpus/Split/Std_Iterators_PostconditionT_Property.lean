import Mathlib

set_option pp.all true
-- spec: Std.Iterators.PostconditionT.Property : forall {m : Type.{w} -> Type.{w'}} {α : Type.{w}}, (Std.Iterators.PostconditionT.{w, w'} m α) -> α -> Prop
def Std.Iterators.PostconditionT.Property : forall {m : Type.{w} -> Type.{w'}} {α : Type.{w}}, (Std.Iterators.PostconditionT.{w, w'} m α) -> α -> Prop :=
  fun (m : Type.{w} -> Type.{w'}) (α : Type.{w}) (self : Std.Iterators.PostconditionT.{w, w'} m α) => self.1
