import Split.String
import Split.String_toByteArray
import Split.ByteArray_utf8DecodeChar
import Split.Bool_true
import Split.Nat
import Split.Bool
import Split.Char
import Split.Option_isSome
import Split.Eq
import Split.ByteArray_utf8DecodeChar?

-- String.decodeChar from environment
-- def String.decodeChar : forall (s : [mdata borrowed:1 String]) (byteIdx : [mdata borrowed:1 Nat]), (Eq.{1} Bool (Option.isSome.{0} Char (ByteArray.utf8DecodeChar? (String.toByteArray s) byteIdx)) Bool.true) -> Char
-- (definition body omitted)

-- Stub: this file represents the declaration `String.decodeChar`.
-- In a full split, the body would be extracted from the environment.
