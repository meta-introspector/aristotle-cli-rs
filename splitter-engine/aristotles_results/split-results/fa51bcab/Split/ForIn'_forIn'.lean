import Split.outParam
import Split.Membership_mem
import Split.Membership
import Split.ForInStep
import Split.ForIn'

-- ForIn'.forIn' from environment
-- def ForIn'.forIn' : forall {m : Type.{u₁} -> Type.{u₂}} {ρ : Type.{u}} {α : outParam.{succ (succ v)} Type.{v}} {d : outParam.{max (succ u) (succ v)} (Membership.{v, u} α ρ)} [self : ForIn'.{u, v, u₁, u₂} m ρ α d] {β : Type.{u₁}} (x : ρ), β -> (forall (a : α), (Membership.mem.{v, u} α ρ d x a) -> β -> (m (ForInStep.{u₁} β))) -> (m β)
-- (definition body omitted)

-- Stub: this file represents the declaration `ForIn'.forIn'`.
-- In a full split, the body would be extracted from the environment.
