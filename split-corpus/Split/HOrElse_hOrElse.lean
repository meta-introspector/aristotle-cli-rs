import Mathlib

set_option pp.all true
-- spec: HOrElse.hOrElse : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HOrElse.{u, v, w} α β γ], α -> (Unit -> β) -> γ
def HOrElse.hOrElse : forall {α : Type.{u}} {β : Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : HOrElse.{u, v, w} α β γ], α -> (Unit -> β) -> γ :=
  fun (α : Type.{u}) (β : Type.{v}) {γ : outParam.{succ (succ w)} Type.{w}} [self : HOrElse.{u, v, w} α β γ] => self.1
