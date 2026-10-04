import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Internal.scrambleHash : UInt64 -> UInt64
def Std.DHashMap.Internal.scrambleHash : UInt64 -> UInt64 :=
  fun (hash : UInt64) => have fold : UInt64 := HXor.hXor.{0, 0, 0} UInt64 UInt64 UInt64 (instHXorOfXorOp.{0} UInt64 instXorOpUInt64) hash (HShiftRight.hShiftRight.{0, 0, 0} UInt64 UInt64 UInt64 (instHShiftRightOfShiftRight.{0} UInt64 instShiftRightUInt64) hash (OfNat.ofNat.{0} UInt64 32 (UInt64.instOfNat 32))); HXor.hXor.{0, 0, 0} UInt64 UInt64 UInt64 (instHXorOfXorOp.{0} UInt64 instXorOpUInt64) fold (HShiftRight.hShiftRight.{0, 0, 0} UInt64 UInt64 UInt64 (instHShiftRightOfShiftRight.{0} UInt64 instShiftRightUInt64) fold (OfNat.ofNat.{0} UInt64 16 (UInt64.instOfNat 16)))
