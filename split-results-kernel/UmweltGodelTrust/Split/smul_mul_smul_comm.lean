import Split.instHSMul
import Split.instSMulOfMul
import Split.HMul_hMul
import Split.IsScalarTower
import Split.SMul
import Split.Mul
import Split.smul_smul_smul_comm
import Split.SMulCommClass_symm
import Split.HSMul_hSMul
import Split.Eq
import Split.SMulCommClass
import Split.instHMul

-- smul_mul_smul_comm from environment
-- theorem smul_mul_smul_comm : forall {α : Type.{u_5}} {β : Type.{u_6}} [inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.10 : Mul.{u_5} α] [inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.13 : Mul.{u_6} β] [inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16 : SMul.{u_5, u_6} α β] [inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.20 : IsScalarTower.{u_5, u_6, u_6} α β β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16 (instSMulOfMul.{u_6} β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.13) inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16] [inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.25 : IsScalarTower.{u_5, u_5, u_6} α α β (instSMulOfMul.{u_5} α inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.10) inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16 inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16] [inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.30 : SMulCommClass.{u_5, u_6, u_6} α β β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16 (instSMulOfMul.{u_6} β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.13)] (a : α) (b : β) (c : α) (d : β), Eq.{succ u_6} β (HMul.hMul.{u_6, u_6, u_6} β β β (instHMul.{u_6} β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.13) (HSMul.hSMul.{u_5, u_6, u_6} α β β (instHSMul.{u_5, u_6} α β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16) a b) (HSMul.hSMul.{u_5, u_6, u_6} α β β (instHSMul.{u_5, u_6} α β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16) c d)) (HSMul.hSMul.{u_5, u_6, u_6} α β β (instHSMul.{u_5, u_6} α β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.16) (HMul.hMul.{u_5, u_5, u_5} α α α (instHMul.{u_5} α inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.10) a c) (HMul.hMul.{u_6, u_6, u_6} β β β (instHMul.{u_6} β inst._@.Mathlib.Algebra.Group.Action.Defs.3629162982._hygCtx._hyg.13) b d))

-- Stub: this file represents the declaration `smul_mul_smul_comm`.
-- In a full split, the body would be extracted from the environment.
