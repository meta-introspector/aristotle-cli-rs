import Split.instPowNat
import Split.Eq_mpr
import Split.Bool_not_false
import Split.Bool_not
import Split.congrArg
import Split.HSub_hSub
import Split.Nat_two_pow_pos
import Split.Bool_and_true
import Split.id
import Split.Bool_and
import Split.instSubNat
import Split.instOfNatNat
import Split.Nat_testBit_two_pow_sub_succ
import Split.instNatPowNat
import Split.Bool_true
import Split.instHAdd
import Split.Nat_zero_testBit
import Split.instHSub
import Split.HPow_hPow
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.True
import Split.Nat_testBit
import Split.eq_self
import Split.Bool
import Split.of_eq_true
import Split.Nat_decLt
import Split.instAddNat
import Split.congrFun'
import Split.instHPow
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Bool_false
import Split.Decidable_decide
import Split.Eq
import Split.Eq_trans

-- Nat.testBit_two_pow_sub_one from environment
-- theorem Nat.testBit_two_pow_sub_one : forall (n : Nat) (i : Nat), Eq.{1} Bool (Nat.testBit (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) n) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) i) (Decidable.decide (LT.lt.{0} Nat instLTNat i n) (Nat.decLt i n))

-- Stub: this file represents the declaration `Nat.testBit_two_pow_sub_one`.
-- In a full split, the body would be extracted from the environment.
