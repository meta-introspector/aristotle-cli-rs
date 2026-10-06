import Mathlib

set_option pp.all true
-- spec: String.toRawSubstring : String -> Substring.Raw
def String.toRawSubstring : String -> Substring.Raw :=
  fun (s : String) => Substring.Raw.mk s (String.Pos.Raw.mk (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (String.rawEndPos s)
