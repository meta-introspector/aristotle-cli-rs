import Mathlib

-- spec: theorem String.getUTF8Byte.eq_1 : forall (s : String) (p : String.Pos.Raw) (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos s)), Eq.{1} UInt8 (String.getUTF8Byte s p h) (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (String.toByteArray s) (String.Pos.Raw.byteIdx p) h)
theorem String.getUTF8Byte.eq_1 : forall (s : String) (p : String.Pos.Raw) (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos s)), Eq.{1} UInt8 (String.getUTF8Byte s p h) (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (String.toByteArray s) (String.Pos.Raw.byteIdx p) h) :=
  fun (s : String) (p : String.Pos.Raw) (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos s)) => Eq.refl.{1} UInt8 (String.getUTF8Byte s p h)
