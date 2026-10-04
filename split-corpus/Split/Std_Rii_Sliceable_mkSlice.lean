import Mathlib

set_option pp.all true
-- spec: Std.Rii.Sliceable.mkSlice : forall {α : Type.{u}} {β : outParam.{succ (succ v)} Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : Std.Rii.Sliceable.{u, v, w} α β γ], α -> (Std.Rii.{v} β) -> γ
def Std.Rii.Sliceable.mkSlice : forall {α : Type.{u}} {β : outParam.{succ (succ v)} Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : Std.Rii.Sliceable.{u, v, w} α β γ], α -> (Std.Rii.{v} β) -> γ :=
  fun (α : Type.{u}) {β : outParam.{succ (succ v)} Type.{v}} {γ : outParam.{succ (succ w)} Type.{w}} [self : Std.Rii.Sliceable.{u, v, w} α β γ] => self.1
