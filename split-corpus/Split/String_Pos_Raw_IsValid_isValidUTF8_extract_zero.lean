import Mathlib

-- spec: theorem String.Pos.Raw.IsValid.isValidUTF8_extract_zero : forall {s : String} {off : String.Pos.Raw}, (String.Pos.Raw.IsValid s off) -> (ByteArray.IsValidUTF8 (ByteArray.extract (String.toByteArray s) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (String.Pos.Raw.byteIdx off)))
theorem String.Pos.Raw.IsValid.isValidUTF8_extract_zero : forall {s : String} {off : String.Pos.Raw}, (String.Pos.Raw.IsValid s off) -> (ByteArray.IsValidUTF8 (ByteArray.extract (String.toByteArray s) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (String.Pos.Raw.byteIdx off))) :=
  fun (s : String) (off : String.Pos.Raw) (self : String.Pos.Raw.IsValid s off) => self.2
