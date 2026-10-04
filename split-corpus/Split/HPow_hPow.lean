import Mathlib

set_option pp.all true
-- spec: HPow.hPow : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HPow.{u, v, w} α β γ], α -> β -> γ
def HPow.hPow : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HPow.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HPow.{u, v, w} α β γ] => self.1
