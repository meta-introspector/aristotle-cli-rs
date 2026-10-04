import Mathlib

set_option pp.all true
-- spec: HAppend.hAppend : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HAppend.{u, v, w} α β γ], α -> β -> γ
def HAppend.hAppend : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HAppend.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HAppend.{u, v, w} α β γ] => self.1
