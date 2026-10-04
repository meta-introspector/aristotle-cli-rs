import Mathlib

-- spec: theorem Std.IsLinearOrder.le_total : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3] (a : α) (b : α), Or (LE.le.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 a b) (LE.le.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 b a)
theorem Std.IsLinearOrder.le_total : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3] (a : α) (b : α), Or (LE.le.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 a b) (LE.le.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 b a) :=
  fun (α : Type.{u}) {inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearOrder.{u} α inst._@.Init.Data.Order.Classes.355461848._hygCtx._hyg.3] => self.2
