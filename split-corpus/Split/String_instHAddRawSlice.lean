import Mathlib

set_option pp.all true
-- spec: String.instHAddRawSlice : HAdd.{0, 0, 0} String.Pos.Raw String.Slice String.Pos.Raw
def String.instHAddRawSlice : HAdd.{0, 0, 0} String.Pos.Raw String.Slice String.Pos.Raw :=
  HAdd.mk.{0, 0, 0} String.Pos.Raw String.Slice String.Pos.Raw (fun (p : String.Pos.Raw) (s : String.Slice) => String.Pos.Raw.mk (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (String.Pos.Raw.byteIdx p) (String.Slice.utf8ByteSize s)))
