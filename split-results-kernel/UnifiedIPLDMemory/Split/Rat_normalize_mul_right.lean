import Split.Eq_mpr
import Split.HMul_hMul
import Split.Nat_mul_ne_zero
import Split.congrArg
import Split.Rat
import Split.Rat_normalize_mul_left
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
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.instNatCastInt
import Split.Int_mul_comm
import Split.optParam
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Rat.normalize_mul_right from environment
-- theorem Rat.normalize_mul_right : forall {d : Nat} {n : Int} {a : Nat} (d0 : Ne.{1} Nat d (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (a0 : Ne.{1} Nat a (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Eq.{1} Rat (Rat.normalize (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n (Nat.cast.{0} Int instNatCastInt a)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) d a) (Nat.mul_ne_zero d a d0 a0)) (Rat.normalize n d d0)

-- Stub: this file represents the declaration `Rat.normalize_mul_right`.
-- In a full split, the body would be extracted from the environment.
