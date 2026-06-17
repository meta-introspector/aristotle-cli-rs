import Split.String
import Split.Lean_Name_num
import Split.Lean_Name_str
import Split.Lean_Name_anonymous
import Split.Nat
import Split.Lean_Name

-- Lean.Name.rec from environment
-- recursor Lean.Name.rec : forall {motive : Lean.Name -> Sort.{u}}, (motive Lean.Name.anonymous) -> (forall (pre : Lean.Name) (str : String), (motive pre) -> (motive (Lean.Name.str pre str))) -> (forall (pre : Lean.Name) (i : Nat), (motive pre) -> (motive (Lean.Name.num pre i))) -> (forall (t : Lean.Name), motive t)

-- Stub: this file represents the declaration `Lean.Name.rec`.
-- In a full split, the body would be extracted from the environment.
