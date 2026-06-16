import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.Int_ofNat_eq_natCast
import Split.id
import Split.instSubNat
import Split.Int_ofNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Unit
import Split.instHSub
import Split.Int_subNatNat_eq_1
import Split.Int_subNatNat
import Split.Nat
import Split.Eq_refl
import Split.instNatCastInt
import Split.Int_negSucc
import Split.OfNat_ofNat
import Split.Eq
import Split.Int_negOfNat_match_1

-- Int.subNatNat_of_sub_eq_zero from environment
-- theorem Int.subNatNat_of_sub_eq_zero : forall {m : Nat} {n : Nat}, (Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Eq.{1} Int (Int.subNatNat m n) (Nat.cast.{0} Int instNatCastInt (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m n)))

-- Stub: this file represents the declaration `Int.subNatNat_of_sub_eq_zero`.
-- In a full split, the body would be extracted from the environment.
