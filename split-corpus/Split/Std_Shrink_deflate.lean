import Mathlib

set_option pp.all true
-- spec: Std.Shrink.deflate : forall {α : Type.{u_1}}, α -> (Std.Shrink.{u_1} α)
def Std.Shrink.deflate : forall {α : Type.{u_1}}, α -> (Std.Shrink.{u_1} α) :=
  fun {α : Type.{u_1}} (x : α) => cast.{succ u_1} α (Std.Shrink.{u_1} α) (_private.Init.Data.Iterators.Basic.0.Std.Shrink.deflate._proof_1.{u_1} α) x
