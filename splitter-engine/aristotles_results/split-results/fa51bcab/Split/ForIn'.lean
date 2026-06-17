import Split.outParam
import Split.Membership

-- ForIn' from environment
-- inductive ForIn' : (Type.{u₁} -> Type.{u₂}) -> (forall (ρ : Type.{u}) (α : outParam.{succ (succ v)} Type.{v}), (outParam.{max (succ u) (succ v)} (Membership.{v, u} α ρ)) -> Sort.{max (max (max (succ u) (succ (succ u₁))) (succ u₂)) (succ v)})
-- ctors: [ForIn'.mk]

-- Stub: this file represents the declaration `ForIn'`.
-- In a full split, the body would be extracted from the environment.
