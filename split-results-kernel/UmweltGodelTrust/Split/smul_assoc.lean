import Split.instHSMul
import Split.IsScalarTower
import Split.SMul
import Split.HSMul_hSMul
import Split.Eq
import Split.IsScalarTower_smul_assoc

-- smul_assoc from environment
-- theorem smul_assoc : forall {α : Type.{u_5}} {M : Type.{u_9}} {N : Type.{u_10}} [inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.12 : SMul.{u_9, u_10} M N] [inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.16 : SMul.{u_10, u_5} N α] [inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.20 : SMul.{u_9, u_5} M α] [inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.24 : IsScalarTower.{u_9, u_10, u_5} M N α inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.16 inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.20] (x : M) (y : N) (z : α), Eq.{succ u_5} α (HSMul.hSMul.{u_10, u_5, u_5} N α α (instHSMul.{u_10, u_5} N α inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.16) (HSMul.hSMul.{u_9, u_10, u_10} M N N (instHSMul.{u_9, u_10} M N inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.12) x y) z) (HSMul.hSMul.{u_9, u_5, u_5} M α α (instHSMul.{u_9, u_5} M α inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.20) x (HSMul.hSMul.{u_10, u_5, u_5} N α α (instHSMul.{u_10, u_5} N α inst._@.Mathlib.Algebra.Group.Action.Defs.3586319278._hygCtx._hyg.16) y z))

-- Stub: this file represents the declaration `smul_assoc`.
-- In a full split, the body would be extracted from the environment.
