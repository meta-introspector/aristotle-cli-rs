import Split.Nat_lt_wfRel
import Split.WellFoundedRelation_rel
import Split.WellFoundedRelation_wf
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.WellFounded_fix

-- Nat.strongRecOn from environment
-- def Nat.strongRecOn : forall {motive : Nat -> Sort.{u}} (n : Nat), (forall (n : Nat), (forall (m : Nat), (LT.lt.{0} Nat instLTNat m n) -> (motive m)) -> (motive n)) -> (motive n)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.strongRecOn`.
-- In a full split, the body would be extracted from the environment.
