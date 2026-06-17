import Split.Rat_normalize_eq_mkRat
import Split.Eq_mpr
import Split.HMul_hMul
import Split.Nat_mul_ne_zero
import Split.congrArg
import Split.Rat
import Split.id
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instMul
import Split.mkRat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.Rat_instAdd
import Split.Int_instAdd
import Split.Eq_refl
import Split.instNatCastInt
import Split.Rat_normalize_add_normalize
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Rat.mkRat_add_mkRat from environment
-- theorem Rat.mkRat_add_mkRat : forall (n₁ : Int) (n₂ : Int) {d₁ : Nat} {d₂ : Nat}, (Ne.{1} Nat d₁ (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Ne.{1} Nat d₂ (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Eq.{1} Rat (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) (mkRat n₁ d₁) (mkRat n₂ d₂)) (mkRat (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n₁ (Nat.cast.{0} Int instNatCastInt d₂)) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) n₂ (Nat.cast.{0} Int instNatCastInt d₁))) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) d₁ d₂)))

-- Stub: this file represents the declaration `Rat.mkRat_add_mkRat`.
-- In a full split, the body would be extracted from the environment.
