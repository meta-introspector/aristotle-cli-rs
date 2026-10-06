import Mathlib

set_option pp.all true
-- spec: String.Slice.str : String.Slice -> String
def String.Slice.str : String.Slice -> String :=
  fun (self : String.Slice) => self.1
