import Split.Int
import Split.Nat_cast
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Int_subNatNat
import Split.Nat
import Split.Int_instAdd
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq
import Split.rfl

-- Int.ofNat_add_negSucc from environment
-- theorem Int.ofNat_add_negSucc : forall (m : Nat) (n : Nat), Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (Nat.cast.{0} Int instNatCastInt m) (Int.negSucc n)) (Int.subNatNat m (Nat.succ n))

-- Stub: this file represents the declaration `Int.ofNat_add_negSucc`.
-- In a full split, the body would be extracted from the environment.
