import Split.IsRightCancelAdd
import Split.Function_Injective_ne_iff
import Split.Ne
import Split.instHAdd
import Split.Iff
import Split.HAdd_hAdd
import Split.add_left_injective
import Split.Add

-- add_ne_add_left from environment
-- theorem add_ne_add_left : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2553200564._hygCtx._hyg.3 : Add.{u_1} G] [inst._@.Mathlib.Algebra.Group.Defs.2553200564._hygCtx._hyg.6 : IsRightCancelAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2553200564._hygCtx._hyg.3] (a : G) {b : G} {c : G}, Iff (Ne.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2553200564._hygCtx._hyg.3) b a) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2553200564._hygCtx._hyg.3) c a)) (Ne.{succ u_1} G b c)

-- Stub: this file represents the declaration `add_ne_add_left`.
-- In a full split, the body would be extracted from the environment.
