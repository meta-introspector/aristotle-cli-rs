import Split.instPowNat
import Split.BitVec_toNat_add
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.UInt8_toBitVec
import Split.instAddUInt8
import Split.instNatPowNat
import Split.instHAdd
import Split.HMod_hMod
import Split.HPow_hPow
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.instHPow
import Split.UInt8_toNat
import Split.OfNat_ofNat
import Split.UInt8
import Split.Eq

-- UInt8.toNat_add from environment
-- theorem UInt8.toNat_add : forall (a : UInt8) (b : UInt8), Eq.{1} Nat (UInt8.toNat (HAdd.hAdd.{0, 0, 0} UInt8 UInt8 UInt8 (instHAdd.{0} UInt8 instAddUInt8) a b)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (UInt8.toNat a) (UInt8.toNat b)) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))))

-- Stub: this file represents the declaration `UInt8.toNat_add`.
-- In a full split, the body would be extracted from the environment.
