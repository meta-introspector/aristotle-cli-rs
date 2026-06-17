import Split.Nat_gcd
import Split.Iff_mpr
import Split.Nat_Coprime
import Split.Int_instDiv
import Split.instHDiv
import Split.HMul_hMul
import Split.Int_natAbs_mul
import Split.Nat_mul_ne_zero
import Split.congrArg
import Split.Rat
import Split.Rat_normalize_den_nz
import Split.HDiv_hDiv
import Split.Nat_gcd_mul_left
import Split.Nat_mul_div_mul_left
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instMul
import Split.Int_instLTInt
import Split.Rat_normalize_reduced
import Split.Nat_pos_of_ne_zero
import Split.instOfNat
import Split.Nat
import Split.congr
import Split.LT_lt
import Split.True
import Split.Int_natAbs
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.Eq_ndrec
import Split.congrFun'
import Split.Rat_mk'_congr_simp
import Split.Rat_normalize_eq
import Split.instNatCastInt
import Split.instLTNat
import Split.Rat_mk'
import Split.OfNat_ofNat
import Split.Eq
import Split.Int_natCast_pos
import Split.rfl
import Split.Int_mul_ediv_mul_of_pos
import Split.Eq_trans
import Split.instHMul

-- Rat.normalize_mul_left from environment
-- theorem Rat.normalize_mul_left : forall {d : Nat} {n : Int} {a : Nat} (d0 : Ne.{1} Nat d (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (a0 : Ne.{1} Nat a (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Eq.{1} Rat (Rat.normalize (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Nat.cast.{0} Int instNatCastInt a) n) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) a d) (Nat.mul_ne_zero a d a0 d0)) (Rat.normalize n d d0)

-- Stub: this file represents the declaration `Rat.normalize_mul_left`.
-- In a full split, the body would be extracted from the environment.
