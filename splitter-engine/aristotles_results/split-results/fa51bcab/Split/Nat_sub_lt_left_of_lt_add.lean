import Split.congrArg
import Split.Nat_succ_le_of_lt
import Split.HSub_hSub
import Split.Nat_add_sub_cancel_left
import Split.Eq_mp
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.instHSub
import Split.Nat_sub_le_sub_right
import Split.HAdd_hAdd
import Split.Nat_succ_sub
import Split.Nat
import Split.LT_lt
import Split.instAddNat
import Split.instLTNat
import Split.Nat_succ

-- Nat.sub_lt_left_of_lt_add from environment
-- theorem Nat.sub_lt_left_of_lt_add : forall {n : Nat} {k : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n k) -> (LT.lt.{0} Nat instLTNat k (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n m)) -> (LT.lt.{0} Nat instLTNat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) k n) m)

-- Stub: this file represents the declaration `Nat.sub_lt_left_of_lt_add`.
-- In a full split, the body would be extracted from the environment.
