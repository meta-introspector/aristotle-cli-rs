import Split.Int
import Split.Nat_cast
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Int_instAdd
import Split.instAddNat
import Split.instNatCastInt
import Split.Eq
import Split.rfl

-- Int.natCast_add from environment
-- theorem Int.natCast_add : forall (n : Nat) (m : Nat), Eq.{1} Int (Nat.cast.{0} Int instNatCastInt (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m)) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (Nat.cast.{0} Int instNatCastInt n) (Nat.cast.{0} Int instNatCastInt m))

-- Stub: this file represents the declaration `Int.natCast_add`.
-- In a full split, the body would be extracted from the environment.
