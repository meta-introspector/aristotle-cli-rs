import Split.Int
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Int_instAdd
import Split.instAddNat
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq
import Split.rfl

-- Int.negSucc_add_negSucc from environment
-- theorem Int.negSucc_add_negSucc : forall (m : Nat) (n : Nat), Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (Int.negSucc m) (Int.negSucc n)) (Int.negSucc (Nat.succ (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n)))

-- Stub: this file represents the declaration `Int.negSucc_add_negSucc`.
-- In a full split, the body would be extracted from the environment.
