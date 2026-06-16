import Split.Semigroup
import Split.Semigroup_toMul
import Split.instHSMul
import Split.HMul_hMul
import Split.SMul
import Split.SemigroupAction
import Split.HSMul_hSMul
import Split.Eq
import Split.instHMul

-- SemigroupAction.mk from environment
-- constructor SemigroupAction.mk : forall {α : Type.{u_9}} {β : Type.{u_10}} [inst._@.Mathlib.Algebra.Group.Action.Defs.3323368930._hygCtx._hyg.20 : Semigroup.{u_9} α] [toSMul : SMul.{u_9, u_10} α β], (forall (x : α) (y : α) (b : β), Eq.{succ u_10} β (HSMul.hSMul.{u_9, u_10, u_10} α β β (instHSMul.{u_9, u_10} α β toSMul) (HMul.hMul.{u_9, u_9, u_9} α α α (instHMul.{u_9} α (Semigroup.toMul.{u_9} α inst._@.Mathlib.Algebra.Group.Action.Defs.3323368930._hygCtx._hyg.20)) x y) b) (HSMul.hSMul.{u_9, u_10, u_10} α β β (instHSMul.{u_9, u_10} α β toSMul) x (HSMul.hSMul.{u_9, u_10, u_10} α β β (instHSMul.{u_9, u_10} α β toSMul) y b))) -> (SemigroupAction.{u_9, u_10} α β inst._@.Mathlib.Algebra.Group.Action.Defs.3323368930._hygCtx._hyg.20)

-- Stub: this file represents the declaration `SemigroupAction.mk`.
-- In a full split, the body would be extracted from the environment.
