import Mathlib

set_option pp.all true
-- spec: ReprTuple.reprTuple : forall {α : Type.{u}} [self : ReprTuple.{u} α], α -> (List.{0} Std.Format) -> (List.{0} Std.Format)
def ReprTuple.reprTuple : forall {α : Type.{u}} [self : ReprTuple.{u} α], α -> (List.{0} Std.Format) -> (List.{0} Std.Format) :=
  fun (α : Type.{u}) [self : ReprTuple.{u} α] => self.1
