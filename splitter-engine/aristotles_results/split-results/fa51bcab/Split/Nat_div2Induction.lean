import Split.instHDiv
import Split.False_elim
import Split.HDiv_hDiv
import Split.instOfNatNat
import Split.dite
import Split.GT_gt
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.instDecidableEqNat
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Not
import Split.Nat_strongRecOn

-- Nat.div2Induction from environment
-- def Nat.div2Induction : forall {motive : Nat -> Sort.{u}} (n : Nat), (forall (n : Nat), ((GT.gt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (motive (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))))) -> (motive n)) -> (motive n)
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.div2Induction`.
-- In a full split, the body would be extracted from the environment.
