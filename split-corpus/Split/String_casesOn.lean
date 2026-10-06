import Mathlib

set_option pp.all true
-- spec: String.casesOn : forall {motive : String -> Sort.{u}} (t : String), (forall (toByteArray : ByteArray) (isValidUTF8 : ByteArray.IsValidUTF8 toByteArray), motive (String.ofByteArray toByteArray isValidUTF8)) -> (motive t)
def String.casesOn : forall {motive : String -> Sort.{u}} (t : String), (forall (toByteArray : ByteArray) (isValidUTF8 : ByteArray.IsValidUTF8 toByteArray), motive (String.ofByteArray toByteArray isValidUTF8)) -> (motive t) :=
  fun {motive : String -> Sort.{u}} (t : String) (ofByteArray : forall (toByteArray : ByteArray) (isValidUTF8 : ByteArray.IsValidUTF8 toByteArray), motive (String.ofByteArray toByteArray isValidUTF8)) => String.rec.{u} motive (fun (toByteArray : ByteArray) (isValidUTF8 : ByteArray.IsValidUTF8 toByteArray) => ofByteArray toByteArray isValidUTF8) t
