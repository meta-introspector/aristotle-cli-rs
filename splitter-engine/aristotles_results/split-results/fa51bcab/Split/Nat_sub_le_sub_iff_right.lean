import Split.HSub_hSub
import Split.instSubNat
import Split.LE_le
import Split.instLENat
import Split.Iff
import Split.instHSub
import Split.Nat_sub_le_sub_right
import Split.Nat
import Split.Iff_intro
import Split.Nat_le_of_sub_le_sub_right

-- Nat.sub_le_sub_iff_right from environment
-- theorem Nat.sub_le_sub_iff_right : forall {k : Nat} {m : Nat} {n : Nat}, (LE.le.{0} Nat instLENat k m) -> (Iff (LE.le.{0} Nat instLENat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m k)) (LE.le.{0} Nat instLENat n m))

-- Stub: this file represents the declaration `Nat.sub_le_sub_iff_right`.
-- In a full split, the body would be extracted from the environment.
