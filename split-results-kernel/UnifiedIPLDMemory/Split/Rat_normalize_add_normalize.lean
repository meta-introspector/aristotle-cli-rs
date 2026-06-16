import Split.Eq_mpr
import Split.Nat_Coprime
import Split.HMul_hMul
import Split.Nat_mul_ne_zero
import Split.congrArg
import Split.Nat_mul_left_comm
import Split.Int_mul_assoc
import Split.Rat
import Split.Rat_add_def
import Split.Rat_normalize_mul_right
import Split.Rat_normalize_num_den
import Split.Rat_den
import Split.Exists
import Split.Int_mul_left_comm
import Split.Eq_rec
import Split.id
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_mul_comm
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instMul
import Split.And_casesOn
import Split.Rat_den_nz
import Split.instHAdd
import Split.And
import Split.Exists_casesOn
import Split.HAdd_hAdd
import Split.Rat_casesOn
import Split.Nat
import Split.congr
import Split.True
import Split.Int_natAbs
import Split.eq_self
import Split.Rat_instAdd
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Int_instAdd
import Split.Eq_refl
import Split.congrFun'
import Split.instNatCastInt
import Split.Int_mul_comm
import Split.Rat_mk'
import Split.optParam
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Int_add_mul
import Split.Eq
import Split.Eq_trans
import Split.instHMul

-- Rat.normalize_add_normalize from environment
-- theorem Rat.normalize_add_normalize : forall (n₁ : Int) (n₂ : Int) {d₁ : Nat} {d₂ : Nat} (z₁ : Ne.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) d₁ (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (z₂ : Ne.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) d₂ (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Eq.{1} Rat (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) (Rat.normalize n₁ d₁ z₁) (Rat.normalize n₂ d₂ z₂)) (Rat.normalize (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n₁ (Nat.cast.{0} Int instNatCastInt d₂)) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n₂ (Nat.cast.{0} Int instNatCastInt d₁))) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) d₁ d₂) (Nat.mul_ne_zero d₁ d₂ z₁ z₂))

-- Stub: this file represents the declaration `Rat.normalize_add_normalize`.
-- In a full split, the body would be extracted from the environment.
