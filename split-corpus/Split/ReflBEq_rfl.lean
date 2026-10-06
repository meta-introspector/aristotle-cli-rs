import Mathlib

-- spec: theorem ReflBEq.rfl : forall {α : Type.{u_1}} {inst._@.Init.Core.616482424._hygCtx._hyg.3 : BEq.{u_1} α} [self : ReflBEq.{u_1} α inst._@.Init.Core.616482424._hygCtx._hyg.3] {a : α}, Eq.{1} Bool (BEq.beq.{u_1} α inst._@.Init.Core.616482424._hygCtx._hyg.3 a a) Bool.true
theorem ReflBEq.rfl : forall {α : Type.{u_1}} {inst._@.Init.Core.616482424._hygCtx._hyg.3 : BEq.{u_1} α} [self : ReflBEq.{u_1} α inst._@.Init.Core.616482424._hygCtx._hyg.3] {a : α}, Eq.{1} Bool (BEq.beq.{u_1} α inst._@.Init.Core.616482424._hygCtx._hyg.3 a a) Bool.true :=
  fun (α : Type.{u_1}) {inst._@.Init.Core.616482424._hygCtx._hyg.3 : BEq.{u_1} α} [self : ReflBEq.{u_1} α inst._@.Init.Core.616482424._hygCtx._hyg.3] => self.1
