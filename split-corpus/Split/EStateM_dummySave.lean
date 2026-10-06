import Mathlib

set_option pp.all true
-- spec: EStateM.dummySave : forall {σ : Type.{u}}, σ -> PUnit.{u_1}
def EStateM.dummySave : forall {σ : Type.{u}}, σ -> PUnit.{u_1} :=
  fun {σ : Type.{u}} (x._@.Init.Prelude.2766524647._hygCtx._hyg.11 : σ) => PUnit.unit.{u_1}
