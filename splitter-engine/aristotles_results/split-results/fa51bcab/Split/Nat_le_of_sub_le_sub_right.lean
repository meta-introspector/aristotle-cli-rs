import Split.Nat_zero_le
import Split.congrArg
import Split.HSub_hSub
import Split.Eq_mp
import Split.Nat_brecOn
import Split.instSubNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Nat_below
import Split.instHAdd
import Split.instHSub
import Split.Nat_le_of_succ_le_succ
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.instAddNat
import Split.Nat_succ_sub_succ
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Nat_succ_le_succ

-- Nat.le_of_sub_le_sub_right from environment
-- theorem Nat.le_of_sub_le_sub_right : forall {n : Nat} {m : Nat} {k : Nat}, (LE.le.{0} Nat instLENat k m) -> (LE.le.{0} Nat instLENat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m k)) -> (LE.le.{0} Nat instLENat n m)

-- Stub: this file represents the declaration `Nat.le_of_sub_le_sub_right`.
-- In a full split, the body would be extracted from the environment.
