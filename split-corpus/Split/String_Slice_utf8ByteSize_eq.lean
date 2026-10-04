import Mathlib

-- spec: theorem String.Slice.utf8ByteSize_eq : forall {s : String.Slice}, Eq.{1} Nat (String.Slice.utf8ByteSize s) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s))) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))))
theorem String.Slice.utf8ByteSize_eq : forall {s : String.Slice}, Eq.{1} Nat (String.Slice.utf8ByteSize s) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s))) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s)))) :=
  fun {s : String.Slice} => rfl.{1} Nat (String.Slice.utf8ByteSize s)
