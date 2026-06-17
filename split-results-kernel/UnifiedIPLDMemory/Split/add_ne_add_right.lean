import Split.add_right_injective
import Split.Function_Injective_ne_iff
import Split.Ne
import Split.instHAdd
import Split.Iff
import Split.HAdd_hAdd
import Split.IsLeftCancelAdd
import Split.Add

-- add_ne_add_right from environment
-- theorem add_ne_add_right : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.712572810._hygCtx._hyg.3 : Add.{u_1} G] [inst._@.Mathlib.Algebra.Group.Defs.712572810._hygCtx._hyg.6 : IsLeftCancelAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.712572810._hygCtx._hyg.3] (a : G) {b : G} {c : G}, Iff (Ne.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.712572810._hygCtx._hyg.3) a b) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.712572810._hygCtx._hyg.3) a c)) (Ne.{succ u_1} G b c)

-- Stub: this file represents the declaration `add_ne_add_right`.
-- In a full split, the body would be extracted from the environment.
