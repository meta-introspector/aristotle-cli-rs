import Split.instHAdd
import Split.HAdd_hAdd
import Split.IsLeftCancelAdd
import Split.IsLeftCancelAdd_add_left_cancel
import Split.Eq
import Split.Add

-- add_left_cancel from environment
-- theorem add_left_cancel : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2711695107._hygCtx._hyg.3 : Add.{u_1} G] [inst._@.Mathlib.Algebra.Group.Defs.2711695107._hygCtx._hyg.6 : IsLeftCancelAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2711695107._hygCtx._hyg.3] {a : G} {b : G} {c : G}, (Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2711695107._hygCtx._hyg.3) a b) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2711695107._hygCtx._hyg.3) a c)) -> (Eq.{succ u_1} G b c)

-- Stub: this file represents the declaration `add_left_cancel`.
-- In a full split, the body would be extracted from the environment.
