import Split.instOfNatNat
import Split.instHAdd
import Split.And
import Split.HAdd_hAdd
import Split.Nat
import Split.And_intro
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.rfl
import Split.Nat_noConfusion

-- Nat.eq_zero_of_add_eq_zero from environment
-- theorem Nat.eq_zero_of_add_eq_zero : forall {n : Nat} {m : Nat}, (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (And (Eq.{1} Nat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Eq.{1} Nat m (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))

-- Stub: this file represents the declaration `Nat.eq_zero_of_add_eq_zero`.
-- In a full split, the body would be extracted from the environment.
