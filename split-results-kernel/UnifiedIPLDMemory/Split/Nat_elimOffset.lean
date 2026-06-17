import Split.Nat_add_right_cancel
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq

-- Nat.elimOffset from environment
-- def Nat.elimOffset : forall {α : Sort.{u}} (a : Nat) (b : Nat) (k : Nat), (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) b k)) -> ((Eq.{1} Nat a b) -> α) -> α
-- (definition body omitted)

-- Stub: this file represents the declaration `Nat.elimOffset`.
-- In a full split, the body would be extracted from the environment.
