import Mathlib

set_option pp.all true
-- spec: HAdd.hAdd : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HAdd.{u, v, w} α β γ], α -> β -> γ
def HAdd.hAdd : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HAdd.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HAdd.{u, v, w} α β γ] => self.1
