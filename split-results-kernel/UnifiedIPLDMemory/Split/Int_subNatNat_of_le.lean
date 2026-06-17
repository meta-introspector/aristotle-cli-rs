import Split.HSub_hSub
import Split.instSubNat
import Split.Int
import Split.LE_le
import Split.instLENat
import Split.Nat_cast
import Split.instHSub
import Split.Int_subNatNat
import Split.Nat
import Split.instNatCastInt
import Split.Eq
import Split.Nat_sub_eq_zero_of_le
import Split.Int_subNatNat_of_sub_eq_zero

-- Int.subNatNat_of_le from environment
-- theorem Int.subNatNat_of_le : forall {m : Nat} {n : Nat}, (LE.le.{0} Nat instLENat n m) -> (Eq.{1} Int (Int.subNatNat m n) (Nat.cast.{0} Int instNatCastInt (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m n)))

-- Stub: this file represents the declaration `Int.subNatNat_of_le`.
-- In a full split, the body would be extracted from the environment.
