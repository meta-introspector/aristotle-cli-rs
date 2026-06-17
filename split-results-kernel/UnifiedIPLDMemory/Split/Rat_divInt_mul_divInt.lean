import Split.Rat_instMul
import Split.HMul_hMul
import Split.congrArg
import Split.Rat
import Split.Rat_divInt
import Split.Exists
import Split.Int_instNegInt
import Split.instMulNat
import Split.Int
import Split.Rat_mkRat_mul_mkRat
import Split.Nat_cast
import Split.Int_mul_neg
import Split.Or_casesOn
import Split.Int_instMul
import Split.Rat_divInt_ofNat
import Split.mkRat
import Split.Exists_casesOn
import Split.Rat_divInt_neg'
import Split.Int_eq_nat_or_neg
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.congrFun'
import Split.Int_neg_mul
import Split.Or
import Split.instNatCastInt
import Split.Int_neg_neg
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg
import Split.Eq_trans
import Split.instHMul

-- Rat.divInt_mul_divInt from environment
-- theorem Rat.divInt_mul_divInt : forall (n₁ : Int) (n₂ : Int) {d₁ : Int} {d₂ : Int}, Eq.{1} Rat (HMul.hMul.{0, 0, 0} Rat Rat Rat (instHMul.{0} Rat Rat.instMul) (Rat.divInt n₁ d₁) (Rat.divInt n₂ d₂)) (Rat.divInt (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n₁ n₂) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) d₁ d₂))

-- Stub: this file represents the declaration `Rat.divInt_mul_divInt`.
-- In a full split, the body would be extracted from the environment.
