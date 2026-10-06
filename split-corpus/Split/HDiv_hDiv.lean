import Mathlib

set_option pp.all true
-- spec: HDiv.hDiv : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HDiv.{u, v, w} α β γ], α -> β -> γ
def HDiv.hDiv : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HDiv.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HDiv.{u, v, w} α β γ] => self.1
