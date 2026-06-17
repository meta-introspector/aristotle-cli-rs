import Split.HMul_hMul
import Split.String
import Split.Nat_instMod
import Split.instHMod
import Split.instMulNat
import Split.instOfNatNat
import Split.HMod_hMod
import Split.ContentAddressing_asciiSum
import Split.Nat
import Split.LT_lt
import Split.Decidable_byContradiction
import Split.ContentAddressing_HashFunction_apply
import Split.instDecidableEqNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.instHMul

-- ContentAddressing.asciiSum_recoverable from environment
-- theorem ContentAddressing.asciiSum_recoverable : forall (s : String), (LT.lt.{0} Nat instLTNat (ContentAddressing.HashFunction.apply ContentAddressing.asciiSum s) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)) (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) -> (Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (ContentAddressing.HashFunction.apply ContentAddressing.asciiSum s) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)) (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) (ContentAddressing.HashFunction.apply ContentAddressing.asciiSum s))

-- Stub: this file represents the declaration `ContentAddressing.asciiSum_recoverable`.
-- In a full split, the body would be extracted from the environment.
