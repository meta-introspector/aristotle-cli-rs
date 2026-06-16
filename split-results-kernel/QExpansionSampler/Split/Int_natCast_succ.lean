import Split.Int
import Split.Nat_cast
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.Int_instAdd
import Split.instNatCastInt
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.rfl

-- Int.natCast_succ from environment
-- theorem Int.natCast_succ : forall (n : Nat), Eq.{1} Int (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (Nat.cast.{0} Int instNatCastInt n) (OfNat.ofNat.{0} Int 1 (instOfNat 1)))

-- Stub: this file represents the declaration `Int.natCast_succ`.
-- In a full split, the body would be extracted from the environment.
