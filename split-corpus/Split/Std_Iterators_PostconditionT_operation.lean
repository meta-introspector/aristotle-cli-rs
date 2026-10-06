import Mathlib

set_option pp.all true
-- spec: Std.Iterators.PostconditionT.operation : forall {m : Type.{w} -> Type.{w'}} {α : Type.{w}} (self : Std.Iterators.PostconditionT.{w, w'} m α), m (Subtype.{succ w} α (Std.Iterators.PostconditionT.Property.{w, w'} m α self))
def Std.Iterators.PostconditionT.operation : forall {m : Type.{w} -> Type.{w'}} {α : Type.{w}} (self : Std.Iterators.PostconditionT.{w, w'} m α), m (Subtype.{succ w} α (Std.Iterators.PostconditionT.Property.{w, w'} m α self)) :=
  fun (m : Type.{w} -> Type.{w'}) (α : Type.{w}) (self : Std.Iterators.PostconditionT.{w, w'} m α) => self.2
