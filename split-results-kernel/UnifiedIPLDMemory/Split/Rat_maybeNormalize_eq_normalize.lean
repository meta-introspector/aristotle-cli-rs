import Split.Rat_maybeNormalize_eq
import Split.Eq_mpr
import Split.Nat_Coprime
import Split.Nat_div_mul_cancel
import Split.Int_instDiv
import Split.Int_ediv_mul_cancel
import Split.Dvd_dvd
import Split.instHDiv
import Split.HMul_hMul
import Split.Nat_mul_ne_zero
import Split.congrArg
import Split.Rat
import Split.Int_divExact
import Split.Rat_normalize_mul_right
import Split.mt
import Split.Eq_rec
import Split.Rat_mk_eq_normalize
import Split.id
import Split.HDiv_hDiv
import Split.Ne
import Split.instMulNat
import Split.instOfNatNat
import Split.Int
import Split.Rat_maybeNormalize
import Split.Nat_cast
import Split.Rat_normalize
import Split.Int_instDvd
import Split.Int_instMul
import Split.Nat_div_zero
import Split.Nat_instDvd
import Split.Nat
import Split.True
import Split.Int_natAbs
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.congrFun'
import Split.instNatCastInt
import Split.Rat_mk'
import Split.optParam
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Eq_trans
import Split.instHMul

-- Rat.maybeNormalize_eq_normalize from environment
-- theorem Rat.maybeNormalize_eq_normalize : forall {num : Int} {den : Nat} {g : Nat} (dvd_num : Dvd.dvd.{0} Int Int.instDvd (Nat.cast.{0} Int instNatCastInt g) num) (dvd_den : Dvd.dvd.{0} Nat Nat.instDvd g den) (den_nz : Ne.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (reduced : Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g)), (Dvd.dvd.{0} Int Int.instDvd (Nat.cast.{0} Int instNatCastInt g) num) -> (Dvd.dvd.{0} Nat Nat.instDvd g den) -> (Eq.{1} Rat (Rat.maybeNormalize num den g dvd_num dvd_den den_nz reduced) (Rat.normalize num den (mt (Eq.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (fun (x._@.Init.Data.Rat.Lemmas.273893753._hygCtx._hyg.38 : Eq.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) => Rat.maybeNormalize_eq_normalize._proof_1 den g x._@.Init.Data.Rat.Lemmas.273893753._hygCtx._hyg.38) den_nz)))

-- Stub: this file represents the declaration `Rat.maybeNormalize_eq_normalize`.
-- In a full split, the body would be extracted from the environment.
