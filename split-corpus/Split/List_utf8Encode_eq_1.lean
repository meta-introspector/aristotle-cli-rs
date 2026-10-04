import Mathlib

-- spec: theorem List.utf8Encode.eq_1 : forall (l : List.{0} Char), Eq.{1} ByteArray (List.utf8Encode l) (List.toByteArray (List.flatMap.{0, 0} Char UInt8 String.utf8EncodeChar l))
theorem List.utf8Encode.eq_1 : forall (l : List.{0} Char), Eq.{1} ByteArray (List.utf8Encode l) (List.toByteArray (List.flatMap.{0, 0} Char UInt8 String.utf8EncodeChar l)) :=
  fun (l : List.{0} Char) => Eq.refl.{1} ByteArray (List.utf8Encode l)
