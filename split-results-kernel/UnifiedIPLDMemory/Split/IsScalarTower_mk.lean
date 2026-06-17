import Split.instHSMul
import Split.IsScalarTower
import Split.SMul
import Split.HSMul_hSMul
import Split.Eq

-- IsScalarTower.mk from environment
-- constructor IsScalarTower.mk : forall {M : Type.{u_9}} {N : Type.{u_10}} {α : Type.{u_11}} [inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.21 : SMul.{u_9, u_10} M N] [inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25 : SMul.{u_10, u_11} N α] [inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.29 : SMul.{u_9, u_11} M α], (forall (x : M) (y : N) (z : α), Eq.{succ u_11} α (HSMul.hSMul.{u_10, u_11, u_11} N α α (instHSMul.{u_10, u_11} N α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25) (HSMul.hSMul.{u_9, u_10, u_10} M N N (instHSMul.{u_9, u_10} M N inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.21) x y) z) (HSMul.hSMul.{u_9, u_11, u_11} M α α (instHSMul.{u_9, u_11} M α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.29) x (HSMul.hSMul.{u_10, u_11, u_11} N α α (instHSMul.{u_10, u_11} N α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25) y z))) -> (IsScalarTower.{u_9, u_10, u_11} M N α inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.21 inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.25 inst._@.Mathlib.Algebra.Group.Action.Defs.306604460._hygCtx._hyg.29)

-- Stub: this file represents the declaration `IsScalarTower.mk`.
-- In a full split, the body would be extracted from the environment.
