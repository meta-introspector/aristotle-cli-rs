import Mathlib

set_option pp.all true
-- spec: HMul.hMul : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HMul.{u, v, w} α β γ], α -> β -> γ
def HMul.hMul : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HMul.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HMul.{u, v, w} α β γ] => self.1
