import Split.instPowNat
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.BitVec_toNat
import Split.BitVec_ofNat
import Split.instNatPowNat
import Split.HMod_hMod
import Split.HPow_hPow
import Split.Nat
import Split.eq_self
import Split.of_eq_true
import Split.instHPow
import Split.OfNat_ofNat
import Split.Eq

-- BitVec.toNat_ofNat from environment
-- theorem BitVec.toNat_ofNat : forall (x : Nat) (w : Nat), Eq.{1} Nat (BitVec.toNat w (BitVec.ofNat w x)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) x (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w))

-- Stub: this file represents the declaration `BitVec.toNat_ofNat`.
-- In a full split, the body would be extracted from the environment.
