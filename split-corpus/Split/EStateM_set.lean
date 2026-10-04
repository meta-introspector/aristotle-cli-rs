import Mathlib

set_option pp.all true
-- spec: EStateM.set : forall {ε : Type.{u}} {σ : Type.{u}}, σ -> (EStateM.{u} ε σ PUnit.{succ u})
def EStateM.set : forall {ε : Type.{u}} {σ : Type.{u}}, σ -> (EStateM.{u} ε σ PUnit.{succ u}) :=
  fun {ε : Type.{u}} {σ : Type.{u}} (s : σ) (x._@.Init.Prelude.3103831427._hygCtx._hyg.13 : σ) => EStateM.Result.ok.{u} ε σ PUnit.{succ u} PUnit.unit.{succ u} s
