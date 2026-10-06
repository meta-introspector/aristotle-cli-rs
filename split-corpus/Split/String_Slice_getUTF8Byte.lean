import Mathlib

set_option pp.all true
-- spec: String.Slice.getUTF8Byte : forall (s : String.Slice) (p : String.Pos.Raw), (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) -> UInt8
def String.Slice.getUTF8Byte : forall (s : String.Slice) (p : String.Pos.Raw), (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) -> UInt8 :=
  fun (s : String.Slice) (p : String.Pos.Raw) (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) => String.getUTF8Byte (String.Slice.str s) (String.Pos.Raw.offsetBy p (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))) (String.Slice.getUTF8Byte._proof_3 s p h)
