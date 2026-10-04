import Mathlib

-- spec: theorem String.Slice.byteIdx_rawEndPos : forall {s : String.Slice}, Eq.{1} Nat (String.Pos.Raw.byteIdx (String.Slice.rawEndPos s)) (String.Slice.utf8ByteSize s)
theorem String.Slice.byteIdx_rawEndPos : forall {s : String.Slice}, Eq.{1} Nat (String.Pos.Raw.byteIdx (String.Slice.rawEndPos s)) (String.Slice.utf8ByteSize s) :=
  fun {s : String.Slice} => rfl.{1} Nat (String.Pos.Raw.byteIdx (String.Slice.rawEndPos s))
