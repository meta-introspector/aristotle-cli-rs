import Mathlib

-- spec: theorem LawfulBEq.eq_of_beq : forall {α : Type.{u}} {inst._@.Init.Core.2400486342._hygCtx._hyg.3 : BEq.{u} α} [self : LawfulBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3] {a : α} {b : α}, (Eq.{1} Bool (BEq.beq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3 a b) Bool.true) -> (Eq.{succ u} α a b)
theorem LawfulBEq.eq_of_beq : forall {α : Type.{u}} {inst._@.Init.Core.2400486342._hygCtx._hyg.3 : BEq.{u} α} [self : LawfulBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3] {a : α} {b : α}, (Eq.{1} Bool (BEq.beq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3 a b) Bool.true) -> (Eq.{succ u} α a b) :=
  fun (α : Type.{u}) {inst._@.Init.Core.2400486342._hygCtx._hyg.3 : BEq.{u} α} [self : LawfulBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3] => self.2
