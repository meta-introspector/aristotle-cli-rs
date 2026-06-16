import Split.Eq_mpr
import Split.Decidable_casesOn
import Split.Dvd_dvd
import Split.instHDiv
import Split.congrArg
import Split.Nat_decidable_dvd
import Split.Decidable
import Split.id
import Split.HDiv_hDiv
import Split.instOfNatNat
import Split.if_pos
import Split.instHAdd
import Split.Nat_instDvd
import Split.HAdd_hAdd
import Split.Nat
import Split.True
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.Nat_succ_div_of_not_dvd
import Split.Nat_succ_div_of_dvd
import Split.instAddNat
import Split.congrFun'
import Split.OfNat_ofNat
import Split.Eq
import Split.if_neg
import Split.Not
import Split.Eq_trans
import Split.ite

-- Nat.succ_div from environment
-- theorem Nat.succ_div : forall {a : Nat} {b : Nat}, Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) b) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) a b) (ite.{1} Nat (Dvd.dvd.{0} Nat Nat.instDvd b (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (Nat.decidable_dvd b (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) a (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))

-- Stub: this file represents the declaration `Nat.succ_div`.
-- In a full split, the body would be extracted from the environment.
