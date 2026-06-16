import Split.AddSemigroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddSemigroup_add_assoc
import Split.Eq

-- add_assoc from environment
-- theorem add_assoc : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3 : AddSemigroup.{u_1} G] (a : G) (b : G) (c : G), Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddSemigroup.toAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddSemigroup.toAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) a b) c) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddSemigroup.toAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) a (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddSemigroup.toAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) b c))

-- Stub: this file represents the declaration `add_assoc`.
-- In a full split, the body would be extracted from the environment.
