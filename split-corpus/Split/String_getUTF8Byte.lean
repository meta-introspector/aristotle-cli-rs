import Mathlib

set_option pp.all true
-- spec: String.getUTF8Byte : forall (s : [mdata borrowed:1 String]) (p : String.Pos.Raw), (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos s)) -> UInt8
def String.getUTF8Byte : forall (s : [mdata borrowed:1 String]) (p : String.Pos.Raw), (LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos s)) -> UInt8 :=
  fun (s : String) (p : String.Pos.Raw) (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos s)) => GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (String.toByteArray s) (String.Pos.Raw.byteIdx p) h
