import Split.Nat_gcd
import Split.Iff_mpr
import Split.Nat_gcd_dvd_left
import Split.Nat_div_mul_cancel
import Split.Int_instDiv
import Split.Rat_num
import Split.Int_ediv_mul_cancel
import Split.Dvd_dvd
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.and_self
import Split.Rat
import Split.Rat_normalize_den_nz
import Split.Int_ofNat_dvd_left
import Split.Rat_den
import Split.Exists
import Split.HDiv_hDiv
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instDvd
import Split.Int_instMul
import Split.Rat_normalize_reduced
import Split.And
import Split.Nat_instDvd
import Split.Nat
import Split.And_intro
import Split.congr
import Split.True
import Split.Int_natAbs
import Split.eq_self
import Split.Nat_instDiv
import Split.Exists_intro
import Split.of_eq_true
import Split.Nat_gcd_dvd_right
import Split.congrFun'
import Split.Rat_normalize_eq
import Split.instNatCastInt
import Split.Rat_mk'
import Split.optParam
import Split.OfNat_ofNat
import Split.Eq
import Split.Nat_gcd_ne_zero_right
import Split.rfl
import Split.Eq_trans
import Split.instHMul

-- Rat.normalize_num_den' from environment
-- theorem Rat.normalize_num_den' : forall (num : Int) (den : Nat) (nz : Ne.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Exists.{1} Nat (fun (d : Nat) => And (Ne.{1} Nat d (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (And (Eq.{1} Int num (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Rat.num (Rat.normalize num den nz)) (Nat.cast.{0} Int instNatCastInt d))) (Eq.{1} Nat den (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Rat.den (Rat.normalize num den nz)) d))))

-- Stub: this file represents the declaration `Rat.normalize_num_den'`.
-- In a full split, the body would be extracted from the environment.
