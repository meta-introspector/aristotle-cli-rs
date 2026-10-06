import Mathlib

set_option pp.all true
-- spec: instToFormatOfToString : forall {α : Type.{u_1}} [inst._@.Init.Data.Format.Instances.2069425524._hygCtx._hyg.5 : ToString.{u_1} α], Std.ToFormat.{u_1} α
def instToFormatOfToString : forall {α : Type.{u_1}} [inst._@.Init.Data.Format.Instances.2069425524._hygCtx._hyg.5 : ToString.{u_1} α], Std.ToFormat.{u_1} α :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Format.Instances.2069425524._hygCtx._hyg.5 : ToString.{u_1} α] => Std.ToFormat.mk.{u_1} α (Function.comp.{succ u_1, 1, 1} α String Std.Format Std.Format.text (ToString.toString.{u_1} α inst._@.Init.Data.Format.Instances.2069425524._hygCtx._hyg.5))
