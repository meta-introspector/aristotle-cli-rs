import Split.Semigroup
import Split.Semigroup_toMul
import Split.Semigroup_mul_assoc
import Split.HMul_hMul
import Split.Eq
import Split.instHMul

-- mul_assoc from environment
-- theorem mul_assoc : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3 : Semigroup.{u_1} G] (a : G) (b : G) (c : G), Eq.{succ u_1} G (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (Semigroup.toMul.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (Semigroup.toMul.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) a b) c) (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (Semigroup.toMul.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) a (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (Semigroup.toMul.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2875213658._hygCtx._hyg.3)) b c))

-- Stub: this file represents the declaration `mul_assoc`.
-- In a full split, the body would be extracted from the environment.
