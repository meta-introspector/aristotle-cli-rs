import Split.instHSMul
import Split.instSMulOfMul
import Split.HMul_hMul
import Split.smul_assoc
import Split.IsScalarTower
import Split.SMul
import Split.Mul
import Split.HSMul_hSMul
import Split.Eq
import Split.instHMul

-- smul_mul_assoc from environment
-- theorem smul_mul_assoc : forall {α : Type.{u_5}} {β : Type.{u_6}} [inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.10 : Mul.{u_6} β] [inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.13 : SMul.{u_5, u_6} α β] [inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.17 : IsScalarTower.{u_5, u_6, u_6} α β β inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.13 (instSMulOfMul.{u_6} β inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.10) inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.13] (r : α) (x : β) (y : β), Eq.{succ u_6} β (HMul.hMul.{u_6, u_6, u_6} β β β (instHMul.{u_6} β inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.10) (HSMul.hSMul.{u_5, u_6, u_6} α β β (instHSMul.{u_5, u_6} α β inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.13) r x) y) (HSMul.hSMul.{u_5, u_6, u_6} α β β (instHSMul.{u_5, u_6} α β inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.13) r (HMul.hMul.{u_6, u_6, u_6} β β β (instHMul.{u_6} β inst._@.Mathlib.Algebra.Group.Action.Defs.4236977198._hygCtx._hyg.10) x y))

-- Stub: this file represents the declaration `smul_mul_assoc`.
-- In a full split, the body would be extracted from the environment.
