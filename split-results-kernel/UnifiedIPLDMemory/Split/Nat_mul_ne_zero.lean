import Split.Iff_mpr
import Split.HMul_hMul
import Split.Nat_mul_ne_zero_iff
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.And
import Split.Nat
import Split.And_intro
import Split.OfNat_ofNat
import Split.instHMul

-- Nat.mul_ne_zero from environment
-- theorem Nat.mul_ne_zero : forall {n : Nat} {m : Nat}, (Ne.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Ne.{1} Nat m (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Ne.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))

-- Stub: this file represents the declaration `Nat.mul_ne_zero`.
-- In a full split, the body would be extracted from the environment.
