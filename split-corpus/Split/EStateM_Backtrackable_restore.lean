import Mathlib

set_option pp.all true
-- spec: EStateM.Backtrackable.restore : forall {δ : outParam.{succ (succ u)} Type.{u}} {σ : Type.{u}} [self : EStateM.Backtrackable.{u} δ σ], σ -> δ -> σ
def EStateM.Backtrackable.restore : forall {δ : outParam.{succ (succ u)} Type.{u}} {σ : Type.{u}} [self : EStateM.Backtrackable.{u} δ σ], σ -> δ -> σ :=
  fun {δ : outParam.{succ (succ u)} Type.{u}} (σ : Type.{u}) [self : EStateM.Backtrackable.{u} δ σ] => self.2
