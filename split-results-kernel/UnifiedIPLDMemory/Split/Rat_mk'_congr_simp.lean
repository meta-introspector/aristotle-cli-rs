import Split.Nat_Coprime
import Split.Rat
import Split.Eq_rec
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Nat
import Split.Int_natAbs
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Rat_mk'
import Split.OfNat_ofNat
import Split.Eq

-- Rat.mk'.congr_simp from environment
-- theorem Rat.mk'.congr_simp : forall (num : Int) (num_1 : Int) (e_num : Eq.{1} Int num num_1) (den : Nat) (den_1 : Nat) (e_den : Eq.{1} Nat den den_1) (den_nz : Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) (reduced : Nat.Coprime (Int.natAbs num) den), Eq.{1} Rat (Rat.mk' num den den_nz reduced) (Rat.mk' num_1 den_1 (Eq.ndrec.{0, 1} Nat den (fun (den : Nat) => Ne.{1} Nat den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) den_nz den_1 e_den) (Eq.ndrec.{0, 1} Int num (fun (num : Int) => Nat.Coprime (Int.natAbs num) den_1) (Eq.ndrec.{0, 1} Nat den (fun (den : Nat) => Nat.Coprime (Int.natAbs num) den) reduced den_1 e_den) num_1 e_num))

-- Stub: this file represents the declaration `Rat.mk'.congr_simp`.
-- In a full split, the body would be extracted from the environment.
