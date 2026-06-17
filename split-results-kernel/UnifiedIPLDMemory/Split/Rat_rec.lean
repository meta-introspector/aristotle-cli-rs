import Split.Nat_Coprime
import Split.Rat
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat
import Split.Int_natAbs
import Split.Rat_mk'
import Split.OfNat_ofNat

-- Rat.rec from environment
-- recursor Rat.rec : forall {motive : Rat -> Sort.{u}}, (forall (num : Int) (den : Nat) (den_nz : Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (reduced : Nat.Coprime (Int.natAbs num) den), motive (Rat.mk' num den den_nz reduced)) -> (forall (t : Rat), motive t)

-- Stub: this file represents the declaration `Rat.rec`.
-- In a full split, the body would be extracted from the environment.
