import Split.LawfulBEq
import Split.Bool_true
import Split.BEq_beq
import Split.Iff
import Split.Iff_intro
import Split.Bool
import Split.LawfulBEq_toReflBEq
import Split.LawfulBEq_eq_of_beq
import Split.BEq
import Split.Eq
import Split.beq_of_eq

-- beq_iff_eq from environment
-- theorem beq_iff_eq : forall {α : Type.{u_1}} [inst._@.Init.Core.1842407054._hygCtx._hyg.9 : BEq.{u_1} α] [inst._@.Init.Core.1842407054._hygCtx._hyg.12 : LawfulBEq.{u_1} α inst._@.Init.Core.1842407054._hygCtx._hyg.9] {a : α} {b : α}, Iff (Eq.{1} Bool (BEq.beq.{u_1} α inst._@.Init.Core.1842407054._hygCtx._hyg.9 a b) Bool.true) (Eq.{succ u_1} α a b)

-- Stub: this file represents the declaration `beq_iff_eq`.
-- In a full split, the body would be extracted from the environment.
