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

-- BitVec.rec from environment
-- recursor BitVec.rec : forall {w : Nat} {motive : (BitVec w) -> Sort.{u}}, (forall (toFin : Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)), motive (BitVec.ofFin w toFin)) -> (forall (t : BitVec w), motive t)

-- Stub: this file represents the declaration `BitVec.rec`.
-- In a full split, the body would be extracted from the environment.
