import Split.instPowNat
import Split.BitVec_instAdd
import Split.BitVec
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.BitVec_toNat
import Split.instNatPowNat
import Split.instHAdd
import Split.HMod_hMod
import Split.HPow_hPow
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.instHPow
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl

-- BitVec.toNat_add from environment
-- theorem BitVec.toNat_add : forall {w : Nat} (x : BitVec w) (y : BitVec w), Eq.{1} Nat (BitVec.toNat w (HAdd.hAdd.{0, 0, 0} (BitVec w) (BitVec w) (BitVec w) (instHAdd.{0} (BitVec w) (BitVec.instAdd w)) x y)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (BitVec.toNat w x) (BitVec.toNat w y)) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w))

-- Stub: this file represents the declaration `BitVec.toNat_add`.
-- In a full split, the body would be extracted from the environment.
