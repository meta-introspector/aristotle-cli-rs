import Split.instPowNat
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.instNatPowNat
import Split.HMod_hMod
import Split.BitVec_toNat_ofNat
import Split.HPow_hPow
import Split.Nat
import Split.instHPow
import Split.UInt8_ofNat
import Split.UInt8_toNat
import Split.OfNat_ofNat
import Split.Eq

-- UInt8.toNat_ofNat' from environment
-- theorem UInt8.toNat_ofNat' : forall {n : Nat}, Eq.{1} Nat (UInt8.toNat (UInt8.ofNat n)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) n (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))))

-- Stub: this file represents the declaration `UInt8.toNat_ofNat'`.
-- In a full split, the body would be extracted from the environment.
