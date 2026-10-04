import Mathlib

set_option pp.all true
-- spec: Std.Shrink.inflate : forall {α : Type.{u_1}}, (Std.Shrink.{u_1} α) -> α
def Std.Shrink.inflate : forall {α : Type.{u_1}}, (Std.Shrink.{u_1} α) -> α :=
  fun {α : Type.{u_1}} (x : Std.Shrink.{u_1} α) => cast.{succ u_1} (Std.Shrink.{u_1} α) α (_private.Init.Data.Iterators.Basic.0.Std.Shrink.inflate._proof_1.{u_1} α) x
