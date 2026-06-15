import Split.instPowNat
import Split.UInt32_toUInt8
import Split.UInt32_toNat
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.instNatPowNat
import Split.HMod_hMod
import Split.HPow_hPow
import Split.Nat
import Split.UInt32
import Split.instHPow
import Split.UInt8_toNat
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl

-- UInt32.toNat_toUInt8 from environment
-- theorem UInt32.toNat_toUInt8 : forall (x : UInt32), Eq.{1} Nat (UInt8.toNat (UInt32.toUInt8 x)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (UInt32.toNat x) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))))

-- Stub: this file represents the declaration `UInt32.toNat_toUInt8`.
-- In a full split, the body would be extracted from the environment.
