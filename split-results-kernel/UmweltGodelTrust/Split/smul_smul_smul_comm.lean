import Split.Eq_mpr
import Split.instHSMul
import Split.smul_assoc
import Split.congrArg
import Split.IsScalarTower
import Split.SMul
import Split.id
import Split.Eq_refl
import Split.HSMul_hSMul
import Split.SMulCommClass_smul_comm
import Split.Eq
import Split.SMulCommClass

-- smul_smul_smul_comm from environment
-- theorem smul_smul_smul_comm : forall {α : Type.{u_5}} {β : Type.{u_6}} {γ : Type.{u_7}} {δ : Type.{u_8}} [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.10 : SMul.{u_5, u_6} α β] [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.14 : SMul.{u_5, u_7} α γ] [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.18 : SMul.{u_6, u_8} β δ] [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.22 : SMul.{u_5, u_8} α δ] [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.26 : SMul.{u_7, u_8} γ δ] [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.30 : IsScalarTower.{u_5, u_6, u_8} α β δ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.18 inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.22] [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.35 : IsScalarTower.{u_5, u_7, u_8} α γ δ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.14 inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.26 inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.22] [inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.40 : SMulCommClass.{u_6, u_7, u_8} β γ δ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.18 inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.26] (a : α) (b : β) (c : γ) (d : δ), Eq.{succ u_8} δ (HSMul.hSMul.{u_6, u_8, u_8} β δ δ (instHSMul.{u_6, u_8} β δ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.18) (HSMul.hSMul.{u_5, u_6, u_6} α β β (instHSMul.{u_5, u_6} α β inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.10) a b) (HSMul.hSMul.{u_7, u_8, u_8} γ δ δ (instHSMul.{u_7, u_8} γ δ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.26) c d)) (HSMul.hSMul.{u_7, u_8, u_8} γ δ δ (instHSMul.{u_7, u_8} γ δ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.26) (HSMul.hSMul.{u_5, u_7, u_7} α γ γ (instHSMul.{u_5, u_7} α γ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.14) a c) (HSMul.hSMul.{u_6, u_8, u_8} β δ δ (instHSMul.{u_6, u_8} β δ inst._@.Mathlib.Algebra.Group.Action.Defs.2725767273._hygCtx._hyg.18) b d))

-- Stub: this file represents the declaration `smul_smul_smul_comm`.
-- In a full split, the body would be extracted from the environment.
