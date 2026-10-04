import Mathlib

-- spec: theorem Std.IsPreorder.le_refl : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsPreorder.{u} α inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3] (a : α), LE.le.{u} α inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3 a a
theorem Std.IsPreorder.le_refl : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsPreorder.{u} α inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3] (a : α), LE.le.{u} α inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3 a a :=
  fun (α : Type.{u}) {inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsPreorder.{u} α inst._@.Init.Data.Order.Classes.3671837007._hygCtx._hyg.3] => self.1
