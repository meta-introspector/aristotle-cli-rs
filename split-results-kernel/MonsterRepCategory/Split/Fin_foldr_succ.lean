import Split.instNeZeroNatHAdd_1
import Split.Nat_le_refl
import Split.Fin_succ
import Split.Fin_foldr
import Split.Fin_instOfNat
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_instNeZeroSucc
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq

-- Fin.foldr_succ from environment
-- theorem Fin.foldr_succ : forall {n : Nat} {α : Sort.{u_1}} (f : (Fin (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) -> α -> α) (x : α), Eq.{u_1} α (Fin.foldr.{u_1} α (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) f x) (f (OfNat.ofNat.{0} (Fin (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) 0 (Fin.instOfNat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (instNeZeroNatHAdd_1 n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) 0)) (Fin.foldr.{u_1} α n (fun (i : Fin n) => f (Fin.succ n i)) x))

-- Stub: this file represents the declaration `Fin.foldr_succ`.
-- In a full split, the body would be extracted from the environment.
