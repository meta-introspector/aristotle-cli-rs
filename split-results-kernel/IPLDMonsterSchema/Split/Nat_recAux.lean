import Split.Nat_rec
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat

-- Nat.recAux from environment
-- def Nat.recAux : forall {motive : Nat -> Sort.{u}}, (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (n : Nat), (motive n) -> (motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))) -> (forall (t : Nat), motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.recAux`.
-- In a full split, the body would be extracted from the environment.
