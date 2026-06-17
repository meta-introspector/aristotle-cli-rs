import Split.congrArg
import Split.HSub_hSub
import Split.Nat_brecOn
import Split.instSubNat
import Split.instOfNatNat
import Split.Nat_below
import Split.instHAdd
import Split.Nat_pred_min_pred
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_sub
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_pred
import Split.Min_min
import Split.instMinNat
import Split.rfl
import Split.Eq_trans

-- Nat.sub_min_sub_right from environment
-- theorem Nat.sub_min_sub_right : forall (a : Nat) (b : Nat) (c : Nat), Eq.{1} Nat (Min.min.{0} Nat instMinNat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) a c) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) b c)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Min.min.{0} Nat instMinNat a b) c)

-- Stub: this file represents the declaration `Nat.sub_min_sub_right`.
-- In a full split, the body would be extracted from the environment.
