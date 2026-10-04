import Mathlib

set_option pp.all true
-- spec: String.extract : forall {s : [mdata borrowed:1 String]}, ([mdata borrowed:1 String.Pos s]) -> ([mdata borrowed:1 String.Pos s]) -> String
def String.extract : forall {s : [mdata borrowed:1 String]}, ([mdata borrowed:1 String.Pos s]) -> ([mdata borrowed:1 String.Pos s]) -> String :=
  fun {s : String} (b : String.Pos s) (e : String.Pos s) => String.ofByteArray (ByteArray.extract (String.toByteArray s) (String.Pos.Raw.byteIdx (String.Pos.offset s b)) (String.Pos.Raw.byteIdx (String.Pos.offset s e))) (String.Pos.isValidUTF8_extract s b e)
