import Mathlib

set_option pp.all true
-- spec: Std.Slice.internalRepresentation : forall {γ : Type.{u}}, (Std.Slice.{u} γ) -> γ
def Std.Slice.internalRepresentation : forall {γ : Type.{u}}, (Std.Slice.{u} γ) -> γ :=
  fun (γ : Type.{u}) (self : Std.Slice.{u} γ) => self.1
