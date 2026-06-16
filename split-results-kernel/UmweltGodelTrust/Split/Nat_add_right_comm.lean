import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Nat_add_assoc
import Split.instAddNat
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq
import Split.Nat_add_comm

-- Nat.add_right_comm from environment
-- theorem Nat.add_right_comm : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m) k) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n k) m)

-- Stub: this file represents the declaration `Nat.add_right_comm`.
-- In a full split, the body would be extracted from the environment.
