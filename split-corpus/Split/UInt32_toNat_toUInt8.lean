import Mathlib

-- spec: theorem UInt32.toNat_toUInt8 : forall (x : UInt32), Eq.{1} Nat (UInt8.toNat (UInt32.toUInt8 x)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (UInt32.toNat x) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))))
theorem UInt32.toNat_toUInt8 : forall (x : UInt32), Eq.{1} Nat (UInt8.toNat (UInt32.toUInt8 x)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (UInt32.toNat x) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) :=
  fun (x : UInt32) => rfl.{1} Nat (UInt8.toNat (UInt32.toUInt8 x))
