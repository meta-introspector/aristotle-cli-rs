import Split.Rat_normalize_eq_mkRat
import Split.Eq_mpr
import Split.Rat_num
import Split.HMul_hMul
import Split.Nat_mul_ne_zero
import Split.congrArg
import Split.Rat
import Split.Rat_add_def
import Split.Rat_den
import Split.id
import Split.instMulNat
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instMul
import Split.Rat_den_nz
import Split.mkRat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Rat_instAdd
import Split.Int_instAdd
import Split.Eq_refl
import Split.instNatCastInt
import Split.Eq
import Split.instHMul

-- Rat.add_def' from environment
-- theorem Rat.add_def' : forall (a : Rat) (b : Rat), Eq.{1} Rat (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) a b) (mkRat (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Rat.num a) (Nat.cast.{0} Int instNatCastInt (Rat.den b))) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Rat.num b) (Nat.cast.{0} Int instNatCastInt (Rat.den a)))) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Rat.den a) (Rat.den b)))

-- Stub: this file represents the declaration `Rat.add_def'`.
-- In a full split, the body would be extracted from the environment.
