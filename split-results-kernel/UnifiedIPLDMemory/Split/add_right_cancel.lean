import Split.IsRightCancelAdd
import Split.instHAdd
import Split.HAdd_hAdd
import Split.IsRightCancelAdd_add_right_cancel
import Split.Eq
import Split.Add

-- add_right_cancel from environment
-- theorem add_right_cancel : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.1619184494._hygCtx._hyg.3 : Add.{u_1} G] [inst._@.Mathlib.Algebra.Group.Defs.1619184494._hygCtx._hyg.6 : IsRightCancelAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1619184494._hygCtx._hyg.3] {a : G} {b : G} {c : G}, (Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1619184494._hygCtx._hyg.3) a b) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1619184494._hygCtx._hyg.3) c b)) -> (Eq.{succ u_1} G a c)

-- Stub: this file represents the declaration `add_right_cancel`.
-- In a full split, the body would be extracted from the environment.
