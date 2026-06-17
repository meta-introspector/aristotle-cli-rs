import Split.instPowNat
import Split.BitVec_ofFin
import Split.BitVec
import Split.Fin_mk
import Split.instOfNatNat
import Split.instNatPowNat
import Split.HPow_hPow
import Split.Nat
import Split.LT_lt
import Split.instHPow
import Split.instLTNat
import Split.OfNat_ofNat

-- BitVec.ofNatLT from environment
-- def BitVec.ofNatLT : forall {w : Nat} (i : Nat), (LT.lt.{0} Nat instLTNat i (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)) -> (BitVec w)
-- (definition body omitted)

-- Stub: this file represents the declaration `BitVec.ofNatLT`.
-- In a full split, the body would be extracted from the environment.
