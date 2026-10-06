import Mathlib

set_option pp.all true
-- spec: String.Slice.trimAsciiEnd : String.Slice -> String.Slice
def String.Slice.trimAsciiEnd : String.Slice -> String.Slice :=
  fun (s : String.Slice) => String.Slice.dropEndWhile (Char -> Bool) s Char.isWhitespace (String.Slice.Pattern.CharPred.instBackwardPatternForallCharBool Char.isWhitespace)
