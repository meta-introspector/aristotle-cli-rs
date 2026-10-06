import Mathlib

set_option pp.all true
-- spec: String.Slice.copy : String.Slice -> String
def String.Slice.copy : String.Slice -> String :=
  fun (s : String.Slice) => String.extract (String.Slice.str s) (String.Slice.startInclusive s) (String.Slice.endExclusive s)
