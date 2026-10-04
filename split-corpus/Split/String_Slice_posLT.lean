import Mathlib

set_option pp.all true
-- spec: String.Slice.posLT : forall (s : String.Slice) (offset : String.Pos.Raw), (LT.lt.{0} String.Pos.Raw String.instLTRaw (OfNat.ofNat.{0} String.Pos.Raw 0 String.instOfNatRaw) offset) -> (String.Slice.Pos s)
def String.Slice.posLT : forall (s : String.Slice) (offset : String.Pos.Raw), (LT.lt.{0} String.Pos.Raw String.instLTRaw (OfNat.ofNat.{0} String.Pos.Raw 0 String.instOfNatRaw) offset) -> (String.Slice.Pos s) :=
  fun (s : String.Slice) (offset : String.Pos.Raw) (_h : LT.lt.{0} String.Pos.Raw String.instLTRaw (OfNat.ofNat.{0} String.Pos.Raw 0 String.instOfNatRaw) offset) => String.Slice.posLE s (String.Pos.Raw.dec offset)
