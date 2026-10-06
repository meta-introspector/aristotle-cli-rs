import Mathlib

set_option pp.all true
-- spec: HMod.hMod : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HMod.{u, v, w} α β γ], α -> β -> γ
def HMod.hMod : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HMod.{u, v, w} α β γ], α -> β -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HMod.{u, v, w} α β γ] => self.1
