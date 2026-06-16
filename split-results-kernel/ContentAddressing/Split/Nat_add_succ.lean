import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_succ
import Split.Eq
import Split.rfl

-- Nat.add_succ from environment
-- theorem Nat.add_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (Nat.succ m)) (Nat.succ (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m))

-- Stub: this file represents the declaration `Nat.add_succ`.
-- In a full split, the body would be extracted from the environment.
