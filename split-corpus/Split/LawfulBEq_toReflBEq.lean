import Mathlib

-- spec: theorem LawfulBEq.toReflBEq : forall {α : Type.{u}} {inst._@.Init.Core.2400486342._hygCtx._hyg.3 : BEq.{u} α} [self : LawfulBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3], ReflBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3
theorem LawfulBEq.toReflBEq : forall {α : Type.{u}} {inst._@.Init.Core.2400486342._hygCtx._hyg.3 : BEq.{u} α} [self : LawfulBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3], ReflBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3 :=
  fun (α : Type.{u}) {inst._@.Init.Core.2400486342._hygCtx._hyg.3 : BEq.{u} α} [self : LawfulBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3] => self.1
