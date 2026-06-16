import Split.instPowNat
import Split.BitVec_ofFin
import Split.BitVec
import Split.instOfNatNat
import Split.instNatPowNat
import Split.HPow_hPow
import Split.Nat
import Split.instHPow
import Split.OfNat_ofNat
import Split.Fin
import Split.BitVec_rec

-- BitVec.casesOn from environment
-- def BitVec.casesOn : forall {w : Nat} {motive : (BitVec w) -> Sort.{u}} (t : BitVec w), (forall (toFin : Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)), motive (BitVec.ofFin w toFin)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `BitVec.casesOn`.
-- In a full split, the body would be extracted from the environment.
