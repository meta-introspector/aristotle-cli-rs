import Mathlib

-- spec: theorem String.size_toByteArray : forall {s : String}, Eq.{1} Nat (ByteArray.size (String.toByteArray s)) (String.utf8ByteSize s)
theorem String.size_toByteArray : forall {s : String}, Eq.{1} Nat (ByteArray.size (String.toByteArray s)) (String.utf8ByteSize s) :=
  fun {s : String} => rfl.{1} Nat (ByteArray.size (String.toByteArray s))
