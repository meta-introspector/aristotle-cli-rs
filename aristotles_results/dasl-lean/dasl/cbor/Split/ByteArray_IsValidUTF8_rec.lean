import Mathlib

-- spec: recursor ByteArray.IsValidUTF8.rec : forall {b : ByteArray} {motive : (ByteArray.IsValidUTF8 b) -> Prop}, (forall (m : List.{0} Char) (hm : Eq.{1} ByteArray b (List.utf8Encode m)), motive (ByteArray.IsValidUTF8.intro b m hm)) -> (forall (t : ByteArray.IsValidUTF8 b), motive t)
