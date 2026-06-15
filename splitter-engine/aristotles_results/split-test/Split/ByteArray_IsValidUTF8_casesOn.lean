import Split.ByteArray_IsValidUTF8_rec
import Split.List
import Split.ByteArray_IsValidUTF8_intro
import Split.Char
import Split.ByteArray
import Split.List_utf8Encode
import Split.Eq
import Split.ByteArray_IsValidUTF8

-- ByteArray.IsValidUTF8.casesOn from environment
-- def ByteArray.IsValidUTF8.casesOn : forall {b : ByteArray} {motive : (ByteArray.IsValidUTF8 b) -> Prop} (t : ByteArray.IsValidUTF8 b), (forall (m : List.{0} Char) (hm : Eq.{1} ByteArray b (List.utf8Encode m)), motive (ByteArray.IsValidUTF8.intro b m hm)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `ByteArray.IsValidUTF8.casesOn`.
-- In a full split, the body would be extracted from the environment.
