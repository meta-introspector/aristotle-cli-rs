import Mathlib

-- spec: constructor ForIn'.mk : forall {m : Type.{u₁} -> Type.{u₂}} {ρ : Type.{u}} {α : outParam.{succ (succ v)} Type.{v}} {d : outParam.{max (succ u) (succ v)} (Membership.{v, u} α ρ)}, (forall {β : Type.{u₁}} (x : ρ), β -> (forall (a : α), (Membership.mem.{v, u} α ρ d x a) -> β -> (m (ForInStep.{u₁} β))) -> (m β)) -> (ForIn'.{u, v, u₁, u₂} m ρ α d)
