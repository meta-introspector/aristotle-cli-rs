import Mathlib

-- spec: theorem EquivBEq.toReflBEq : forall {α : Type.{u_1}} {inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3 : BEq.{u_1} α} [self : EquivBEq.{u_1} α inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3], ReflBEq.{u_1} α inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3
theorem EquivBEq.toReflBEq : forall {α : Type.{u_1}} {inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3 : BEq.{u_1} α} [self : EquivBEq.{u_1} α inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3], ReflBEq.{u_1} α inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3 :=
  fun (α : Type.{u_1}) {inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3 : BEq.{u_1} α} [self : EquivBEq.{u_1} α inst._@.Init.Data.BEq.1926014564._hygCtx._hyg.3] => self.2
