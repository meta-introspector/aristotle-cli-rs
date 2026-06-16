import Split.congrArg
import Split.Eq_mp
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_add_left_cancel
import Split.Eq
import Split.Nat_add_comm

-- Nat.add_right_cancel from environment
-- theorem Nat.add_right_cancel : forall {n : Nat} {m : Nat} {k : Nat}, (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) k m)) -> (Eq.{1} Nat n k)

-- Stub: this file represents the declaration `Nat.add_right_cancel`.
-- In a full split, the body would be extracted from the environment.
