import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.Int_ofNat
import Split.instOfNatNat
import Split.Int
import Split.LE_le
import Split.instLENat
import Split.Nat_cast
import Split.Unit
import Split.instHSub
import Split.Int_subNatNat_eq_1
import Split.Int_subNatNat
import Split.Nat
import Split.Eq_refl
import Split.Int_instSub
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_sub_eq_zero_of_le
import Split.Int_negOfNat_match_1

-- Int.ofNat_sub from environment
-- theorem Int.ofNat_sub : forall {m : Nat} {n : Nat}, (LE.le.{0} Nat instLENat m n) -> (Eq.{1} Int (Nat.cast.{0} Int instNatCastInt (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)) (HSub.hSub.{0, 0, 0} Int Int Int (instHSub.{0} Int Int.instSub) (Nat.cast.{0} Int instNatCastInt n) (Nat.cast.{0} Int instNatCastInt m)))

-- Stub: this file represents the declaration `Int.ofNat_sub`.
-- In a full split, the body would be extracted from the environment.
