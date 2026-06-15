import Split.Lean_Name_rec
import Split.String
import Split.Lean_Name_num
import Split.Lean_Name_str
import Split.Lean_Name_anonymous
import Split.Nat
import Split.Lean_Name

-- Lean.Name.casesOn from environment
-- def Lean.Name.casesOn : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (motive Lean.Name.anonymous) -> (forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) -> (forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Lean.Name.casesOn`.
-- In a full split, the body would be extracted from the environment.
