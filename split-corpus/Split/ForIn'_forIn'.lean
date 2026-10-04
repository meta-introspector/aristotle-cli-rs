import Mathlib

set_option pp.all true
-- spec: ForIn'.forIn' : forall {m : Type.{u₁} -> Type.{u₂}} {ρ : Type.{u}} {α : outParam.{succ (succ v)} Type.{v}} {d : outParam.{max (succ u) (succ v)} (Membership.{v, u} α ρ)} [self : ForIn'.{u, v, u₁, u₂} m ρ α d] {β : Type.{u₁}} (x : ρ), β -> (forall (a : α), (Membership.mem.{v, u} α ρ d x a) -> β -> (m (ForInStep.{u₁} β))) -> (m β)
def ForIn'.forIn' : forall {m : Type.{u₁} -> Type.{u₂}} {ρ : Type.{u}} {α : outParam.{succ (succ v)} Type.{v}} {d : outParam.{max (succ u) (succ v)} (Membership.{v, u} α ρ)} [self : ForIn'.{u, v, u₁, u₂} m ρ α d] {β : Type.{u₁}} (x : ρ), β -> (forall (a : α), (Membership.mem.{v, u} α ρ d x a) -> β -> (m (ForInStep.{u₁} β))) -> (m β) :=
  fun (m : Type.{u₁} -> Type.{u₂}) (ρ : Type.{u}) {α : outParam.{succ (succ v)} Type.{v}} {d : outParam.{max (succ u) (succ v)} (Membership.{v, u} α ρ)} [self : ForIn'.{u, v, u₁, u₂} m ρ α d] => self.1
