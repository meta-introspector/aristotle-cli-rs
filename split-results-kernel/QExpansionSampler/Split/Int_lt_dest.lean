import Split.congrArg
import Split.Int_add_left_comm
import Split.Exists
import Split.Eq_mp
import Split.Int_le_dest
import Split.Int
import Split.Int_add_comm
import Split.Nat_cast
import Split.Int_instLTInt
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Exists_intro
import Split.Int_instAdd
import Split.instNatCastInt
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq

-- Int.lt.dest from environment
-- theorem Int.lt.dest : forall {a : Int} {b : Int}, (LT.lt.{0} Int Int.instLTInt a b) -> (Exists.{1} Nat (fun (n : Nat) => Eq.{1} Int (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (Nat.cast.{0} Int instNatCastInt (Nat.succ n))) b))

-- Stub: this file represents the declaration `Int.lt.dest`.
-- In a full split, the body would be extracted from the environment.
