import Split.Nat_le_of_sub_eq_zero
import Split.Eq_mpr
import Split.congrArg
import Split.HSub_hSub
import Split.Exists
import Split.Nat_add_sub_cancel_left
import Split.Eq_mp
import Split.id
import Split.Nat_sub_eq_iff_eq_add
import Split.instSubNat
import Split.Int_ofNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_le_of_lt
import Split.Nat_cast
import Split.instHAdd
import Split.Unit
import Split.instHSub
import Split.HAdd_hAdd
import Split.Int_subNatNat
import Split.Nat
import Split.propext
import Split.instAddNat
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_lt_of_sub_eq_succ
import Split.Nat_le_dest
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq
import Split.Int_negOfNat_match_1
import Split.Nat_add_comm

-- Int.subNatNat_elim from environment
-- theorem Int.subNatNat_elim : forall (m : Nat) (n : Nat) (motive : Nat -> Nat -> Int -> Prop), (forall (i : Nat) (n : Nat), motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n i) n (Nat.cast.{0} Int instNatCastInt i)) -> (forall (i : Nat) (m : Nat), motive m (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m i) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (Int.negSucc i)) -> (motive m n (Int.subNatNat m n))

-- Stub: this file represents the declaration `Int.subNatNat_elim`.
-- In a full split, the body would be extracted from the environment.
