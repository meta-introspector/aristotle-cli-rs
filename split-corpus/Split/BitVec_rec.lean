import Mathlib

-- spec: recursor BitVec.rec : forall {w : Nat} {motive : (BitVec w) -> Sort.{u}}, (forall (toFin : Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)), motive (BitVec.ofFin w toFin)) -> (forall (t : BitVec w), motive t)
