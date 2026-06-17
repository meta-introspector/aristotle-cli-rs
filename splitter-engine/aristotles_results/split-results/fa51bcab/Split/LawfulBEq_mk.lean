import Split.LawfulBEq
import Split.Bool_true
import Split.BEq_beq
import Split.ReflBEq
import Split.Bool
import Split.BEq
import Split.Eq

-- LawfulBEq.mk from environment
-- constructor LawfulBEq.mk : forall {α : Type.{u}} [inst._@.Init.Core.2400486342._hygCtx._hyg.3 : BEq.{u} α] [toReflBEq : ReflBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3], (forall {a : α} {b : α}, (Eq.{1} Bool (BEq.beq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3 a b) Bool.true) -> (Eq.{succ u} α a b)) -> (LawfulBEq.{u} α inst._@.Init.Core.2400486342._hygCtx._hyg.3)

-- Stub: this file represents the declaration `LawfulBEq.mk`.
-- In a full split, the body would be extracted from the environment.
