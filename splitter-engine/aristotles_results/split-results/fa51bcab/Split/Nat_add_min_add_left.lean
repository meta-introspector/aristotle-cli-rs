import Split.Eq_mpr
import Split.Decidable_casesOn
import Split.congrArg
import Split.Decidable
import Split.id
import Split.LE_le
import Split.instLENat
import Split.if_pos
import Split.Nat_min_def
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.ite_congr
import Split.Eq
import Split.if_neg
import Split.Not
import Split.Nat_decLe
import Split.Min_min
import Split.instMinNat
import Split.ite

-- Nat.add_min_add_left from environment
-- theorem Nat.add_min_add_left : forall (a : Nat) (b : Nat) (c : Nat), Eq.{1} Nat (Min.min.{0} Nat instMinNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a b) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a c)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a (Min.min.{0} Nat instMinNat b c))

-- Stub: this file represents the declaration `Nat.add_min_add_left`.
-- In a full split, the body would be extracted from the environment.
