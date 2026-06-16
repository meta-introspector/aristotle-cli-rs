import Split.Eq_mpr
import Split.Dvd_dvd
import Split.instHDiv
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instOfNatNat
import Split.instHAdd
import Split.HMod_hMod
import Split.Nat_instDvd
import Split.HAdd_hAdd
import Split.Nat_dvd_iff_mod_eq_zero
import Split.Nat
import Split.Nat_instDiv
import Split.propext
import Split.Nat_succ_div_of_dvd
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- Nat.succ_div_of_mod_eq_zero from environment
-- theorem Nat.succ_div_of_mod_eq_zero : forall {a : Nat} {b : Nat}, (Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) b) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) b) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) a b) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))

-- Stub: this file represents the declaration `Nat.succ_div_of_mod_eq_zero`.
-- In a full split, the body would be extracted from the environment.
