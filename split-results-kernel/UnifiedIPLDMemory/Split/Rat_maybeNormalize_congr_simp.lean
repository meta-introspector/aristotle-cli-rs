import Split.Nat_Coprime
import Split.Int_instDiv
import Split.Dvd_dvd
import Split.instHDiv
import Split.Rat
import Split.Eq_rec
import Split.HDiv_hDiv
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Rat_maybeNormalize
import Split.Nat_cast
import Split.Int_instDvd
import Split.Nat_instDvd
import Split.Nat
import Split.Int_natAbs
import Split.Nat_instDiv
import Split.Eq_ndrec
import Split.Eq_refl
import Split.instNatCastInt
import Split.OfNat_ofNat
import Split.Eq

-- Rat.maybeNormalize.congr_simp from environment
-- theorem Rat.maybeNormalize.congr_simp : forall (num : Int) (num_1 : Int) (e_num : Eq.{1} Int num num_1) (den : Nat) (den_1 : Nat) (e_den : Eq.{1} Nat den den_1) (g : Nat) (g_1 : Nat) (e_g : Eq.{1} Nat g g_1) (dvd_num : Dvd.dvd.{0} Int Int.instDvd (Nat.cast.{0} Int instNatCastInt g) num) (dvd_den : Dvd.dvd.{0} Nat Nat.instDvd g den) (den_nz : Ne.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (reduced : Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g)), Eq.{1} Rat (Rat.maybeNormalize num den g dvd_num dvd_den den_nz reduced) (Rat.maybeNormalize num_1 den_1 g_1 (Eq.ndrec.{0, 1} Int num (fun (num : Int) => Dvd.dvd.{0} Int Int.instDvd (Nat.cast.{0} Int instNatCastInt g_1) num) (Eq.ndrec.{0, 1} Nat g (fun (g : Nat) => Dvd.dvd.{0} Int Int.instDvd (Nat.cast.{0} Int instNatCastInt g) num) dvd_num g_1 e_g) num_1 e_num) (Eq.ndrec.{0, 1} Nat den (fun (den : Nat) => Dvd.dvd.{0} Nat Nat.instDvd g_1 den) (Eq.ndrec.{0, 1} Nat g (fun (g : Nat) => Dvd.dvd.{0} Nat Nat.instDvd g den) dvd_den g_1 e_g) den_1 e_den) (Eq.ndrec.{0, 1} Nat den (fun (den : Nat) => Ne.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g_1) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (Eq.ndrec.{0, 1} Nat g (fun (g : Nat) => Ne.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) den_nz g_1 e_g) den_1 e_den) (Eq.ndrec.{0, 1} Int num (fun (num : Int) => Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g_1))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den_1 g_1)) (Eq.ndrec.{0, 1} Nat den (fun (den : Nat) => Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g_1))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g_1)) (Eq.ndrec.{0, 1} Nat g (fun (g : Nat) => Nat.Coprime (Int.natAbs (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) num (Nat.cast.{0} Int instNatCastInt g))) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) den g)) reduced g_1 e_g) den_1 e_den) num_1 e_num))

-- Stub: this file represents the declaration `Rat.maybeNormalize.congr_simp`.
-- In a full split, the body would be extracted from the environment.
