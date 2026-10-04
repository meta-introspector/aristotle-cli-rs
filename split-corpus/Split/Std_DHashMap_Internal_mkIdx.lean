import Mathlib

set_option pp.all true
-- spec: Std.DHashMap.Internal.mkIdx : forall (sz : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) sz) -> UInt64 -> (Subtype.{1} USize (fun (u : USize) => LT.lt.{0} Nat instLTNat (USize.toNat u) sz))
def Std.DHashMap.Internal.mkIdx : forall (sz : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) sz) -> UInt64 -> (Subtype.{1} USize (fun (u : USize) => LT.lt.{0} Nat instLTNat (USize.toNat u) sz)) :=
  fun (sz : Nat) (h : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) sz) (hash : UInt64) => Subtype.mk.{1} USize (fun (u : USize) => LT.lt.{0} Nat instLTNat (USize.toNat u) sz) (HAnd.hAnd.{0, 0, 0} USize USize USize (instHAndOfAndOp.{0} USize instAndOpUSize) (UInt64.toUSize (Std.DHashMap.Internal.scrambleHash hash)) (HSub.hSub.{0, 0, 0} USize USize USize (instHSub.{0} USize instSubUSize) (USize.ofNat sz) (OfNat.ofNat.{0} USize 1 (USize.instOfNat 1)))) (Std.DHashMap.Internal.mkIdx._proof_2 sz h hash)
