import Mathlib

set_option pp.all true
-- spec: HAnd.hAnd : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HAnd.{u, v, w} α β γ], α -> β -> γ
def HAnd.hAnd : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HAnd.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HAnd.{u, v, w} α β γ] => self.1
