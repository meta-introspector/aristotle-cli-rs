import Mathlib

-- spec: theorem String.isValidUTF8 : forall (self : String), ByteArray.IsValidUTF8 (String.toByteArray self)
theorem String.isValidUTF8 : forall (self : String), ByteArray.IsValidUTF8 (String.toByteArray self) :=
  fun (self : String) => self.2
