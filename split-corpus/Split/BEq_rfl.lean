import Mathlib

-- spec: theorem BEq.rfl : forall {α : Type.{u_1}} [inst._@.Init.Core.4264954151._hygCtx._hyg.5 : BEq.{u_1} α] [inst._@.Init.Core.4264954151._hygCtx._hyg.8 : ReflBEq.{u_1} α inst._@.Init.Core.4264954151._hygCtx._hyg.5] {a : α}, Eq.{1} Bool (BEq.beq.{u_1} α inst._@.Init.Core.4264954151._hygCtx._hyg.5 a a) Bool.true
theorem BEq.rfl : forall {α : Type.{u_1}} [inst._@.Init.Core.4264954151._hygCtx._hyg.5 : BEq.{u_1} α] [inst._@.Init.Core.4264954151._hygCtx._hyg.8 : ReflBEq.{u_1} α inst._@.Init.Core.4264954151._hygCtx._hyg.5] {a : α}, Eq.{1} Bool (BEq.beq.{u_1} α inst._@.Init.Core.4264954151._hygCtx._hyg.5 a a) Bool.true :=
  fun {α : Type.{u_1}} [inst._@.Init.Core.4264954151._hygCtx._hyg.5 : BEq.{u_1} α] [inst._@.Init.Core.4264954151._hygCtx._hyg.8 : ReflBEq.{u_1} α inst._@.Init.Core.4264954151._hygCtx._hyg.5] {a : α} => ReflBEq.rfl.{u_1} α inst._@.Init.Core.4264954151._hygCtx._hyg.5 inst._@.Init.Core.4264954151._hygCtx._hyg.8 a
