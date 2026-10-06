import Mathlib

-- spec: theorem Std.IsLinearOrder.toIsPartialOrder : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3], Std.IsPartialOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3
theorem Std.IsLinearOrder.toIsPartialOrder : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3], Std.IsPartialOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 :=
  fun (α : Type.{u}) {inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3] => self.1
