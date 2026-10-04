import Mathlib

set_option pp.all true
-- spec: EStateM.Backtrackable.save : forall {δ : outParam.{succ (succ u)} Type.{u}} {σ : Type.{u}} [self : EStateM.Backtrackable.{u} δ σ], σ -> δ
def EStateM.Backtrackable.save : forall {δ : outParam.{succ (succ u)} Type.{u}} {σ : Type.{u}} [self : EStateM.Backtrackable.{u} δ σ], σ -> δ :=
  fun {δ : outParam.{succ (succ u)} Type.{u}} (σ : Type.{u}) [self : EStateM.Backtrackable.{u} δ σ] => self.1
