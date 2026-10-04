import Mathlib

set_option pp.all true
-- spec: EStateM.dummyRestore : forall {σ : Type.{u}}, σ -> PUnit.{u_1} -> σ
def EStateM.dummyRestore : forall {σ : Type.{u}}, σ -> PUnit.{u_1} -> σ :=
  fun {σ : Type.{u}} (s : σ) (x._@.Init.Prelude.243281715._hygCtx._hyg.14 : PUnit.{u_1}) => s
