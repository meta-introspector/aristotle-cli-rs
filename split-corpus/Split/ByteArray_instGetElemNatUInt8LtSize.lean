import Mathlib

set_option pp.all true
-- spec: ByteArray.instGetElemNatUInt8LtSize : GetElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs))
def ByteArray.instGetElemNatUInt8LtSize : GetElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) :=
  GetElem.mk.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) (fun (xs : ByteArray) (i : Nat) (h : LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) => ByteArray.get xs i h)
