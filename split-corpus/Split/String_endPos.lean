import Mathlib

set_option pp.all true
-- spec: String.endPos : forall (s : String), String.Pos s
def String.endPos : forall (s : String), String.Pos s :=
  fun (s : String) => String.Pos.mk s (String.rawEndPos s) (String.endPos._proof_1 s)
