import Mathlib

set_option pp.all true
-- spec: HXor.hXor : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HXor.{u, v, w} α β γ], α -> β -> γ
def HXor.hXor : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HXor.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HXor.{u, v, w} α β γ] => self.1
