import Split.Nat_gcd
import Split.Iff_mpr
import Split.Nat_gcd_dvd_left
import Split.Eq_mpr
import Split.Nat_Coprime
import Split.Nat_div_mul_cancel
import Split.Rat_instMul
import Split.Rat_num
import Split.Dvd_dvd
import Split.instHDiv
import Split.Nat_mul_right_comm
import Split.HMul_hMul
import Split.Nat_mul_ne_zero
import Split.congrArg
import Split.Int_mul_assoc
import Split.Rat
import Split.Int_divExact
import Split.Rat_normalize_mul_right
import Split.Int_ofNat_dvd_left
import Split.Rat_den
import Split.Eq_rec
import Split.Rat_mk_eq_normalize
import Split.id
import Split.HDiv_hDiv
import Split.Int_divExact_eq_tdiv
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Nat_mul_assoc
import Split.Rat_normalize
import Split.Rat_mul
import Split.Int_instDvd
import Split.Int_instMul
import Split.Int_natCast_mul
import Split.Int_tdiv
import Split.Rat_den_nz
import Split.Nat_instDvd
import Split.Nat
import Split.congr
import Split.Int_tdiv_mul_cancel
import Split.Int_natAbs
import Split.Nat_instDiv
import Split.Eq_ndrec
import Split.Nat_gcd_dvd_right
import Split.Eq_refl
import Split.congrFun'
import Split.Rat_mk'_congr_simp
import Split.instNatCastInt
import Split.Rat_mk'
import Split.optParam
import Split.Int_mul_right_comm
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Nat_gcd_ne_zero_right
import Split.Nat_divExact
import Split.instHMul

-- Rat.mul_def from environment
-- theorem Rat.mul_def : forall (a : Rat) (b : Rat), Eq.{1} Rat (HMul.hMul.{0, 0, 0} Rat Rat Rat (instHMul.{0} Rat Rat.instMul) a b) (Rat.normalize (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Rat.num a) (Rat.num b)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Rat.den a) (Rat.den b)) (Nat.mul_ne_zero (Rat.den a) (Rat.den b) (Rat.den_nz a) (Rat.den_nz b)))

-- Stub: this file represents the declaration `Rat.mul_def`.
-- In a full split, the body would be extracted from the environment.
