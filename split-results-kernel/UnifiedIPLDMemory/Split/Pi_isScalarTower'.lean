import Split.instHSMul
import Split.smul_assoc
import Split.IsScalarTower
import Split.SMul
import Split.funext
import Split.Pi_instSMul
import Split.HSMul_hSMul
import Split.Pi_smul'
import Split.IsScalarTower_mk

-- Pi.isScalarTower' from environment
-- theorem Pi.isScalarTower' : forall {ι : Type.{u_1}} {M : Type.{u_2}} {α : ι -> Type.{u_4}} {β : ι -> Type.{u_5}} [inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.15 : forall (i : ι), SMul.{u_2, u_4} M (α i)] [inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.25 : forall (i : ι), SMul.{u_4, u_5} (α i) (β i)] [inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.38 : forall (i : ι), SMul.{u_2, u_5} M (β i)] [inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.48 : forall (i : ι), IsScalarTower.{u_2, u_4, u_5} M (α i) (β i) (inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.15 i) (inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.25 i) (inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.38 i)], IsScalarTower.{u_2, max u_1 u_4, max u_1 u_5} M (forall (i : ι), α i) (forall (i : ι), β i) (Pi.instSMul.{u_1, u_2, u_4} ι M α inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.15) (Pi.smul'.{u_1, u_4, u_5} ι α β inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.25) (Pi.instSMul.{u_1, u_2, u_5} ι M β inst._@.Mathlib.Algebra.Group.Action.Pi.243307169._hygCtx._hyg.38)

-- Stub: this file represents the declaration `Pi.isScalarTower'`.
-- In a full split, the body would be extracted from the environment.
