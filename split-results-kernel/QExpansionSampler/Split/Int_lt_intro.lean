import Split.Eq_rec
import Split.Int
import Split.Nat_cast
import Split.Int_instLTInt
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Int_instAdd
import Split.instNatCastInt
import Split.OfNat_ofNat
import Split.Eq
import Split.Int_lt_add_succ

-- Int.lt.intro from environment
-- theorem Int.lt.intro : forall {a : Int} {b : Int} {n : Nat}, (Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (Nat.cast.{0} Int instNatCastInt n) (OfNat.ofNat.{0} Int 1 (instOfNat 1)))) b) -> (LT.lt.{0} Int Int.instLTInt a b)

-- Stub: this file represents the declaration `Int.lt.intro`.
-- In a full split, the body would be extracted from the environment.
