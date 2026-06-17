import Split.Nat_pow_succ'
import Split.instPowNat
import Split.bne_self_eq_false
import Split.False
import Split.bne
import Split.Nat_recAux
import Split.instHDiv
import Split.HMul_hMul
import Split.instDecidableTrue
import Split.Nat_instAndOp
import Split.congrArg
import Split.Decidable_decide_congr_simp
import Split.Nat_mod_two_eq_zero_or_one
import Split.id
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.decide_false
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_div_one
import Split.decide_true
import Split.instBEqOfDecidableEq
import Split.instHShiftRightOfShiftRight
import Split.Nat_one_and_eq_mod_two
import Split.Or_casesOn
import Split.instNatPowNat
import Split.Bool_true
import Split.instHAdd
import Split.HMod_hMod
import Split.HPow_hPow
import Split.Nat_instShiftRight
import Split.HAdd_hAdd
import Split.HShiftRight_hShiftRight
import Split.Nat
import Split.congr
import Split.True
import Split.Nat_testBit
import Split.eq_self
import Split.Nat_instDiv
import Split.instDecidableFalse
import Split.Bool
import Split.of_eq_true
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instDecidableEqNat
import Split.Or_inl
import Split.Nat_testBit_add_one
import Split.Or
import Split.instHPow
import Split.HAnd_hAnd
import Split.Nat_instLawfulBEq
import Split.OfNat_ofNat
import Split.Bool_false
import Split.Decidable_decide
import Split.Eq
import Split.instHAndOfAndOp
import Split.Or_inr
import Split.Eq_trans
import Split.Nat_div_div_eq_div_mul
import Split.instHMul

-- Nat.testBit_eq_decide_div_mod_eq from environment
-- theorem Nat.testBit_eq_decide_div_mod_eq : forall {i : Nat} {x : Nat}, Eq.{1} Bool (Nat.testBit x i) (Decidable.decide (Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) i)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (instDecidableEqNat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) i)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Nat.testBit_eq_decide_div_mod_eq`.
-- In a full split, the body would be extracted from the environment.
