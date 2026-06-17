import Split.instHSMul
import Split.IsScalarTower
import Split.SMul
import Split.HSMul_hSMul
import Split.Eq

-- IsScalarTower.smul_assoc from environment
-- theorem IsScalarTower.smul_assoc : forall {M : Type.{u_9}} {N : Type.{u_10}} {α : Type.{u_11}} {inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.21 : SMul.{u_9, u_10} M N} {inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25 : SMul.{u_10, u_11} N α} {inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.29 : SMul.{u_9, u_11} M α} [self : IsScalarTower.{u_9, u_10, u_11} M N α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.21 inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25 inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.29] (x : M) (y : N) (z : α), Eq.{succ u_11} α (HSMul.hSMul.{u_10, u_11, u_11} N α α (instHSMul.{u_10, u_11} N α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25) (HSMul.hSMul.{u_9, u_10, u_10} M N N (instHSMul.{u_9, u_10} M N inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.21) x y) z) (HSMul.hSMul.{u_9, u_11, u_11} M α α (instHSMul.{u_9, u_11} M α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.29) x (HSMul.hSMul.{u_10, u_11, u_11} N α α (instHSMul.{u_10, u_11} N α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25) y z))

-- Stub: this file represents the declaration `IsScalarTower.smul_assoc`.
-- In a full split, the body would be extracted from the environment.
