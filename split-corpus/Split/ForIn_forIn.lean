import Mathlib

set_option pp.all true
-- spec: ForIn.forIn : forall {m : Type.{u₁} -> Type.{u₂}} {ρ : Type.{u}} {α : outParam.{succ (succ v)} Type.{v}} [self : ForIn.{u, v, u₁, u₂} m ρ α] {β : Type.{u₁}}, ρ -> β -> (α -> β -> (m (ForInStep.{u₁} β))) -> (m β)
def ForIn.forIn : forall {m : Type.{u₁} -> Type.{u₂}} {ρ : Type.{u}} {α : outParam.{succ (succ v)} Type.{v}} [self : ForIn.{u, v, u₁, u₂} m ρ α] {β : Type.{u₁}}, ρ -> β -> (α -> β -> (m (ForInStep.{u₁} β))) -> (m β) :=
  fun (m : Type.{u₁} -> Type.{u₂}) (ρ : Type.{u}) {α : outParam.{succ (succ v)} Type.{v}} [self : ForIn.{u, v, u₁, u₂} m ρ α] => self.1
