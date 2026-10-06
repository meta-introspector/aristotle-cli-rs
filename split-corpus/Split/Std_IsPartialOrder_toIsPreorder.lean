import Mathlib

-- spec: theorem Std.IsPartialOrder.toIsPreorder : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsPartialOrder.{u} α inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3], Std.IsPreorder.{u} α inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3
theorem Std.IsPartialOrder.toIsPreorder : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsPartialOrder.{u} α inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3], Std.IsPreorder.{u} α inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3 :=
  fun (α : Type.{u}) {inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsPartialOrder.{u} α inst._@.Init.Data.Order.Classes.569721259._hygCtx._hyg.3] => self.1
