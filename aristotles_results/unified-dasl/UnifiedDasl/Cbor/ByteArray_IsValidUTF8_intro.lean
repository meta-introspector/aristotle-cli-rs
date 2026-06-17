import Mathlib

-- spec: constructor ByteArray.IsValidUTF8.intro : forall {b : ByteArray} (m : List.{0} Char), (Eq.{1} ByteArray b (List.utf8Encode m)) -> (ByteArray.IsValidUTF8 b)
