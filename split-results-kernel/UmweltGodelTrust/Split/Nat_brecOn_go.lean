import Split.PProd_mk
import Split.Nat_rec
import Split.Nat_below
import Split.PProd
import Split.PUnit
import Split.Nat
import Split.Nat_zero
import Split.PUnit_unit
import Split.Nat_succ

-- Nat.brecOn.go from environment
-- def Nat.brecOn.go : forall {motive : Nat -> Sort.{u}} (t : Nat), (forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)) -> (PProd.{u, max 1 u} (motive t) (Nat.below.{u} motive t))
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.brecOn.go`.
-- In a full split, the body would be extracted from the environment.
