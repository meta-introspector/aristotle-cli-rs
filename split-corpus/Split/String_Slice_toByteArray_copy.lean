import Mathlib

-- spec: theorem String.Slice.toByteArray_copy : forall {s : String.Slice}, Eq.{1} ByteArray (String.toByteArray (String.Slice.copy s)) (ByteArray.extract (String.toByteArray (String.Slice.str s)) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s))))
theorem String.Slice.toByteArray_copy : forall {s : String.Slice}, Eq.{1} ByteArray (String.toByteArray (String.Slice.copy s)) (ByteArray.extract (String.toByteArray (String.Slice.str s)) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s)))) :=
  fun {s : String.Slice} => rfl.{1} ByteArray (String.toByteArray (String.Slice.copy s))
