import Mathlib

-- spec: theorem String.byteIdx_rawEndPos : forall {s : String}, Eq.{1} Nat (String.Pos.Raw.byteIdx (String.rawEndPos s)) (String.utf8ByteSize s)
theorem String.byteIdx_rawEndPos : forall {s : String}, Eq.{1} Nat (String.Pos.Raw.byteIdx (String.rawEndPos s)) (String.utf8ByteSize s) :=
  fun {s : String} => rfl.{1} Nat (String.Pos.Raw.byteIdx (String.rawEndPos s))
