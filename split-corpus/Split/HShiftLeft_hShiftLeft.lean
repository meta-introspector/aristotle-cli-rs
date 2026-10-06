import Mathlib

set_option pp.all true
-- spec: HShiftLeft.hShiftLeft : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HShiftLeft.{u, v, w} α β γ], α -> β -> γ
def HShiftLeft.hShiftLeft : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HShiftLeft.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HShiftLeft.{u, v, w} α β γ] => self.1
