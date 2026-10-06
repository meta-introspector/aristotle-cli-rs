import Mathlib

-- spec: theorem Std.IsLinearPreorder.toIsPreorder : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearPreorder.{u} α inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3], Std.IsPreorder.{u} α inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3
theorem Std.IsLinearPreorder.toIsPreorder : forall {α : Type.{u}} {inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearPreorder.{u} α inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3], Std.IsPreorder.{u} α inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3 :=
  fun (α : Type.{u}) {inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3 : LE.{u} α} [self : Std.IsLinearPreorder.{u} α inst._@.Init.Data.Order.Classes.1822583122._hygCtx._hyg.3] => self.1
