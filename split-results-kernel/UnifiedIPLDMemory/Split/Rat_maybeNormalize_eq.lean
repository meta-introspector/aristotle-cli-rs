import Split.Eq_mpr
import Split.Nat_Coprime
import Split.Int_instDiv
import Split.Decidable_casesOn
import Split.Dvd_dvd
import Split.instHDiv
import Split.congrArg
import Split.Int_ediv_one
import Split.Rat
import Split.Int_divExact
import Split.Decidable
import Split.Eq_rec
import Split.dif_pos
import Split.id
import Split.HDiv_hDiv
import Split.Ne
import Split.instOfNatNat
import Split.Nat_div_one
import Split.Int
import Split.Rat_maybeNormalize
import Split.dif_neg
import Split.Nat_cast
import Split.dite
import Split.Int_instDvd
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
import Split.Rat_mk'_congr_simp
import Split.instDecidableEqNat
import Split.instNatCastInt
import Split.Rat_mk'
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Not
import Split.Nat_divExact
import Split.Eq_trans

-- Rat.maybeNormalize_eq from environment
-- theorem Rat.maybeNormalize_eq : forall {num : Int} {den : Nat} {g : Nat} (dvd_num : Dvd.dvd.{0} Int Int.instDvd (Nat.cast.{0} Int instNatCastInt g) num) (dvd_den : Dvd.dvd.{0} Nat Nat.instDvd g den) (den_nz : Ne.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (reduced : Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g)), Eq.{1} Rat (Rat.maybeNormalize num den g dvd_num dvd_den den_nz reduced) (Rat.mk' (Int.divExact num (Nat.cast.{0} ([mdata borrowed:1 Int]) instNatCastInt g) dvd_num) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g) den_nz reduced)

-- Stub: this file represents the declaration `Rat.maybeNormalize_eq`.
-- In a full split, the body would be extracted from the environment.
