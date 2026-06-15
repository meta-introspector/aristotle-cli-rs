import Split.List
import Split.ByteArray_IsValidUTF8_intro
import Split.Char
import Split.ByteArray
import Split.List_utf8Encode
import Split.Eq
import Split.ByteArray_IsValidUTF8

-- ByteArray.IsValidUTF8.rec from environment
-- recursor ByteArray.IsValidUTF8.rec : forall {b : ByteArray} {motive : (ByteArray.IsValidUTF8 b) -> Prop}, (forall (m : List.{0} Char) (hm : Eq.{1} ByteArray b (List.utf8Encode m)), motive (ByteArray.IsValidUTF8.intro b m hm)) -> (forall (t : ByteArray.IsValidUTF8 b), motive t)

-- Stub: this file represents the declaration `ByteArray.IsValidUTF8.rec`.
-- In a full split, the body would be extracted from the environment.
