import Mathlib

-- spec: theorem ByteArray.isValidUTF8_utf8Encode : forall {l : List.{0} Char}, ByteArray.IsValidUTF8 (List.utf8Encode l)
theorem ByteArray.isValidUTF8_utf8Encode : forall {l : List.{0} Char}, ByteArray.IsValidUTF8 (List.utf8Encode l) :=
  fun {l : List.{0} Char} => ByteArray.IsValidUTF8.intro (List.utf8Encode l) l (rfl.{1} ByteArray (List.utf8Encode l))
