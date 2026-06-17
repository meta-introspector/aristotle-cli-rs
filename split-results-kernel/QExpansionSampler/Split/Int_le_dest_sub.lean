import Split.Int_NonNeg
import Split.HSub_hSub
import Split.Exists
import Split.Int
import Split.LE_le
import Split.Nat_cast
import Split.instHSub
import Split.Nat
import Split.Iff_mp
import Split.Int_instSub
import Split.instNatCastInt
import Split.Eq
import Split.Int_instLEInt
import Split.Int_nonneg_def

-- Int.le.dest_sub from environment
-- theorem Int.le.dest_sub : forall {a : Int} {b : Int}, (LE.le.{0} Int Int.instLEInt a b) -> (Exists.{1} Nat (fun (n : Nat) => Eq.{1} Int (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) b a) (Nat.cast.{0} Int instNatCastInt n)))

-- Stub: this file represents the declaration `Int.le.dest_sub`.
-- In a full split, the body would be extracted from the environment.
