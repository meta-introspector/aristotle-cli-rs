import Mathlib

-- spec: theorem UInt8.ofNat_uInt32ToNat : forall (n : UInt32), Eq.{1} UInt8 (UInt8.ofNat (UInt32.toNat n)) (UInt32.toUInt8 n)
theorem UInt8.ofNat_uInt32ToNat : forall (n : UInt32), Eq.{1} UInt8 (UInt8.ofNat (UInt32.toNat n)) (UInt32.toUInt8 n) :=
  fun (n : UInt32) => rfl.{1} UInt8 (UInt8.ofNat (UInt32.toNat n))
