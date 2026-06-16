import Split.Rat
import Split.Eq_rec
import Split.Ne
import Split.instOfNatNat
import Split.Int
import Split.Rat_normalize
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.optParam
import Split.OfNat_ofNat
import Split.Eq

-- Rat.normalize.congr_simp from environment
-- theorem Rat.normalize.congr_simp : forall (num : Int) (num_1 : Int), (Eq.{1} Int num num_1) -> (forall (den : Nat) (den_1 : Nat) (e_den : Eq.{1} Nat den den_1) (den_nz : Ne.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))), Eq.{1} Rat (Rat.normalize num den den_nz) (Rat.normalize num_1 den_1 (Eq.ndrec.{0, 1} Nat den (fun (den : Nat) => Ne.{1} (optParam.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) den (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) den_nz den_1 e_den)))

-- Stub: this file represents the declaration `Rat.normalize.congr_simp`.
-- In a full split, the body would be extracted from the environment.
