import Mathlib

set_option pp.all true
-- spec: Membership.mem : forall {α : outParam.{succ (succ u)} Type.{u}} {γ : Type.{v}} [self : Membership.{u, v} α γ], γ -> α -> Prop
def Membership.mem : forall {α : outParam.{succ (succ u)} Type.{u}} {γ : Type.{v}} [self : Membership.{u, v} α γ], γ -> α -> Prop :=
  fun {α : outParam.{succ (succ u)} Type.{u}} (γ : Type.{v}) [self : Membership.{u, v} α γ] => self.1
