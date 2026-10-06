import Mathlib

-- spec: theorem UInt8.toNat_ofNat' : forall {n : Nat}, Eq.{1} Nat (UInt8.toNat (UInt8.ofNat n)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) n (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))))
theorem UInt8.toNat_ofNat' : forall {n : Nat}, Eq.{1} Nat (UInt8.toNat (UInt8.ofNat n)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) n (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) :=
  fun {n : Nat} => BitVec.toNat_ofNat n (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))
