import Split.instNeZeroNatHAdd_1
import Split.Fin_instOfNat
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_instNeZeroSucc
import Split.Nat
import Split.LT_lt
import Split.instLTFin
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Fin
import Split.Nat_zero_lt_one

-- Fin.zero_lt_one from environment
-- theorem Fin.zero_lt_one : forall {n : Nat}, LT.lt.{0} (Fin (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)))) (instLTFin (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)))) (OfNat.ofNat.{0} (Fin (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)))) 0 (Fin.instOfNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) (instNeZeroNatHAdd_1 n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) 0)) (OfNat.ofNat.{0} (Fin (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)))) 1 (Fin.instOfNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2))) (instNeZeroNatHAdd_1 n (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) 1))

-- Stub: this file represents the declaration `Fin.zero_lt_one`.
-- In a full split, the body would be extracted from the environment.
