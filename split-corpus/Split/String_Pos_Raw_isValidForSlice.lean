import Mathlib

set_option pp.all true
-- spec: String.Pos.Raw.isValidForSlice : String.Slice -> String.Pos.Raw -> Bool
def String.Pos.Raw.isValidForSlice : String.Slice -> String.Pos.Raw -> Bool :=
  fun (s : String.Slice) (p : String.Pos.Raw) => dite.{1} Bool (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) (String.instDecidableLtRaw p (String.Slice.rawEndPos s)) (fun (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s)) => Decidable.decide (UInt8.IsUTF8FirstByte (String.Slice.getUTF8Byte s p h)) (UInt8.instDecidableIsUTF8FirstByte (String.Slice.getUTF8Byte s p h))) (fun (h : Not (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.Slice.rawEndPos s))) => Decidable.decide (Eq.{1} String.Pos.Raw p (String.Slice.rawEndPos s)) (instDecidableEqRaw p (String.Slice.rawEndPos s)))
